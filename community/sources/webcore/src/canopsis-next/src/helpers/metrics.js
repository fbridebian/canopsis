import {
  AGGREGATE_FUNCTIONS,
  ALARM_METRIC_PARAMETERS,
  DATETIME_FORMATS,
  EXTERNAL_METRIC_UNITS,
  KPI_RATING_ENTITY_METRICS,
  KPI_RATING_USER_CRITERIA,
  KPI_RATING_USER_METRICS,
  SAMPLINGS,
  TIME_UNITS,
  USER_METRIC_PARAMETERS,
} from '@/constants';

import { addUnitToDate, convertDateToString, convertDateToTimestampByTimezone } from '@/helpers/date/date';
import { isOmitEqual } from '@/helpers/equal';
import { convertDurationToMaxUnitDuration, convertDurationToString } from '@/helpers/date/duration';

/**
 * @typedef { 'hour' | 'day' | 'week' | 'month' } Sampling
 */

/**
 * @typedef { 'ms' | 'us' | 's' } ExternalMetricTimeUnit
 */

/**
 * @typedef { 'c' | 'B' | 'KB' | 'MB' | 'GB' | 'TB' } ExternalMetricDataSizeUnit
 */

/**
 * @typedef { ExternalMetricTimeUnit | ExternalMetricDataSizeUnit | '%' } ExternalMetricUnit
 */

/**
 * @typedef {Object} Metric
 * @property {number} timestamp
 */

/**
 * Check metric is time
 *
 * @param {string} metric
 * @returns {boolean}
 */
export const isTimeMetric = metric => [
  USER_METRIC_PARAMETERS.totalUserActivity,
  ALARM_METRIC_PARAMETERS.averageAck,
  ALARM_METRIC_PARAMETERS.averageResolve,
  ALARM_METRIC_PARAMETERS.timeToAck,
  ALARM_METRIC_PARAMETERS.timeToResolve,
  ALARM_METRIC_PARAMETERS.maxAck,
  ALARM_METRIC_PARAMETERS.minAck,
].includes(metric);

/**
 * Check metric is ratio
 *
 * @param {string} metric
 * @returns {boolean}
 */
export const isRatioMetric = metric => [
  ALARM_METRIC_PARAMETERS.ratioCorrelation,
  ALARM_METRIC_PARAMETERS.ratioInstructions,
  ALARM_METRIC_PARAMETERS.ratioTickets,
  ALARM_METRIC_PARAMETERS.ratioNonDisplayed,
  ALARM_METRIC_PARAMETERS.ratioRemediatedAlarms,
].includes(metric);

/**
 * Return label by sampling
 *
 * @param {number | string} value
 * @param {Sampling} sampling
 * @returns {string}
 *
 * @example
 * getDateLabelBySampling(1636523087405, 'hour') // 10/11/2021 12:44
 * getDateLabelBySampling(1636523087405, 'day') // 10/11/2021
 * getDateLabelBySampling(1636523087405, 'week') // 10/11/2021 - \n17/11/2021
 * getDateLabelBySampling(1636523087405, 'month') // November 2021
 */
export const getDateLabelBySampling = (value, sampling) => {
  switch (sampling) {
    case SAMPLINGS.hour:
      return convertDateToString(value, DATETIME_FORMATS.dateTimePicker);
    case SAMPLINGS.day:
      return convertDateToString(value, DATETIME_FORMATS.short);
    case SAMPLINGS.week:
      return [
        convertDateToString(value, DATETIME_FORMATS.short),
        convertDateToString(addUnitToDate(value, 1, TIME_UNITS.week), DATETIME_FORMATS.short),
      ].join(' - \n');
  }

  return convertDateToString(value, DATETIME_FORMATS.yearWithMonth);
};

/**
 * Check is user criteria
 *
 * @param {string} criteria
 * @returns {boolean}
 */
export const isUserCriteria = criteria => KPI_RATING_USER_CRITERIA.includes(criteria);

