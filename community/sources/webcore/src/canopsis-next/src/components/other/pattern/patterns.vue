<template lang="pug">
  patterns-list(
    :pagination.sync="pagination",
    :patterns="patterns",
    :total-items="patternsMeta.total_count",
    :pending="patternsPending",
    @edit="$listeners.edit",
    @remove="$listeners.remove",
    @remove-selected="$listeners['remove-selected']"
  )
</template>

<script>
import { localQueryMixin } from '@/mixins/query-local/query';
import { entitiesPatternsMixin } from '@/mixins/entities/pattern';

import PatternsList from './patterns-list.vue';

export default {
  components: {
    PatternsList,
  },
  mixins: [
    localQueryMixin,
    entitiesPatternsMixin,
  ],
  mounted() {
    this.fetchList();
  },
  methods: {
    fetchList() {
      return this.fetchPatternsList({ params: this.getQuery() });
    },
  },
};
</script>
