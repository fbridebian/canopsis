<template lang="pug">
  mermaid-preview.mermaid-expand-panel(:map="map")
</template>

<script>
import MermaidPreview from './mermaid-preview.vue';

export default {
  components: { MermaidPreview },
  props: {
    map: {
      type: Object,
      required: true,
    },
  },
};
</script>
