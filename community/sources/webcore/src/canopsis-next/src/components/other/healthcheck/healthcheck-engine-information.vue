<template lang="pug">
  div
    p.pre-wrap(v-if="!engine.is_running") {{ systemDownMessage }}
    div(v-if="engine.is_too_few_instances")
      div.pre-wrap {{ $t('healthcheck.activeInstances', { instances, minInstances, optimalInstances }) }}
      healthcheck-engine-instance-diagram(
        :instances="instances",
        :min-instances="minInstances",
        :optimal-instances="optimalInstances",
        :is-pro-engine="isProEngine"
      )
    p.pre-wrap(v-if="engine.is_queue_overflown")
      | {{ $t('healthcheck.queueOverflowed', { queueLength, maxQueueLength }) }}
    p.pre-wrap(v-if="engine.is_diff_instances_config") {{ $t('healthcheck.invalidInstancesConfiguration') }}
</template>

<script>
import { PRO_ENGINES, HEALTHCHECK_ENGINES_NAMES, HEALTHCHECK_SERVICES_NAMES } from '@/constants';

import { healthcheckNodesMixin } from '@/mixins/healthcheck/healthcheck-nodes';

import HealthcheckEngineInstanceDiagram from './partials/healthcheck-engine-instance-diagram.vue';

export default {
  components: { HealthcheckEngineInstanceDiagram },
  mixins: [healthcheckNodesMixin],
  props: {
    engine: {
      type: Object,
      default: () => ({}),
    },
    maxQueueLength: {
      type: Number,
      default: 0,
    },
  },
  computed: {
    name() {
      return this.getNodeName(this.engine.name);
    },

    isProEngine() {
      return PRO_ENGINES.includes(this.engine.name);
    },

    queueLength() {
      return this.engine.queue_length;
    },

    instances() {
      return this.engine.instances;
    },

    minInstances() {
      return this.engine.min_instances;
    },

    optimalInstances() {
      return this.engine.optimal_instances;
    },

    systemDownMessage() {
      const messageKey = {
        [HEALTHCHECK_ENGINES_NAMES.fifo]: 'healthcheck.engineDown',
        [HEALTHCHECK_SERVICES_NAMES.timescaleDB]: 'healthcheck.timescaleDown',
      }[this.engine.name] || 'healthcheck.engineDownOrSlow';

      return this.$t(messageKey, { name: this.name });
    },
  },
};
</script>
