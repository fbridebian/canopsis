<template lang="pug">
  v-menu(offset-y)
    template(#activator="{ on }")
      v-btn.mr-0(
        v-on="on",
        :loading="pending",
        :disabled="!availableExceptions.length",
        color="primary"
      ) {{ $t('pbehavior.exceptions.choose') }}
    v-list(dense)
      v-list-tile(v-for="exception in availableExceptions", :key="exception._id", @click="addItemIntoArray(exception)")
        v-list-tile-content
          v-list-tile-title {{ exception.name }}
</template>

<script>
import { MAX_LIMIT } from '@/constants';

import { mapIds } from '@/helpers/array';

import { formArrayMixin } from '@/mixins/form';
import { entitiesPbehaviorExceptionMixin } from '@/mixins/entities/pbehavior/exceptions';

export default {
  inject: ['$validator'],
  mixins: [
    formArrayMixin,
    entitiesPbehaviorExceptionMixin,
  ],
  model: {
    prop: 'value',
    event: 'input',
  },
  props: {
    value: {
      type: Array,
      required: true,
    },
  },
  data() {
    return {
      pending: false,
      exceptions: [],
    };
  },
  computed: {
    selectedExceptionsIds() {
      return mapIds(this.value);
    },

    availableExceptions() {
      return this.exceptions.filter(({ _id: id }) => !this.selectedExceptionsIds.includes(id));
    },
  },
  mounted() {
    this.fetchList();
  },
  methods: {
    async fetchList() {
      this.pending = true;

      try {
        const { data } = await this.fetchPbehaviorExceptionsListWithoutStore({ params: { limit: MAX_LIMIT } });

        this.exceptions = data;
      } catch (err) {
        console.error(err);
      } finally {
        this.pending = false;
      }
    },
  },
};
</script>
