<template lang="pug">
  v-badge.time-line-flag(:value="isActiveBadge", color="transparent", overlap)
    template(#badge="")
      v-icon.time-line-flag__badge-icon(color="error", size="14") error
    v-icon(:color="style.color") {{ style.icon }}
</template>

<script>
import { EVENT_ENTITY_TYPES } from '@/constants';

import { formatStep } from '@/helpers/entities/entity/formatting';

/**
 * Component for the flag on the alarms list's timeline
 *
 * @module alarm
 *
 * @prop {Object} step - step object
 */
export default {
  props: {
    step: {
      type: Object,
      required: true,
    },
    error: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    style() {
      return formatStep(this.step);
    },

    isActiveBadge() {
      return [EVENT_ENTITY_TYPES.declareTicketFail, EVENT_ENTITY_TYPES.webhookFail].includes(this.step._t);
    },
  },
};
</script>

<style lang="scss">
.time-line-flag {
  &__badge-icon {
    background: white;
    border-radius: 50%;
  }
}
</style>
