<template lang="pug">
  modal-wrapper(close)
    template(#title="")
      span {{ $t('common.pbehaviorList') }}
    template(#text="")
      c-advanced-data-table(:headers="headers", :items="filteredPbehaviors", expand)
        template(#enabled="{ item }")
          c-enabled(:value="item.enabled")
        template(#tstart="{ item }") {{ item.tstart | timezone($system.timezone) }}
        template(#tstop="{ item }") {{ item.tstop | timezone($system.timezone) }}
        template(#rrule="{ item }")
          v-icon {{ item.rrule ? 'check' : 'clear' }}
        template(#actions="{ item }")
          v-layout(row)
            c-action-btn(
              v-if="hasAccessToEditPbehavior",
              type="edit",
              @click="showEditPbehaviorModal(item)"
            )
            c-action-btn(
              v-if="hasAccessToDeletePbehavior",
              type="delete",
              @click="showRemovePbehaviorModal(item._id)"
            )
        template(#is_active_status="{ item }")
          v-icon(:color="item.is_active_status ? 'primary' : 'error'") $vuetify.icons.settings_sync
        template(#expand="{ item }")
          pbehaviors-list-expand-item(:pbehavior="item")
      v-layout(justify-end)
        c-action-fab-btn(
          :tooltip="$t('modals.pbehaviorsCalendar.title')",
          icon="calendar_today",
          color="secondary",
          small,
          left,
          @click="showPbehaviorsCalendarModal"
        )
        v-btn(
          v-if="showAddButton",
          color="primary",
          icon,
          fab,
          small,
          @click="showCreatePbehaviorModal"
        )
          v-icon add
    template(#actions="")
      v-btn.primary(@click="$modals.hide") {{ $t('common.ok') }}
</template>

<script>
import { MODALS, CRUD_ACTIONS } from '@/constants';

import { createEntityIdPatternByValue } from '@/helpers/entities/pattern/form';

import { modalInnerMixin } from '@/mixins/modal/inner';
import { entitiesPbehaviorMixin } from '@/mixins/entities/pbehavior';

import PbehaviorsListExpandItem from '@/components/other/pbehavior/pbehaviors/partials/pbehaviors-list-expand-item.vue';

import ModalWrapper from '../modal-wrapper.vue';

/**
 * Modal showing a list of an alarm's pbehaviors
 */
export default {
  name: MODALS.pbehaviorList,
  inject: ['$system'],
  components: {
    PbehaviorsListExpandItem,
    ModalWrapper,
  },
  mixins: [modalInnerMixin, entitiesPbehaviorMixin],
  computed: {
    headers() {
      return [
        { text: this.$t('common.name'), value: 'name' },
        { text: this.$t('common.author'), value: 'author.display_name' },
        { text: this.$t('pbehavior.isEnabled'), value: 'enabled' },
        { text: this.$t('pbehavior.begins'), value: 'tstart' },
        { text: this.$t('pbehavior.ends'), value: 'tstop' },
        { text: this.$t('common.type'), value: 'type.name' },
        { text: this.$t('common.reason'), value: 'reason.name' },
        { text: this.$t('common.recurrence'), value: 'rrule' },
        { text: this.$t('common.status'), value: 'is_active_status', sortable: false },
        { text: this.$t('common.actionsLabel'), value: 'actions', sortable: false },
      ];
    },
    availableActions() {
      return this.modal.config.availableActions ?? [];
    },

    hasAccessToEditPbehavior() {
      return this.availableActions.includes(CRUD_ACTIONS.update);
    },

    hasAccessToDeletePbehavior() {
      return this.availableActions.includes(CRUD_ACTIONS.delete);
    },

    filteredPbehaviors() {
      if (this.modal.config.onlyActive) {
        return this.pbehaviors.filter(value => value.enabled);
      }

      return this.pbehaviors;
    },
    showAddButton() {
      return this.modal.config.availableActions.includes(CRUD_ACTIONS.create);
    },
  },
  mounted() {
    this.fetchPbehaviorsByEntityId({
      params: { _id: this.modal.config.entityId },
    });
  },
  methods: {
    showRemovePbehaviorModal(pbehaviorId) {
      this.$modals.show({
        name: MODALS.confirmation,
        config: {
          action: () => this.removePbehavior({ id: pbehaviorId }),
        },
      });
    },

    showCreatePbehaviorModal() {
      this.$modals.show({
        name: MODALS.pbehaviorPlanning,
        config: {
          entityPattern: createEntityIdPatternByValue(this.modal.config.entityId),
        },
      });
    },

    showEditPbehaviorModal(pbehavior) {
      this.$modals.show({
        name: MODALS.createPbehavior,
        config: {
          pbehavior,
          noPattern: true,
          timezone: this.$system.timezone,
          action: data => this.updatePbehavior({ data, id: pbehavior._id }),
        },
      });
    },

    showPbehaviorsCalendarModal() {
      this.$modals.show({
        name: MODALS.pbehaviorsCalendar,
        config: {
          entityId: this.modal.config.entityId,
        },
      });
    },
  },
};
</script>
