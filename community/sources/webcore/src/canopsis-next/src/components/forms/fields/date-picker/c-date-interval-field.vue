<template lang="pug">
  div.c-date-interval(:class="{ 'c-date-interval--column': column }")
    c-date-picker-field(
      v-field="value.from",
      :label="$t('common.from')",
      :disabled="disabled",
      :allowed-dates="isAllowedFromDate",
      hide-details
    )
      template(#append="")
        v-icon calendar_today
    c-date-picker-field(
      v-field="value.to",
      :label="$t('common.to')",
      :disabled="disabled",
      :allowed-dates="isAllowedToDate",
      :content-class="{ 'ml-4': !column }",
      hide-details
    )
      template(#append="")
        v-icon calendar_today
</template>

<script>
export default {
  model: {
    event: 'input',
    prop: 'value',
  },
  props: {
    value: {
      type: Object,
      default: () => ({}),
    },
    isAllowedFromDate: {
      type: Function,
      required: false,
    },
    isAllowedToDate: {
      type: Function,
      required: false,
    },
    disabled: {
      type: Boolean,
      required: false,
    },
    column: {
      type: Boolean,
      required: false,
    },
  },
};
</script>

<style scoped lang="scss">
.c-date-interval {
  display: inline-flex;

  &--column {
    flex-direction: column;
  }
}
</style>
