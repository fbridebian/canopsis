<template lang="pug">
  v-form(@submit.prevent="submit")
    modal-wrapper(close)
      template(#title="")
        span {{ $t('modals.createPause.title') }}
      template(#text="")
        service-pause-event-form(v-model="form")
      template(#actions="")
        v-btn(depressed, flat, @click="$modals.hide") {{ $t('common.cancel') }}
        v-btn.primary(
          :disabled="isDisabled",
          :loading="submitting",
          type="submit"
        ) {{ $t('common.saveChanges') }}
</template>

<script>
import { MODALS } from '@/constants';

import { modalInnerMixin } from '@/mixins/modal/inner';
import { submittableMixinCreator } from '@/mixins/submittable';
import { confirmableModalMixinCreator } from '@/mixins/confirmable-modal';

import ServicePauseEventForm from '@/components/widgets/service-weather/service-pause-event-form.vue';

import ModalWrapper from '../modal-wrapper.vue';

export default {
  name: MODALS.createServicePauseEvent,
  $_veeValidate: {
    validator: 'new',
  },
  components: { ServicePauseEventForm, ModalWrapper },
  mixins: [
    modalInnerMixin,
    submittableMixinCreator(),
    confirmableModalMixinCreator(),
  ],
  data() {
    return {
      form: {
        comment: '',
        reason: '',
      },
    };
  },
  methods: {
    async submit() {
      const isFormValid = await this.$validator.validateAll();

      if (isFormValid) {
        if (this.config.action) {
          await this.config.action(this.form);
        }

        this.$modals.hide();
      }
    },
  },
};
</script>
