<template lang="pug">
  v-layout(column)
    c-enabled-field(
      v-model="enabled",
      :label="label",
      color="primary",
      @input="updateIcon"
    )
    c-icon-field(
      v-if="enabled",
      v-field="icon",
      :label="$t('common.icon')",
      :name="name",
      required
    )
</template>

<script>
import { formBaseMixin } from '@/mixins/form';

export default {
  mixins: [formBaseMixin],
  model: {
    prop: 'icon',
    event: 'input',
  },
  props: {
    icon: {
      type: String,
      required: false,
    },
    label: {
      type: String,
      required: false,
    },
    name: {
      type: String,
      default: 'icon',
    },
  },
  data() {
    return {
      enabled: !!this.icon,
    };
  },
  methods: {
    updateIcon(value) {
      if (!value) {
        this.updateModel('');
      }
    },
  },
};
</script>
