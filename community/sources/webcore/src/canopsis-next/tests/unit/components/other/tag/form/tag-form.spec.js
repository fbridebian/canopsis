import Faker from 'faker';

import { generateShallowRenderer, generateRenderer } from '@unit/utils/vue';
import { createInputStub } from '@unit/stubs/input';

import { COLORS } from '@/config';
import { IDLE_RULE_TYPES } from '@/constants';

import TagForm from '@/components/other/tag/form/tag-form.vue';

const stubs = {
  'v-text-field': createInputStub('v-text-field'),
  'c-color-picker-field': true,
  'tag-patterns-form': true,
};

const selectValueField = wrapper => wrapper.find('input.v-text-field');
const selectColorPickerField = wrapper => wrapper.find('c-color-picker-field-stub');
const selectTagPatternsForm = wrapper => wrapper.find('tag-patterns-form-stub');

describe('tag-form', () => {
  const factory = generateShallowRenderer(TagForm, {
    stubs,
  });
  const snapshotFactory = generateRenderer(TagForm, {
    stubs,
  });

  test('Value changed after trigger name field', () => {
    const wrapper = factory({
      propsData: {
        form: {
          value: '',
        },
      },
    });

    const newValue = Faker.datatype.string();

    selectValueField(wrapper).vm.$emit('input', newValue);

    expect(wrapper).toEmit('input', { value: newValue });
  });

  test('Color changed after trigger color picker field', () => {
    const wrapper = factory({
      propsData: {
        form: {
          color: Faker.internet.color(),
        },
      },
    });

    const newValue = Faker.internet.color();

    selectColorPickerField(wrapper).vm.$emit('input', newValue);

    expect(wrapper).toEmit('input', { color: newValue });
  });

  test('Tag patterns changed after trigger patterns form', () => {
    const wrapper = factory({
      propsData: {
        form: {
          value: 'Value',
          patterns: {},
        },
      },
    });

    const newPatterns = {
      alarm_pattern: {},
      entity_pattern: {},
    };

    selectTagPatternsForm(wrapper).vm.$emit('input', newPatterns);

    expect(wrapper).toEmit('input', {
      value: 'Value',
      patterns: newPatterns,
    });
  });

  test('Renders `tag-form` with default props', () => {
    const wrapper = snapshotFactory();

    expect(wrapper.element).toMatchSnapshot();
  });

  test('Renders `tag-form` with custom props', () => {
    const wrapper = snapshotFactory({
      propsData: {
        form: {
          type: IDLE_RULE_TYPES.entity,
          color: COLORS.secondary,
          patterns: {},
        },
        isImported: true,
        maxTagNameLength: 11,
      },
    });

    expect(wrapper.element).toMatchSnapshot();
  });
});
