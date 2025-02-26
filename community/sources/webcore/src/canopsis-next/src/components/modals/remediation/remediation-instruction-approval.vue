<template lang="pug">
  v-form(@submit.prevent="submit")
    modal-wrapper(close)
      template(#title="")
        span {{ $t('modals.remediationInstructionApproval.title') }}
      template(#text="")
        v-fade-transition
          v-layout(v-if="!remediationInstructionApproval", justify-center)
            v-progress-circular(color="primary", indeterminate)
          v-layout(v-else, column)
            remediation-instruction-approval-alert(
              :approval="remediationInstructionApproval.approval"
            )
            remediation-instruction-approval-tabs(
              :original="remediationInstructionApproval.original",
              :updated="remediationInstructionApproval.updated"
            )
      template(#actions="")
        v-btn(
          depressed,
          flat,
          @click="$modals.hide"
        ) {{ $t('common.cancel') }}
        v-btn.warning(
          :disabled="isDisabled || !remediationInstructionApproval",
          :loading="submitting",
          depressed,
          flat,
          @click="dismiss"
        ) {{ $t('common.dismiss') }}
        v-btn.primary(
          :disabled="isDisabled || !remediationInstructionApproval",
          :loading="submitting",
          @click="approve"
        ) {{ $t('common.approve') }}
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

import { MODALS } from '@/constants';

import { modalInnerMixin } from '@/mixins/modal/inner';
import { submittableMixinCreator } from '@/mixins/submittable';

import RemediationInstructionApprovalAlert from '@/components/other/remediation/instructions/partials/approval-alert.vue';
import RemediationInstructionApprovalTabs from '@/components/other/remediation/instructions/partials/approval-tabs.vue';

import ModalWrapper from '../modal-wrapper.vue';

const { mapActions } = createNamespacedHelpers('remediationInstruction');

export default {
  name: MODALS.remediationInstructionApproval,
  components: {
    RemediationInstructionApprovalAlert,
    RemediationInstructionApprovalTabs,
    ModalWrapper,
  },
  mixins: [
    modalInnerMixin,
    submittableMixinCreator(),
  ],
  data() {
    return {
      remediationInstructionApproval: null,
    };
  },
  mounted() {
    this.fetchItem();
  },
  methods: {
    ...mapActions({
      fetchRemediationInstructionApprovalWithoutStore: 'fetchItemApprovalWithoutStore',
      updateRemediationInstructionApproval: 'updateApproval',
    }),

    async fetchItem() {
      this.remediationInstructionApproval = await this.fetchRemediationInstructionApprovalWithoutStore({
        id: this.config.remediationInstructionId,
      });
    },

    approve() {
      return this.submit(true);
    },

    dismiss() {
      return this.submit();
    },

    async submit(approve = false) {
      await this.updateRemediationInstructionApproval({
        id: this.config.remediationInstructionId,
        data: { approve },
      });

      if (this.config.afterSubmit) {
        await this.config.afterSubmit();
      }

      this.$modals.hide();
    },
  },
};
</script>
