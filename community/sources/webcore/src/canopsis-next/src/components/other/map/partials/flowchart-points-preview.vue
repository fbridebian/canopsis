<template lang="pug">
  g.flowchart-points-preview
    component.flowchart-points-preview__point(
      v-for="{ point, x, y } in nonShapesIcons",
      :key="point._id",
      :x="x",
      :y="y",
      :width="iconSize",
      :height="iconSize",
      is="foreignObject",
      @click="openPopup(point, $event)"
    )
      point-icon(
        :entity="point.entity",
        :size="iconSize",
        :color-indicator="colorIndicator",
        :pbehavior-enabled="pbehaviorEnabled"
      )

    component.flowchart-points-preview__point(
      v-for="{ point, x, y } in shapesIcons",
      :key="point._id",
      :height="iconSize",
      :width="iconSize",
      :x="x",
      :y="y",
      is="foreignObject",
      @click="openPopup(point, $event)"
    )
      point-icon(
        :entity="point.entity",
        :size="iconSize",
        :color-indicator="colorIndicator",
        :pbehavior-enabled="pbehaviorEnabled"
      )

    component(is="foreignObject", style="overflow: visible;")
      point-popup-dialog(
        v-if="activePoint",
        :point="activePoint",
        :position-x="positionX",
        :position-y="positionY",
        :popup-actions="popupActions",
        :popup-template="popupTemplate",
        :color-indicator="colorIndicator",
        @show:alarms="showAlarms",
        @show:map="showLinkedMap",
        @close="closePopup"
      )
</template>

<script>
import { mapInformationPopupMixin } from '@/mixins/map/map-information-popup-mixin';
import { mapFlowchartPointsMixin } from '@/mixins/map/map-flowchart-points-mixin';

import PointIcon from './point-icon.vue';
import PointPopupDialog from './point-popup-dialog.vue';

export default {
  components: { PointPopupDialog, PointIcon },
  mixins: [mapInformationPopupMixin, mapFlowchartPointsMixin],
};
</script>

<style lang="scss">
.flowchart-points-preview {
  &__point {
    cursor: pointer;
  }
}
</style>
