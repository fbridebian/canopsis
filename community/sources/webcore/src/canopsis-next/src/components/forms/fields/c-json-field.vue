<template lang="pug">
  v-layout(row, wrap)
    v-flex(xs12)
      v-textarea(
        v-validate="",
        v-on="listeners",
        :value="localValue",
        :label="label",
        :name="name",
        :rows="rows",
        :auto-grow="autoGrow",
        :box="box",
        :readonly="readonly",
        :outline="outline",
        :disabled="disabled",
        :error-messages="errors.collect(name)",
        data-vv-validate-on="none"
      )
        template(#append="")
          c-help-icon(icon="help", :text="helpText", left)
    v-flex(v-if="!validateOnBlur && !readonly", xs12)
      v-btn.ml-0(
        :disabled="errors.has(name) || !wasChanged",
        color="primary",
        outline,
        @click="parse"
      ) {{ $t('common.parse') }}
      v-btn(
        :disabled="!wasChanged",
        color="grey darken-1",
        outline,
        @click="reset"
      ) {{ $t('common.reset') }}
</template>

<script>
import { isString } from 'lodash';
import { Validator } from 'vee-validate';

import { convertPayloadToJson } from '@/helpers/payload-json';
import { stringifyJson } from '@/helpers/json';

export default {
  inject: {
    $validator: {
      default: new Validator(),
    },
  },
  model: {
    prop: 'value',
    event: 'input',
  },
  props: {
    value: {
      type: [Object, Array, String],
      default: () => ({}),
    },
    label: {
      type: String,
      default: '',
    },
    name: {
      type: String,
      default: 'json',
    },
    rows: {
      type: [Number, String],
      default: 5,
    },
    validateOn: {
      type: String,
      default: 'blur',
      validator: value => ['blur', 'button'].includes(value),
    },
    helpText: {
      type: String,
      default: '',
    },
    variables: {
      type: [Boolean, Array],
      default: false,
    },
    autoGrow: {
      type: Boolean,
      default: false,
    },
    box: {
      type: Boolean,
      default: false,
    },
    readonly: {
      type: Boolean,
      default: false,
    },
    outline: {
      type: Boolean,
      default: false,
    },
    disabled: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    const localValue = this.valueToLocalValue(this.value);

    return {
      localValue,

      sourceValue: localValue,
    };
  },
  computed: {
    validateOnBlur() {
      return this.validateOn === 'blur';
    },

    wasChanged() {
      return this.valueToLocalValue(this.value) !== this.localValue;
    },

    listeners() {
      const listeners = {
        input: this.resetValidation,
      };

      if (this.validateOnBlur) {
        listeners.blur = this.parse;
      }

      return listeners;
    },
  },
  watch: {
    value(newValue) {
      const newLocalValue = this.valueToLocalValue(newValue);
      this.sourceValue = newLocalValue;

      if (newLocalValue !== this.localValue) {
        this.localValue = newLocalValue;
        this.$validator.reset({ name: this.name });
      }
    },
  },
  methods: {
    valueToLocalValue(value) {
      try {
        return this.variables
          ? convertPayloadToJson(value)
          : stringifyJson(value);
      } catch (err) {
        this.$popups.error({ text: this.$t('errors.default') });

        return '{}';
      }
    },

    parse() {
      try {
        const payload = this.variables
          ? convertPayloadToJson(this.localValue)
          : JSON.parse(this.localValue);

        this.$validator.reset({ name: this.name });

        if (this.value === payload) {
          this.localValue = this.valueToLocalValue(payload);
        }

        if (this.variables) {
          this.$emit('input', payload);
        } else {
          this.$emit('input', isString(this.value) ? this.localValue : payload);
        }
      } catch (err) {
        this.errors.add({
          field: this.name,
          msg: this.$t('errors.JSONNotValid'),
          rule: this.rule,
        });
      }
    },

    reset() {
      this.localValue = this.valueToLocalValue(this.value);

      this.$validator.reset({ name: this.name });
    },

    resetValidation(value) {
      this.localValue = value;

      if (this.errors.has(this.name)) {
        this.errors.remove(this.name);
      }

      if (value === this.sourceValue) {
        this.$validator.reset({ name: this.name });

        return;
      }

      if (!this.wasChanged) {
        this.$validator.flag(this.name, {
          touched: true,
          changed: true,
        });
      }
    },
  },
};
</script>
