import { generateRenderer } from '@unit/utils/vue';

import { ALARMS_OPENED_VALUES } from '@/constants';

import OpenedResolvedFilter from '@/components/sidebars/alarm/form/fields/opened-resolved-filter.vue';

const selectRadioElementsByValue = (wrapper, value) => wrapper
  .find(`.v-input--radio-group__input input[value="${value ?? ''}"]`);

describe('opened-resolved-filter', () => {
  const snapshotFactory = generateRenderer(OpenedResolvedFilter, {
    parentComponent: {
      provide: {
        list: {
          register: jest.fn(),
          unregister: jest.fn(),
        },
        listClick: jest.fn(),
      },
    },
  });

  it.each(Object.entries(ALARMS_OPENED_VALUES))(
    'Value changed after to %s after trigger a radio field',
    (key, value) => {
      const wrapper = snapshotFactory({
        propsData: {
          value: value === ALARMS_OPENED_VALUES.opened
            ? ALARMS_OPENED_VALUES.resolved
            : ALARMS_OPENED_VALUES.opened,
        },
      });

      const radioElement = selectRadioElementsByValue(wrapper, value);

      radioElement.trigger('change');

      const inputEvents = wrapper.emitted('input');

      expect(inputEvents).toHaveLength(1);

      const [eventData] = inputEvents[0];
      expect(eventData).toBe(value);
    },
  );

  it('Renders `opened-resolved-filter` with default props', () => {
    const wrapper = snapshotFactory();

    expect(wrapper.element).toMatchSnapshot();
  });

  it('Renders `opened-resolved-filter` with custom props', () => {
    const wrapper = snapshotFactory({
      propsData: {
        value: ALARMS_OPENED_VALUES.all,
      },
    });

    expect(wrapper.element).toMatchSnapshot();
  });
});
