<template lang="pug">
  v-form(@submit.prevent="submit")
    modal-wrapper(close)
      template(#title="")
        span {{ $t('modals.pbehaviorPlanning.title') }}
      template(#text="")
        pbehavior-planning-calendar(
          :pbehaviors-by-id.sync="form.pbehaviorsById",
          :added-pbehaviors-by-id.sync="form.addedPbehaviorsById",
          :changed-pbehaviors-by-id.sync="form.changedPbehaviorsById",
          :removed-pbehaviors-by-id.sync="form.removedPbehaviorsById",
          :read-only="readOnly",
          :entity-pattern="entityPattern"
        )
      template(#actions="")
        v-btn(depressed, flat, @click="$modals.hide") {{ $t('common.cancel') }}
        v-btn.primary(
          :disabled="isDisabled",
          :loading="submitting",
          type="submit"
        ) {{ $t('common.submit') }}
</template>

<script>
import { keyBy, omit } from 'lodash';

import { MODALS } from '@/constants';

import { pbehaviorToDuplicateForm, pbehaviorToRequest } from '@/helpers/entities/pbehavior/form';

import { modalInnerMixin } from '@/mixins/modal/inner';
import { submittableMixinCreator } from '@/mixins/submittable';
import { confirmableModalMixinCreator } from '@/mixins/confirmable-modal';
import { entitiesPbehaviorMixin } from '@/mixins/entities/pbehavior';

import PbehaviorPlanningCalendar from '@/components/other/pbehavior/calendar/pbehavior-planning-calendar.vue';

import ModalWrapper from '../modal-wrapper.vue';

export default {
  name: MODALS.pbehaviorPlanning,
  components: { PbehaviorPlanningCalendar, ModalWrapper },
  mixins: [
    modalInnerMixin,
    entitiesPbehaviorMixin,
    submittableMixinCreator(),
    confirmableModalMixinCreator(),
  ],
  data() {
    const { pbehaviors = [], pbehaviorsToAdd = [] } = this.modal.config;

    return {
      form: {
        pbehaviorsById: keyBy(pbehaviors, '_id'),
        addedPbehaviorsById: keyBy(pbehaviorsToAdd.map(pbehaviorToDuplicateForm), '_id'),
        changedPbehaviorsById: {},
        removedPbehaviorsById: {},
      },
    };
  },
  computed: {
    readOnly() {
      return !!this.config.readOnly;
    },

    entityPattern() {
      return this.config.entityPattern;
    },
  },
  methods: {
    async submit() {
      const { pbehaviors: originalPbehaviors } = this.config;
      const createdPbehaviors = Object.values(this.form.addedPbehaviorsById)
        .map(pbehavior => pbehaviorToRequest(omit(pbehavior, ['_id'])));
      const updatedPbehaviors = Object.values(this.form.changedPbehaviorsById).map(pbehaviorToRequest);
      const removedPbehaviors = Object.values(this.form.removedPbehaviorsById);

      await Promise.all([
        createdPbehaviors.length && this.createPbehaviorsWithComments(createdPbehaviors),
        updatedPbehaviors.length && this.updatePbehaviorsWithComments(updatedPbehaviors, originalPbehaviors),
        removedPbehaviors.length && this.removePbehaviors(removedPbehaviors),
      ]);

      if (this.config.afterSubmit) {
        await this.config.afterSubmit();
      }

      this.$modals.hide();
    },
  },
};
</script>