/**
 * Get all metrics by criteria
 *
 * @param {string} criteria
 * @returns {string[]}
 */
export const getAvailableMetricsByCriteria = criteria => (
  isUserCriteria(criteria)
    ? KPI_RATING_USER_METRICS
    : KPI_RATING_ENTITY_METRICS
);

/**
 * If metric available for criteria return metric, else return first available metric
 *
 * @param {string} metric
 * @param {string} [criteria]
 * @returns {string}
 */
export const getAvailableMetricByCriteria = (metric, criteria) => {
  const metrics = getAvailableMetricsByCriteria(criteria);

  if (criteria && metrics.includes(metric)) {
    return metric;
  }

  const [firstMetric] = metrics;

  return firstMetric;
};

/**
 * Check query is changed with interval
 *
 * @param {Object} query
 * @param {Object} oldQuery
 * @param {number} minDate
 * @returns {boolean}
 */
export const isMetricsQueryChanged = (query, oldQuery, minDate) => {
  const isFromChanged = query.interval.from !== oldQuery.interval.from;
  const isFromEqualMinDate = query.interval.from === minDate;
  const isToChanged = query.interval.to !== oldQuery.interval.to;
  const isQueryWithoutIntervalChanged = !isOmitEqual(query, oldQuery, ['interval']);

  return isQueryWithoutIntervalChanged || (isFromChanged && !isFromEqualMinDate) || isToChanged;
};

/**
 * Check is external percent metric unit
 *
 * @param {ExternalMetricUnit} [unit]
 * @returns {boolean}
 */
export const isExternalPercentMetricUnit = unit => unit === EXTERNAL_METRIC_UNITS.percent;

/**
 * Check is external time metric unit
 *
 * @param {ExternalMetricUnit} [unit]
 * @returns {boolean}
 */
export const isExternalTimeMetricUnit = unit => [
  EXTERNAL_METRIC_UNITS.microsecond,
  EXTERNAL_METRIC_UNITS.millisecond,
  EXTERNAL_METRIC_UNITS.second,
].includes(unit);

/**
 * Check is external data size metric unit
 *
 * @param {ExternalMetricUnit} [unit]
 * @returns {boolean}
 */
export const isExternalDataSizeMetricUnit = unit => [
  EXTERNAL_METRIC_UNITS.continuousCounter,
  EXTERNAL_METRIC_UNITS.byte,
  EXTERNAL_METRIC_UNITS.kilobyte,
  EXTERNAL_METRIC_UNITS.megabyte,
  EXTERNAL_METRIC_UNITS.gigabyte,
  EXTERNAL_METRIC_UNITS.terabyte,
].includes(unit);

/**
 * Convert metrics timestamps to local timezone
 *
 * @param {Metric[]} metrics
 * @param {string} timezone
 * @returns {Metric[]}
 */
export const convertMetricsToTimezone = (metrics, timezone) => metrics.map(metric => ({
  ...metric,

  timestamp: convertDateToTimestampByTimezone(metric.timestamp, timezone),
}));

/**
 * Get default aggregate function by metric
 *
 * @param {string} metric
 * @returns {string}
 */
export const getDefaultAggregateFunctionByMetric = (metric) => {
  switch (metric) {
    case ALARM_METRIC_PARAMETERS.createdAlarms:
    case ALARM_METRIC_PARAMETERS.ackAlarms:
    case ALARM_METRIC_PARAMETERS.cancelAckAlarms:
    case ALARM_METRIC_PARAMETERS.ratioCorrelation:
    case ALARM_METRIC_PARAMETERS.ratioInstructions:
    case ALARM_METRIC_PARAMETERS.ratioNonDisplayed:
    case ALARM_METRIC_PARAMETERS.ratioRemediatedAlarms:
      return AGGREGATE_FUNCTIONS.sum;
    default:
      return AGGREGATE_FUNCTIONS.avg;
  }
};

/**
 * Get all available aggregate functions by metric
 *
 * @param {string} metric
 * @returns {string[]}
 */
