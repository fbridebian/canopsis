<template lang="pug">
  v-autocomplete(
    v-field="value",
    v-validate="rules",
    :label="label",
    :hint="hint",
    :items="availableIconNames",
    :name="name",
    :error-messages="errors.collect(name)",
    :disabled="disabled",
    persistent-hint
  )
    template(#selection="{ item }")
      v-icon {{ item }}
      span.ml-2 {{ item }}
    template(#item="{ item }")
      v-icon {{ item }}
      span.ml-2 {{ item }}
    template(#no-data="")
      slot(name="no-data")
</template>

<script>
import materialIconNameByCode from '@/assets/material-icons/MaterialIcons-Regular.json';

export default {
  inject: ['$validator'],
  model: {
    prop: 'value',
    event: 'input',
  },
  props: {
    value: {
      type: String,
      default: '',
    },
    label: {
      type: String,
      default: '',
    },
    hint: {
      type: String,
      default: '',
    },
    name: {
      type: String,
      default: 'icon_name',
    },
    required: {
      type: Boolean,
      default: false,
    },
    disabled: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    availableIconNames() {
      return Object.keys(materialIconNameByCode);
    },

    rules() {
      return {
        required: this.required,
      };
    },
  },
};
</script>
