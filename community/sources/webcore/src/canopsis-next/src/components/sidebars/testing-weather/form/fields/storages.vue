<template lang="pug">
  widget-settings-item(:title="title", optional)
    c-storages-field(
      v-field="storages",
      v-on="$listeners",
      :label="$t('settings.serverStorage')",
      :disabled="disabled",
      :help-text="helpText"
    )
</template>

<script>
import WidgetSettingsItem from '@/components/sidebars/partials/widget-settings-item.vue';

export default {
  components: { WidgetSettingsItem },
  model: {
    prop: 'storages',
    event: 'input',
  },
  props: {
    storages: {
      type: Array,
      default: () => [],
    },
    helpText: {
      type: String,
      required: false,
    },
    title: {
      type: String,
      required: true,
    },
    disabled: {
      type: Boolean,
      default: false,
    },
  },
};
</script>
