<template lang="pug">
  div
    c-advanced-data-table.v-table-small(
      :headers="headers",
      :items="items",
      :loading="pending",
      :total-items="totalItems",
      :pagination="pagination",
      :select-all="removable",
      advanced-pagination,
      @update:pagination="$emit('update:pagination', $event)"
    )
      template(#mass-actions="{ selected }")
        c-action-btn(
          v-if="removable",
          type="delete",
          @click="$emit('remove-selected', selected)"
        )
      template(#oid="{ item }")
        snmp-rules-list-item-cell(:fields="oidFields", :source="item.oid")
      template(#output="{ item }")
        snmp-rules-list-item-cell(:fields="commonFields", :source="item.output")
      template(#resource="{ item }")
        snmp-rules-list-item-cell(:fields="commonFields", :source="item.resource")
      template(#component="{ item }")
        snmp-rules-list-item-cell(:fields="commonFields", :source="item.component")
      template(#state="{ item }")
        template(v-if="isTemplateStateType(item)")
          snmp-rules-list-item-cell(:fields="templateStateFields", :source="item.state")
          snmp-rules-list-item-cell(:fields="stateOidField")
          div.pl-3
            snmp-rules-list-item-cell(:fields="stateOidFields", :source="item.state.stateoid")
        template(v-else)
          snmp-rules-list-item-cell(:fields="stateFields", :source="item.state")
      template(#actions="{ item }")
        v-layout(row)
          c-action-btn(
            v-if="updatable",
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
</template>

<script>
import { ENTITIES_STATES, SNMP_STATE_TYPES } from '@/constants';

import SnmpRulesListItemCell from './partials/snmp-rules-list-item-cell.vue';

export default {
  components: {
    SnmpRulesListItemCell,
  },
  props: {
    pagination: {
      type: Object,
      required: true,
    },
    items: {
      type: Array,
      default: () => [],
    },
    totalItems: {
      type: Number,
      required: false,
    },
    pending: {
      type: Boolean,
      default: true,
    },
    removable: {
      type: Boolean,
      default: false,
    },
    duplicable: {
      type: Boolean,
      default: false,
    },
    updatable: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    oidFields() {
      return ['mibName', 'moduleName'];
    },

    commonFields() {
      return ['value', 'regex'];
    },

    stateFields() {
      return ['state', 'type'];
    },

    templateStateFields() {
      return [...Object.keys(ENTITIES_STATES), 'type'];
    },

    stateOidFields() {
      return [...this.commonFields, 'formatter'];
    },

    stateOidField() {
      return ['stateoid'];
    },

    headers() {
      return [
        {
          text: this.$t('snmpRule.oid'),
          value: 'oid',
          sortable: false,
        },
        {
          text: this.$t('snmpRule.output'),
          value: 'output',
          sortable: false,
        },
        {
          text: this.$t('snmpRule.resource'),
          value: 'resource',
          sortable: false,
        },
        {
          text: this.$t('snmpRule.component'),
          value: 'component',
          sortable: false,
        },
        {
          text: this.$t('snmpRule.state'),
          value: 'state',
          sortable: false,
        },
        {
          text: this.$t('common.actionsLabel'),
          value: 'actions',
          sortable: false,
        },
      ];
    },
  },
  methods: {
    isTemplateStateType(rule) {
      return rule.state.type === SNMP_STATE_TYPES.template;
    },
  },
};
</script>

<style lang="scss">
  .v-table-small table.v-table {
    tbody td:first-child,
    tbody td:not(:first-child),
    tbody th:first-child,
    tbody th:not(:first-child),
    thead td:first-child,
    thead td:not(:first-child),
    thead th:first-child,
    thead th:not(:first-child) {
      padding: 0 10px;
    }
  }
</style>
