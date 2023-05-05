import { generateShallowRenderer, generateRenderer } from '@unit/utils/vue';

import CPatternGroupField from '@/components/forms/fields/pattern/c-pattern-group-field.vue';

const stubs = {
  'c-pattern-operator-information': true,
  'c-pattern-rules-field': true,
};

const selectPatternRulesField = wrapper => wrapper.find('c-pattern-rules-field-stub');

describe('c-pattern-group-field', () => {
  const factory = generateShallowRenderer(CPatternGroupField, { stubs });
  const snapshotFactory = generateRenderer(CPatternGroupField, { stubs });

  test('Rules updated after trigger input event on pattern rules field', async () => {
    const wrapper = factory({
      propsData: {
        group: {
          rules: [],
        },
        attributes: [],
      },
    });

    const patternRulesField = selectPatternRulesField(wrapper);

    const newRules = [{}, {}];

    patternRulesField.vm.$emit('input', newRules);

    const inputEvents = wrapper.emitted('input');

    expect(inputEvents).toHaveLength(1);

    const [eventData] = inputEvents[0];
    expect(eventData).toEqual({
      rules: newRules,
    });
  });

  test('Group removed after trigger input event on pattern rules field without rules', async () => {
    const wrapper = factory({
      propsData: {
        group: {
          rules: [{}, {}],
        },
        attributes: [],
      },
    });

    const patternRulesField = selectPatternRulesField(wrapper);

    patternRulesField.vm.$emit('input', []);

    const removeEvents = wrapper.emitted('remove');

    expect(removeEvents).toHaveLength(1);
  });

  test('Renders `c-pattern-group-field` with default props', () => {
    const wrapper = snapshotFactory({
      propsData: {
        group: {
          rules: [],
        },
        attributes: [],
      },
    });

    expect(wrapper.element).toMatchSnapshot();
  });

  test('Renders `c-pattern-group-field` with custom props', () => {
    const wrapper = snapshotFactory({
      propsData: {
        group: {
          rules: [],
        },
        attributes: [
          { text: 'Attribute text', value: 'attribute value' },
        ],
        disabled: true,
      },
    });

    expect(wrapper.element).toMatchSnapshot();
  });
});
