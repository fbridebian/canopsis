<template lang="pug">
  g(@dblclick.stop="enableEditingMode")
    rhombus-figure(
      v-bind="shape.properties",
      v-on="$listeners",
      :width="shape.width",
      :height="shape.height",
      :x="shape.x",
      :y="shape.y",
      :cursor="readonly ? '' : 'move'"
    )
    text-editor(
      ref="editor",
      v-bind="shape.textProperties",
      :value="shape.text",
      :y="shape.y",
      :x="shape.x",
      :width="shape.width",
      :height="shape.height",
      :editable="editing",
      @blur="disableEditingMode"
    )
</template>

<script>
import { flowchartTextEditorMixin } from '@/mixins/flowchart/text-editor';

import TextEditor from '../../common/text-editor.vue';
import RhombusFigure from '../../figures/rhombus-figure.vue';

export default {
  components: { RhombusFigure, TextEditor },
  mixins: [flowchartTextEditorMixin],
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
