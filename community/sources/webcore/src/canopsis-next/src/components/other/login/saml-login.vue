<template lang="pug">
  v-card
    v-card-text
      div.ml-2.mb-2.body-2 {{ $t('login.loginWithSAML') }}
      v-btn(:href="samlHref", color="primary") {{ title }}
</template>

<script>
import qs from 'qs';
import { get } from 'lodash';

import { APP_HOST, API_HOST, API_ROUTES } from '@/config';

import { removeTrailingSlashes } from '@/helpers/url';

import { entitiesInfoMixin } from '@/mixins/entities/info';

export default {
  mixins: [entitiesInfoMixin],
  computed: {
    title() {
      return get(this.samlConfig, 'title', this.$t('login.loginWithSAML'));
    },

    samlHref() {
      const { redirect = '' } = this.$route.query;

      const loginUrl = removeTrailingSlashes(`${API_HOST}${API_ROUTES.saml.auth}`);
      const query = qs.stringify({ relayState: removeTrailingSlashes(`${APP_HOST}${redirect}`) });

      return `${loginUrl}?${query}`;
    },
  },
};
</script>
