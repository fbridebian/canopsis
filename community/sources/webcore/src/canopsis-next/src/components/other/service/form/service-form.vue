<template lang="pug">
  v-layout(column)
    c-name-field(v-field="form.name", required)
    v-layout
      v-flex.pr-3(xs6)
        c-entity-category-field(v-field="form.category", addable, required)
      v-flex.pr-3(xs4)
        c-entity-state-field(
          v-field="form.sli_avail_state",
          :label="$t('service.availabilityState')",
          required
        )
      v-flex(xs2)
        c-impact-level-field(v-field="form.impact_level", required)
    c-coordinates-field(v-field="form.coordinates", row)
    text-editor-field(
      v-validate="'required'",
      v-field="form.output_template",
      :label="$t('service.outputTemplate')",
      :error-messages="errors.collect('output_template')",
      :variables="outputVariables",
      name="output_template"
    )
    c-enabled-field(v-field="form.enabled")
    v-tabs(slider-color="primary", centered)
      v-tab(:class="{ 'error--text': errors.has('entity_patterns') }") {{ $t('common.entityPatterns') }}
      v-tab-item
        c-patterns-field.mt-2(
          v-field="form.patterns",
          :entity-attributes="entityAttributes",
          with-entity,
          entity-counters-type
        )
      v-tab.validation-header(:disabled="advancedJsonWasChanged") {{ $t('entity.manageInfos') }}
      v-tab-item
        manage-infos(v-field="form.infos")
</template>

<script>
import { get } from 'lodash';

import {
  ENTITY_PATTERN_FIELDS,
  SERVICE_WEATHER_STATE_COUNTERS,
  SERVICE_WEATHER_TEMPLATE_COUNTERS_BY_STATE_COUNTERS,
} from '@/constants';

import ManageInfos from '@/components/widgets/context/manage-infos.vue';
import TextEditorField from '@/components/forms/fields/text-editor-field.vue';

export default {
  inject: ['$validator'],
  components: {
    TextEditorField,
    ManageInfos,
  },
  model: {
    prop: 'form',
    event: 'input',
  },
  props: {
    form: {
      type: Object,
      default: () => ({}),
    },
  },
  computed: {
    outputVariables() {
      const messages = this.$t('serviceWeather.stateCounters');

      return Object.values(SERVICE_WEATHER_STATE_COUNTERS).map(field => ({
        text: messages[field],
        value: SERVICE_WEATHER_TEMPLATE_COUNTERS_BY_STATE_COUNTERS[field],
      }));
    },

    advancedJsonWasChanged() {
      return get(this.fields, ['advancedJson', 'changed']);
    },

    entityAttributes() {
      return [
        {
          value: ENTITY_PATTERN_FIELDS.lastEventDate,
          options: { disabled: true },
        },
        {
          value: ENTITY_PATTERN_FIELDS.connector,
          options: { disabled: true },
        },
        {
          value: ENTITY_PATTERN_FIELDS.componentInfos,
          options: { disabled: true },
        },
      ];
    },
  },
};
</script>
