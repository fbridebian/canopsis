<template lang="pug">
  v-layout(column)
    c-draggable-list-field(v-field="actions", handle=".action-drag-handler")
      event-filter-enrichment-action-form.mb-3(
        v-for="(action, index) in actions",
        v-field="actions[index]",
        :name="`${name}.${action.key}`",
        :key="action.key",
        :variables="variables",
        @remove="removeItemFromArray(index)"
      )
      v-flex
        v-btn.ml-0.my-0(color="primary", outline, @click="addAction") {{ $t('eventFilter.addAction') }}
</template>

<script>
import { eventFilterActionToForm } from '@/helpers/entities/event-filter/rule/form';

import { formArrayMixin } from '@/mixins/form';

import EventFilterEnrichmentActionForm from './event-filter-enrichment-action-form.vue';

export default {
  inject: ['$validator'],
  components: { EventFilterEnrichmentActionForm },
  mixins: [formArrayMixin],
  model: {
    prop: 'actions',
    event: 'input',
  },
  props: {
    actions: {
      type: Array,
      required: true,
    },
    variables: {
      type: Array,
      default: () => [],
    },
    name: {
      type: String,
      default: 'actions',
    },
  },
  methods: {
    addAction() {
      this.addItemIntoArray(eventFilterActionToForm());
    },
  },
};
</script>
