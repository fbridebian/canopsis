<template lang="pug">
  v-layout.mt-2(column)
    v-layout.py-1
      v-flex.mt-3(xs1)
        c-draggable-step-number(
          :color="draggableStepNumberColor",
          disabled
        ) {{ $t('remediation.instruction.endpointAvatar') }}
      v-flex(xs11)
        v-layout(row)
          v-flex.px-1(xs11)
            v-text-field(
              v-field="value",
              v-validate="'required'",
              :label="$t('remediation.instruction.endpoint')",
              :name="name",
              :error-messages="errors.collect(name)",
              :disabled="disabled",
              box
            )
              template(#append="")
                c-help-icon(:text="$t('remediation.instruction.tooltips.endpoint')", icon="help", left)
          v-flex(xs1)
</template>

<script>
import { uid } from '@/helpers/uid';

export default {
  inject: ['$validator'],
  model: {
    prop: 'value',
    event: 'input',
  },
  props: {
    value: {
      type: String,
      default: '',
    },
    disabled: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    fieldSuffix() {
      return uid();
    },

    name() {
      return `endpoint${this.fieldSuffix}`;
    },

    draggableStepNumberColor() {
      return this.errors.has(this.name) ? 'error' : 'primary';
    },
  },
};
</script>
