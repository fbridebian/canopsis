<template lang="pug">
  widget-settings-item(:title="$t('kpi.calculationMethod')")
    c-alarm-metric-aggregate-function-field(v-field="value")
</template>

<script>
import WidgetSettingsItem from '@/components/sidebars/partials/widget-settings-item.vue';

export default {
  components: { WidgetSettingsItem },
  props: {
    value: {
      type: String,
      required: true,
    },
  },
};
</script>
