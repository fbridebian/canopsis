<template lang="pug">
  c-advanced-data-table(:headers="headers", :items="tickets", hide-actions, disable-initial-sort)
    template(#ticket_url="{ item }")
      template(v-if="item.ticket_url")
        a(v-if="isValidTicketUrl(item.ticket_url)", :href="item.ticket_url", target="_blank") {{ item.ticket_url }}
        span(v-else) {{ item.ticket_url }}
    template(#t="{ item }") {{ item.t | date }}
    template(#_t="{ item }")
      c-help-icon(v-bind="getIconProps(item)", top)
    template(#metaalarm="{ item }")
      v-icon(v-if="item.ticket_meta_alarm_id === parentAlarmId", top) low_priority
</template>

<script>
import { EVENT_ENTITY_TYPES } from '@/constants';

import { isValidUrl } from '@/plugins/validator/helpers/is-valid-url';

export default {
  props: {
    tickets: {
      type: Array,
      required: true,
    },
    parentAlarmId: {
      type: String,
      required: false,
    },
  },
  computed: {
    headers() {
      return [
        { text: this.$t('declareTicket.ticketURL'), value: 'ticket_url' },
        { text: this.$t('declareTicket.ticketID'), value: 'ticket' },
        { text: this.$t('common.systemName'), value: 'ticket_system_name' },
        { text: this.$t('declareTicket.ruleName'), value: 'ticket_rule_name' },
        { text: this.$t('common.date'), value: 't' },
        { text: this.$t('common.status'), value: '_t' },
        this.parentAlarmId && { text: this.$t('alarm.metaAlarm'), value: 'metaalarm' },
        { text: this.$t('common.author'), value: 'a' },
        { text: this.$tc('common.comment'), value: 'ticket_comment' },
      ].filter(Boolean);
    },
  },
  methods: {
    isValidTicketUrl(url) {
      return isValidUrl(url);
    },

    isSuccessTicket(ticket) {
      return [EVENT_ENTITY_TYPES.declareTicket, EVENT_ENTITY_TYPES.assocTicket].includes(ticket._t);
    },

    getIconProps(item) {
      const isSuccess = this.isSuccessTicket(item);

      return {
        icon: isSuccess ? 'check_circle' : 'error',
        color: isSuccess ? 'primary' : 'error',
        text: item.m,
        maxWidth: 400,
      };
    },
  },
};
</script>