export const getAggregateFunctionsByMetric = (metric) => {
  switch (metric) {
    case ALARM_METRIC_PARAMETERS.activeAlarms:
    case ALARM_METRIC_PARAMETERS.ackActiveAlarms:
    case ALARM_METRIC_PARAMETERS.ticketActiveAlarms:
    case ALARM_METRIC_PARAMETERS.withoutTicketActiveAlarms:
    case ALARM_METRIC_PARAMETERS.averageAck:
    case ALARM_METRIC_PARAMETERS.averageResolve:
    case ALARM_METRIC_PARAMETERS.timeToAck:
    case ALARM_METRIC_PARAMETERS.timeToResolve:
    case ALARM_METRIC_PARAMETERS.notAckedAlarms:
    case ALARM_METRIC_PARAMETERS.notAckedInHourAlarms:
    case ALARM_METRIC_PARAMETERS.notAckedInFourHoursAlarms:
    case ALARM_METRIC_PARAMETERS.notAckedInDayAlarms:
      return [
        AGGREGATE_FUNCTIONS.avg,
        AGGREGATE_FUNCTIONS.min,
        AGGREGATE_FUNCTIONS.max,
      ];
    case ALARM_METRIC_PARAMETERS.ratioCorrelation:
    case ALARM_METRIC_PARAMETERS.ratioInstructions:
    case ALARM_METRIC_PARAMETERS.ratioNonDisplayed:
    case ALARM_METRIC_PARAMETERS.ratioRemediatedAlarms:
      return [AGGREGATE_FUNCTIONS.sum];
    case ALARM_METRIC_PARAMETERS.ratioTickets:
      return [AGGREGATE_FUNCTIONS.avg];
    case ALARM_METRIC_PARAMETERS.createdAlarms:
    case ALARM_METRIC_PARAMETERS.nonDisplayedAlarms:
    case ALARM_METRIC_PARAMETERS.instructionAlarms:
    case ALARM_METRIC_PARAMETERS.pbehaviorAlarms:
    case ALARM_METRIC_PARAMETERS.correlationAlarms:
    case ALARM_METRIC_PARAMETERS.ackAlarms:
    case ALARM_METRIC_PARAMETERS.cancelAckAlarms:
    case ALARM_METRIC_PARAMETERS.minAck:
    case ALARM_METRIC_PARAMETERS.maxAck:
    case ALARM_METRIC_PARAMETERS.manualInstructionAssignedAlarms:
    case ALARM_METRIC_PARAMETERS.manualInstructionExecutedAlarms:
      return [
        AGGREGATE_FUNCTIONS.sum,
        AGGREGATE_FUNCTIONS.avg,
        AGGREGATE_FUNCTIONS.min,
        AGGREGATE_FUNCTIONS.max,
      ];
    default:
      return [
        AGGREGATE_FUNCTIONS.sum,
        AGGREGATE_FUNCTIONS.last,
        AGGREGATE_FUNCTIONS.avg,
        AGGREGATE_FUNCTIONS.min,
        AGGREGATE_FUNCTIONS.max,
      ];
  }
};

/**
 * Get max time duration for metrics array
 *
 * @param {Metric[]} metrics
 * @returns {Duration}
 */
export const getMaxTimeDurationForMetrics = (metrics) => {
  const maxTimeValue = Math.max.apply(null, metrics.reduce((acc, { title: metric, data, unit }) => {
    if (isTimeMetric(metric) || isExternalTimeMetricUnit(unit)) {
      const maxDatasetValue = Math.max.apply(null, data.map(({ value }) => value));

      acc.push(maxDatasetValue);
    }

    return acc;
  }, []));

  return convertDurationToMaxUnitDuration({
    value: maxTimeValue,
    unit: TIME_UNITS.second,
  });
};

/**
 * Check if metrics has history data
 *
 * @param {Metric[]} [metrics = {}]
 * @return {boolean}
 */
export const hasHistoryData = (metrics = []) => {
  const [firstMetric = {}] = metrics;

  return firstMetric.data?.length
    && firstMetric.data.every(({ history_timestamp: historyTimestamp }) => historyTimestamp);
};

