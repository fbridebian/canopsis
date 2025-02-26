<template lang="pug">
  v-select.mt-0(
    v-validate="rules",
    v-field="category",
    :label="$t('common.category')",
    :loading="entityCategoriesPending || creating",
    :readonly="creating",
    :items="entityCategories",
    :error-messages="errors.collect(name)",
    :name="name",
    :hide-details="hideDetails",
    :clearable="!required",
    item-text="name",
    item-value="_id",
    return-object,
    @keydown.enter.prevent="createCategory"
  )
    template(v-if="addable", #append-item="")
      v-text-field.pb-3.pt-1.px-3(
        ref="createField",
        v-model.trim="newCategory",
        v-validate="newCategoryRules",
        :label="$t('service.createCategory')",
        :error-messages="errors.collect(newCategoryFieldName)",
        :name="newCategoryFieldName",
        hide-details,
        @keyup.enter="createCategory",
        @blur="clearCategory"
      )
        template(#append="")
          c-help-icon(icon="help", :text="$t('service.createCategoryHelp')", left)
</template>

<script>
import { MAX_LIMIT } from '@/constants';

import { formBaseMixin } from '@/mixins/form';
import entitiesEntityCategoryMixin from '@/mixins/entities/entity-category';

export default {
  inject: ['$validator'],
  mixins: [formBaseMixin, entitiesEntityCategoryMixin],
  model: {
    prop: 'category',
    event: 'input',
  },
  props: {
    category: {
      type: [Object, String],
      default: '',
    },
    name: {
      type: String,
      default: 'category',
    },
    addable: {
      type: Boolean,
      default: false,
    },
    required: {
      type: Boolean,
      default: false,
    },
    hideDetails: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      newCategory: '',
      creating: false,
    };
  },
  computed: {
    newCategoryFieldName() {
      return `${this.name}.create`;
    },

    categoriesNames() {
      return this.entityCategories.map(({ name }) => name.toLowerCase());
    },

    rules() {
      return {
        required: this.required,
      };
    },

    newCategoryRules() {
      return {
        unique: {
          values: this.categoriesNames,
        },
      };
    },
  },
  mounted() {
    this.fetchList();
  },
  methods: {
    async createCategory() {
      const isValid = await this.$validator.validate(this.newCategoryFieldName);

      if (!isValid || !this.newCategory) {
        return;
      }

      this.creating = true;

      const category = await this.createEntityCategory({
        data: {
          name: this.newCategory,
        },
      });

      await this.fetchList();

      this.creating = false;
      this.clearCategory();

      this.updateModel(category);
    },

    clearCategory() {
      this.$refs.createField.blur();
      this.newCategory = '';
    },

    fetchList() {
      return this.fetchEntityCategoriesList({
        params: { limit: MAX_LIMIT },
      });
    },
  },
};
</script>
