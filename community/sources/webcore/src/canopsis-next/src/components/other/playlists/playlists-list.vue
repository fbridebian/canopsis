<template lang="pug">
  c-advanced-data-table(
    :headers="headers",
    :items="playlists",
    :loading="pending",
    :total-items="totalItems",
    :pagination="pagination",
    advanced-pagination,
    expand,
    search,
    @update:pagination="$emit('update:pagination', $event)"
  )
    template(#fullscreen="{ item }")
      c-enabled(:value="item.fullscreen")
    template(#interval="{ item }") {{ item.interval | duration }}
    template(#enabled="{ item }")
      c-enabled(:value="item.enabled")
    template(#actions="{ item }")
      c-action-btn(:tooltip="$t('common.play')")
        template(#button="")
          v-btn.mx-1.ma-0(:to="getPlaylistRouteById(item._id, true)", icon)
            v-icon play_arrow
      c-copy-btn(
        :value="getPlaylistRouteFullUrlById(item._id)",
        :tooltip="$t('common.copyLink')",
        @success="onSuccessCopied",
        @error="onErrorCopied"
      )
      c-action-btn(
        v-if="duplicable",
        type="duplicate",
        @click="$emit('duplicate', item)"
      )
      c-action-btn(
        v-if="updatable",
        type="edit",
        @click="$emit('edit', item)"
      )
      c-action-btn(
        v-if="removable",
        type="delete",
        @click="$emit('remove', item._id)"
      )
    template(#expand="{ item }")
      playlist-list-expand-item(:playlist="item")
</template>

<script>
import { APP_HOST } from '@/config';
import { ROUTES_NAMES } from '@/constants';

import { removeTrailingSlashes } from '@/helpers/url';

import PlaylistListExpandItem from './partials/playlists-list-expand-item.vue';

export default {
  components: {
    PlaylistListExpandItem,
  },
  props: {
    playlists: {
      type: Array,
      required: true,
    },
    pending: {
      type: Boolean,
      default: false,
    },
    totalItems: {
      type: Number,
      required: false,
    },
    pagination: {
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
    duplicable: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    headers() {
      return [
        {
          text: this.$t('common.name'),
          value: 'name',
        },
        {
          text: this.$t('common.fullscreen'),
          value: 'fullscreen',
          sortable: false,
        },
        {
          text: this.$t('common.enabled'),
          value: 'enabled',
        },
        {
          text: this.$t('common.interval'),
          value: 'interval',
          sortable: false,
        },
        {
          text: this.$t('common.actionsLabel'),
          value: 'actions',
          sortable: false,
        },
      ];
    },
  },
  methods: {
    getPlaylistRouteById(id, userAction = false) {
      return {
        name: ROUTES_NAMES.playlist,
        params: { id, userAction },
        query: { autoplay: true },
      };
    },

    getPlaylistRouteFullUrlById(id) {
      const { href } = this.$router.resolve(this.getPlaylistRouteById(id));

      return removeTrailingSlashes(`${APP_HOST}${href}`);
    },

    onSuccessCopied() {
      this.$popups.success({ text: this.$t('success.linkCopied') });
    },

    onErrorCopied() {
      this.$popups.success({ text: this.$t('errors.default') });
    },
  },
};
</script>
