<template lang="pug">
  v-form(@submit.prevent="submit")
    modal-wrapper(close)
      template(#title="")
        span {{ title }}
      template(#text="")
        flowchart-map-form(v-model="form")
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
        ) {{ $t('common.submit') }}
</template>

<script>
import { MODALS } from '@/constants';

import { formToMap, mapToForm } from '@/helpers/entities/map/form';

import { modalInnerMixin } from '@/mixins/modal/inner';
import { submittableMixinCreator } from '@/mixins/submittable';
import { confirmableModalMixinCreator } from '@/mixins/confirmable-modal';

import FlowchartMapForm from '@/components/other/map/form/flowchart-map-form.vue';

import ModalWrapper from '../modal-wrapper.vue';

export default {
  name: MODALS.createFlowchartMap,
  $_veeValidate: {
    validator: 'new',
  },
  components: { FlowchartMapForm, ModalWrapper },
  mixins: [
    modalInnerMixin,
    submittableMixinCreator(),
    confirmableModalMixinCreator(),
  ],
  data() {
    return {
      form: mapToForm(this.modal.config.map),
    };
  },
  computed: {
    title() {
      return this.config.title ?? this.$t('modals.createFlowchartMap.create.title');
    },
  },
  methods: {
    async submit() {
      const isFormValid = await this.$validator.validateAll();

      if (isFormValid) {
        if (this.config.action) {
          await this.config.action(formToMap(this.form));
        }

        this.$modals.hide();
      }
    },
  },
};
</script>
