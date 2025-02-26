<template lang="pug">
  v-layout(wrap)
    v-flex(xs3)
      event-filter-failure-type-field(:value="query.type", @input="updateQueryField('type', $event)")
    v-flex(v-if="eventFilter.unread_failures_count", xs12)
      v-btn.mx-0(:loading="markAsReadPending", color="primary", @click="markNewFailuresAsRead")
        v-icon(left) done_all
        span {{ $t('eventFilter.markAsRead') }}
    v-flex(xs12)
      event-filter-failures-list(
        :failures="eventFilterFailures",
        :pagination.sync="pagination",
        :total-items="eventFilterFailuresMeta.total_count",
        :pending="eventFilterFailuresPending"
      )
</template>

<script>
import { localQueryMixin } from '@/mixins/query-local/query';
import { entitiesEventFilterMixin } from '@/mixins/entities/event-filter';

import EventFilterFailureTypeField from '../form/fields/event-filter-failure-type-field.vue';

import EventFilterFailuresList from './event-filter-failures-list.vue';

export default {
  components: { EventFilterFailureTypeField, EventFilterFailuresList },
  mixins: [localQueryMixin, entitiesEventFilterMixin],
  props: {
    eventFilter: {
      type: Object,
      default: () => ({}),
    },
  },
  data() {
    return {
      query: {
        type: undefined,
      },
      eventFilterFailures: [],
      eventFilterFailuresMeta: {},
      eventFilterFailuresPending: false,
      markAsReadPending: false,
    };
  },
  watch: {
    'eventFilter.failures_count': {
      handler() {
        this.fetchList();
      },
    },
  },
  mounted() {
    this.fetchList();
  },
  methods: {
    async markNewFailuresAsRead() {
      this.markAsReadPending = true;

      try {
        await this.markNewEventFilterFailuresAsRead({ id: this.eventFilter._id });

        this.fetchList();
        this.$emit('refresh');
      } catch (err) {
        console.error(err);
      } finally {
        this.markAsReadPending = false;
      }
    },

    async fetchList() {
      this.eventFilterFailuresPending = true;

      try {
        const params = this.getQuery();

        params.type = this.query.type;

        const { data, meta } = await this.fetchEventFilterFailuresListWithoutStore({
          id: this.eventFilter._id,
          params,
        });

        this.eventFilterFailures = data;
        this.eventFilterFailuresMeta = meta;
      } catch (err) {
        console.error(err);
      } finally {
        this.eventFilterFailuresPending = false;
      }
    },
  },
};
</script>
