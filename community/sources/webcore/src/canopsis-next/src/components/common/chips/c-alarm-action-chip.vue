<template lang="pug">
  v-chip.c-alarm-action-chip(
    :class="{ 'c-alarm-action-chip--closable': closable, 'c-alarm-action-chip--small': small }",
    :color="color",
    small,
    @click="$emit('click')"
  )
    span.c-alarm-action-chip__text.white--text
      slot
    v-icon.cursor-pointer.ml-2(
      v-if="closable",
      color="white",
      @click.stop="$emit('close')"
    ) cancel
</template>

<script>
export default {
  props: {
    color: {
      type: String,
      required: false,
    },
    closable: {
      type: Boolean,
      default: false,
    },
    small: {
      type: Boolean,
      default: false,
    },
  },
};
</script>

<style lang="scss">
.c-alarm-action-chip {
  border-radius: 5px;
  font-size: 12px;
  min-height: 24px;
  height: unset !important;

  &__text {
    white-space: initial;
    word-wrap: break-word;
    max-width: 100%;
  }

  .v-chip__content {
    height: unset !important;
    cursor: pointer;
  }

  &--closable {
    .v-chip__content {
      padding-right: 4px;
    }
  }

  &--small {
    min-height: 20px !important;
    margin: 2px;
  }

  .v-datatable thead th.column.sortable & .v-icon {
    opacity: .6;
  }

  .v-icon {
    transform: unset !important;
  }
}
</style>
