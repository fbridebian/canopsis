<template lang="pug">
  v-tabs(color="secondary lighten-1", slider-color="primary", dark, centered)
    v-tab {{ $t('common.summary') }}
    v-tab-item
      v-layout.py-3.secondary.lighten-2(row, justify-center)
        v-flex(xs11)
          v-card
            v-card-text
              v-flex(xs12, md8, offset-md2, lg6, offset-lg3)
                event-filters-rule-summary(:event-filter="eventFilter")
    v-tab {{ $tc('common.pattern', 2) }}
    v-tab-item(lazy)
      v-layout.pa-3.secondary.lighten-2(row, justify-center)
        v-flex(xs10)
          v-card
            v-card-text
              c-patterns-field(:value="patterns", readonly, with-entity, with-event)
    template(v-if="isEnrichment")
      v-tab {{ $tc('common.action', 2) }}
      v-tab-item
        v-layout.py-3.secondary.lighten-2(row, justify-center)
          v-flex(xs11)
            v-data-table(:items="eventFilter.config.actions", :headers="headers")
              template(#items="{ item }")
                td(v-for="{ value } in headers", :key="value") {{ item[value] }}
      v-tab(:disabled="!externalDataForm.length") {{ $t('externalData.title') }}
      v-tab-item
        v-layout.py-3.secondary.lighten-2(row, justify-center)
          v-flex(xs11)
            external-data-form(:form="externalDataForm", disabled)
    template(v-if="eventFilter.failures_count")
      v-tab {{ $tc('common.error', 2) }}
      v-tab-item(lazy)
        v-layout.py-3.secondary.lighten-2(row, justify-center)
          v-flex(xs11)
            v-card
              v-card-text
                event-filter-failures(:event-filter="eventFilter", @refresh="$emit('refresh')")
</template>

<script>
import { externalDataToForm } from '@/helpers/entities/shared/external-data/form';
import { eventFilterPatternToForm } from '@/helpers/entities/event-filter/rule/form';
import { isEnrichmentEventFilterRuleType } from '@/helpers/entities/event-filter/rule/entity';

import ExternalDataForm from '@/components/forms/external-data/external-data-form.vue';

import EventFiltersRuleSummary from './event-filters-rule-summary.vue';
import EventFilterFailures from './event-filter-failures.vue';

export default {
  components: {
    EventFiltersRuleSummary,
    EventFilterFailures,
    ExternalDataForm,
  },
  props: {
    eventFilter: {
      type: Object,
      default: () => ({}),
    },
  },
  computed: {
    patterns() {
      return eventFilterPatternToForm(this.eventFilter);
    },

    isEnrichment() {
      return isEnrichmentEventFilterRuleType(this.eventFilter.type);
    },

    headers() {
      return [
        { value: 'type', text: this.$t('common.type'), sortable: false },
        { value: 'name', text: this.$t('common.name'), sortable: false },
        { value: 'value', text: this.$t('common.value'), sortable: false },
        { value: 'description', text: this.$t('common.description'), sortable: false },
      ];
    },

    externalDataForm() {
      return externalDataToForm(this.eventFilter.external_data);
    },
  },
};
</script>
