<template lang="pug">
  v-radio-group.mt-0(
    v-field="value",
    :label="$t('remediation.instruction.type')",
    :disabled="disabled",
    hide-details,
    mandatory
  )
    v-radio(
      v-for="type in types",
      :key="type.value",
      :label="type.label",
      :value="type.value",
      color="primary"
    )
</template>

<script>
import { REMEDIATION_INSTRUCTION_TYPES } from '@/constants';

export default {
  model: {
    prop: 'value',
    event: 'input',
  },
  props: {
    value: {
      type: Number,
      default: REMEDIATION_INSTRUCTION_TYPES.manual,
    },
    disabled: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    types() {
      return Object.values(REMEDIATION_INSTRUCTION_TYPES).map(value => ({
        value,
        label: this.$t(`remediation.instruction.types.${value}`),
      }));
    },
  },
};
</script>
