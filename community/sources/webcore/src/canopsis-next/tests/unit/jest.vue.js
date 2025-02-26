const path = require('path');
const { merge } = require('lodash');
const { process, getCacheKey } = require('vue-jest');

const updateFieldDirective = require('../../tools/update-field-directive');

const configWithVueJestOptions = {
  globals: {
    'vue-jest': {
      transform: {
        js: path.resolve(__dirname, './jest.transform'),
      },
      templateCompiler: {
        compilerOptions: {
          directives: {
            field: updateFieldDirective,
          },
        },
      },
    },
  },
};

module.exports = {
  process: (src, filename, config) => {
    const configWithDirectives = merge({}, config, configWithVueJestOptions);

    return process(src, filename, configWithDirectives);
  },
  getCacheKey,
};
