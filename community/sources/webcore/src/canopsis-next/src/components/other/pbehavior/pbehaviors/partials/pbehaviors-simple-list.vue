<template lang="pug">
  v-layout(column)
    v-layout(row, justify-end)
      c-action-fab-btn.ma-0(
        v-if="addable",
        :tooltip="$t('modals.createPbehavior.create.title')",
        icon="add",
        color="primary",
        small,
        left,
        @click="showCreatePbehaviorModal"
      )
      c-action-fab-btn.ma-0(
        :tooltip="$t('modals.pbehaviorsCalendar.title')",
        icon="calendar_today",
        color="secondary",
        small,
        left,
        @click="showPbehaviorsCalendarModal"
      )
    c-advanced-data-table.ma-0(
      :items="pbehaviors",
      :headers="headers",
      :loading="pending",
      :dense="dense"
    )
      template(#enabled="{ item }")
        c-enabled(:value="item.enabled")
      template(#tstart="{ item }") {{ formatIntervalDate(item, 'tstart') }}
      template(#tstop="{ item }") {{ formatIntervalDate(item, 'tstop') }}
      template(#rrule_end="{ item }") {{ formatRruleEndDate(item) }}
      template(#rrule="{ item }")
        v-icon {{ item.rrule ? 'check' : 'clear' }}
      template(#icon="{ item }")
        v-icon(color="primary") {{ item.type.icon_name }}
      template(#status="{ item }")
        v-icon(:color="item.is_active_status ? 'primary' : 'error'") $vuetify.icons.settings_sync
      template(#actions="{ item }")
        v-layout(row)
          c-action-btn(
            v-if="updatable",
            :disabled="!item.editable",
            :tooltip="item.editable ? $t('common.edit') : $t('pbehavior.notEditable')",
            type="edit",
            @click="showEditPbehaviorModal(item)"
          )
          c-action-btn(v-if="removable", type="delete", @click="showDeletePbehaviorModal(item._id)")
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

import { MODALS } from '@/constants';

import Observer from '@/services/observer';

import { createEntityIdPatternByValue } from '@/helpers/entities/pattern/form';

import { pbehaviorsDateFormatMixin } from '@/mixins/pbehavior/pbehavior-date-format';

const { mapActions } = createNamespacedHelpers('pbehavior');

export default {
  inject: {
    $system: {},
    $periodicRefresh: {
      default() {
        return new Observer();
      },
    },
  },
  mixins: [pbehaviorsDateFormatMixin],
  props: {
    entity: {
      type: Object,
      required: true,
    },
    removable: {
      type: Boolean,
      default: false,
    },
    updatable: {
      type: Boolean,
      default: false,
    },
    dense: {
      type: Boolean,
      default: false,
    },
    addable: {
      type: Boolean,
      default: false,
    },
    withActiveStatus: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      pending: false,
      pbehaviors: [],
    };
  },
  computed: {
    headers() {
      const headers = [
        { text: this.$t('common.name'), value: 'name' },
        { text: this.$t('common.author'), value: 'author.display_name' },
        { text: this.$t('pbehavior.isEnabled'), value: 'enabled' },
        { text: this.$t('pbehavior.begins'), value: 'tstart' },
        { text: this.$t('pbehavior.ends'), value: 'tstop' },
        { text: this.$t('pbehavior.rruleEnd'), value: 'rrule_end' },
        { text: this.$t('common.recurrence'), value: 'rrule' },
        { text: this.$t('common.type'), value: 'type.name' },
        { text: this.$t('common.reason'), value: 'reason.name' },
        { text: this.$t('common.icon'), value: 'icon' },
      ];

      if (this.withActiveStatus) {
        headers.push({ text: this.$t('common.status'), value: 'status', sortable: false });
      }

      if (this.updatable || this.removable) {
        headers.push({ text: this.$t('common.actionsLabel'), value: 'actions', sortable: false });
      }

      return headers;
    },
  },
  mounted() {
    this.fetchList();

    this.$periodicRefresh.register(this.fetchList);
  },
  beforeDestroy() {
    this.$periodicRefresh.unregister(this.fetchList);
  },
  methods: {
    ...mapActions({
      fetchPbehaviorsByEntityIdWithoutStore: 'fetchListByEntityIdWithoutStore',
      removePbehavior: 'removeWithoutStore',
    }),

    showEditPbehaviorModal(pbehavior) {
      this.$modals.show({
        name: MODALS.pbehaviorPlanning,
        config: {
          pbehaviors: [pbehavior],
          afterSubmit: this.fetchList,
        },
      });
    },

    showPbehaviorsCalendarModal() {
      this.$modals.show({
        name: MODALS.pbehaviorsCalendar,
        config: {
          title: this.$t('modals.pbehaviorsCalendar.entity.title', { name: this.entity.name }),
          entityId: this.entity._id,
        },
      });
    },

    showCreatePbehaviorModal() {
      this.$modals.show({
        name: MODALS.pbehaviorPlanning,
        config: {
          entityPattern: createEntityIdPatternByValue(this.entity._id),
          afterSubmit: this.fetchList,
        },
      });
    },

    showDeletePbehaviorModal(pbehaviorId) {
      this.$modals.show({
        name: MODALS.confirmation,
        config: {
          action: async () => {
            await this.removePbehavior({ id: pbehaviorId });

            return this.fetchList();
          },
        },
      });
    },

    async fetchList() {
      try {
        this.pending = true;

        this.pbehaviors = await this.fetchPbehaviorsByEntityIdWithoutStore({
          id: this.entity._id,
          params: {
            with_flags: true,
          },
        });
      } catch (err) {
        console.warn(err);
      } finally {
        this.pending = false;
      }
    },
  },
};
</script>
