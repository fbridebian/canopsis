<template lang="pug">
  v-layout.c-search-field(row, align-end)
    v-combobox(
      v-if="combobox",
      v-model="localValue",
      :label="$t('common.search')",
      :items="items",
      :menu-props="comboboxMenuProps",
      :return-object="false",
      append-icon="",
      item-text="search",
      item-value="search",
      hide-details,
      hide-no-data,
      single-line,
      @input="submit"
    )
      template(#item="{ item }")
        v-list-tile-content
          v-list-tile-title.pr-2 {{ item.search }}
        v-list-tile-action
          v-layout(row)
            v-btn.ma-0(
              small,
              icon,
              @click.stop="$emit('remove', item.search)"
            )
              v-icon(color="grey", small) delete
            v-btn.ma-0(
              :class="{ 'c-search-field__item__pinned': item.pinned }",
              small,
              icon,
              @click.stop="$emit('toggle-pin', item.search)"
            )
              v-icon(:color="item.pinned ? 'inherit' : 'grey'", small) $vuetify.icons.push_pin
    v-text-field.ma-0(
      v-else,
      v-model="localValue",
      :label="$t('common.search')",
      hide-details,
      single-line,
      @keydown.enter.prevent="submit"
    )
    c-action-btn(
      :tooltip="$t('common.search')",
      icon="search",
      @click="submit"
    )
    c-action-btn(
      :tooltip="$t('common.clearSearch')",
      icon="clear",
      @click="clear"
    )
    slot
</template>

<script>
/**
 * Search component
 */
export default {
  props: {
    value: {
      type: String,
      default: '',
    },
    combobox: {
      type: Boolean,
      default: false,
    },
    items: {
      type: Array,
      required: false,
    },
  },
  data() {
    return {
      localValue: this.value,
    };
  },
  computed: {
    comboboxMenuProps() {
      return {
        contentClass: 'c-search-field__menu',
      };
    },
  },
  watch: {
    value(newValue) {
      if (newValue !== this.localValue) {
        this.localValue = newValue;
      }
    },
  },
  methods: {
    clear() {
      this.localValue = '';

      this.$emit('clear');
    },

    submit() {
      this.$emit('submit', this.localValue ? this.localValue.trim() : '');
    },
  },
};
</script>

<style lang="scss">
.c-search-field {
  padding: 0 24px;

  .v-btn--icon {
    margin: 0 6px !important;
  }

  & > :last-child .v-btn--icon {
    margin-right: -6px !important;
  }

  &__menu {
    .v-list {
      padding: 0;

      .v-list__tile {
        height: 32px;

        .v-btn:not(.c-search-field__item__pinned) {
          opacity: 0;
        }

        &:hover .v-btn {
          opacity: 1;
        }
      }
    }
  }
}
</style>
