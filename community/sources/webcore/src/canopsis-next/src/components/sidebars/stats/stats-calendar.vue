<template lang="pug">
  widget-settings(:submitting="submitting", @submit="submit")
    field-title(v-model="form.title")
    v-divider
    alarms-list-modal-form(
      v-model="form.parameters.alarmsList",
      :templates="preparedWidgetTemplates",
      :templates-pending="widgetTemplatesPending"
    )
    v-divider
    widget-settings-group(:title="$t('settings.advancedSettings')")
      field-filters(
        :filters.sync="form.filters",
        :widget-id="widget._id",
        addable,
        editable,
        with-alarm,
        with-entity,
        with-pbehavior,
        hide-selector
      )
      v-divider
      field-opened-resolved-filter(v-field="form.parameters.opened")
      v-divider
      field-switcher(
        v-field="form.parameters.considerPbehaviors",
        :title="$t('settings.considerPbehaviors.title')"
      )
      v-divider
      field-criticity-levels(v-field="form.parameters.criticityLevels")
      v-divider
      field-levels-colors-selector(
        v-field="form.parameters.criticityLevelsColors",
        color-type="hex",
        hide-suffix
      )
    v-divider
</template>

<script>
import { SIDE_BARS } from '@/constants';

import { widgetSettingsMixin } from '@/mixins/widget/settings';
import { formValidationHeaderMixin } from '@/mixins/form';
import { entitiesInfosMixin } from '@/mixins/entities/infos';
import { widgetTemplatesMixin } from '@/mixins/widget/templates';

import FieldTitle from '../form/fields/title.vue';
import FieldFilters from '../form/fields/filters.vue';
import FieldSwitcher from '../form/fields/switcher.vue';
import AlarmsListModalForm from '../alarm/form/alarms-list-modal.vue';
import WidgetSettings from '../partials/widget-settings.vue';
import WidgetSettingsGroup from '../partials/widget-settings-group.vue';
import FieldOpenedResolvedFilter from '../alarm/form/fields/opened-resolved-filter.vue';

import StatsCalendarAdvancedForm from './form/stats-calendar-advanced.vue';
import FieldCriticityLevels from './form/fields/criticity-levels.vue';
import FieldLevelsColorsSelector from './form/fields/levels-colors-selector.vue';

/**
 * Component to regroup the entities list settings fields
 */
export default {
  name: SIDE_BARS.statsCalendarSettings,
  components: {
    WidgetSettingsGroup,
    WidgetSettings,
    FieldTitle,
    FieldOpenedResolvedFilter,
    FieldFilters,
    FieldSwitcher,
    FieldCriticityLevels,
    FieldLevelsColorsSelector,
    AlarmsListModalForm,
    StatsCalendarAdvancedForm,
  },
  mixins: [
    widgetSettingsMixin,
    formValidationHeaderMixin,
    entitiesInfosMixin,
    widgetTemplatesMixin,
  ],
  mounted() {
    this.fetchInfos();
  },
};
</script>
