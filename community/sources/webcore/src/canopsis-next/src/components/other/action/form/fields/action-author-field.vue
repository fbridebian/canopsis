<template lang="pug">
  v-layout(column)
    c-enabled-field.mt-0(
      v-field="value.forward_author",
      :label="$t('scenario.forwardAuthor')"
    )
    v-text-field(
      v-if="!value.forward_author",
      v-field="value.author",
      :label="$t('common.author')"
    )
</template>

<script>
export default {
  model: {
    prop: 'value',
    event: 'input',
  },
  props: {
    value: {
      type: Object,
      required: true,
    },
  },
};
</script>
