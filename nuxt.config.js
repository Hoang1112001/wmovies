import colors from 'vuetify/es5/util/colors'

export default {
  // Disable server-side rendering: https://go.nuxtjs.dev/ssr-mode
  ssr: false,

  // Target: https://go.nuxtjs.dev/config-target
  target: 'static',
  router: {
    routes: [],
    extendRoutes(routes, resolve) {
      routes.push({
        name: 'movie-detail',
        path: '/movies/:slug',
        component: resolve(__dirname, 'pages/movies/movie_detail/index.vue'),
      })
      routes.push({
        name: 'movie-detail-play',
        path: '/movies/:slug/play',
        component: resolve(__dirname, 'pages/movies/movie_detail/play.vue'),
      })
      routes.push({
        name: 'movie-couplet',
        path: '/movies/couplet/:slug',
        component: resolve(__dirname, 'pages/movies/couplet/index.vue'),
      })
      routes.push({
        name: 'movie-word',
        path: '/movies/word/:slug',
        component: resolve(__dirname, 'pages/movies/word/index.vue'),
      })
      routes.push({
        name: 'actor',
        path: '/actors/:slug',
        component: resolve(__dirname, 'pages/actors/index.vue'),
      })
    },
  },
  generate: {
    dir: process.env.DEPLOY_DIR || 'dist',
  },
  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    titleTemplate: '%s - WMovies',
    title: 'WMovies',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
      { name: 'format-detection', content: 'telephone=no' },
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    // https://go.nuxtjs.dev/eslint
    '@nuxtjs/eslint-module',
    // https://go.nuxtjs.dev/vuetify
    '@nuxtjs/vuetify',
    '@nuxtjs/firebase',
  ],

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    // https://go.nuxtjs.dev/axios
    '@nuxtjs/axios',
    // https://go.nuxtjs.dev/pwa
    '@nuxtjs/pwa',
    // https://go.nuxtjs.dev/content
    '@nuxt/content',

    '@nuxtjs/apollo',

    '@nuxtjs/firebase',

    '@nuxtjs/dotenv',

    '@nuxtjs/toast',
  ],
  //
  apollo: {
    clientConfigs: {
      default: '~/plugins/apollo-config.js',
    },
    defaultOptions: {
      // See 'apollo' definition
      // For example: default query options
      $query: {
        loadingKey: 'loading',
        fetchPolicy: 'network-only',
      },
    },

    // setup a global query loader observer (see below for example)
    watchLoading: '~/plugins/apollo-watch-loading-handler.js',

    // setup a global error handler (see below for example)
    errorHandler: '~/plugins/apollo-error-handler.js',

    // Sets the authentication type for any authorized request.
    authenticationType: 'Bearer',

    // Token name for the cookie which will be set in case of authentication
    tokenName: 'apollo-token',
  },
  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {
    // Workaround to avoid enforcing hard-coded localhost:3000: https://github.com/nuxt-community/axios-module/issues/308
    baseURL: '/',
  },

  // PWA module configuration: https://go.nuxtjs.dev/pwa
  pwa: {
    manifest: {
      lang: 'en',
    },
    source: '~/static/icon.png',
  },

  // Content module configuration: https://go.nuxtjs.dev/config-content
  content: {},

  // Vuetify module configuration: https://go.nuxtjs.dev/config-vuetify
  vuetify: {
    customVariables: ['~/assets/variables.scss'],
    theme: {
      dark: false,
      themes: {
        dark: {
          primary: colors.blue.darken2,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3,
        },
      },
    },
  },
  toast: {
    position: 'top-right',
    duration: 3000,
    iconPack: 'mdi',
    keepOnHover: true,
    register: [
      // Register custom toasts
      {
        name: 'my-error',
        message: 'Oops...Something went wrong',
        options: {
          type: 'error',
        },
      },
    ],
  },
  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
    hotMiddleware: true,
  },
  firebase: {
    config: {
      apiKey: 'AIzaSyBywLoLM7yhLtsX7h1oeeI7Z1S2ALJZB6Q',
      authDomain: 'wmovies-821a0.firebaseapp.com',
      projectId: 'wmovies-821a0',
      storageBucket: 'wmovies-821a0.appspot.com',
      messagingSenderId: '681078994887',
      appId: '1:681078994887:web:143f215a81e0878bc58be2',
      measurementId: 'G-1Q353X4BT2',
    },
    services: {
      storage: true,
    },
  },
}
