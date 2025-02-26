import Faker from 'faker';

import { generateRenderer, generateShallowRenderer } from '@unit/utils/vue';

import PbehaviorCommentsField from '@/components/other/pbehavior/pbehaviors/fields/pbehavior-comments-field.vue';

const stubs = {
  'pbehavior-comment-field': true,
};

const selectAddCommentButton = wrapper => wrapper.find('v-btn-stub');
const selectCommentFieldByIndex = (wrapper, index) => wrapper
  .findAll('pbehavior-comment-field-stub')
  .at(index);

describe('pbehavior-comments-field', () => {
  const factory = generateShallowRenderer(PbehaviorCommentsField, {

    stubs,
  });
  const snapshotFactory = generateRenderer(PbehaviorCommentsField, { stubs });

  test('Comment added after trigger create button', () => {
    const comments = [{ key: Faker.datatype.string(), message: Faker.datatype.string() }];
    const wrapper = factory({
      propsData: {
        comments,
      },
    });

    selectAddCommentButton(wrapper).vm.$emit('click');

    expect(wrapper).toEmit('input', [
      ...comments,
      {
        key: expect.any(String),
        message: '',
      },
    ]);
  });

  test('Comment changed after trigger comment field', () => {
    const comments = [
      { key: 'comment-1', message: 'message-1' },
      { key: 'comment-2', message: 'message-2' },
    ];
    const wrapper = factory({
      propsData: {
        comments,
      },
    });

    const newComment = {
      key: Faker.datatype.string(),
      message: Faker.datatype.number(),
    };

    selectCommentFieldByIndex(wrapper, 1).vm.$emit('input', newComment);

    expect(wrapper).toEmit('input', [
      comments[0],
      newComment,
    ]);
  });

  test('Comment removed after trigger comment field', () => {
    const comments = [
      { key: 'comment-1', message: 'message-1' },
      { key: 'comment-2', message: 'message-2' },
    ];
    const wrapper = factory({
      propsData: {
        comments,
      },
    });

    selectCommentFieldByIndex(wrapper, 1).vm.$emit('remove');

    expect(wrapper).toEmit('input', [
      comments[0],
    ]);
  });

  test('Renders `pbehavior-comments-field` with default props', () => {
    const wrapper = snapshotFactory({
      propsData: { comments: [] },
    });

    expect(wrapper.element).toMatchSnapshot();
  });

  test('Renders `pbehavior-comments-field` with custom props', () => {
    const wrapper = snapshotFactory({
      propsData: {
        comments: [
          { key: 'comment-1', message: 'message-1' },
          { key: 'comment-2', message: 'message-2' },
        ],
      },
    });

    expect(wrapper.element).toMatchSnapshot();
  });
});
