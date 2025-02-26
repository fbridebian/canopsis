<template lang="pug">
  shared-actions-panel(:actions="preparedActions", :small="small", :wrap="wrap")
</template>

<script>
import { find } from 'lodash';

import {
  MODALS,
  EVENT_ENTITY_TYPES,
  ALARM_LIST_ACTIONS_TYPES,
  LINK_RULE_ACTIONS,
  REMEDIATION_INSTRUCTION_EXECUTION_STATUSES,
} from '@/constants';

import featuresService from '@/services/features';

import { getEntityEventIcon } from '@/helpers/entities/entity/icons';
import { isManualGroupMetaAlarmRuleType, isAutoMetaAlarmRuleType } from '@/helpers/entities/meta-alarm/rule/form';
import { isInstructionExecutionIconInProgress } from '@/helpers/entities/remediation/instruction-execution/form';
import { isInstructionManual } from '@/helpers/entities/remediation/instruction/form';
import { harmonizeLinks, getLinkRuleLinkActionType } from '@/helpers/entities/link/list';
import {
  isCancelledAlarmStatus,
  isClosedAlarmStatus,
  isResolvedAlarm,
  isAlarmStateOk,
  isAlarmStatusCancelled,
  isAlarmStatusClosed,
  isAlarmStatusFlapping,
  isAlarmStatusOngoing,
} from '@/helpers/entities/alarm/form';

import { entitiesAlarmMixin } from '@/mixins/entities/alarm';
import { entitiesMetaAlarmMixin } from '@/mixins/entities/meta-alarm';
import { entitiesManualMetaAlarmMixin } from '@/mixins/entities/manual-meta-alarm';
import { widgetActionsPanelAlarmMixin } from '@/mixins/widget/actions-panel/alarm';
import { clipboardMixin } from '@/mixins/clipboard';
import { widgetActionsPanelAlarmExportPdfMixin } from '@/mixins/widget/actions-panel/alarm-export-pdf';

import SharedActionsPanel from '@/components/common/actions-panel/actions-panel.vue';

/**
 * Component to regroup actions (actions-panel-item) for each alarm on the alarms list
 *
 * @module alarm
 *
 * @prop {Object} item - Object representing an alarm
 * @prop {Object} widget - Full widget object
 */
