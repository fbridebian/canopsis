<template lang="pug">
  div.system-message
    v-layout(align-center)
      span.mr-1
        slot(name="label") {{ label }}
      c-copy-btn(
        :value="value",
        :tooltip="$t('testSuite.copyMessage')",
        @success="showCopySuccessPopup",
        @error="showCopyErrorPopup"
      )
      c-download-btn(:value="value", :name="fileName", type="txt")
    pre.pre-wrap.system-message__text
      slot {{ value }}
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      required: true,
    },
    label: {
      type: String,
      required: false,
    },
    fileName: {
      type: String,
      required: false,
    },
  },
  methods: {
    showCopySuccessPopup() {
      this.$popups.success({ text: this.$t('testSuite.popups.systemMessageCopied') });
    },

    showCopyErrorPopup() {
      this.$popups.error({ text: this.$t('errors.default') });
    },
  },
};
</script>

<style lang="scss" scoped>
$lineHeight: 20px;
$maxLineCount: 10;

.system-message {
  &__text {
    line-height: $lineHeight;
    max-height: $lineHeight * $maxLineCount;
    overflow: auto;
  }
}
</style>
