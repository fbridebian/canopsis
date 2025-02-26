<template lang="pug">
  v-layout.c-alarm-actions-chips(
    :key="wrapperKey",
    :class="{ 'c-alarm-actions-chips--small': small }",
    row,
    wrap,
    align-center
  )
    c-alarm-action-chip.ma-0(
      v-for="item in inlineItems",
      :key="item[itemValue]",
      :class="itemClass",
      :color="item.color",
      :small="small",
      :closable="closable",
      @click="selectItem(item)",
      @close="closeItem(item)"
    )
      slot(name="item", :item="item")
        span {{ item[itemText] }}
    v-menu(
      v-if="dropDownItems.length",
      key="more",
      bottom,
      left,
      @input="$emit('activate')"
    )
      template(#activator="{ on }")
        v-btn.c-alarm-actions-chips__more-btn.ma-0(v-on="on", color="grey", icon)
          v-icon(color="white", size="20") more_horiz
      v-card
        v-card-text
          v-layout.c-alarm-actions-chips__more(:class="{ 'c-alarm-actions-chips--small': small }")
            c-alarm-action-chip.mx-0(
              v-for="item in dropDownItems",
              :key="item[itemValue]",
              :class="itemClass",
              :color="item.color",
              :closable="closable",
              @click="selectItem(item)",
              @close="closeItem(item)"
            )
              slot(name="item", :item="item")
                span {{ item[itemText] }}
</template>

<script>
import { uid } from '@/helpers/uid';

export default {
  props: {
    items: {
      type: Array,
      default: () => [],
    },
    activeItem: {
      type: String,
      required: false,
    },
    inlineCount: {
      type: [Number, String],
      default: 2,
    },
    closable: {
      type: Boolean,
      default: false,
    },
    small: {
      type: Boolean,
      default: false,
    },
    itemValue: {
      type: String,
      default: 'text',
    },
    itemText: {
      type: String,
      default: 'text',
    },
    itemClass: {
      type: String,
      required: false,
    },
    returnObject: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      wrapperKey: uid(),
    };
  },
  computed: {
    sortedItems() {
      return [...this.items].sort((first, second) => {
        if (first[this.itemValue] === this.activeItem) {
          return -1;
        }

        if (second[this.itemValue] === this.activeItem) {
          return 0;
        }

        if (first[this.itemText] < second[this.itemText]) {
          return -1;
        }

        if (first[this.itemText] > second[this.itemText]) {
          return 1;
        }

        return 0;
      });
    },

    inlineItems() {
      return this.sortedItems.slice(0, this.inlineCount);
    },

    dropDownItems() {
      return this.sortedItems.slice(this.inlineCount);
    },
  },
  watch: {
    inlineItems() {
      this.wrapperKey = uid();
    },
  },
  methods: {
    selectItem(item) {
      this.$emit('select', this.returnObject ? item : item[this.itemValue]);
    },

    closeItem(item) {
      this.$emit('close', this.returnObject ? item : item[this.itemValue]);
    },
  },
};
</script>

<style lang="scss">
.c-alarm-actions-chips {
  &, &__more {
    column-gap: 8px;
    row-gap: 4px;
  }

  &--small {
    column-gap: 4px;
  }

  &__more-btn {
    width: 24px;
    height: 24px;
  }
}
</style>
