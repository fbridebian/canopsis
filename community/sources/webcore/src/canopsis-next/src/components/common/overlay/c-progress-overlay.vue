<template lang="pug">
  v-fade-transition(v-if="transition")
    v-layout.progress(
      v-if="pending",
      :class="backgroundColor",
      :style="{ opacity }"
    )
      v-progress-circular(:color="color", :size="size", indeterminate)
  v-layout.progress(
    v-else-if="pending",
    :class="backgroundColor",
    :style="{ opacity }"
  )
    v-progress-circular(:color="color", :size="size", indeterminate)
</template>

<script>
export default {
  props: {
    pending: {
      type: Boolean,
      default: false,
    },
    opacity: {
      type: Number,
      default: 0.5,
    },
    size: {
      type: Number,
      required: false,
    },
    backgroundColor: {
      type: String,
      default: 'background',
    },
    color: {
      type: String,
      default: 'primary',
    },
    transition: {
      type: Boolean,
      default: true,
    },
  },
};
</script>

<style lang="scss" scoped>
  .progress {
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    z-index: 2;

    & ::v-deep .v-progress-circular {
      top: 50%;
      left: 50%;
      margin-top: -16px;
      margin-left: -16px;
    }
  }
</style>
