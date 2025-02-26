<template lang="pug">
  c-advanced-data-table(
    :headers="headers",
    :items="rules",
    :loading="pending",
    :total-items="totalItems",
    :pagination="pagination",
    :select-all="removable",
    expand,
    search,
    advanced-pagination,
    @update:pagination="$emit('update:pagination', $event)"
  )
    template(#mass-actions="{ selected }")
      c-action-btn(
        v-if="removable",
        type="delete",
        @click="$emit('remove-selected', selected)"
      )
    template(#duration="{ item }")
      span {{ item.duration | duration }}
    template(#priority="{ item }") {{ item.priority || '-' }}
    template(#actions="{ item }")
      v-layout(row)
        c-action-btn(
          v-if="updatable",
          :badge-value="isOldPattern(item)",
          :badge-tooltip="$t('pattern.oldPatternTooltip')",
          type="edit",
          @click="$emit('edit', item)"
        )
        c-action-btn(
          v-if="duplicable",
          type="duplicate",
          @click="$emit('duplicate', item)"
        )
        c-action-btn(
          v-if="removable",
          type="delete",
          @click="$emit('remove', item._id)"
        )
    template(#expand="{ item }")
      alarm-status-rules-list-expand-item(:rule="item")
</template>

<script>
import { OLD_PATTERNS_FIELDS } from '@/constants';

import { isOldPattern } from '@/helpers/entities/pattern/form';

import AlarmStatusRulesListExpandItem from './partials/alarm-status-rules-list-expand-item.vue';

export default {
  components: { AlarmStatusRulesListExpandItem },
  props: {
    rules: {
      type: Array,
      required: true,
    },
    flapping: {
      type: Boolean,
      default: false,
    },
    pending: {
      type: Boolean,
      default: false,
    },
    totalItems: {
      type: Number,
      required: false,
    },
    pagination: {
      type: Object,
      required: true,
    },
    removable: {
      type: Boolean,
      default: false,
    },
    updatable: {
      type: Boolean,
      default: false,
    },
    duplicable: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    headers() {
      return [
        { text: this.$t('common.id'), value: '_id' },
        { text: this.$t('common.name'), value: 'name' },
        { text: this.$t('common.duration'), value: 'duration', sortable: false },
        { text: this.$t('common.priority'), value: 'priority' },

        this.flapping && { text: this.$t('common.frequencyLimit'), value: 'freq_limit' },

        { text: this.$t('common.author'), value: 'author.display_name' },
        {
          text: this.$t('common.actionsLabel'),
          value: 'actions',
          sortable: false,
        },
      ].filter(Boolean);
    },
  },
  methods: {
    isOldPattern(item) {
      return isOldPattern(item, [OLD_PATTERNS_FIELDS.entity, OLD_PATTERNS_FIELDS.alarm]);
    },
  },
};
</script>
