<template lang="pug">
  tr
    td.cursor-pointer
      c-expand-btn.mr-2(:expanded="expanded", @expand="$emit('expand')")
      span {{ group.name }}
    permission-group-row-cell(
      v-for="role in roles",
      :key="`role-permission-${role._id}`",
      :group="group",
      :role="role",
      :changed-role="changedRoles[role._id]",
      :disabled="disabled || isEmptyPermissions",
      @change="change"
    )
</template>

<script>
import PermissionGroupRowCell from './permission-group-row-cell.vue';

export default {
  components: { PermissionGroupRowCell },
  props: {
    group: {
      type: Object,
      required: true,
    },
    roles: {
      type: Array,
      default: () => [],
    },
    changedRoles: {
      type: Object,
      default: () => ({}),
    },
    disabled: {
      type: Boolean,
      default: false,
    },
    expanded: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    isEmptyPermissions() {
      return !this.group?.permissions?.length;
    },
  },
  methods: {
    change(...args) {
      this.$emit('change', ...args);
    },
  },
};
</script>
