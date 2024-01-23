<!-- eslint-disable vue/require-v-for-key -->
<!-- eslint-disable vue/valid-v-for -->
<!-- eslint-disable vue/no-v-text-v-html-on-component -->
<template>
  <v-app>
    <v-card elevation="24" width="95%" style="margin: 10px auto" class="white">
      <v-row>
        <v-col cols="12" sm="12" lg="12" xl="12" md="12">
          <v-card-text>
            <v-row>
              <v-col cols="12" sm="4" lg="4" xl="4" md="4" class="mt-n4">
                <UserNav></UserNav>
              </v-col>
              <v-col cols="12" sm="8" lg="8" xl="8" md="8">
                <v-app-bar color="error" class="">
                  <v-toolbar-title
                    class="text-center white--text font-weight-bold"
                    ><v-icon color="white">mdi-history</v-icon> LỊCH SỬ XEM
                    PHIM</v-toolbar-title
                  >
                </v-app-bar>

                <v-container>
                  <v-row dense>
                    <v-col
                      v-if="historyMovies.length === 0"
                      cols="12"
                      sm="12"
                      lg="12"
                      xl="12"
                      md="12"
                      >{{ messageEmptyMovies }}
                      <v-icon
                        v-if="
                          messageEmptyMovies !==
                          'Đang tải dữ liệu, vui lòng đợi...'
                        "
                        >mdi-emoticon-sad-outline</v-icon
                      >
                    </v-col>
                    <v-col
                      v-else
                      v-for="(file, i) in historyMovies"
                      :key="i"
                      cols="12"
                      sm="3"
                      lg="3"
                      xl="3"
                      md="3"
                    >
                      <v-card class="mx-auto" max-width="400">
                        <v-menu
                          open-on-hover
                          open-delay="1000"
                          :close-on-content-click="false"
                          :nudge-width="200"
                          offset-x
                        >
                          <template v-slot:activator="{ on, attrs }">
                            <div
                              class="image-container"
                              v-bind="attrs"
                              v-on="on"
                            >
                              <v-img
                                class="white--text align-start"
                                height="200px"
                                :src="file.image"
                                contain
                              >
                              </v-img>
                              <div class="overlay">
                                <v-btn fab large :to="file.link">
                                  <v-icon>mdi-play</v-icon></v-btn
                                >
                              </div>
                            </div>
                          </template>
                          <v-card max-height="400">
                            <v-list>
                              <v-list-item>
                                <v-list-item-content>
                                  <v-list-item-title
                                    class="orange--text font-weight-bold"
                                  >
                                    {{
                                      file.title +
                                      ' (' +
                                      file.year_of_manufacture +
                                      ')'
                                    }}</v-list-item-title
                                  >
                                  <v-list-item-subtitle
                                    class="text--primary font-italic"
                                    >{{ file.subtitle }}</v-list-item-subtitle
                                  >
                                </v-list-item-content>
                              </v-list-item>
                            </v-list>

                            <v-divider></v-divider>

                            <v-list dense>
                              <v-list-item dense>
                                <v-list-item-icon>
                                  <v-icon> mdi-alarm </v-icon>
                                </v-list-item-icon>

                                <v-list-item-content class="ml-n5">
                                  <v-list-item-title
                                    >Thời lượng: ~
                                    {{ file.time }} phút/tập</v-list-item-title
                                  >
                                </v-list-item-content>
                              </v-list-item>
                              <v-list-item dense>
                                <v-list-item-icon>
                                  <v-icon> mdi-account-group </v-icon>
                                </v-list-item-icon>

                                <v-list-item-content class="ml-n5">
                                  <v-list-item-title>
                                    Diễn viên:
                                    <template
                                      v-for="movie_actor in file.movie_actors"
                                    >
                                      <a
                                        @click="
                                          toLinkSearch('actor', movie_actor)
                                        "
                                        style="text-decoration: none"
                                        >{{ movie_actor.actor.name + ' ' }},
                                      </a>
                                    </template>
                                  </v-list-item-title>
                                </v-list-item-content>
                              </v-list-item>
                              <v-list-item dense>
                                <v-list-item-icon>
                                  <v-icon> mdi-multimedia </v-icon>
                                </v-list-item-icon>

                                <v-list-item-content class="ml-n5">
                                  <v-list-item-title>
                                    Thể loại:
                                    <template
                                      v-for="movie_category in file.movie_categories"
                                    >
                                      <a
                                        @click="
                                          toLinkSearch(
                                            'category',
                                            movie_category
                                          )
                                        "
                                        style="text-decoration: none"
                                        >{{
                                          movie_category.category.name + ' '
                                        }},
                                      </a></template
                                    >
                                  </v-list-item-title>
                                </v-list-item-content>
                              </v-list-item>
                              <v-list-item dense>
                                <v-list-item-icon>
                                  <v-icon> mdi-flag </v-icon>
                                </v-list-item-icon>

                                <v-list-item-content class="ml-n5">
                                  <v-list-item-title>
                                    Quốc gia:
                                    <a
                                      @click="
                                        toLinkSearch('country', file.country)
                                      "
                                      >{{ file.country.name }}
                                    </a></v-list-item-title
                                  >
                                </v-list-item-content>
                              </v-list-item>
                              <v-list-item dense>
                                <v-list-item-icon>
                                  <v-icon> mdi-calendar </v-icon>
                                </v-list-item-icon>

                                <v-list-item-content class="ml-n5">
                                  <v-list-item-title
                                    >Năm sản xuất:
                                    {{
                                      ' ' + file.year_of_manufacture
                                    }}</v-list-item-title
                                  >
                                </v-list-item-content>
                              </v-list-item>
                            </v-list>
                          </v-card>
                        </v-menu>
                        <v-card-title>
                          <v-row class="d-flex flex-column">
                            <v-col class="d-flex justify-space-between">
                              <v-chip x-small draggable>
                                {{ file.type.toUpperCase() }}
                              </v-chip>
                              <v-chip x-small draggable>
                                <v-icon small left> mdi-eye </v-icon>
                                {{ file.view }} lượt xem
                              </v-chip>
                            </v-col>
                            <v-col class="d-flex">
                              <nuxt-link :to="file.link">
                                <span
                                  class="d-inline-block text-truncate hover-title red--text"
                                  style="font-size: 16px; max-width: 180px"
                                >
                                  {{
                                    file.title +
                                    ' (' +
                                    file.year_of_manufacture +
                                    ')'
                                  }}
                                </span></nuxt-link
                              >
                            </v-col>
                          </v-row>
                        </v-card-title>
                        <v-card-subtitle
                          class="d-inline-block text-truncate font-italic font-weight-medium orange--text"
                          style="max-width: 220px"
                        >
                          {{ file.subtitle }}
                        </v-card-subtitle>
                      </v-card>
                    </v-col>
                    <v-col cols="12" sm="12" lg="12" xl="12" md="12">
                      <v-pagination
                        v-show="
                          historyMovies.length > 0 && lengthPanigation > 1
                        "
                        v-model="pageMovie"
                        :length="lengthPanigation"
                        :total-visible="7"
                      ></v-pagination>
                    </v-col>
                  </v-row>
                </v-container>
              </v-col>
            </v-row>
          </v-card-text>
        </v-col>
      </v-row>
    </v-card>
    <!-- Hiển thị thông tin chi tiết về phim -->
  </v-app>
