<!-- eslint-disable vue/require-v-for-key -->
<!-- eslint-disable vue/valid-v-for -->
<!-- eslint-disable vue/no-v-text-v-html-on-component -->
<template>
  <v-app>
    <v-card elevation="24" width="95%" style="margin: 10px auto" class="white">
      <v-row>
        <v-col cols="12" sm="9" lg="9" xl="9" md="9">
          <v-card-text>
            <v-row>
              <v-col cols="12" sm="4" lg="4" xl="4" md="4" class="pa-1">
                <v-img height="200" width="500" :src="movie.image"> </v-img>
                <!-- <v-layout justify-center>
                    <v-btn class="mt-1 error">Xem trailer</v-btn>
                  </v-layout> -->
                <v-card class="d-flex flex-column mt-4">
                  <v-card-text class="d-flex justify-space-between">
                    <v-btn
                      small
                      @click="toLink('')"
                      class="mt-2 mb-2 error mx-auto"
                      ><v-icon>mdi-keyboard-return</v-icon>Quay lại
                    </v-btn>
                    <v-btn
                      small
                      @click="toLink('word')"
                      class="mt-2 mb-2 error mx-auto"
                      ><v-icon>mdi-bookshelf</v-icon>Từ vựng đã lưu</v-btn
                    >
                  </v-card-text>
                  <v-card-text class="mt-n6">
                    <div>
                      <h2 class="orange--text font-weight-bold">
                        {{ movie.name_en }}
                      </h2>
                      <p class="font-italic">{{ movie.name }}</p>
                    </div>
                    <p class="text-justify font-weight-bold">
                      {{ movie.content }}
                    </p></v-card-text
                  >
                </v-card>
              </v-col>
              <v-col cols="12" sm="8" lg="8" xl="8" md="8">
                <v-app-bar color="error" class="mt-n2">
                  <v-toolbar-title
                    class="text-center white--text font-weight-bold"
                    >Danh sách các cặp đã lưu trong phim</v-toolbar-title
                  >
                </v-app-bar>

                <v-container>
                  <v-row dense>
                    <v-col
                      v-if="couplets.length === 0"
                      cols="12"
                      sm="12"
                      lg="12"
                      xl="12"
                      md="12"
                      >{{ messageEmptyCouplet }}
                      <v-icon
                        v-if="
                          messageEmptyCouplet !==
                          'Đang tải dữ liệu, vui lòng đợi...'
                        "
                        >mdi-emoticon-sad-outline</v-icon
                      >
                    </v-col>
                    <v-col v-for="(item, i) in couplets" :key="i" cols="12">
                      <v-card :color="item.color" dark>
                        <div class="d-flex">
                          <div>
                            <v-card-title
                              class="text-h5 black--text font-weight-bold"
                              >{{ item.coupletEng }}</v-card-title
                            >

                            <v-card-subtitle
                              class="mt-n2 font-weight-medium black--text"
                              >{{ item.coupletVi }}</v-card-subtitle
                            >
                            <v-card-subtitle
                              class="mt-n5 black--text font-italic"
                            >
                              {{ 'Được lưu từ phim: ' }}
                              <nuxt-link
                                class="linkMovie"
                                :to="'/movies/' + item.movie.code"
                              >
                                {{
                                  item.movie.name_en.toUpperCase()
                                }}</nuxt-link
                              ></v-card-subtitle
                            >
                            <v-card-actions>
                              <v-btn
                                color="black"
                                class="ml-2 mt-n3"
                                height="40px"
                                right
                                rounded
                                outlined
                                width="40px"
                                @click="speakWordLookup(item.coupletEng)"
                              >
                                Nghe
                              </v-btn>
                              <v-btn
                                color="black"
                                class="ml-2 mt-n3"
                                height="40px"
                                right
                                rounded
                                outlined
                                width="40px"
                              >
                                Nói
                              </v-btn>
                              <v-btn
                                color="black"
                                class="ml-2 mt-n3"
                                height="40px"
                                right
                                rounded
                                outlined
                                width="40px"
                              >
                                Xóa
                              </v-btn>
                            </v-card-actions>
                          </div>
                        </div>
                      </v-card>
                    </v-col>
                    <v-col cols="12" sm="12" lg="12" xl="12" md="12">
                      <v-pagination
                        v-show="couplets.length > 0"
                        v-model="pageCouplet"
                        :length="lengthPanigation"
                        :total-visible="7"
                      ></v-pagination>
                    </v-col>
                  </v-row>
                </v-container>
                <v-divider class="mt-2"></v-divider>
              </v-col>
            </v-row>
          </v-card-text>
        </v-col>
        <v-col cols="12" sm="3" lg="3" xl="3" md="3">
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
              <template v-for="(item, index) in listViewMovies">
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
                    <v-list-item-title class="orange--text font-weight-bold">{{
                      item.title
                    }}</v-list-item-title>
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
    <!-- Hiển thị thông tin chi tiết về phim -->
  </v-app>
</template>

<script>
import axios from 'axios'

