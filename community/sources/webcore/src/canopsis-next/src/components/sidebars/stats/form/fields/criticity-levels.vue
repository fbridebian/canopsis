<template lang="pug">
  widget-settings-item(:title="$t('settings.criticityLevels')")
    v-layout(wrap)
      v-flex(xs12)
        v-layout(align-center, justify-space-around)
          div {{ $t('settings.colorsSelector.statsCriticity.minor') }} :
          v-flex(xs3)
            c-number-field(
              v-field="levels.minor",
              :min="0",
              name="minor",
              required
            )
      v-flex(xs12)
        v-layout(align-center, justify-space-around)
          div {{ $t('settings.colorsSelector.statsCriticity.major') }} :
          v-flex(xs3)
            c-number-field(
              v-field="levels.major",
              :min="levels.minor + 1",
              name="major",
              required
            )
      v-flex(xs12)
        v-layout(align-center, justify-space-around)
          div {{ $t('settings.colorsSelector.statsCriticity.critical') }} :
          v-flex(xs3)
            c-number-field(
              v-field="levels.critical",
              :min="levels.major + 1",
              name="critical",
              required
            )
</template>

<script>
import WidgetSettingsItem from '@/components/sidebars/partials/widget-settings-item.vue';

export default {
  inject: ['$validator'],
  components: { WidgetSettingsItem },
  model: {
    prop: 'levels',
    event: 'input',
  },
  props: {
    levels: {
      type: Object,
      default: () => ({
        minor: 20,
        major: 30,
        critical: 40,
      }),
    },
  },
};
</script>
