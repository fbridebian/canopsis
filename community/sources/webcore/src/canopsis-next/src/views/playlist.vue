<template lang="pug">
  div
    v-fade-transition(mode="out-in")
      c-progress-overlay(v-if="pending", pending)
      div.playlist(v-else-if="playlist")
        c-page-header {{ playlist.name }}
        portal(:to="$constants.PORTALS_NAMES.additionalTopBarItems")
          v-fade-transition
            v-toolbar-items.playlist__actions.mr-2(v-if="!pending")
              span.playlist__timer.white--text.mr-2 {{ time | duration }}
              v-btn(:disabled="!activeTab", dark, icon, @click="prevTab")
                v-icon skip_previous
              v-btn(v-if="pausing || !played", :disabled="!activeTab", dark, icon, @click="play")
                v-icon play_arrow
              v-btn(v-else, :disabled="!activeTab", dark, icon, @click="pause")
                v-icon pause
              v-btn(:disabled="!activeTab", dark, icon, @click="nextTab")
                v-icon skip_next
              c-action-btn(
                :disabled="!activeTab",
                :tooltip="$t('playlist.player.tooltips.fullscreen')",
                icon="fullscreen",
                color="white",
                @click="toggleFullScreenMode"
              )
        div.position-relative.playlist__tabs-wrapper(ref="playlistTabsWrapper", v-if="activeTab")
          div.playlist__play-button-wrapper(v-if="!played")
            v-btn(color="primary", large, @click="play")
              v-icon(large) play_arrow
          v-fade-transition(mode="out-in")
            view-tab-widgets(:tab="activeTab", :key="activeTab._id")
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

import { toSeconds } from '@/helpers/date/duration';

import { entitiesViewGroupMixin } from '@/mixins/entities/view/group';
import { permissionsEntitiesPlaylistTabMixin } from '@/mixins/permissions/entities/playlist-tab';

import ViewTabWidgets from '@/components/other/view/view-tab-widgets.vue';

const { mapActions } = createNamespacedHelpers('playlist');

export default {
  components: { ViewTabWidgets },
  mixins: [entitiesViewGroupMixin, permissionsEntitiesPlaylistTabMixin],
  props: {
    id: {
      type: String,
      required: true,
    },
    autoplay: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      time: 0,
      pending: false,
      pausing: false,
      played: false,
      playlist: null,
      isFullscreenMode: false,
      activeTabIndex: 0,
    };
  },
  computed: {
    availableTabs() {
      const tabsIds = (this.playlist && this.playlist.tabs_list) || [];

      return this.getAvailableTabsByIds(tabsIds);
    },

    activeTab() {
      return this.availableTabs[this.activeTabIndex];
    },
  },
  async mounted() {
    this.pending = true;

    if (!this.groupsPending) {
      await this.fetchAllGroupsListWithWidgets();
    }

    this.playlist = await this.fetchPlaylistItemWithoutStore({ id: this.id });
    this.initTime();

    this.pending = false;

    if (this.autoplay) {
      this.play();
    }
  },
  beforeDestroy() {
    this.stopTimer();
  },
  methods: {
    ...mapActions({
      fetchPlaylistItemWithoutStore: 'fetchItemWithoutStore',
    }),

    initTime() {
      const { value, unit } = this.playlist.interval;

      this.time = toSeconds(value, unit);
    },

    play() {
      this.played = true;
      this.pausing = false;

      if (this.playlist.fullscreen && !this.isFullscreenMode && this.$route.params.userAction) {
        this.$nextTick(this.toggleFullScreenMode);
      }

      this.startTimer();
    },

    pause() {
      this.pausing = true;
      this.stopTimer();
    },

    prevTab() {
      if (this.availableTabs.length) {
        const lastIndex = this.availableTabs.length - 1;

        this.activeTabIndex = this.activeTabIndex <= 0 ? lastIndex : this.activeTabIndex - 1;

        this.initTime();
        this.restartTimer();
      }
    },

    nextTab() {
      if (this.availableTabs.length) {
        const lastIndex = this.availableTabs.length - 1;
        this.activeTabIndex = this.activeTabIndex >= lastIndex ? 0 : this.activeTabIndex + 1;

        this.restartTimer();
      }
    },

    timerTick() {
      this.time -= 1;

      if (this.time <= 0) {
        return this.nextTab();
      }

      return this.startTimer();
    },

    startTimer() {
      this.timer = setTimeout(this.timerTick, 1000);
    },

    stopTimer() {
      clearTimeout(this.timer);
    },

    restartTimer() {
      this.stopTimer();
      this.initTime();

      if (this.played && !this.pausing) {
        this.startTimer();
      }
    },

    toggleFullScreenMode() {
      this.$fullscreen.toggle(this.$refs.playlistTabsWrapper, {
        fullscreenClass: 'full-screen',
        callback: value => this.isFullscreenMode = value,
      });
    },
  },
};
</script>

<style lang="scss">
.playlist {
  &__tabs-wrapper {
    min-height: 60px;
  }

  &__play-button-wrapper {
    position: absolute;
    width: 100%;
    height: 100%;
    left: 0;
    top: 0;
    z-index: 3;
    background: rgba(255, 255, 255, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__actions {
    width: 310px;
  }

  &__timer {
    line-height: 48px;
  }
}
</style>
