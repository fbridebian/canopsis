<template lang="pug">
  div
    v-navigation-drawer.side-bar.secondary(
      v-model="isOpen",
      :width="$config.SIDE_BAR_WIDTH",
      :class="{ editing: isNavigationEditingMode }",
      :ignore-click-outside="isGroupsOrderChanged || hasMaximizedModal",
      app
    )
      div.brand.ma-0.secondary.lighten-1
        app-logo.logo
        logged-users-count
        app-version.version
      template(v-if="hasReadAnyViewAccess")
        v-layout.pa-2(v-if="!mutatedGroups.length && groupsPending", row, justify-center)
          v-progress-circular(color="white", indeterminate)
        c-draggable-list-field.groups-panel(
          v-else,
          v-model="mutatedGroups",
          :class="{ ordering: isGroupsOrderChanged }",
          :component-data="{ props: { expand: true, dark: true, focusable: true } }",
          :disabled="!isNavigationEditingMode",
          component="v-expansion-panel"
        )
          groups-side-bar-group(
            v-for="(group, index) in mutatedGroups",
            :key="group._id",
            :group.sync="mutatedGroups[index]",
            :is-groups-order-changed="isGroupsOrderChanged"
          )
      v-divider
      v-fade-transition
        div.v-overlay.v-overlay--active(v-show="isGroupsOrderChanged")
          v-btn.primary(@click="submit") {{ $t('common.submit') }}
          v-btn(@click="resetMutatedGroups") {{ $t('common.cancel') }}
      groups-side-bar-playlists
      groups-settings-button(
        tooltipRight,
        @toggleEditingMode="toggleNavigationEditingMode"
      )
    v-fade-transition
      div.v-overlay.v-overlay--active.content-overlay(v-show="isGroupsOrderChanged")
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

import { isDeepOrderChanged } from '@/helpers/dragdrop';
import { groupsWithViewsToPositions } from '@/helpers/entities/view/form';

import { entitiesViewMixin } from '@/mixins/entities/view';
import layoutNavigationGroupsBarMixin from '@/mixins/layout/navigation/groups-bar';

import GroupsSettingsButton from '../groups-settings-button.vue';
import AppLogo from '../app-logo.vue';
import AppVersion from '../app-version.vue';
import LoggedUsersCount from '../logged-users-count.vue';

import GroupsSideBarGroup from './groups-side-bar-group.vue';
import GroupsSideBarPlaylists from './groups-side-bar-playlists.vue';

const { mapGetters: modalMapGetters } = createNamespacedHelpers('modals');

/**
 * Component for the side-bar, on the left of the application
 *
 * @prop {bool} [value=false] - visibility control
 *
 * @event input#update
 */
export default {
  components: {
    GroupsSettingsButton,
    AppLogo,
    AppVersion,
    LoggedUsersCount,
    GroupsSideBarGroup,
    GroupsSideBarPlaylists,
  },
  mixins: [
    entitiesViewMixin,
    layoutNavigationGroupsBarMixin,
  ],
  props: {
    value: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      mutatedGroups: [],
    };
  },
  computed: {
    ...modalMapGetters(['hasMaximizedModal']),

    isOpen: {
      get() {
        return this.value;
      },
      set(value) {
        if (value !== this.value) {
          this.$emit('input', value);
        }
      },
    },

    isGroupsOrderChanged() {
      return isDeepOrderChanged(
        this.availableGroups,
        this.mutatedGroups,
        '_id',
        (entity = {}, anotherEntity = {}) => isDeepOrderChanged(entity.views, anotherEntity.views),
      );
    },
  },
  watch: {
    availableGroups: {
      deep: true,
      immediate: true,
      handler(groups) {
        this.setMutatedGroups(groups);
      },
    },
  },
  methods: {
    /**
     * Reset mutated groups method
     */
    resetMutatedGroups() {
      this.setMutatedGroups(this.availableGroups);
    },

    /**
     * Set mutated groups method
     *
     * @param {ViewGroupWithViews[]} [groups=[]] - New mutated groups
     */
    setMutatedGroups(groups = []) {
      this.mutatedGroups = groups.map(group => ({
        ...group,

        views: [...group.views],
      }));
    },

    /**
     * Submit the sidebar ordering
     *
     * @returns {Promise<void>}
     */
    async submit() {
      try {
        const data = groupsWithViewsToPositions(this.mutatedGroups);

        await this.updateViewsPositions({ data });
        await this.fetchAllGroupsListWithWidgets();

        this.$popups.success({ text: this.$t('layout.sideBar.ordering.popups.success') });
      } catch (err) {
        this.$popups.error({ text: this.$t('layout.sideBar.ordering.popups.error') });
      }
    },
  },
};
</script>

<style lang="scss" scoped>
  .content-overlay {
    z-index: 6;
  }

  .groups-panel {
    position: relative;
    box-shadow: none;

    &.ordering {
      position: absolute;
      z-index: 9;
    }

    .editing &:after {
      content: '';
      position: absolute;
      top: 100%;
      width: 100%;
      height: 48px;
    }
  }

  .side-bar {
    position: fixed;
    height: 100vh;
    overflow-y: auto;

    &.editing {
      z-index: 9;
    }
  }

  .brand {
    max-height: 48px;
    position: relative;
    display: flex;
    justify-content: center;
    padding: 0.5em 0;

    & ::v-deep .logged-users-count {
      right: 0;
    }
  }

  .version {
    position: absolute;
    bottom: 0;
    right: 0;
    padding-right: 0.5em;
    color: white;
    font-size: 0.8em;
    line-height: 1.3em;
  }

  .logo {
    max-width: 100%;
    max-height: 100%;
    object-fit: scale-down;
  }
</style>
