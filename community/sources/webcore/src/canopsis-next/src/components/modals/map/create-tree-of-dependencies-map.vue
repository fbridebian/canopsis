<template lang="pug">
  v-form(@submit.prevent="submit")
    modal-wrapper(close)
      template(#title="")
        span {{ title }}
      template(#text="")
        tree-of-dependencies-map-form(v-model="form")
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

import { mapToForm, formToMap } from '@/helpers/entities/map/form';

import { modalInnerMixin } from '@/mixins/modal/inner';
import { submittableMixinCreator } from '@/mixins/submittable';
import { confirmableModalMixinCreator } from '@/mixins/confirmable-modal';

import TreeOfDependenciesMapForm from '@/components/other/map/form/tree-of-dependencies-map-form.vue';

import ModalWrapper from '../modal-wrapper.vue';

export default {
  name: MODALS.createTreeOfDependenciesMap,
  $_veeValidate: {
    validator: 'new',
  },
  components: {
    TreeOfDependenciesMapForm,
    ModalWrapper,
  },
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
      return this.config.title ?? this.$t('modals.createTreeOfDependenciesMap.create.title');
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
