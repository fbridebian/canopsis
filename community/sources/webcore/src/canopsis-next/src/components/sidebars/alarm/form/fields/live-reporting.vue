<template lang="pug">
  settings-button-field(
    :is-empty="isValueEmpty",
    addable,
    removable,
    @create="showEditLiveReportingModal",
    @edit="showEditLiveReportingModal",
    @delete="removeLiveReporting"
  )
    template(#title="")
      div.subheading {{ $t('settings.liveReporting.title') }}
</template>

<script>
import { MODALS } from '@/constants';

import { formBaseMixin } from '@/mixins/form';

import SettingsButtonField from '@/components/sidebars/form/fields/button-field.vue';

export default {
  components: { SettingsButtonField },
  mixins: [formBaseMixin],
  props: {
    value: {
      type: Object,
      default: () => ({}),
    },
  },
  computed: {
    isValueEmpty() {
      const { tstart, tstop } = this.value || {};

      return !tstart && !tstop;
    },
  },
  methods: {
    showEditLiveReportingModal() {
      this.$modals.show({
        name: MODALS.editLiveReporting,
        config: {
          ...this.value,

          action: value => this.updateModel(value),
        },
      });
    },

    removeLiveReporting() {
      this.updateModel({});
    },
  },
};
</script>
