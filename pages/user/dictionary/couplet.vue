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
                <v-app-bar color="error" class="mt-n2">
                  <v-toolbar-title
                    class="text-center white--text font-weight-bold"
                    >CẶP CÂU ĐÃ LƯU</v-toolbar-title
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
import axios from 'axios'
import UserNav from '~/components/UserNav.vue'
export default {
  components: {
    UserNav,
  },
  data() {
    return {
      pageCouplet: 1,
      lengthPanigation: 0,
      limit: 4,
      offset: 0,
      isLogin: false,
      tabs: null,
      title: '',
      messageEmptyCouplet: 'Đang tải dữ liệu, vui lòng đợi...',
      couplets: [],
    }
  },

  mounted() {
    // this.$nuxt.$on('auth', (auth) => {
    //   this.isLogin = auth
    // })
    if (localStorage.getItem('user_id')) {
      this.isLogin = localStorage.getItem('user_id')
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
    speakWordLookup(couplet) {
      if ('speechSynthesis' in window) {
        // Tạo một instance của SpeechSynthesisUtterance
        const utterance = new SpeechSynthesisUtterance()
        const randomColor = Math.floor(Math.random() * 16777215).toString(16)
        console.log(randomColor)
        // Thiết lập ngôn ngữ và nội dung cần đọc
        utterance.lang = 'en-US' // Ngôn ngữ tiếng Anh
        utterance.text = couplet // Nội dung cần đọc

        // Gọi phương thức speechSynthesis.speak() để đọc nội dung
        window.speechSynthesis.speak(utterance)
      } else {
        console.error('Trình duyệt không hỗ trợ API Web Speech.')
      }
    },
    async loadMovieCouplets() {
      if (this.isLogin) {
        try {
          const resData = await axios.get(
            `${process.env.URL_SERVER}/api/get-user-couplets/${this.isLogin}/${this.limit}/${this.offset}`
          )
          if (resData && resData.data && resData.data.status) {
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
            this.messageEmptyCouplets =
              'Bạn chưa lưu cặp từ nào trên WMovies cả'
          }
        } catch (error) {
          console.log(error)
        }
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
