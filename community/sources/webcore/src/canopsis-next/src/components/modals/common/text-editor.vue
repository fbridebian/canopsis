<template lang="pug">
  v-form(@submit.prevent="submit")
    modal-wrapper(close)
      template(#title="")
        span {{ title }}
      template(#text="")
        text-editor-field(
          v-model="form.text",
          v-validate="config.rules",
          :label="config.label",
          :error-messages="errors.collect('text')",
          :variables="variables",
          :dark="$system.dark",
          name="text"
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
        ) {{ $t('common.submit') }}
</template>

<script>
import { MODALS, VALIDATION_DELAY } from '@/constants';

import { modalInnerMixin } from '@/mixins/modal/inner';
import { submittableMixinCreator } from '@/mixins/submittable';
import { confirmableModalMixinCreator } from '@/mixins/confirmable-modal';

import ModalWrapper from '../modal-wrapper.vue';

const TextEditorField = () => import(/* webpackChunkName: "TextEditor" */ '@/components/common/text-editor/text-editor.vue');

export default {
  name: MODALS.textEditor,
  $_veeValidate: {
    validator: 'new',
    delay: VALIDATION_DELAY,
  },
  inject: ['$system'],
  components: { TextEditorField, ModalWrapper },
  mixins: [
    modalInnerMixin,
    submittableMixinCreator(),
    confirmableModalMixinCreator(),
  ],
  data() {
    const text = this.modal.config.text ?? '';

    return {
      form: {
        text,
      },
    };
  },
  computed: {
    title() {
      return this.config.title ?? this.$t('modals.textEditor.title');
    },

    variables() {
      return this.config.variables;
    },
  },
  methods: {
    async submit() {
      const isFormValid = await this.$validator.validateAll();

      if (isFormValid) {
        if (this.config.action) {
          await this.config.action(this.form.text);
        }

        this.$modals.hide();
      }
    },
  },
};
</script>
