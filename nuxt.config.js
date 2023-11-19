import colors from 'vuetify/es5/util/colors'

export default {
  // Disable server-side rendering: https://go.nuxtjs.dev/ssr-mode
  ssr: false,

  // Target: https://go.nuxtjs.dev/config-target
  target: 'static',
  router: {
    routes: [
      {
        name: 'movie-detail',
        path: '/movies/:slug',
        component: 'pages/movies/_slug/index.vue',
      },
      {
        name: 'movie-detail-play',
        path: '/movies/:slug/play',
        component: 'pages/movies/_slug/play.vue',
      },
      {
        name: 'movie-couplet',
        path: '/movies/couplet/:slug',
        component: 'pages/movies/couplet/_slug/index.vue',
      },
      {
        name: 'movie-word',
        path: '/movies/word/:slug',
        component: 'pages/movies/word/_slug/index.vue',
      },
    ],
    extendRoutes(routes, resolve) {
      // routes.push({
      //   name: 'movie-detail',
      //   path: '/movies/:slug',
      //   component: resolve(__dirname, 'pages/_slug/index.vue'),
      // })
    },
  },
  generate: {
    dir: process.env.DEPLOY_DIR || 'dist',
    // routes() {
    //   const slugs = ['KCB', 'TN', 'DP', 'BANT', 'BS']
    //   const routes = slugs.map((slug) => `/${slug}`)
    //   return routes
    // },
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

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
    hotMiddleware: true,
  },
  firebase: {
    config: {
      apiKey: 'AIzaSyArVeDEa0vRiK4g3s2hACyvCQul0uKssvo',
      authDomain: 'ent-hms.firebaseapp.com',
      databaseURL: 'https://ent-hms-default-rtdb.firebaseio.com',
      projectId: 'ent-hms',
      storageBucket: 'ent-hms.appspot.com',
      messagingSenderId: '911014492216',
      appId: '1:911014492216:web:01862da5a9173708f50ecd',
      measurementId: 'G-9X4C18M5M3',
    },
    services: {
      auth: true, // Just as example. Can be any other service.
    },
  },
}
