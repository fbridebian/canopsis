<template lang="pug">
  line-shape(
    v-on="$listeners",
    :shape="shape",
    :readonly="readonly",
    :marker-start="`url(#${shape._id}-start)`",
    :marker-end="`url(#${shape._id}-end)`"
  )
    marker(
      :id="`${shape._id}-end`",
      refX="20",
      refY="10",
      markerWidth="60",
      markerHeight="60",
      markerUnits="userSpaceOnUse",
      orient="auto"
    )
      arrow-figure(:fill="shape.properties['stroke']")
    marker(
      :id="`${shape._id}-start`",
      refX="20",
      refY="10",
      markerWidth="60",
      markerHeight="60",
      markerUnits="userSpaceOnUse",
      orient="auto-start-reverse"
    )
      arrow-figure(:fill="shape.properties['stroke']")
</template>

<script>
import ArrowFigure from '../../figures/arrow-figure.vue';
import LineShape from '../line-shape/line-shape.vue';

export default {
  components: { LineShape, ArrowFigure },
  props: {
    shape: {
      type: Object,
      required: true,
    },
    readonly: {
      type: Boolean,
      default: false,
    },
  },
};
</script>
