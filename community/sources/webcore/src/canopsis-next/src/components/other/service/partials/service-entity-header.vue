<template lang="pug">
  v-layout(justify-space-between, align-center)
    v-flex(@click.stop="")
      v-checkbox.ma-0.pa-0(
        :input-value="selected",
        :disabled="!selectable",
        color="white",
        hide-details,
        @change="$emit('update:selected', $event)"
      )
    v-flex.pa-2
      v-icon(color="white", small) {{ entity.icon }}
    v-flex.pl-1.white--text.subheading(xs12)
      v-layout(align-center)
        div.mr-1.entity-name {{ entityName }}
        v-btn.mx-1(
          v-for="icon in extraIcons",
          :key="icon.icon",
          :color="icon.color",
          small,
          dark,
          icon
        )
          v-icon(small) {{ icon.icon }}
        c-no-events-icon(:value="entity.idle_since", color="white", top)
        div(@click.stop="")
          v-alert.entity-alert.ma-0.px-2.py-1(
            v-if="lastActionUnavailable",
            :value="lastActionUnavailable",
            color="black",
            dismissible,
            @input="hideAlert"
          ) {{ $t('serviceWeather.cannotBeApplied') }}
</template>

<script>
import { get } from 'lodash';

import { COLORS } from '@/config';
import { ENTITIES_STATUSES, EVENT_ENTITY_TYPES } from '@/constants';

import { getEntityEventIcon } from '@/helpers/entities/entity/icons';

export default {
  props: {
    entity: {
      type: Object,
      required: true,
    },
    selected: {
      type: Boolean,
      default: false,
    },
    selectable: {
      type: Boolean,
      default: false,
    },
    lastActionUnavailable: {
      type: Boolean,
      default: false,
    },
    entityNameField: {
      type: String,
      default: 'name',
    },
  },
  computed: {
    entityName() {
      return get({ entity: this.entity }, this.entityNameField, this.entityNameField);
    },

    extraIcons() {
      const extraIcons = [];

      if (this.entity.ack) {
        extraIcons.push({
          icon: getEntityEventIcon(EVENT_ENTITY_TYPES.fastAck),
          color: 'purple',
        });
      }

      if (this.entity.ticket) {
        extraIcons.push({
          icon: getEntityEventIcon(EVENT_ENTITY_TYPES.assocTicket),
          color: 'blue',
        });
      }

      if (this.entity.status?.val === ENTITIES_STATUSES.cancelled) {
        extraIcons.push({
          icon: getEntityEventIcon(EVENT_ENTITY_TYPES.delete),
          color: 'grey darken-1',
        });
      }

      if (this.entity.pbh_origin_icon) {
        extraIcons.push({
          icon: this.entity.pbh_origin_icon,
          color: COLORS.secondary,
        });
      }

      return extraIcons;
    },
  },
  methods: {
    hideAlert() {
      this.$emit('remove:unavailable');
    },
  },
};
</script>

<style lang="scss" scoped>
.entity-name {
  line-height: 1.5em;
  word-break: break-all;
}
.entity-alert {
  border: none;
  background-color: rgba(255, 255, 255, 0.2) !important;
  border-radius: 5px;

  & ::v-deep .v-alert__dismissible .v-icon {
    margin-left: 0;
    font-size: 18px;
  }
}
</style>
