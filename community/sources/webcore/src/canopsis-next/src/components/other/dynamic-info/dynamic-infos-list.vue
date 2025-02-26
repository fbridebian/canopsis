<template lang="pug">
  c-advanced-data-table(
    :pagination="pagination",
    :items="dynamicInfos",
    :loading="pending",
    :headers="headers",
    :total-items="totalItems",
    :search-tooltip="$t('dynamicInfo.advancedSearch')",
    :select-all="removable",
    advanced-search,
    advanced-pagination,
    hide-actions,
    expand,
    @update:pagination="$emit('update:pagination', $event)"
  )
    template(#mass-actions="{ selected }")
      c-action-btn(
        v-if="removable",
        type="delete",
        @click="$emit('remove-selected', selected)"
      )
    template(#created="{ item }") {{ item.created | date }}
    template(#updated="{ item }") {{ item.updated | date }}
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
        pbehaviors-create-action-btn(:entity-id="item._id")
        pbehaviors-list-action-btn(:entity-id="item._id")
    template(#expand="{ item }")
      dynamic-infos-list-expand-item(:info="item")
</template>

<script>
import { OLD_PATTERNS_FIELDS } from '@/constants';

import { isOldPattern } from '@/helpers/entities/pattern/form';

import PbehaviorsCreateActionBtn from '@/components/other/pbehavior/pbehaviors/partials/pbehaviors-create-action-btn.vue';
import PbehaviorsListActionBtn from '@/components/other/pbehavior/pbehaviors/partials/pbehaviors-list-action-btn.vue';

import DynamicInfosListExpandItem from './partials/dynamic-infos-expand-item.vue';

export default {
  components: {
    PbehaviorsCreateActionBtn,
    PbehaviorsListActionBtn,
    DynamicInfosListExpandItem,
  },
  props: {
    dynamicInfos: {
      type: Array,
      required: true,
    },
    pagination: {
      type: Object,
      required: true,
    },
    totalItems: {
      type: Number,
      required: false,
    },
    pending: {
      type: Boolean,
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
        { text: this.$t('common.description'), value: 'description', sortable: false },
        { text: this.$t('common.enabled'), value: 'enabled', sortable: false },
        { text: this.$t('common.author'), value: 'author.display_name' },
        { text: this.$t('common.created'), value: 'created' },
        { text: this.$t('common.updated'), value: 'updated' },
        { text: this.$t('common.actionsLabel'), value: 'actions', sortable: false },
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
