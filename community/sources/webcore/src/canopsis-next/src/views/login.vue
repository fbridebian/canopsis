<template lang="pug">
  div.login(:class="{ 'login--maintenance': maintenance }")
    div.login__image(v-if="maintenance")
      v-icon(size="120", color="white") $vuetify.icons.miscellaneous_services
    div.login__description
      c-compiled-template(:template="description")
    div.login__container
      base-login
      cas-login.mt-2(v-if="isCASAuthEnabled", key="cas")
      saml-login.mt-2(v-if="isSAMLAuthEnabled", key="saml")
    login-footer
</template>

<script>
import { LOGIN_APP_INFO_POLLING_DELAY } from '@/constants';

import { authMixin } from '@/mixins/auth';
import { entitiesInfoMixin } from '@/mixins/entities/info';

import BaseLogin from '@/components/other/login/base-login.vue';
import CasLogin from '@/components/other/login/cas-login.vue';
import SamlLogin from '@/components/other/login/saml-login.vue';
import LoginFooter from '@/components/other/login/login-footer.vue';

export default {
  components: {
    BaseLogin,
    CasLogin,
    SamlLogin,
    LoginFooter,
  },
  mixins: [authMixin, entitiesInfoMixin],
  data() {
    return {
      intervalId: null,
    };
  },
  mounted() {
    this.startAppInfoPolling();
  },
  beforeDestroy() {
    this.stopAppInfoPolling();
  },
  methods: {
    startAppInfoPolling() {
      if (this.intervalId) {
        this.stopAppInfoPolling();
      }

      this.intervalId = setInterval(this.fetchAppInfo, LOGIN_APP_INFO_POLLING_DELAY);
    },

    stopAppInfoPolling() {
      clearInterval(this.intervalId);
    },
  },
};
</script>

<style lang="scss" scoped>
.login {
  min-width: 100%;
  min-height: 100vh;
  overflow-x: hidden;
  display: grid;
  align-items: center;

  grid-template-columns: 1fr 8fr 1fr;
  grid-template-rows: 5% auto auto 15% auto;
  background: var(--v-secondary-base);

  grid-template-areas:
    ". . ."
    ". image ."
    ". description ."
    ". form ."
    ". . ."
    "footer footer footer";

  &__image {
    grid-area: image;
    display: flex;
    justify-content: center;
  }

  &__description {
    grid-area: description;
    align-content: center;
    min-height: 500px;
    width: 100%;
    overflow-x: hidden;
    overflow-y: auto;
    color: white;
  }

  &__container {
    grid-area: form;
    width: 100%;
    min-height: 500px;
    display: flex;
    flex-flow: column;
    justify-content: space-between;
  }

  &--maintenance {
    background: #6a6a6a;
  }

  @media (min-width: 900px) {
    grid-template-columns: auto 40% 1% 40% auto;
    grid-template-rows: auto auto auto auto;

    grid-template-areas:
      ". . . . ."
      "image description . form ."
      ". . . . ."
      "footer footer footer footer footer";

    &__image {
      min-height: 500px;
      padding-top: 80px;
    }
  }

  @media (min-width: 1200px) {
    grid-template-columns: auto 30% 3% 30% auto;
  }
}
</style>