/**
 * Convert metric data size value to byte unit
 *
 * @param {number} value
 * @param {ExternalMetricDataSizeUnit} unit
 * @returns {number}
 */
export const convertDataSizeMetricValueToBytes = (value, unit) => {
  const degree = {
    [EXTERNAL_METRIC_UNITS.terabyte]: 4,
    [EXTERNAL_METRIC_UNITS.gigabyte]: 3,
    [EXTERNAL_METRIC_UNITS.megabyte]: 2,
    [EXTERNAL_METRIC_UNITS.kilobyte]: 1,
    [EXTERNAL_METRIC_UNITS.byte]: 0,
    [EXTERNAL_METRIC_UNITS.continuousCounter]: 0,
  }[unit];

  return value * (1024 ** degree);
};

/**
 * Convert metric time value to seconds unit
 *
 * @param {number} value
 * @param {ExternalMetricTimeUnit} unit
 * @returns {number}
 */
export const convertTimeMetricValueToSeconds = (value, unit) => {
  if (unit === EXTERNAL_METRIC_UNITS.second) {
    return value;
  }

  const degree = {
    [EXTERNAL_METRIC_UNITS.millisecond]: 1,
    [EXTERNAL_METRIC_UNITS.microsecond]: 2,
  }[unit];

  return value / (1000 ** degree);
};

/**
 * Convert metric value by dataset unit
 *
 * @param {number} value
 * @param {ExternalMetricUnit} unit
 * @returns {number}
 */
export const convertMetricValueByUnit = (value, unit) => {
  if (isExternalDataSizeMetricUnit(unit)) {
    return convertDataSizeMetricValueToBytes(value, unit);
  }

  if (isExternalTimeMetricUnit(unit)) {
    return convertTimeMetricValueToSeconds(value, unit);
  }

  return value;
};

/**
 * Convert metric data size value to tick string
 *
 * @param {number} value
 * @returns {string}
 */
// eslint-disable-next-line consistent-return
export const convertDataSizeValueToTickString = (value) => {
  const units = [
    EXTERNAL_METRIC_UNITS.byte,
    EXTERNAL_METRIC_UNITS.kilobyte,
    EXTERNAL_METRIC_UNITS.megabyte,
    EXTERNAL_METRIC_UNITS.gigabyte,
    EXTERNAL_METRIC_UNITS.terabyte,
  ];

  for (let index = 0; index < units.length; index += 1) {
    const result = value / (1024 ** index);

    if (result < 1024 || index === units.length - 1) {
      const resultUnit = units[index];

      return `${result % 1 > 0 ? result.toFixed(2) : result}${resultUnit}`;
    }
  }
};

/**
 * Convert time value to duration string with microseconds
 *
 * @param {number} value
 * @returns {string}
 */
export const convertMetricDurationToString = (value) => {
  const milliseconds = value * 1000;
  const hasMicroseconds = milliseconds % 1 > 0;

  let result = convertDurationToString(
    value,
    DATETIME_FORMATS.durationWithMilliseconds,
    TIME_UNITS.second,
    hasMicroseconds ? '' : '0s',
  );

  if (hasMicroseconds) {
    const microseconds = (value * (1000 ** 2));
    result += ` ${microseconds} μs`;
  }

  return result.trim();
};

/**
 * Convert value to string by metric and unit
 *
 * @param {number} value
 * @param {string} metric
 * @param {ExternalMetricUnit} unit
 * @returns {string}
 */
export const convertMetricValueToString = (value, metric, unit) => {
  if (isTimeMetric(metric) || isExternalTimeMetricUnit(unit)) {
    return convertMetricDurationToString(value);
  }

  if (isRatioMetric(metric) || isExternalPercentMetricUnit(unit)) {
    return `${value}%`;
  }

  if (isExternalDataSizeMetricUnit(unit)) {
    return convertDataSizeValueToTickString(value);
  }

  return value;
};
