<template lang="pug">
  v-layout.my-2(:class="{ 'error--text': isFailedStatus }", row, align-center)
    v-icon.mr-1(:color="iconColor") alarm
    span {{ label }}
</template>

<script>
import { convertDateToString } from '@/helpers/date/date';
import { convertDurationToString, toSeconds } from '@/helpers/date/duration';

export default {
  props: {
    failedAt: {
      type: Number,
      required: false,
    },
    completedAt: {
      type: Number,
      required: false,
    },
    startedAt: {
      type: Number,
      required: false,
    },
    timeToComplete: {
      type: Object,
      required: true,
    },
  },
  computed: {
    isFailedStatus() {
      return !!this.failedAt;
    },

    iconColor() {
      return this.isFailedStatus ? 'error' : '';
    },

    completedLabel() {
      return this.$t('remediation.instructionExecute.completedAt', {
        time: this.convertDate(this.completedAt),
      });
    },

    startedLabel() {
      return this.$t('remediation.instructionExecute.startedAt', {
        time: this.convertDate(this.startedAt),
      });
    },

    failedLabel() {
      return this.$t('remediation.instructionExecute.failedAt', {
        time: this.convertDate(this.failedAt),
      });
    },

    timeToCompleteLabel() {
      const { value, unit } = this.timeToComplete;

      return this.$t('remediation.instructionExecute.timeToComplete', {
        duration: convertDurationToString(toSeconds(value, unit)),
      });
    },

    label() {
      if (this.completedAt) {
        return this.completedLabel;
      }

      if (this.failedAt) {
        return this.failedLabel;
      }

      if (this.startedAt) {
        return this.startedLabel;
      }

      return this.timeToCompleteLabel;
    },
  },
  methods: {
    convertDate(date) {
      return convertDateToString(date, 'dateTimePicker');
    },
  },
};
</script>
