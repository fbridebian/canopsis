<template lang="pug">
  v-layout(row)
    template(v-if="value")
      v-text-field.mt-0.pt-0(:value="value", :disabled="disabled", readonly, hide-details)
      c-action-btn(
        :disabled="disabled",
        type="edit",
        btn-class="ml-2",
        @click="$emit('edit', value)"
      )
      c-action-btn(
        :disabled="disabled",
        type="delete",
        @click="$emit('remove')"
      )
    v-btn.ml-0(
      v-else,
      :disabled="disabled",
      :color="errors.has(name) ? 'error' : 'primary'",
      @click="$emit('add')"
    ) {{ $t('common.add') }}
</template>

<script>
import { validationAttachRequiredMixin } from '@/mixins/form/validation-attach-required';

export default {
  inject: ['$validator'],
  mixins: [validationAttachRequiredMixin],
  model: {
    prop: 'value',
    event: 'input',
  },
  props: {
    value: {
      type: String,
      required: true,
    },
    disabled: {
      type: Boolean,
      default: false,
    },
    name: {
      type: String,
      default: 'storage',
    },
  },
  watch: {
    value() {
      this.$validator.validate(this.name);
    },

    disabled: {
      immediate: true,
      handler(disabled) {
        if (disabled) {
          this.detachRequiredRule();
        } else {
          this.attachRequiredRule(this.requiredRuleGetter);
        }
      },
    },
  },
  beforeDestroy() {
    this.detachRequiredRule();
  },
  methods: {
    requiredRuleGetter() {
      return this.value.length > 0;
    },
  },
};
</script>