export default {
  components: { SharedActionsPanel },
  mixins: [
    entitiesAlarmMixin,
    entitiesMetaAlarmMixin,
    entitiesManualMetaAlarmMixin,
    widgetActionsPanelAlarmMixin,
    clipboardMixin,
    widgetActionsPanelAlarmExportPdfMixin,
  ],
  props: {
    item: {
      type: Object,
      required: true,
    },
    widget: {
      type: Object,
      required: true,
    },
    parentAlarm: {
      type: Object,
      default: null,
    },
    small: {
      type: Boolean,
      default: false,
    },
    wrap: {
      type: Boolean,
      default: false,
    },
    refreshAlarmsList: {
      type: Function,
      default: () => {},
    },
  },
  computed: {
    isCancelledAlarm() {
      return isCancelledAlarmStatus(this.item);
    },

    isClosedAlarm() {
      return isClosedAlarmStatus(this.item);
    },

    isResolvedAlarm() {
      return isResolvedAlarm(this.item);
    },

    isAlarmStatusClosed() {
      return isAlarmStatusClosed(this.item);
    },

    isAlarmStatusCancelled() {
      return isAlarmStatusCancelled(this.item);
    },

    isAlarmStatusOngoing() {
      return isAlarmStatusOngoing(this.item);
    },

    isAlarmStatusFlapping() {
      return isAlarmStatusFlapping(this.item);
    },

    isOpenedAlarm() {
      return !this.isAlarmStatusClosed && !this.isAlarmStatusCancelled;
    },

    isAlarmStateOk() {
      return isAlarmStateOk(this.item);
    },

    isActionsAllowWithOkState() {
      return this.widget.parameters.isActionsAllowWithOkState && this.isAlarmStateOk;
    },

    isAlarmOpenedOrActionAllowedWithStateOk() {
      return this.isOpenedAlarm || this.isActionsAllowWithOkState;
    },

    isParentAlarmManualMetaAlarm() {
      return isManualGroupMetaAlarmRuleType(this.parentAlarm?.meta_alarm_rule?.type);
    },

    isParentAlarmAutoMetaAlarm() {
      return isAutoMetaAlarmRuleType(this.parentAlarm?.meta_alarm_rule?.type);
    },

    visibleLinks() {
      return harmonizeLinks(this.item.links).filter(link => !link.hide_in_menu);
    },

    linksActions() {
      return this.visibleLinks.map((link) => {
        const type = getLinkRuleLinkActionType(link);

        return {
          type,
          icon: link.icon_name,
          title: this.$t('alarm.followLink', { title: link.label }),
          method: link.action === LINK_RULE_ACTIONS.copy
            ? () => this.writeTextToClipboard(link.url)
            : () => window.open(link.url, '_blank'),
        };
      });
    },

    instructionsActions() {
      const {
        assigned_instructions: assignedInstructions = [],
      } = this.item;

      if (assignedInstructions.length) {
        const pausedInstructions = assignedInstructions.filter(instruction => instruction.execution);
        const hasRunningInstruction = isInstructionExecutionIconInProgress(this.item.instruction_execution_icon);

        return assignedInstructions.map((instruction) => {
          const { execution } = instruction;
          let titlePrefix = 'execute';
          let cssClass = '';

          if (execution) {
            if (execution.status === REMEDIATION_INSTRUCTION_EXECUTION_STATUSES.running) {
              titlePrefix = 'inProgress';
              cssClass = 'font-italic';
            } else {
              titlePrefix = 'resume';
            }
          }

          return {
            cssClass,
            type: ALARM_LIST_ACTIONS_TYPES.executeInstruction,
            icon: getEntityEventIcon(EVENT_ENTITY_TYPES.executeInstruction),
            disabled: hasRunningInstruction
              || (Boolean(pausedInstructions.length) && !find(pausedInstructions, { _id: instruction._id })),
            title: this.$t(`remediation.instruction.${titlePrefix}Instruction`, {
              instructionName: instruction.name,
            }),
            method: () => this.showExecuteInstructionModal(instruction),
          };
        });
      }

      return [];
    },

    ticketsActions() {
      const actions = [];
      const {
        assigned_declare_ticket_rules: assignedDeclareTicketRules = [],
      } = this.item;

      if (!this.item.v?.tickets?.length || this.widget.parameters.isMultiDeclareTicketEnabled) {
        actions.unshift({
          type: ALARM_LIST_ACTIONS_TYPES.associateTicket,
          icon: getEntityEventIcon(EVENT_ENTITY_TYPES.assocTicket),
          title: this.$t('alarm.actions.titles.associateTicket'),
          method: this.showAssociateTicketModal,
        });

        if (assignedDeclareTicketRules.length) {
          actions.unshift({
            type: ALARM_LIST_ACTIONS_TYPES.declareTicket,
            icon: getEntityEventIcon(EVENT_ENTITY_TYPES.declareTicket),
            title: this.$t('alarm.actions.titles.declareTicket'),
            method: this.showDeclareTicketModal,
          });
        }
      }

      return actions;
    },

    actions() {
      const actions = [];
      const variablesHelpAction = {
        type: ALARM_LIST_ACTIONS_TYPES.variablesHelp,
        icon: 'help',
        title: this.$t('alarm.actions.titles.variablesHelp'),
        method: this.showVariablesHelperModal,
      };

      const exportPdfAction = {
        type: ALARM_LIST_ACTIONS_TYPES.exportPdf,
        icon: 'assignment_returned',
        title: this.$t('alarm.actions.titles.exportPdf'),
        method: this.exportPdf,
      };

      if (this.isCancelledAlarm && !this.isResolvedAlarm) {
        actions.unshift({
          type: ALARM_LIST_ACTIONS_TYPES.unCancel,
          icon: 'delete_forever',
          title: this.$t('alarm.actions.titles.unCancel'),
          method: this.showUnCancelModal,
        });
      }

      if (this.isOpenedAlarm) {
        actions.push(
          {
            type: ALARM_LIST_ACTIONS_TYPES.snooze,
            icon: getEntityEventIcon(EVENT_ENTITY_TYPES.snooze),
            title: this.$t('alarm.actions.titles.snooze'),
            method: this.showSnoozeModal,
          },
          {
            type: ALARM_LIST_ACTIONS_TYPES.pbehaviorAdd,
            icon: getEntityEventIcon(EVENT_ENTITY_TYPES.pbehaviorAdd),
            title: this.$t('alarm.actions.titles.pbehavior'),
            method: this.showAddPbehaviorModal,
          },
        );
      }

      if (this.isAlarmOpenedOrActionAllowedWithStateOk) {
        actions.push(
          {
            type: ALARM_LIST_ACTIONS_TYPES.comment,
            icon: getEntityEventIcon(EVENT_ENTITY_TYPES.comment),
            title: this.$t('alarm.actions.titles.comment'),
            method: this.showCreateCommentEventModal,
          },
        );
      }

      if (this.isOpenedAlarm && this.item.entity) {
        actions.push({
          type: ALARM_LIST_ACTIONS_TYPES.history,
          icon: 'history',
          title: this.$t('alarm.actions.titles.history'),
          method: this.showHistoryModal,
        });
      }

      if (this.isOpenedAlarm) {
        actions.push(variablesHelpAction, exportPdfAction);
      }

      if (this.isAlarmOpenedOrActionAllowedWithStateOk && this.isParentAlarmManualMetaAlarm) {
        actions.push({
          type: ALARM_LIST_ACTIONS_TYPES.removeAlarmsFromManualMetaAlarm,
          icon: getEntityEventIcon(EVENT_ENTITY_TYPES.removeAlarmsFromManualMetaAlarm),
          title: this.$t('alarm.actions.titles.removeAlarmsFromManualMetaAlarm'),
          method: this.showRemoveAlarmsFromManualMetaAlarmModal,
        });
      }

      if (this.isAlarmOpenedOrActionAllowedWithStateOk && this.isParentAlarmAutoMetaAlarm) {
        actions.push({
          type: ALARM_LIST_ACTIONS_TYPES.removeAlarmsFromAutoMetaAlarm,
          icon: getEntityEventIcon(EVENT_ENTITY_TYPES.removeAlarmsFromAutoMetaAlarm),
          title: this.$t('alarm.actions.titles.removeAlarmsFromAutoMetaAlarm'),
          method: this.showRemoveAlarmsFromAutoMetaAlarmModal,
        });
      }

      /**
       * If we will have actions for resolved alarms in the features we should move this condition to
       * the every features repositories
       */
      if (
        this.isOpenedAlarm
        && featuresService.has('components.alarmListActionPanel.computed.actions')
      ) {
        const featuresActions = featuresService.call('components.alarmListActionPanel.computed.actions', this, []);

        if (featuresActions?.length) {
          actions.unshift(...featuresActions);
        }
      }

      if (
        (this.isAlarmStatusClosed && this.isActionsAllowWithOkState)
        || this.isAlarmStatusOngoing
        || this.isAlarmStatusFlapping
      ) {
        const ackAction = {
          type: ALARM_LIST_ACTIONS_TYPES.ack,
          icon: getEntityEventIcon(EVENT_ENTITY_TYPES.ack),
          title: this.$t('alarm.actions.titles.ack'),
          method: this.showAckModal,
        };

        if (this.item.v.ack) {
          if (this.widget.parameters.isMultiAckEnabled) {
            actions.unshift(ackAction);
          }

          actions.unshift(
            {
              type: ALARM_LIST_ACTIONS_TYPES.ackRemove,
              icon: getEntityEventIcon(EVENT_ENTITY_TYPES.ackRemove),
              title: this.$t('alarm.actions.titles.ackRemove'),
              method: this.showAckRemoveModal,
            },
            {
              type: ALARM_LIST_ACTIONS_TYPES.changeState,
              icon: getEntityEventIcon(EVENT_ENTITY_TYPES.changeState),
              title: this.$t('alarm.actions.titles.changeState'),
              method: this.showCreateChangeStateEventModal,
            },
          );

          if (!this.isAlarmStateOk) {
            actions.unshift(
              {
                type: ALARM_LIST_ACTIONS_TYPES.cancel,
                icon: '$vuetify.icons.list_delete',
                title: this.$t('alarm.actions.titles.cancel'),
                method: this.showCancelModal,
              },
              {
                type: ALARM_LIST_ACTIONS_TYPES.fastCancel,
                icon: 'delete',
                title: this.$t('alarm.actions.titles.fastCancel'),
                method: this.createFastCancel,
              },
            );
          }

          actions.unshift(...this.ticketsActions);
        } else {
          actions.unshift(
            ackAction,
            {
              type: ALARM_LIST_ACTIONS_TYPES.fastAck,
              icon: getEntityEventIcon(EVENT_ENTITY_TYPES.fastAck),
              title: this.$t('alarm.actions.titles.fastAck'),
              method: this.createFastAckEvent,
            },
          );
        }
      }

      actions.push(...this.linksActions);

      if (this.isOpenedAlarm) {
        actions.push(...this.instructionsActions);
      } else {
        actions.push(variablesHelpAction, exportPdfAction);
      }

      return actions;
    },

    filteredActions() {
      return this.actions.filter(this.actionsAccessFilterHandler);
    },

    preparedActions() {
      return this.filteredActions.map(action => ({
        ...action,
        loading: this.isActionTypeInPending(action.type),
      }));
    },
  },
  methods: {
    afterSubmit() {
      this.refreshAlarmsList();
    },

    showCreateChangeStateEventModal() {
      this.showCreateChangeStateEventModalByAlarms([this.item]);
    },

    showSnoozeModal() {
      this.showSnoozeModalByAlarms([this.item]);
    },

    showAckModal() {
      this.showAckModalByAlarms([this.item]);
    },

    createFastAckEvent() {
      this.createFastAckActionByAlarms([this.item]);
    },

    async exportPdf() {
      this.setActionPending(ALARM_LIST_ACTIONS_TYPES.exportPdf, true);
      await this.exportAlarmToPdf(this.item, this.widget.parameters.exportPdfTemplate);
      this.setActionPending(ALARM_LIST_ACTIONS_TYPES.exportPdf, false);
    },

    showAssociateTicketModal() {
      this.showAssociateTicketModalByAlarms([this.item]);
    },

    showDeclareTicketModal() {
      this.showDeclareTicketModalByAlarms([this.item]);
    },

    showCreateCommentEventModal() {
      this.showCreateCommentModalByAlarms([this.item]);
    },

    showAckRemoveModal() {
      this.showAckRemoveModalByAlarms([this.item]);
    },

    showCancelModal() {
      this.showCancelModalByAlarms([this.item]);
    },

    showUnCancelModal() {
      this.showUnCancelModalByAlarms([this.item]);
    },

    createFastCancel() {
      this.createFastCancelActionByAlarms([this.item]);
    },

    showRemoveAlarmsFromManualMetaAlarmModal() {
      this.showRemoveAlarmsFromManualMetaAlarmModalByAlarms([this.item]);
    },

    showRemoveAlarmsFromAutoMetaAlarmModal() {
      this.showRemoveAlarmsFromAutoMetaAlarmModalByAlarms([this.item]);
    },

    showVariablesHelperModal() {
      this.showVariablesHelperModalByAlarm(this.item);
    },

    showAddPbehaviorModal() {
      this.showAddPbehaviorModalByAlarms(this.item);
    },

    showHistoryModal() {
      this.showHistoryModalByAlarm(this.item);
    },

    showExecuteInstructionModal(assignedInstruction) {
      const refreshAlarm = () => this.refreshAlarmsList();

      this.$modals.show({
        id: `${this.item._id}${assignedInstruction._id}`,
        name: isInstructionManual(assignedInstruction)
          ? MODALS.executeRemediationInstruction
          : MODALS.executeRemediationSimpleInstruction,
        config: {
          assignedInstruction,
          alarmId: this.item._id,
          onClose: refreshAlarm,
          onComplete: refreshAlarm,
          onExecute: refreshAlarm,
        },
      });
    },
  },
};
</script>
