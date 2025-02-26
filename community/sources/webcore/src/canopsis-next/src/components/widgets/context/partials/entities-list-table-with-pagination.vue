<template lang="pug">
  div
    c-empty-data-table-columns(v-if="!columns.length")
    c-advanced-data-table(
      v-else,
      :items="entities",
      :headers="headers",
      :loading="pending || columnsFiltersPending",
      :total-items="meta.total_count",
      :pagination.sync="pagination",
      :toolbar-props="toolbarProps",
      :select-all="selectable",
      expand,
      no-pagination
    )
      template(#toolbar="")
        slot(name="toolbar")
        v-flex(v-if="columns.length", xs12)
          v-layout(row, wrap, align-center)
            c-pagination(
              :page="query.page",
              :limit="query.limit",
              :total="meta.total_count",
              type="top",
              @input="updateQueryPage"
            )
      template(v-for="column in columns", #[column.value]="{ item }")
        entity-column-cell(
          :entity="item",
          :column="column",
          :columns-filters="columnsFilters"
        )
      template(#actions="{ item }")
        actions-panel(:item="item")
      template(#expand="{ item }")
        entities-list-expand-panel(
          :item="item",
          :columns-filters="columnsFilters",
          :service-dependencies-columns="widget.parameters.serviceDependenciesColumns",
          :resolved-alarms-columns="widget.parameters.resolvedAlarmsColumns",
          :active-alarms-columns="widget.parameters.activeAlarmsColumns",
          :charts="widget.parameters.charts"
        )
      template(#mass-actions="{ selected, clearSelected }")
        mass-actions-panel.ml-3(
          :items="selected",
          @clear:items="clearSelected"
        )

    c-table-pagination(
      :total-items="meta.total_count",
      :rows-per-page="query.limit",
      :page="query.page",
      @update:page="updateQueryPage",
      @update:rows-per-page="updateRecordsPerPage"
    )
</template>

<script>
import { isEqual, pick } from 'lodash';

import { SORT_ORDERS } from '@/constants';

import { authMixin } from '@/mixins/auth';
import { entitiesAlarmColumnsFiltersMixin } from '@/mixins/entities/associative-table/alarm-columns-filters';

import FilterSelector from '@/components/other/filter/partials/filter-selector.vue';
import FiltersListBtn from '@/components/other/filter/partials/filters-list-btn.vue';

import EntityColumnCell from '../columns-formatting/entity-column-cell.vue';
import ContextFab from '../actions/context-fab.vue';
import ActionsPanel from '../actions/actions-panel.vue';
import MassActionsPanel from '../actions/mass-actions-panel.vue';

import EntitiesListExpandPanel from './entities-list-expand-panel.vue';

export default {
  components: {
    FilterSelector,
    FiltersListBtn,
    EntitiesListExpandPanel,
    ContextFab,
    EntityColumnCell,
    ActionsPanel,
    MassActionsPanel,
  },
  mixins: [
    authMixin,
    entitiesAlarmColumnsFiltersMixin,
  ],
  props: {
    widget: {
      type: Object,
      required: true,
    },
    entities: {
      type: Array,
      required: true,
    },
    meta: {
      type: Object,
      required: true,
    },
    query: {
      type: Object,
      required: true,
    },
    columns: {
      type: Array,
      default: () => [],
    },
    pending: {
      type: Boolean,
      default: false,
    },
    selectable: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      columnsFilters: [],
      columnsFiltersPending: false,
    };
  },
  computed: {
    toolbarProps() {
      return {
        'justify-space-between': true,
        'align-center': true,
      };
    },

    headers() {
      return this.columns.length
        ? [
          ...this.columns,

          { text: this.$t('common.actionsLabel'), value: 'actions', sortable: false },
        ]
        : [];
    },

    pagination: {
      get() {
        const { sortDir, sortKey: sortBy = null, multiSortBy = [] } = this.query;
        const descending = sortDir === SORT_ORDERS.desc;

        return { sortBy, descending, multiSortBy };
      },

      set(value) {
        const paginationKeys = ['sortBy', 'descending', 'multiSortBy'];
        const newPagination = pick(value, paginationKeys);
        const oldPagination = pick(this.pagination, paginationKeys);

        if (isEqual(newPagination, oldPagination)) {
          return;
        }

        const {
          sortBy = null,
          descending = false,
          multiSortBy = [],
        } = newPagination;

        const newQuery = {
          sortKey: sortBy,
          sortDir: descending ? SORT_ORDERS.desc : SORT_ORDERS.asc,
          multiSortBy,
        };

        this.$emit('update:query', {
          ...this.query,
          ...newQuery,
        });
      },
    },
  },
  async mounted() {
    this.columnsFiltersPending = true;
    this.columnsFilters = await this.fetchAlarmColumnsFiltersList();
    this.columnsFiltersPending = false;
  },
  methods: {
    updateRecordsPerPage(limit) {
      this.$emit('update:query', {
        ...this.query,

        page: 1,
        limit,
      });
    },

    updateQueryPage(page) {
      this.$emit('update:query', {
        ...this.query,

        page,
      });
    },
  },
};
</script>
