<template lang="pug">
  v-layout(column)
    c-pattern-field.mb-2(
      v-if="!patterns.old_mongo_query && withType",
      :value="patterns.id",
      :type="type",
      :disabled="disabled || readonly",
      return-object,
      required,
      @input="updatePattern"
    )

    v-tabs(
      v-if="!withType || patterns.id",
      v-model="activeTab",
      slider-color="primary",
      centered
    )
      v-tab(
        :disabled="!isSimpleTab && hasJsonError",
        :href="`#${$constants.PATTERN_EDITOR_TABS.simple}`"
      ) {{ $t('pattern.simpleEditor') }}
      v-tab-item(:value="$constants.PATTERN_EDITOR_TABS.simple")
        v-layout(v-if="patterns.old_mongo_query", justify-center, wrap)
          v-flex.pt-2(xs8)
            div.error--text.text-xs-center {{ $t('pattern.errors.oldPattern') }}
          v-flex.pt-2(v-if="!readonly && !disabled", xs12)
            v-layout(justify-center)
              v-btn(color="primary", @click="discardPattern") {{ $t('pattern.discard') }}
        pattern-groups-field.mt-2(
          v-else,
          v-field="patterns.groups",
          :disabled="formDisabled",
          :readonly="readonly",
          :name="patternGroupsFieldName",
          :type="type",
          :required="required",
          :attributes="attributes"
        )

      v-tab(:href="`#${$constants.PATTERN_EDITOR_TABS.advanced}`") {{ $t('pattern.advancedEditor') }}
      v-tab-item(:value="$constants.PATTERN_EDITOR_TABS.advanced", lazy)
        c-json-field(
          v-if="patterns.old_mongo_query",
          :value="patterns.old_mongo_query",
          :label="$t('pattern.advancedEditor')",
          readonly,
          rows="10"
        )
        pattern-advanced-editor-field(
          v-else,
          :value="patternsJson",
          :disabled="readonly || disabled || !isCustomPattern",
          :attributes="attributes",
          :name="patternJsonFieldName",
          @input="updateGroupsFromPatterns"
        )

    template(v-if="!readonly && !patterns.old_mongo_query")
      v-layout(row, align-center, justify-end)
        v-btn.mr-0(
          v-if="withType && !isCustomPattern",
          :disabled="disabled",
          color="primary",
          @click="updatePatternToCustom"
        ) {{ $t('common.edit') }}
        v-messages.text-xs-right(
          v-if="checked",
          :value="[$tc('common.itemFound', count, { count })]",
          :color="count === 0 ? 'error' : ''"
        )
      v-flex
        v-alert.pre-wrap(v-if="errorMessage", value="true") {{ errorMessage }}
        v-alert(
          :value="overLimit",
          type="warning",
          transition="fade-transition"
        )
          span {{ $t('pattern.errors.countOverLimit', { count }) }}
</template>

<script>
import { isEqual, isEmpty } from 'lodash';

import { PATTERN_CUSTOM_ITEM_VALUE, PATTERN_EDITOR_TABS } from '@/constants';

import { formGroupsToPatternRules, patternsToGroups, patternToForm } from '@/helpers/entities/pattern/form';

import { formMixin, validationChildrenMixin } from '@/mixins/form';

import PatternAdvancedEditorField from './pattern-advanced-editor-field.vue';
import PatternGroupsField from './pattern-groups-field.vue';

export default {
  inject: ['$validator'],
  components: { PatternGroupsField, PatternAdvancedEditorField },
  mixins: [formMixin, validationChildrenMixin],
  model: {
    prop: 'patterns',
    event: 'input',
  },
  props: {
    patterns: {
      type: Object,
      required: true,
    },
    attributes: {
      type: Array,
      required: true,
    },
    disabled: {
      type: Boolean,
      default: false,
    },
    name: {
      type: String,
      default: 'patterns',
    },
    checkCountName: {
      type: String,
      required: false,
    },
    required: {
      type: Boolean,
      default: false,
    },
    type: {
      type: String,
      required: false,
    },
    withType: {
      type: Boolean,
      default: false,
    },
    readonly: {
      type: Boolean,
      default: false,
    },
    counter: {
      type: Object,
      required: false,
    },
  },
  data() {
    return {
      activeTab: PATTERN_EDITOR_TABS.simple,
      patternsJson: [],
    };
  },
  computed: {
    patternGroupsFieldName() {
      return `${this.name}.groups`;
    },

    patternJsonFieldName() {
      return `${this.name}.json`;
    },

    hasJsonError() {
      return this.errors.has(this.patternJsonFieldName);
    },

    errorMessage() {
      return this.errors.collect(this.name)?.join('\n');
    },

    isSimpleTab() {
      return this.activeTab === PATTERN_EDITOR_TABS.simple;
    },

    formDisabled() {
      return this.disabled || (this.withType && !this.isCustomPattern);
    },

    isCustomPattern() {
      return this.patterns.id === PATTERN_CUSTOM_ITEM_VALUE;
    },

    checked() {
      return !isEmpty(this.counter);
    },

    count() {
      return this.counter?.count ?? 0;
    },

    overLimit() {
      return this.counter?.over_limit ?? false;
    },
  },
  watch: {
    'patterns.groups': {
      handler(groups, oldGroups) {
        if (!isEqual(groups, oldGroups)) {
          this.errors.remove(this.name);
        }
      },
    },

    activeTab(newTab) {
      if (newTab === PATTERN_EDITOR_TABS.advanced) {
        this.patternsJson = formGroupsToPatternRules(this.patterns.groups);
      }
    },
  },
  created() {
    this.$validator.attach({
      name: this.name,
      getter: () => this.patterns.length,
      vm: this,
    });
  },
  beforeDestroy() {
    this.$validator.detach(this.name);
  },
  methods: {
    discardPattern() {
      this.updateModel(patternToForm({ id: PATTERN_CUSTOM_ITEM_VALUE }));
    },

    updatePattern(pattern) {
      const { groups } = patternToForm(pattern);

      this.updateModel({
        ...this.patterns,
        is_corporate: pattern.is_corporate,
        id: pattern._id,
        groups,
      });
    },

    updatePatternToCustom() {
      this.updateField('id', PATTERN_CUSTOM_ITEM_VALUE);
    },

    updateGroupsFromPatterns(patterns) {
      this.updateField('groups', patternsToGroups(patterns));

      this.patternsJson = patterns;
    },
  },
};
</script>
