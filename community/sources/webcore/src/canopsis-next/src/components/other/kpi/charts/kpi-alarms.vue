<template lang="pug">
  div.position-relative
    c-progress-overlay(:pending="pending")
    kpi-alarms-filters(v-model="pagination", :min-date="minDate")
    kpi-alarms-chart(
      :metrics="alarmsMetrics",
      :sampling="pagination.sampling",
      :downloading="downloading",
      :min-date="minDate",
      :interval="interval",
      responsive,
      @export:csv="exportMetricsAsCsv",
      @export:png="exportMetricsAsPng",
      @zoom="updateQueryField('interval', $event)"
    )
    kpi-error-overlay(v-if="unavailable || fetchError")
</template>

<script>
import { KPI_ALARM_METRICS_FILENAME_PREFIX } from '@/config';
import { QUICK_RANGES, ALARM_METRIC_PARAMETERS, SAMPLINGS, DATETIME_FORMATS } from '@/constants';

import { convertDateToStartOfDayTimestampByTimezone, convertDateToString } from '@/helpers/date/date';
import { convertMetricsToTimezone } from '@/helpers/entities/metric/list';
import { isMetricsQueryChanged } from '@/helpers/entities/metric/query';

import { entitiesMetricsMixin } from '@/mixins/entities/metrics';
import { localQueryMixin } from '@/mixins/query-local/query';
import { metricsIntervalFilterMixin } from '@/mixins/widget/metrics/interval';
import { metricsExportMixinCreator } from '@/mixins/widget/metrics/export';

import KpiAlarmsFilters from './partials/kpi-alarms-filters.vue';
import KpiErrorOverlay from './partials/kpi-error-overlay.vue';

const KpiAlarmsChart = () => import(/* webpackChunkName: "Charts" */'./partials/kpi-alarms-chart.vue');

export default {
  inject: ['$system'],
  components: { KpiErrorOverlay, KpiAlarmsFilters, KpiAlarmsChart },
  mixins: [
    entitiesMetricsMixin,
    localQueryMixin,
    metricsIntervalFilterMixin,
    metricsExportMixinCreator({
      createExport: 'createKpiAlarmExport',
      fetchExport: 'fetchMetricExport',
    }),
  ],
  props: {
    unavailable: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      alarmsMetrics: [],
      pending: false,
      fetchError: false,
      minDate: null,
      query: {
        sampling: SAMPLINGS.day,
        parameters: [ALARM_METRIC_PARAMETERS.createdAlarms],
        filter: null,
        interval: {
          from: QUICK_RANGES.last7Days.start,
          to: QUICK_RANGES.last7Days.stop,
        },
      },
    };
  },
  computed: {
    interval() {
      return this.getIntervalQuery();
    },
  },
  watch: {
    unavailable: {
      immediate: true,
      handler(unavailable) {
        if (!unavailable) {
          this.fetchList();
        }
      },
    },
  },
  methods: {
    customQueryCondition(query, oldQuery) {
      return isMetricsQueryChanged(query, oldQuery, this.minDate);
    },

    getFileName() {
      const { from, to } = this.getIntervalQuery();

      const fromTime = convertDateToString(from, DATETIME_FORMATS.short);
      const toTime = convertDateToString(to, DATETIME_FORMATS.short);

      return [KPI_ALARM_METRICS_FILENAME_PREFIX, fromTime, toTime, this.query.sampling].join('-');
    },

    getQuery() {
      return {
        ...this.getIntervalQuery(),

        parameters: this.query.parameters.map(metric => ({ metric })),
        sampling: this.query.sampling,
        filter: this.query.filter,
      };
    },

    async fetchList() {
      try {
        this.pending = true;

        const params = this.getQuery();
        const {
          data: alarmsMetrics,
          meta: { min_date: minDate },
        } = await this.fetchAlarmsMetricsWithoutStore({ params });

        this.alarmsMetrics = convertMetricsToTimezone(alarmsMetrics, this.$system.timezone);
        this.minDate = convertDateToStartOfDayTimestampByTimezone(minDate, this.$system.timezone);
        this.fetchError = false;

        if (params.from < this.minDate) {
          this.updateQueryField('interval', { ...this.query.interval, from: this.minDate });
        }
      } catch (err) {
        this.fetchError = true;
      } finally {
        this.pending = false;
      }
    },
  },
};
</script>
