<template lang="pug">
  v-tooltip(top)
    template(#activator="{ on }")
      v-icon.instruction-icon(v-on="on", :class="iconClass", size="22") {{ iconName }}
    span.pre-wrap(v-html="iconTooltip")
</template>

<script>
import { INSTRUCTION_EXECUTION_ICONS } from '@/constants';

import {
  isInstructionExecutionExecutedAndOtherAvailable,
  isInstructionExecutionIconFailed,
  isInstructionExecutionIconInProgress,
  isInstructionExecutionIconSuccess,
  isInstructionExecutionManual,
} from '@/helpers/entities/remediation/instruction-execution/form';

export default {
  props: {
    alarm: {
      type: Object,
      required: true,
    },
  },
  computed: {
    alarmInstructionExecutionIcon() {
      return this.alarm.instruction_execution_icon ?? INSTRUCTION_EXECUTION_ICONS.manualAvailable;
    },

    hasRunningInstruction() {
      return isInstructionExecutionIconInProgress(this.alarmInstructionExecutionIcon);
    },

    someOneInstructionIsFailed() {
      return isInstructionExecutionIconFailed(this.alarmInstructionExecutionIcon);
    },

    someOneInstructionIsSuccessful() {
      return isInstructionExecutionIconSuccess(this.alarmInstructionExecutionIcon);
    },

    instructionExecutedAndOtherAvailable() {
      return isInstructionExecutionExecutedAndOtherAvailable(this.alarmInstructionExecutionIcon);
    },

    isManualInstructionIcon() {
      return isInstructionExecutionManual(this.alarmInstructionExecutionIcon);
    },

    iconName() {
      if (this.isManualInstructionIcon) {
        return '$vuetify.icons.manual_instruction';
      }

      return 'assignment';
    },

    iconClass() {
      const classNames = [];

      if (this.hasRunningInstruction) {
        classNames.push('blinking', 'instruction-icon--dotted');
      }

      if (this.someOneInstructionIsFailed) {
        classNames.push('instruction-icon--failed');
      }

      if (this.someOneInstructionIsSuccessful) {
        classNames.push('instruction-icon--completed');
      }

      if (this.instructionExecutedAndOtherAvailable) {
        classNames.push('instruction-icon--with-manual-available');
      }

      return classNames.join(' ');
    },

    iconTooltip() {
      const {
        running_manual_instructions: runningManualInstructions,
        running_auto_instructions: runningAutoInstructions,
        failed_manual_instructions: failedManualInstructions,
        failed_auto_instructions: failedAutoInstructions,
        successful_manual_instructions: successfulManualInstructions,
        successful_auto_instructions: successfulAutoInstructions,
        assigned_instructions: assignedInstructions,
      } = this.alarm;

      const tooltips = Object.entries({
        runningManualInstructions,
        runningAutoInstructions,
        failedManualInstructions,
        failedAutoInstructions,
        successfulManualInstructions,
        successfulAutoInstructions,
      }).reduce((acc, [key, instructions]) => {
        if (instructions?.length) {
          acc.push(this.$tc(
            `alarm.tooltips.${key}`,
            instructions.length,
            { title: instructions.join(', ') },
          ));
        }

        return acc;
      }, []);

      if (assignedInstructions?.length) {
        tooltips.push(this.$tc('alarm.tooltips.hasManualInstruction', assignedInstructions.length));
      }

      return tooltips.join('\n');
    },
  },
};
</script>

<style lang="scss">
@keyframes blink-with-available {
  0% {
    opacity: 1.0;
  }
  25% {
    color: black;
  }
  50% {
    opacity: 0.3;
  }
}

.instruction-icon {
  box-sizing: content-box;
  border-width: 1px;
  border-color: transparent;
  border-style: solid;

  .theme--dark &, .theme--light & {
    color: grey;
  }

  &--completed.theme--light.v-icon,
  &--completed.theme--dark.v-icon {
    color: var(--v-primary-base);
  }

  &--failed.theme--light.v-icon,
  &--failed.theme--dark.v-icon {
    color: var(--v-error-base);
  }

  &--dotted {
    border-style: dotted;
    border-color: currentColor;
  }

  &--with-manual-available {
    border-style: dashed;
    border-color: currentColor;
    animation: blink-with-available 2s linear infinite;
  }
}
</style>
