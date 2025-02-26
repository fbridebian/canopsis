<template lang="pug">
  c-advanced-data-table(
    :headers="headers",
    :items="idleRules",
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
    template(#type="{ item }") {{ $t(`idleRules.types.${item.type}`) }}
    template(#operation.type="{ item }") {{ item | get('operation.type', '-') }}
    template(#duration="{ item }")
      span {{ item.duration | duration }}
    template(#priority="{ item }") {{ item.priority || '-' }}
    template(#enabled="{ item }")
      c-enabled(:value="item.enabled")
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
      idle-rules-list-expand-item(:idle-rule="item")
</template>

<script>
import { OLD_PATTERNS_FIELDS } from '@/constants';

import { isOldPattern } from '@/helpers/entities/pattern/form';

import IdleRulesListExpandItem from './partials/idle-rules-list-expand-item.vue';

export default {
  components: { IdleRulesListExpandItem },
  props: {
    idleRules: {
      type: Array,
      required: true,
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
        { text: this.$t('common.name'), value: 'name' },
        { text: this.$t('common.type'), value: 'type' },
        { text: this.$t('common.enabled'), value: 'enabled', sortable: false },
        { text: this.$tc('common.action'), value: 'operation.type', sortable: false },
        { text: this.$t('idleRules.timeAwaiting'), value: 'duration', sortable: false },
        { text: this.$t('common.priority'), value: 'priority' },
        { text: this.$t('common.author'), value: 'author.display_name' },
        {
          text: this.$t('common.actionsLabel'),
          value: 'actions',
          sortable: false,
        },
      ];
    },
  },
  methods: {
    isOldPattern(item) {
      return isOldPattern(item, [OLD_PATTERNS_FIELDS.entity, OLD_PATTERNS_FIELDS.alarm]);
    },
  },
};
</script>
