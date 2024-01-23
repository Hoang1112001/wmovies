<template>
  <v-app>
    <v-row>
      <v-col cols="12" sm="12" lg="12" xl="12" md="12">
        <v-card class="d-flex flex-column mt-4 pa-2">
          <v-list-item three-line>
            <v-list-item-avatar tile size="80" color="grey">
              <v-img
                max-height="80"
                max-width="80"
                :src="require('~/static/logo.png')"
              ></v-img
            ></v-list-item-avatar>
            <v-list-item-content>
              <v-list-item-title
                class="text-h6 ml-2 red--text font-weight-medium"
              >
                {{ user.username.toUpperCase() }}
              </v-list-item-title>

              <v-list-item-subtitle
                class="ml-2 mt-1 red--text font-weight-medium"
              >
                EMAIL : {{ user.email }}</v-list-item-subtitle
              >
            </v-list-item-content>
          </v-list-item>
          <v-row class="pa-2">
            <v-col cols="12" sm="12" lg="6" xl="6" md="12">
              <v-btn
                block
                @click="toLink('dictionary/couplet')"
                class="mt-2 mb-2 error mx-auto"
                ><v-icon>mdi-pencil-circle</v-icon>Cặp câu đã lưu
              </v-btn>
            </v-col>
            <v-col cols="12" sm="12" lg="6" xl="6" md="12">
              <v-btn
                block
                @click="toLink('dictionary/word')"
                class="mt-2 mb-2 error mx-auto"
                ><v-icon>mdi-bookshelf</v-icon>Từ vựng đã lưu
              </v-btn>
            </v-col>
            <v-col cols="12" sm="12" lg="6" xl="6" md="12">
              <v-btn
                block
                @click="toLink('favourite')"
                class="mt-2 mb-2 error mx-auto"
                ><v-icon>mdi-heart</v-icon>Phim yêu thích</v-btn
              ></v-col
            >
            <v-col cols="12" sm="12" lg="6" xl="6" md="12">
              <v-btn
                block
                @click="toLink('history')"
                class="mt-2 mb-2 error mx-auto"
                ><v-icon>mdi-history</v-icon>Lịch sử xem phim</v-btn
              ></v-col
            >
            <v-col><Recommend /></v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </v-app>
</template>
<script>
// import axios from 'axios'
import Recommend from '~/components/Recommend.vue'
export default {
  components: {
    Recommend,
  },
  data() {
    return {
      user: {
        username: '',
        email: '',
      },
      isLogin: false,
    }
  },

  mounted() {
    if (this.$nuxt.$store.state.data) {
      this.isLogin = this.$nuxt.$store.state.data.id
      this.user = this.$nuxt.$store.state.data
    } else {
      this.$nuxt.$on('auth', (auth) => {
        if (auth && auth.id) {
          this.isLogin = auth.id
          this.user = { ...auth }
        } else {
          this.$router.push('/')
        }
      })
    }
  },

  methods: {
    toLink(link) {
      this.$router.push(`/user/${link}`)
    },
  },
}
</script>
<style></style>
