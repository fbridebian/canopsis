<template lang="pug">
  div.c-horizontal-time-line
    div.c-horizontal-time-line__groups(v-for="(group, groupIndex) in groupedSteps", :key="group.day")
      span.c-horizontal-time-line__day {{ group.day }}
      v-divider.grey.mr-2(vertical)
      div.c-horizontal-time-line__cards
        template(v-for="(step, stepIndex) in group.steps")
          horizontal-time-line-card(:step="step", :key="`card-${stepIndex}`")
          v-icon.mx-2(
            v-if="groupIndex !== groupedSteps.length - 1 || stepIndex !== group.steps.length - 1",
            :key="`arrow-${stepIndex}`",
            size="16"
          ) arrow_forward
</template>

<script>
import { groupAlarmSteps } from '@/helpers/entities/alarm/list';

import HorizontalTimeLineCard from './horizontal-time-line-card.vue';

export default {
  components: { HorizontalTimeLineCard },
  props: {
    alarm: {
      type: Object,
      required: true,
    },
  },
  computed: {
    groupedSteps() {
      return Object.entries(groupAlarmSteps(this.alarm.v.steps)).map(([day, steps]) => ({
        day,
        steps,
      }));
    },
  },
};
</script>

<style lang="scss" scoped>
  $timeFontSize: 10px;
  $dayPadding: 5px;

  .c-horizontal-time-line {
    display: inline-flex;
    position: relative;
    padding-top: $timeFontSize + $dayPadding;

    &__day {
      font-size: $timeFontSize;
      position: absolute;
      top: 0;
    }

    &__groups {
      display: flex;
    }

    &__cards {
      display: flex;
    }
  }
</style>
