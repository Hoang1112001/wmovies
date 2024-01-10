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
            <v-col>
              <v-card max-width="450" class="mx-auto mt-2 mr-2">
                <v-toolbar color="error" dark>
                  <v-row class="d-flex justify-space-between ml-2 mt-2">
                    <v-toolbar-title class="font-weight-bold"
                      >PHIM ĐỀ XUẤT
                    </v-toolbar-title>
                    <v-img
                      class="mt-n4"
                      max-height="68"
                      max-width="85"
                      :src="require('~/static/logo.png')"
                    ></v-img>
                  </v-row>
                </v-toolbar>

                <v-list three-line>
                  <template v-for="(item, index) in recommendMovies">
                    <v-divider
                      v-if="item.divider"
                      :key="index"
                      :inset="item.inset"
                    ></v-divider>

                    <v-list-item v-else :key="item.title" :href="item.link">
                      <v-list-item-avatar tile>
                        <v-img :src="item.image"></v-img>
                      </v-list-item-avatar>

                      <v-list-item-content>
                        <v-list-item-title
                          class="orange--text font-weight-bold"
                          >{{ item.title }}</v-list-item-title
                        >
                        <v-list-item-subtitle class="font-italic">{{
                          item.subtitle
                        }}</v-list-item-subtitle>
                      </v-list-item-content>
                    </v-list-item>
                  </template>
                </v-list>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </v-app>
</template>
<script>
export default {
  //   asyncData({ params }) {
  //     // Lấy dữ liệu chi tiết về phim từ API hoặc nguồn dữ liệu khác bằng slug name
  //     const slug = params.slug
  //     console.log(slug)

  //     const movieE = slug // Hàm fetch phim theo slug name

  //     return { movieE }
  //   },
  data() {
    return {
      user: {
        username: '',
        email: '',
      },
      isLogin: false,
      recommendMovies: [
        {
          action: '',
          image: require('~/static/friend-1.jpg'),
          subtitle: 'Những người bạn mùa 1',
          title: 'FRIENDS SEASON 1',
          link: '/movies/friend-season-1',
        },
        { divider: true, inset: true },
        {
          action: '',
          image: require('~/static/friend-2.jpg'),
          subtitle: 'Những người bạn mùa 2',
          title: 'FRIENDS SEASON 2',
          link: '/movies/friend-season-2',
        },
        { divider: true, inset: true },
        {
          action: '',
          image: require('~/static/friend-3.jpg'),
          subtitle: 'Những người bạn mùa 3',
          title: 'FRIENDS SEASON 3',
          link: '/movies/friend-season-3',
        },
        { divider: true, inset: true },
        {
          action: '',
          image: require('~/static/friend-4.jpg'),
          subtitle: 'Những người bạn mùa 4',
          title: 'FRIENDS SEASON 4',
          link: '/movies/friend-season-4',
        },
        { divider: true, inset: true },
        {
          action: '',
          image: require('~/static/friend-5.jpg'),
          subtitle: 'Những người bạn mùa 5',
          title: 'FRIENDS SEASON 5',
          link: '/movies/friend-season-5',
        },
      ],
    }
  },

  async mounted() {
    // this.$nuxt.$on('auth', (auth) => {
    //   this.isLogin = auth
    // })

    try {
      const requestGetUser = await fetch(
        `${process.env.URL_SERVER}/account/get-user`,
        {
          method: 'GET', // *GET, POST, PUT, DELETE, etc.
          mode: 'cors', // no-cors, *cors, same-origin
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Credentials': true,
            'Content-Type': 'application/json',
          },
          credentials: 'include',
        }
      )
      const response = await requestGetUser.json()

      if (response.status) {
        const dataUser = response.data
        this.user = {
          id: dataUser.id,
          tempUsername: dataUser.username,
          username: dataUser.username,
          email: dataUser.email,
        }
      } else {
        // this.$nuxt.$emit('auth', this.user.id)
        this.$router.push('/')
      }
    } catch (error) {
      console.log(error)
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
