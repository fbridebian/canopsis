<template lang="pug">
  v-radio-group.mt-0(
    v-field="value",
    :label="label",
    :disabled="disabled",
    color="primary",
    hide-details,
    mandatory
  )
    v-radio(
      :label="stopLabel",
      :value="stopValue",
      color="primary"
    )
    v-radio(
      :label="continueLabel",
      :value="continueValue",
      color="primary"
    )
</template>

<script>
import { WORKFLOW_TYPES } from '@/constants';

export default {
  model: {
    prop: 'value',
    event: 'input',
  },
  props: {
    value: {
      type: Boolean,
      default: WORKFLOW_TYPES.stop,
    },
    label: {
      type: String,
      required: true,
    },
    stopLabel: {
      type: String,
      default() {
        return this.$t('common.stop');
      },
    },
    continueLabel: {
      type: String,
      default() {
        return this.$t('common.continue');
      },
    },
    stopValue: {
      type: Boolean,
      default: WORKFLOW_TYPES.stop,
    },
    continueValue: {
      type: Boolean,
      default: WORKFLOW_TYPES.continue,
    },
    disabled: {
      type: Boolean,
      default: false,
    },
  },
};
</script>
