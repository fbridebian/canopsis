<template lang="pug">
  v-treeview.json-treeview(:items="items", :class="{ 'json-treeview--array': isArray }")
    template(#prepend="{ item }")
      i.caption.mr-1(v-if="item.children") ({{ $t(`common.variableTypes.${item.isArray ? 'array' : 'object'}`) }})

    template(#label="{ item }")
      request-information-content-row(:row="item")
</template>

<script>
import { isArray, isObject } from 'lodash';

import { convertObjectToTreeview } from '@/helpers/treeview';

import RequestInformationContentRow from '@/components/common/request/partials/request-information-content-row.vue';

export default {
  components: { RequestInformationContentRow },
  props: {
    json: {
      type: String,
      required: true,
    },
  },
  computed: {
    parsedJson() {
      return JSON.parse(this.json);
    },

    isArray() {
      return isArray(this.parsedJson);
    },

    isObject() {
      return isObject(this.parsedJson);
    },

    items() {
      const { children } = convertObjectToTreeview(this.parsedJson);

      return children;
    },
  },
};
</script>

<style lang="scss">
.json-treeview {
  &__key {
    font-weight: bold;
  }

  & .v-treeview-node__root {
    min-height: unset !important;
  }

  & .v-treeview-node__label {
    margin: 0;
    font-size: 14px;
  }

  &:after {
    content: '}';
  }

  &:before {
    content: '{';
  }

  &--array {
    &:after {
      content: ']';
    }

    &:before {
      content: '[';
    }
  }
}
</style>
