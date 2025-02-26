<template lang="pug">
  v-card-text
    planning-types-list(
      :pbehavior-types="pbehaviorTypes",
      :pending="pbehaviorTypesPending",
      :totalItems="pbehaviorTypesMeta.total_count",
      :pagination.sync="pagination",
      :removable="hasDeleteAnyPbehaviorTypeAccess",
      @remove-selected="showRemoveSelectedPbehaviorTypeModal",
      @remove="showRemovePbehaviorTypeModal",
      @edit="showEditPbehaviorTypeModal"
    )
</template>

<script>
import { MODALS } from '@/constants';

import { permissionsTechnicalPbehaviorTypesMixin } from '@/mixins/permissions/technical/pbehavior-types';
import { entitiesPbehaviorTypeMixin } from '@/mixins/entities/pbehavior/types';
import { localQueryMixin } from '@/mixins/query-local/query';

import PlanningTypesList from '@/components/other/pbehavior/types/pbehavior-types-list.vue';

export default {
  components: { PlanningTypesList },
  mixins: [
    permissionsTechnicalPbehaviorTypesMixin,
    entitiesPbehaviorTypeMixin,
    localQueryMixin,
  ],
  props: {
    params: {
      type: Object,
      default: () => ({}),
    },
  },
  mounted() {
    this.fetchList();
  },
  methods: {
    fetchList() {
      const params = this.getQuery();
      params.with_flags = true;
      params.with_hidden = true;

      this.fetchPbehaviorTypesList({ params });
    },

    async tryRemovePbehaviorType(pbehaviorTypeId) {
      try {
        await this.removePbehaviorType({ id: pbehaviorTypeId });
      } catch (err) {
        this.$popups.error({ text: err.error || this.$t('errors.default') });
      }
    },

    showEditPbehaviorTypeModal(pbehaviorType) {
      this.$modals.show({
        name: MODALS.createPbehaviorType,
        config: {
          pbehaviorType,
          action: async (newPbehaviorType) => {
            await this.updatePbehaviorType({
              data: newPbehaviorType,
              id: pbehaviorType._id,
            });
            await this.fetchList();
          },
        },
      });
    },

    showRemovePbehaviorTypeModal(pbehaviorTypeId) {
      this.$modals.show({
        name: MODALS.confirmation,
        config: {
          action: async () => {
            await this.tryRemovePbehaviorType(pbehaviorTypeId);
            await this.fetchList();
          },
        },
      });
    },

    showRemoveSelectedPbehaviorTypeModal(selected) {
      this.$modals.show({
        name: MODALS.confirmation,
        config: {
          action: async () => {
            await Promise.all(selected.map(({ _id: id }) => this.tryRemovePbehaviorType(id)));

            await this.fetchList();
          },
        },
      });
    },
  },
};
</script>
