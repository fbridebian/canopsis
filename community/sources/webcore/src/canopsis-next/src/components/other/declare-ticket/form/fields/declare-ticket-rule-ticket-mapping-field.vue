<template lang="pug">
  v-layout(column)
    c-information-block(
      :title="$t('declareTicket.ticketUrlAndId')",
      :help-text="ticketUrlHelpText",
      help-icon="help",
      help-icon-color="grey darken-1"
    )
      c-alert(v-if="isDeclareTicketExist", type="info") {{ $t('declareTicket.webhookTicketDeclarationExist') }}
      v-layout
        v-flex(xs6)
          c-enabled-field(v-field="value.enabled", :disabled="isDeclareTicketExist")
        v-flex(v-if="value.enabled", xs6)
          c-enabled-field(v-field="value.is_regexp", :label="$t('declareTicket.isRegexp')")
      template(v-if="value.enabled")
        c-enabled-field(
          v-if="!hideEmptyResponse",
          v-field="value.empty_response",
          :label="$t('declareTicket.emptyResponse')"
        )
        declare-ticket-rule-ticket-id-field(
          v-field="value.ticket_id",
          :disabled="disabled",
          :name="ticketIdFieldName",
          :required="ticketIdRequired"
        )
        declare-ticket-rule-ticket-url-field(
          v-field="value.ticket_url",
          :disabled="disabled",
          :name="ticketUrlFieldName"
        )
        declare-ticket-rule-ticket-custom-fields-field(v-field="value.mapping", :name="name", :disabled="disabled")
</template>

<script>
import { formMixin } from '@/mixins/form';

import DeclareTicketRuleTicketIdField from './declare-ticket-rule-ticket-id-field.vue';
import DeclareTicketRuleTicketCustomFieldsField from './declare-ticket-rule-ticket-custom-fields-field.vue';
import DeclareTicketRuleTicketUrlField from './declare-ticket-rule-ticket-url-field.vue';

export default {
  inject: ['$validator'],
  components: {
    DeclareTicketRuleTicketUrlField,
    DeclareTicketRuleTicketCustomFieldsField,
    DeclareTicketRuleTicketIdField,
  },
  mixins: [formMixin],
  model: {
    prop: 'value',
    event: 'input',
  },
  props: {
    value: {
      type: Object,
      required: true,
    },
    name: {
      type: String,
      default: 'declare_ticket',
    },
    disabled: {
      type: Boolean,
      default: false,
    },
    isDeclareTicketExist: {
      type: Boolean,
      default: false,
    },
    hideEmptyResponse: {
      type: Boolean,
      default: false,
    },
    ticketIdRequired: {
      type: Boolean,
      default: false,
    },
    onlyOneTicketId: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    ticketIdFieldName() {
      return `${this.name}.ticket_id`;
    },

    ticketUrlFieldName() {
      return `${this.name}.ticket_url`;
    },

    ticketUrlHelpText() {
      return [
        this.$t('declareTicket.ticketUrlAndIdHelpText'),
        this.onlyOneTicketId && this.$t('declareTicket.dataFromOneStepAttention'),
      ].filter(Boolean).join('\n');
    },
  },
};
</script>
