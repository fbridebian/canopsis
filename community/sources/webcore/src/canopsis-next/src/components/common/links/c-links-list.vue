<template lang="pug">
  div.mt-1
    div(v-for="(categoryLinks, category) in preparedLinks", :key="category")
      span.category.mr-2 {{ category }}
      v-divider(light)
      div(v-for="(link, index) in categoryLinks", :key="index")
        div.pa-2.text-xs-right
          c-copy-wrapper(v-if="link.action === $constants.LINK_RULE_ACTIONS.copy", :value="link.url") {{ link.label }}
          a(v-else, :href="link.url", target="_blank") {{ link.label }}
</template>

<script>
import { harmonizeCategoryLinks, harmonizeCategoriesLinks } from '@/helpers/entities/link/list';

export default {
  props: {
    links: {
      type: Object,
      default: () => ({}),
    },
    category: {
      type: String,
      default: null,
    },
  },
  computed: {
    preparedLinks() {
      return this.category
        ? { [this.category]: harmonizeCategoryLinks(this.links, this.category) }
        : harmonizeCategoriesLinks(this.links);
    },
  },
};
</script>

<style lang="scss" scoped>
.category {
  display: inline-block;

  &:first-letter {
    text-transform: uppercase;
  }
}
</style>
