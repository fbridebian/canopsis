<template lang="pug">
  v-menu(
    v-model="opened",
    :close-on-content-click="false",
    content-class="date-time-picker",
    transition="slide-y-transition",
    max-width="290",
    right,
    lazy-with-unmount,
    lazy
  )
    template(#activator="{ on }")
      v-btn(
        v-on="on",
        color="secondary",
        icon,
        fab,
        small
      )
        v-icon calendar_today
    date-time-picker(
      v-field="value",
      :label="label",
      :round-hours="roundHours",
      @close="close"
    )
</template>

<script>
import DateTimePicker from './date-time-picker.vue';

export default {
  components: { DateTimePicker },
  model: {
    prop: 'value',
    event: 'input',
  },
  props: {
    value: {
      type: Date,
      default: () => new Date(),
    },
    label: {
      type: String,
      default: '',
    },
    roundHours: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      opened: false,
    };
  },
  methods: {
    close() {
      this.opened = false;
    },
  },
};
</script>
