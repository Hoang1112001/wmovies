<template>
  <v-app>
    <v-main class="scroll-y">
      <!-- <v-tooltip left>
        <template v-slot:activator="{ on, attrs }"> -->
      <!-- <v-btn
        v-scroll="onScroll"
        class="mt-8"
        fab
        color="error"
        bottom
        right
        small
        absolute
      >
        <v-icon>mdi-magnify</v-icon>
      </v-btn> -->
      <!-- </template>
        <span>Tìm kiếm phim</span>
      </v-tooltip> -->
      <HeaderMovie></HeaderMovie>

      <Nuxt dark class="error" />

      <FooterMovie></FooterMovie>
      <!-- <v-tooltip bottom>
        <template v-slot:activator="{ on, attrs }"> -->
      <v-btn
        v-scroll="onScroll"
        v-show="fab"
        fab
        dark
        fixed
        bottom
        small
        right
        color="error"
        @click="toTop"
      >
        <v-icon>mdi-arrow-up</v-icon></v-btn
      >
      <!-- </template>
        <span>Trở về đầu trang</span>
      </v-tooltip> -->
    </v-main>
  </v-app>
</template>

<script>
import HeaderMovie from '~/components/HeaderMovie.vue'
import FooterMovie from '~/components/FooterMovie.vue'
export default {
  components: { HeaderMovie, FooterMovie },
  name: 'DefaultLayout',
  data() {
    return {
      collapseOnScroll: true,
      clipped: false,
      drawer: false,
      fixed: false,
      fab: false,
      items: [
        {
          icon: 'mdi-apps',
          title: 'Welcome',
          to: '/',
        },
        {
          icon: 'mdi-chart-bubble',
          title: 'Inspire',
          to: '/inspire',
        },
      ],
      miniVariant: false,
      right: true,
      rightDrawer: false,
      title: 'Vuetify.js',
    }
  },
  methods: {
    onScroll(e) {
      if (typeof window === 'undefined') return
      const top = window.pageYOffset || e.target.scrollTop || 0
      this.fab = top > 20
    },
    toTop() {
      this.$vuetify.goTo(0)
    },
  },
}
</script>
