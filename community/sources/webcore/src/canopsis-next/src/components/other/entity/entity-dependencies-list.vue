<template lang="pug">
  entities-list-table-with-pagination(
    :widget="widget",
    :entities="entities",
    :pending="pending",
    :meta="meta",
    :query.sync="query",
    :columns="columns",
    selectable
  )
    template(#toolbar="")
      v-flex
        c-advanced-search-field(
          :query.sync="query",
          :columns="columns",
          :tooltip="$t('context.advancedSearch')"
        )
      v-flex(v-if="hasAccessToCategory")
        c-entity-category-field.mr-3(:category="query.category", @input="updateCategory")
</template>

<script>
import { authMixin } from '@/mixins/auth';
import { localQueryMixin } from '@/mixins/query-local/query';
import { entitiesEntityDependenciesMixin } from '@/mixins/entities/entity-dependencies';
import { permissionsWidgetsContextCategory } from '@/mixins/permissions/widgets/context/category';

import EntitiesListTableWithPagination from '../../widgets/context/partials/entities-list-table-with-pagination.vue';

export default {
  components: { EntitiesListTableWithPagination },
  mixins: [
    authMixin,
    localQueryMixin,
    entitiesEntityDependenciesMixin,
    permissionsWidgetsContextCategory,
  ],
  props: {
    entityId: {
      type: String,
      required: true,
    },
    widget: {
      type: Object,
      required: true,
    },
    impact: {
      type: Boolean,
      default: false,
    },
    columns: {
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {
      pending: false,
      entities: [],
      meta: {},
    };
  },
  mounted() {
    this.fetchList();
  },
  methods: {
    updateCategory(category) {
      const categoryId = category && category._id;

      this.query = {
        ...this.query,

        page: 1,
        category: categoryId,
      };
    },

    async fetchList() {
      try {
        this.pending = true;

        const params = this.getQuery();
        params.with_flags = true;

        const { data, meta } = await this.fetchDependenciesList({
          id: this.entityId,
          params,
        });

        this.entities = data;
        this.meta = meta;
      } catch (err) {
        console.error(err);
      } finally {
        this.pending = false;
      }
    },
  },
};
</script>
