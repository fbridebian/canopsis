<template lang="pug">
  v-layout(row)
    v-flex(offset-xs3, xs6)
      recurrence-rule-information(:rrule="pbehavior.rrule")
      pbehavior-recurrence-rule-periods.mt-2(:pbehavior="pbehavior")
</template>

<script>
import RecurrenceRuleInformation from '@/components/common/reccurence-rule/recurrence-rule-information.vue';

import PbehaviorRecurrenceRulePeriods from './pbehavior-recurrence-rule-periods.vue';

export default {
  components: { RecurrenceRuleInformation, PbehaviorRecurrenceRulePeriods },
  props: {
    pbehavior: {
      type: Object,
      required: true,
    },
  },
};
</script>
