<template lang="pug">
  label
    v-layout.images-viewer.white(align-center)
      v-window(v-model="activeImageIndex")
        v-window-item.images-viewer__img-wrapper(
          v-for="image in images",
          :key="image[itemKey]",
          :reverse-transition="transition",
          :transition="transition"
        )
          div.images-viewer__img-title.white--text.ml-1(v-if="image.name") {{ image.name }}
          img.images-viewer__img(:src="image.src", :alt="image.name")
      v-layout.images-viewer__actions(v-if="images.length", row, justify-space-between, reverse)
        v-btn(icon, flat, color="white", @click="nextImage")
          v-icon(:size="32") chevron_right
        v-btn(icon, flat, color="white", @click="prevImage")
          v-icon(:size="32") chevron_left
      v-layout.images-viewer__image-count(v-if="images.length", row, justify-space-between)
        span.white--text.pl-1 {{ activeImageIndex + 1 }}/{{ images.length }}
</template>

<script>
import { throttle } from 'lodash';

import { VUETIFY_ANIMATION_DELAY } from '@/config';

/**
 * Example:
 *   c-images-viewer(
 *     :images="[{
 *       name: 'Image 1',
 *       src: 'https://src.com/image1'
 *     }, {
 *       name: 'Image 2',
 *       src: 'https://src.com/image2'
 *     }]",
 *     active="https://src.com/image1"
 *   )
 */
export default {
  props: {
    images: {
      type: Array,
      default: () => [],
    },
    active: {
      type: String,
      required: false,
    },
    itemKey: {
      type: String,
      default: 'src',
    },
  },
  data() {
    return {
      directionToNext: true,
      activeImageIndex: this.active
        ? this.images.findIndex(({ src }) => src === this.active)
        : 0,
    };
  },
  computed: {
    transition() {
      return this.directionToNext ? 'v-window-x-transition' : 'v-window-x-reverse-transition';
    },
  },
  mounted() {
    document.addEventListener('keydown', this.keyDownListener);
  },
  beforeDestroy() {
    document.removeEventListener('keydown', this.keyDownListener);
  },
  methods: {
    keyDownListener(event) {
      switch (event.key) {
        case 'ArrowRight':
          this.nextImage();
          break;
        case 'ArrowLeft':
          this.prevImage();
          break;
      }
    },

    prevImage() {
      this.setImageIndex(this.activeImageIndex - 1, false);
    },

    nextImage() {
      this.setImageIndex(this.activeImageIndex + 1, true);
    },

    setImageIndex: throttle(function setImageIndex(nextIndex, directionToNext) {
      this.directionToNext = directionToNext;

      this.activeImageIndex = (this.images.length + nextIndex) % this.images.length;
    }, VUETIFY_ANIMATION_DELAY * 2),
  },
};
</script>

<style lang="scss">
.images-viewer {
  align-items: center;

  .v-window__container {
    display: flex;
    align-items: center;
  }

  &__actions {
    position: absolute;
    left: 0;
    right: 0;
  }

  &__img-wrapper {
    top: unset !important;
  }

  &__img {
    display: block;
    max-height: 90vh;
    max-width: 90vw;
  }

  &__img-title {
    position: absolute;
    top: 0;
    right: 0;
    left: 0;
  }

  &__image-count {
    pointer-events: none;
    position: absolute;
    bottom: 0;
    left: 0;
  }
}
</style>
