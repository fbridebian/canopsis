<template lang="pug">
  v-form(@submit.prevent="submit")
    modal-wrapper(close)
      template(#title="")
        span {{ $t('modals.createRrule.title') }}
      template(#text="")
        recurrence-rule-form(v-model="form.rrule", :start="config.start")
        pbehavior-recurrence-rule-exceptions-field.mt-2(
          v-model="form.exdates",
          :exceptions.sync="form.exceptions",
          :with-exdate-type="config.withExdateType"
        )
      template(#actions="")
        v-btn(
          depressed,
          flat,
          @click="$modals.hide"
        ) {{ $t('common.cancel') }}
        v-btn.primary(
          :disabled="isDisabled",
          :loading="submitting",
          type="submit"
        ) {{ $t('common.saveChanges') }}
</template>

<script>
import { MODALS, VALIDATION_DELAY } from '@/constants';

import { modalInnerMixin } from '@/mixins/modal/inner';
import { submittableMixinCreator } from '@/mixins/submittable';
import { confirmableModalMixinCreator } from '@/mixins/confirmable-modal';

import RecurrenceRuleForm from '@/components/forms/recurrence-rule/recurrence-rule-form.vue';
import PbehaviorRecurrenceRuleExceptionsField from '@/components/other/pbehavior/exceptions/fields/pbehavior-recurrence-rule-exceptions-field.vue';

import ModalWrapper from '../modal-wrapper.vue';

export default {
  name: MODALS.createRecurrenceRule,
  $_veeValidate: {
    validator: 'new',
    delay: VALIDATION_DELAY,
  },
  inject: ['$system'],
  components: {
    RecurrenceRuleForm,
    PbehaviorRecurrenceRuleExceptionsField,
    ModalWrapper,
  },
  mixins: [
    modalInnerMixin,
    submittableMixinCreator(),
    confirmableModalMixinCreator(),
  ],
  data() {
    const { rrule, exdates, exceptions } = this.modal.config;

    return {
      form: {
        rrule: rrule ?? '',
        exdates: exdates ?? [],
        exceptions: exceptions ?? [],
      },
    };
  },
  methods: {
    async submit() {
      const isValid = await this.$validator.validateAll();

      if (isValid) {
        if (this.config.action) {
          const { rrule, exdates, exceptions } = this.form;

          this.config.action({
            rrule,
            exdates,
            exceptions,
          });
        }

        this.$modals.hide();
      }
    },
  },
};
</script>
