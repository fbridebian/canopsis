<template lang="pug">
  widget-settings-item(:title="$t('settings.defaultTimeRange')")
    c-quick-date-interval-type-field(
      v-field="value",
      :name="name",
      :ranges="intervalRanges"
    )
</template>

<script>
import { METRICS_QUICK_RANGES, QUICK_RANGES } from '@/constants';

import WidgetSettingsItem from '@/components/sidebars/partials/widget-settings-item.vue';

export default {
  components: { WidgetSettingsItem },
  props: {
    value: {
      type: String,
      required: false,
    },
    name: {
      type: String,
      required: false,
    },
  },
  computed: {
    intervalRanges() {
      const { [QUICK_RANGES.custom.value]: custom, ...ranges } = METRICS_QUICK_RANGES;

      return Object.values(ranges);
    },
  },
};
</script>
