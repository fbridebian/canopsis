<template lang="pug">
  v-layout(align-center)
    v-btn.ml-0(
      color="secondary",
      small,
      @click="showViewSelectModal"
    ) {{ $t('user.selectDefaultView') }}
    div {{ defaultViewTitle }}
    v-btn(
      v-if="value",
      icon,
      @click="clearDefaultView"
    )
      v-icon(color="error") clear
</template>

<script>
import { MODALS } from '@/constants';

import { entitiesViewGroupMixin } from '@/mixins/entities/view/group';

export default {
  mixins: [entitiesViewGroupMixin],
  model: {
    prop: 'value',
    event: 'input',
  },
  props: {
    value: {
      type: String,
      default: null,
    },
  },
  computed: {
    defaultViewTitle() {
      const userDefaultView = this.getViewById(this.value);

      return userDefaultView ? userDefaultView.title : null;
    },
  },
  methods: {
    showViewSelectModal() {
      this.$modals.show({
        name: MODALS.selectView,
        config: {
          action: viewId => this.$emit('input', viewId),
        },
      });
    },

    clearDefaultView() {
      this.$emit('input', '');
    },
  },
};
</script>
