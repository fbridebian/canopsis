<template lang="pug">
  div
    v-layout(justify-end)
      c-action-btn(
        :tooltip="$t('entity.addInformation')",
        icon="add",
        @click="showAddInfoModal"
      )
    v-data-table(
      :items="infos",
      :headers="tableHeaders",
      :no-data-text="$t('entity.emptyInfos')",
      item-key="name"
    )
      template(#items="{ item, index }")
        td {{ item.name }}
        td {{ item.description }}
        td {{ item.value }}
        td
          v-layout(row)
            c-action-btn(
              type="edit",
              @click="showEditInfoModal(index, item)"
            )
            c-action-btn(
              type="delete",
              @click="removeItemFromArray(index)"
            )
</template>

<script>
import { MODALS } from '@/constants';

import { formArrayMixin } from '@/mixins/form';

export default {
  mixins: [
    formArrayMixin,
  ],
  model: {
    prop: 'infos',
    event: 'input',
  },
  props: {
    infos: {
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {
      tableHeaders: [
        { text: this.$t('common.name'), value: 'name' },
        { text: this.$t('common.description'), value: 'description' },
        { text: this.$t('common.value'), value: 'value' },
        { text: this.$t('common.actionsLabel'), value: 'actions', sortable: false },
      ],
    };
  },
  methods: {
    showAddInfoModal() {
      this.$modals.show({
        name: MODALS.createEntityInfo,
        config: {
          infos: this.infos,
          action: info => this.addItemIntoArray(info),
        },
      });
    },

    showEditInfoModal(index, info) {
      this.$modals.show({
        name: MODALS.createEntityInfo,
        config: {
          infos: this.infos,
          entityInfo: info,
          title: this.$t('modals.createEntityInfo.edit.title'),
          action: editedInfo => this.updateItemInArray(index, editedInfo),
        },
      });
    },
  },
};
</script>
