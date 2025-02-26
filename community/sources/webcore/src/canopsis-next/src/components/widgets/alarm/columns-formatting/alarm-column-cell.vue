<template lang="pug">
  v-menu(
    v-if="column.popupTemplate",
    v-model="opened",
    :close-on-content-click="false",
    :open-on-click="false",
    offset-x,
    lazy-with-unmount,
    lazy
  )
    template(#activator="{ on }")
      v-layout(v-on="on", d-inline-flex, align-center)
        div(v-if="column.isHtml", v-html="sanitizedValue")
        div(v-else, v-bind="component.bind", v-on="component.on")
        v-btn.ma-0(icon, small, @click.stop="showInfoPopup")
          v-icon(small) info
    alarm-column-cell-popup-body(
      :alarm="alarm",
      :template="column.popupTemplate",
      @close="hideInfoPopup"
    )
  div(v-else-if="column.isHtml", v-html="sanitizedValue")
  div(v-else, v-bind="component.bind", v-on="component.on")
</template>

<script>
import { get } from 'lodash';
import sanitizeHTML from 'sanitize-html';

import ColorIndicatorWrapper from '@/components/common/table/color-indicator-wrapper.vue';

import AlarmColumnCellPopupBody from './alarm-column-cell-popup-body.vue';
import AlarmColumnValueState from './alarm-column-value-state.vue';
import AlarmColumnValueStatus from './alarm-column-value-status.vue';
import AlarmColumnValueExtraDetails from './alarm-column-value-extra-details.vue';

/**
 * Component to format alarms list columns
 *
 * @module alarm
 *
 * @prop {Object} alarm - Object representing the alarm
 * @prop {Object} widget - Object representing the widget
 * @prop {Object} column - Property concerned on the column
 */
export default {
  components: {
    AlarmColumnCellPopupBody,
    AlarmColumnValueState,
    AlarmColumnValueStatus,
    AlarmColumnValueExtraDetails,
    ColorIndicatorWrapper,
  },
  props: {
    alarm: {
      type: Object,
      required: true,
    },
    widget: {
      type: Object,
      required: true,
    },
    column: {
      type: Object,
      required: true,
    },
    selectedTag: {
      type: String,
      default: '',
    },
    small: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      opened: false,
    };
  },
  computed: {
    value() {
      const value = get(this.alarm, this.column.value, '');

      return this.column.filter ? this.column.filter(value) : value;
    },

    sanitizedValue() {
      try {
        return sanitizeHTML(this.value, {
          allowedTags: ['h3', 'h4', 'h5', 'h6', 'blockquote', 'p', 'a', 'ul', 'ol',
            'nl', 'li', 'b', 'i', 'strong', 'em', 'strike', 'code', 'hr', 'br', 'div',
            'table', 'thead', 'caption', 'tbody', 'tr', 'th', 'td', 'pre', 'iframe', 'span', 'font', 'u'],
          allowedAttributes: {
            '*': ['style'],
            a: ['href', 'name', 'target'],
            img: ['src', 'alt'],
            font: ['color', 'size', 'face'],
          },
        });
      } catch (err) {
        console.warn(err);

        return '';
      }
    },

    component() {
      return this.column.getComponent(this);
    },
  },
  methods: {
    showInfoPopup() {
      this.opened = true;
    },

    hideInfoPopup() {
      this.opened = false;
    },
  },
};
</script>
