<template lang="pug">
  v-layout(column)
    c-alert(v-if="!webhooks.length", type="info") {{ $t('declareTicket.emptyWebhooks') }}
    c-card-iterator-field.mb-2(
      v-field="webhooks",
      item-key="key",
      :disabled="disabled",
      :draggable-group="draggableGroup"
    )
      template(#item="{ index, item: webhook }")
        declare-ticket-rule-webhook-field(
          v-field="webhooks[index]",
          :name="`${name}.${webhook.key}`",
          :is-declare-ticket-exist="!webhook.declare_ticket.enabled && isSomeOneDeclareTicketEnabled",
          :has-previous="!!index",
          :webhook-number="index + 1",
          @remove="removeItemFromArray(index)"
        )
    v-layout(row, align-center)
      v-btn.ml-0(
        :color="hasWebhooksErrors ? 'error' : 'primary'",
        :disabled="disabled",
        outline,
        @click="addWebhook"
      ) {{ $t('declareTicket.addWebhook') }}
      span.error--text(v-show="hasWebhooksErrors") {{ $t('declareTicket.errors.webhookRequired') }}
</template>

<script>
import { declareTicketRuleWebhookToForm } from '@/helpers/entities/declare-ticket/rule/form';

import { formArrayMixin } from '@/mixins/form';

import DeclareTicketRuleWebhookField from './declare-ticket-rule-webhook-field.vue';

export default {
  inject: ['$validator'],
  components: {
    DeclareTicketRuleWebhookField,
  },
  mixins: [formArrayMixin],
  model: {
    prop: 'webhooks',
    event: 'input',
  },
  props: {
    webhooks: {
      type: Array,
      default: () => ([]),
    },
    name: {
      type: String,
      default: 'webhooks',
    },
    disabled: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    isSomeOneDeclareTicketEnabled() {
      return this.webhooks.some(webhook => webhook.declare_ticket.enabled);
    },

    hasWebhooksErrors() {
      return this.errors.has(this.name);
    },

    draggableGroup() {
      return {
        name: 'declare-ticket-steps',
      };
    },
  },
  watch: {
    webhooks() {
      this.$validator.validate(this.name);
    },
  },
  created() {
    this.attachMinValueRule();
  },
  beforeDestroy() {
    this.detachRules(this.name);
  },
  methods: {
    attachMinValueRule() {
      this.$validator.attach({
        name: this.name,
        rules: 'min_value:1',
        getter: () => this.webhooks.length,
        vm: this,
      });
    },

    detachRules() {
      this.$validator.detach(this.name);
    },

    addWebhook() {
      this.addItemIntoArray(declareTicketRuleWebhookToForm());
    },

    removeStep(index) {
      this.removeItemFromArray(index);
    },
  },
};
</script>