export default {
  asyncData({ params }) {
    // Lấy dữ liệu chi tiết về phim từ API hoặc nguồn dữ liệu khác bằng slug name
    const slug = params.slug
    console.log(slug)

    const movieE = slug // Hàm fetch phim theo slug name

    return { movieE }
  },
  data() {
    return {
      listViewMovies: [
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
      pageCouplet: 1,
      lengthPanigation: 0,
      limit: 4,
      offset: 0,
      isLogin: false,
      tabs: null,
      title: '',
      messageEmptyCouplet: 'Đang tải dữ liệu, vui lòng đợi...',
      movie: {
        id: null,
        code: '',
        name: '',
        name_en: '',
        content: '',
      },
      couplets: [],
    }
  },
  mounted() {
    // this.$nuxt.$on('auth', (auth) => {
    //   this.isLogin = auth
    // })
    if (localStorage.getItem('user_id')) {
      this.isLogin = localStorage.getItem('user_id')
    } else {
      this.$router.push('/')
    }
    this.loadMovieCouplets()
  },
  watch: {
    pageCouplet() {
      console.log(this.pageCouplet)
      this.offset = (this.pageCouplet - 1) * this.limit
      this.loadMovieCouplets()
    },
  },
  methods: {
    toLink(type) {
      this.$router.push(
        `/movies${type === '' ? '' : '/' + type}/${this.movieE}`
      )
    },
    async loadMovieCouplets() {
      if (this.isLogin) {
        try {
          const resData = await axios.get(
            `${process.env.URL_SERVER}/api/get-movie-couplets/${this.isLogin}/${this.movieE}/${this.limit}/${this.offset}`
          )
          if (resData && resData.data && resData.data.status) {
            const movie = {}
            movie.id = resData.data.dataMovie.id
            movie.code = resData.data.dataMovie.code
            movie.name = resData.data.dataMovie.name
            movie.name_en = resData.data.dataMovie.name_en
            movie.content = resData.data.dataMovie.content
            for (
              let indexI = 0;
              indexI < resData.data.dataMovie.movie_images.length;
              indexI++
            ) {
              const elementImage = resData.data.dataMovie.movie_images[indexI]
              if (elementImage.type_image === 'image' && elementImage.url) {
                const images = this.$fire.storage.ref().child('movies/images/')
                const image = images.child(elementImage.url)
                await image.getDownloadURL().then((url) => {
                  movie.image = url
                })
              }
            }
            this.movie = movie
            if (resData.data && resData.data.dataCouplets.length > 0) {
              this.couplets = []
              const arrayCheck = []
              for (
                let index = 0;
                index < resData.data.dataCouplets.length;
                index++
              ) {
                const element = resData.data.dataCouplets[index]
                if (
                  arrayCheck.length === 0 ||
                  !arrayCheck.includes(element.id)
                ) {
                  arrayCheck.push(element.id)

                  const coupletItem = {}
                  coupletItem.id = element.id
                  coupletItem.color = index % 2 === 0 ? '#FF8A80' : '#FFCDD2'
                  // '#' + Math.floor(Math.random() * 16777215).toString(16)
                  coupletItem.coupletEng = element.couplet
                  coupletItem.coupletVi = element.meaning
                  coupletItem.movie = element.movie

                  this.couplets.push(coupletItem)
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
            this.couplets = []
            const movie = {}
            movie.id = resData.data.dataMovie.id
            movie.code = resData.data.dataMovie.code
            movie.name = resData.data.dataMovie.name
            movie.name_en = resData.data.dataMovie.name_en
            movie.content = resData.data.dataMovie.content
            for (
              let indexI = 0;
              indexI < resData.data.dataMovie.movie_images.length;
              indexI++
            ) {
              const elementImage = resData.data.dataMovie.movie_images[indexI]
              if (elementImage.type_image === 'image' && elementImage.url) {
                const images = this.$fire.storage.ref().child('movies/images/')
                const image = images.child(elementImage.url)
                await image.getDownloadURL().then((url) => {
                  movie.image = url
                })
              }
            }
            this.movie = movie
            this.messageEmptyCouplet = 'Bạn chưa lưu cặp từ nào trên WMovies cả'
          }
        } catch (error) {
          console.log(error)
        }
      }
    },
    speakWordLookup(couplet) {
      if ('speechSynthesis' in window) {
        // Tạo một instance của SpeechSynthesisUtterance
        const utterance = new SpeechSynthesisUtterance()

        // Thiết lập ngôn ngữ và nội dung cần đọc
        utterance.lang = 'en-US' // Ngôn ngữ tiếng Anh
        utterance.text = couplet // Nội dung cần đọc

        // Gọi phương thức speechSynthesis.speak() để đọc nội dung
        window.speechSynthesis.speak(utterance)
      } else {
        console.error('Trình duyệt không hỗ trợ API Web Speech.')
      }
    },
  },
}
</script>
<style scoped>
.linkMovie {
  text-decoration: none;
  color: black;
}
.linkMovie:hover {
  color: orange;
  text-decoration: underline;
}
</style>
