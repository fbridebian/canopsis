<template lang="pug">
  v-tooltip(v-if="value", :max-width="maxWidth", :top="top", :right="right", :bottom="bottom", :left="left")
    template(#activator="{ on }")
      v-icon.d-block(v-on="on", :color="color", :size="size") sync_problem
    span {{ message }}
</template>

<script>
import { getDiffBetweenDates } from '@/helpers/date/date';
import { convertDurationToString } from '@/helpers/date/duration';

export default {
  props: {
    value: {
      type: Number,
      default: 0,
    },
    color: {
      type: String,
      default: 'error',
    },
    maxWidth: {
      type: [String, Number],
      required: false,
    },
    top: {
      type: Boolean,
      required: false,
    },
    right: {
      type: Boolean,
      required: false,
    },
    bottom: {
      type: Boolean,
      required: false,
    },
    left: {
      type: Boolean,
      required: false,
    },
    size: {
      type: [String, Number],
      required: false,
    },
  },
  computed: {
    durationDiff() {
      return getDiffBetweenDates(Date.now(), this.value);
    },

    message() {
      return this.$t('common.noReceivedEvents', {
        duration: convertDurationToString(this.durationDiff),
      });
    },
  },
};
</script>
