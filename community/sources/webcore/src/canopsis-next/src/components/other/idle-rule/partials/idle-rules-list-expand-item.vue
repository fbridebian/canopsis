<template lang="pug">
  div
    v-tabs(v-model="activeTab", color="secondary lighten-1", slider-color="primary", dark, centered)
      v-tab {{ $t('common.summary') }}
      v-tab {{ $tc('common.pattern', 2) }}
    v-layout.pa-3.secondary.lighten-2
      v-flex(xs12)
        v-card.pa-3
          v-tabs-items.pt-2(v-model="activeTab")
            v-tab-item
              v-flex(offset-xs2, xs8)
                idle-rules-summary-tab(:idle-rule="idleRule")
            v-tab-item(lazy)
              v-flex(offset-xs2, xs8)
                idle-rule-patterns-form(:form="patterns", :is-entity-type="isEntityType", readonly)
</template>

<script>
import { OLD_PATTERNS_FIELDS, PATTERNS_FIELDS } from '@/constants';

import { filterPatternsToForm } from '@/helpers/entities/filter/form';
import { isIdleRuleEntityType } from '@/helpers/entities/idle-rule/form';

import IdleRulePatternsForm from '@/components/other/idle-rule/form/idle-rule-patterns-form.vue';

import IdleRulesSummaryTab from './idle-rules-summary-tab.vue';

export default {
  components: { IdleRulePatternsForm, IdleRulesSummaryTab },
  props: {
    idleRule: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      activeTab: 0,
    };
  },
  computed: {
    isEntityType() {
      return isIdleRuleEntityType(this.idleRule.type);
    },

    patterns() {
      return filterPatternsToForm(
        this.idleRule,
        [PATTERNS_FIELDS.entity, PATTERNS_FIELDS.alarm],
        [OLD_PATTERNS_FIELDS.entity, OLD_PATTERNS_FIELDS.alarm],
      );
    },
  },
};
</script>