</template>

<script>
// import gql from 'graphql-tag'
// import moment from 'moment'
import axios from 'axios'
import UserNav from '~/components/UserNav.vue'

export default {
  components: {
    UserNav,
  },
  data() {
    return {
      userInfo: null,
      pageMovie: 1,
      lengthPanigation: 0,
      limit: 8,
      offset: 0,
      isLogin: false,
      historyMovies: [],
      messageEmptyMovies: 'Đang tải dữ liệu, vui lòng đợi...',
    }
  },
  watch: {
    pageMovie() {
      console.log(this.pageMovie)
      this.offset = (this.pageMovie - 1) * this.limit
      this.loadMovieHistory()
    },
  },
  mounted() {
    if (this.$nuxt.$store.state.data) {
      this.isLogin = this.$nuxt.$store.state.data.id
      this.userInfo = this.$nuxt.$store.state.data
      this.loadMovieHistory()
    } else {
      this.$nuxt.$on('auth', (auth) => {
        if (auth && auth.id) {
          this.isLogin = auth.id
          this.userInfo = { ...auth }
          this.loadMovieHistory()
        } else {
          this.$router.push('/')
        }
      })
    }
  },

  methods: {
    async loadMovieHistory() {
      if (this.isLogin) {
        try {
          const resData = await axios.get(
            `${process.env.URL_SERVER}/api/get-movie-history/${this.isLogin}/${this.limit}/${this.offset}`
          )
          if (resData && resData.data && resData.data.status) {
            console.log(resData)
            if (resData.data && resData.data.dataHistory.length > 0) {
              this.historyMovies = []
              const arrayCheck = []
              for (
                let index = 0;
                index < resData.data.dataHistory.length;
                index++
              ) {
                const element = resData.data.dataHistory[index].movie
                if (
                  arrayCheck.length === 0 ||
                  !arrayCheck.includes(element.id)
                ) {
                  arrayCheck.push(element.id)
                  const movieItem = {}
                  movieItem.id = element.id
                  movieItem.ep = element.total_episode
                  movieItem.type = element.movie_type
                  movieItem.status = element.movie_status
                  movieItem.view = element.view
                  movieItem.title = element.name_en.toUpperCase()
                  movieItem.subtitle = element.name
                  movieItem.link = '/movies/movie_detail?code=' + element.code
                  movieItem.country = element.country
                  movieItem.year_of_manufacture = element.year_of_manufacture
                  movieItem.time = element.time
                  for (
                    let indexI = 0;
                    indexI < element.movie_images.length;
                    indexI++
                  ) {
                    const elementImage = element.movie_images[indexI]
                    if (
                      elementImage.type_image === 'image' &&
                      elementImage.url
                    ) {
                      const images = this.$fire.storage
                        .ref()
                        .child('movies/images/')
                      const image = images.child(elementImage.url)
                      await image.getDownloadURL().then((url) => {
                        movieItem.image = url
                      })
                    }
                    if (
                      elementImage.type_image === 'banner' &&
                      elementImage.url
                    ) {
                      const images = this.$fire.storage
                        .ref()
                        .child('movies/banners/')
                      const image = images.child(elementImage.url)
                      await image.getDownloadURL().then((url) => {
                        movieItem.banner = url
                      })
                    }
                  }
                  if (element.movie_categories.length > 0) {
                    movieItem.movie_categories = element.movie_categories
                  }
                  if (element.movie_actors.length > 0) {
                    movieItem.movie_actors = element.movie_actors
                  }
                  this.historyMovies.push(movieItem)
                } else {
                  continue
                }
              }
            }
            if (resData.data && resData.data.dataTotal) {
              this.lengthPanigation = Math.ceil(
                resData.data.dataTotal / this.limit
              )
            }
          } else {
            this.historyMovies = []
            this.messageEmptyMovies = 'Bạn chưa xem phim nào của WMovies cả'
          }
        } catch (error) {
          console.log(error)
        }
      }
    },
    toLink(link) {
      this.$router.push(`/${link}`)
    },
    toLinkSearch(type, item) {
      if (type === 'country') {
        this.$router.push({ path: '/search', query: { country: item.code } })
      }
      if (type === 'category') {
        this.$router.push({
          path: '/search',
          query: { category: item.category.code },
        })
      }
      if (type === 'actor') {
        this.$router.push({ path: `/actors`, query: { code: item.actor.code } })
      }
    },
  },
}
</script>
<style>
.hover-title:hover {
  color: orange;
  text-decoration: underline;
  cursor: pointer;
}
.image-container {
  position: relative;
}

.overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  opacity: 0;
  transition: opacity 0.3s;
  display: flex;
  justify-content: center;
  align-items: center;
}

.overlay:hover {
  opacity: 1;
}
</style>
