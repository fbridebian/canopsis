<template lang="pug">
  v-form(@submit.prevent="submit")
    modal-wrapper(close)
      template(#title="")
        span {{ config.title }}
      template(#text="")
        v-layout(row)
          v-flex.text-xs-center
            alarm-general-table(:items="config.items")
        v-layout(row)
          v-divider.my-3
        v-layout(row)
          c-name-field(
            v-model="form.comment",
            :label="$tc('common.comment')",
            :required="isCommentRequired",
            name="comment"
          )
      template(#actions="")
        v-btn(
          depressed,
          flat,
          @click="$modals.hide"
        ) {{ $t('common.cancel') }}
        v-btn.primary(
          :loading="submitting",
          :disabled="isDisabled",
          type="submit"
        ) {{ $t('common.saveChanges') }}
</template>

<script>
import { MODALS, VALIDATION_DELAY } from '@/constants';

import { mapIds } from '@/helpers/array';

import { modalInnerMixin } from '@/mixins/modal/inner';
import { submittableMixinCreator } from '@/mixins/submittable';
import { confirmableModalMixinCreator } from '@/mixins/confirmable-modal';

import AlarmGeneralTable from '@/components/widgets/alarm/alarm-general-list.vue';

import ModalWrapper from '../modal-wrapper.vue';

/**
 * Modal to remove alarms from meta alarm
 */
export default {
  name: MODALS.removeAlarmsFromMetaAlarm,
  $_veeValidate: {
    validator: 'new',
    delay: VALIDATION_DELAY,
  },
  components: { AlarmGeneralTable, ModalWrapper },
  mixins: [
    modalInnerMixin,
    submittableMixinCreator(),
    confirmableModalMixinCreator(),
  ],
  data() {
    return {
      form: {
        comment: '',
      },
    };
  },
  computed: {
    isCommentRequired() {
      return this.config.isCommentRequired ?? true;
    },
  },
  methods: {
    async submit() {
      const isFormValid = await this.$validator.validateAll();

      if (isFormValid) {
        await this.config?.action?.({
          ...this.form,

          alarms: mapIds(this.config.items),
        });

        this.$modals.hide();
      }
    },
  },
};
</script>
