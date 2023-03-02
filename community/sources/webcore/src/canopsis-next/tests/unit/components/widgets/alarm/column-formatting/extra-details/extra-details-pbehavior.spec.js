import { omit } from 'lodash';

import { generateRenderer } from '@unit/utils/vue';

import ExtraDetailsPbehavior from '@/components/widgets/alarm/columns-formatting/extra-details/extra-details-pbehavior.vue';

describe('extra-details-pbehavior', () => {
  const prevDateStartTimestamp = 1386382400000;
  const prevDateStopTimestamp = 1386392400000;
  const prevMonthDateStartTimestamp = 1375884800000;
  const prevMonthDateStopTimestamp = 1375894800000;

  const pbehavior = {
    name: 'pbehavior-name',
    author: {
      _id: 'pbehavior-author',
      name: 'pbehavior-author',
    },
    tstart: prevDateStartTimestamp,
    tstop: prevDateStopTimestamp,
    rrule: 'rrule',
    type: {
      name: 'pbehavior-type-name',
      icon_name: 'pbehavior-type-icon',
    },
    reason: {
      name: 'pbehavior-reason-name',
    },
    last_comment: {
      _id: 'pbehavior-comment-1-id',
      author: {
        name: 'pbehavior-comment-1-author',
      },
      message: 'pbehavior-comment-1-message',
    },
  };
  const pbehaviorInfo = {
    type_name: 'type-name',
    icon_name: 'icon-name',
  };

  const snapshotFactory = generateRenderer(ExtraDetailsPbehavior);

  it('Renders `extra-details-pbehavior` with full pbehavior', () => {
    const wrapper = snapshotFactory({
      propsData: {
        pbehavior,
        pbehaviorInfo,
      },
    });

    const tooltipContent = wrapper.findTooltip();

    expect(wrapper.element).toMatchSnapshot();
    expect(tooltipContent.element).toMatchSnapshot();
  });

  it('Renders `extra-details-pbehavior` without reason', () => {
    const wrapper = snapshotFactory({
      propsData: {
        pbehavior: omit(pbehavior, ['reason']),
        pbehaviorInfo,
      },
    });

    const tooltipContent = wrapper.findTooltip();

    expect(wrapper.element).toMatchSnapshot();
    expect(tooltipContent.element).toMatchSnapshot();
  });

  it('Renders `extra-details-pbehavior` without tstop', () => {
    const wrapper = snapshotFactory({
      propsData: {
        pbehavior: omit(pbehavior, ['tstop']),
        pbehaviorInfo,
      },
    });

    const tooltipContent = wrapper.findTooltip();

    expect(wrapper.element).toMatchSnapshot();
    expect(tooltipContent.element).toMatchSnapshot();
  });

  it('Renders `extra-details-pbehavior` without rrule', () => {
    const wrapper = snapshotFactory({
      propsData: {
        pbehavior: omit(pbehavior, ['rrule']),
        pbehaviorInfo,
      },
    });

    const tooltipContent = wrapper.findTooltip();

    expect(wrapper.element).toMatchSnapshot();
    expect(tooltipContent.element).toMatchSnapshot();
  });

  it('Renders `extra-details-pbehavior` without comment', () => {
    const wrapper = snapshotFactory({
      propsData: {
        pbehavior: omit(pbehavior, ['last_comment']),
        pbehaviorInfo,
      },
    });

    const tooltipContent = wrapper.findTooltip();

    expect(wrapper.element).toMatchSnapshot();
    expect(tooltipContent.element).toMatchSnapshot();
  });

  it('Renders `extra-details-pbehavior` without comment author', () => {
    const wrapper = snapshotFactory({
      propsData: {
        pbehavior: {
          ...pbehavior,
          last_comment: {
            author: null,
            ...pbehavior.last_comment,
          },
        },
        pbehaviorInfo,
      },
    });

    const tooltipContent = wrapper.findTooltip();

    expect(wrapper.element).toMatchSnapshot();
    expect(tooltipContent.element).toMatchSnapshot();
  });

  it('Renders `extra-details-pbehavior` with pbehavior started in previous month', () => {
    const wrapper = snapshotFactory({
      propsData: {
        pbehavior: {
          ...pbehavior,
          tstart: prevMonthDateStartTimestamp,
          tstop: prevMonthDateStopTimestamp,
        },
      },
    });

    const tooltipContent = wrapper.findTooltip();

    expect(wrapper.element).toMatchSnapshot();
    expect(tooltipContent.element).toMatchSnapshot();
  });
});
