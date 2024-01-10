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
                    >TỪ VỰNG ĐÃ LƯU</v-toolbar-title
                  >
                </v-app-bar>

                <v-container>
                  <v-row dense>
                    <v-col
                      v-if="words.length === 0"
                      cols="12"
                      sm="12"
                      lg="12"
                      xl="12"
                      md="12"
                      >{{ messageEmptyWords }}
                      <v-icon
                        v-if="
                          messageEmptyWords !==
                          'Đang tải dữ liệu, vui lòng đợi...'
                        "
                        >mdi-emoticon-sad-outline</v-icon
                      >
                    </v-col>
                    <v-col
                      v-else
                      v-for="(item, i) in words"
                      :key="i"
                      cols="12"
                      sm="6"
                      lg="4"
                      xl="4"
                      md="4"
                    >
                      <v-card :color="item.color" dark>
                        <div class="d-flex">
                          <div>
                            <v-card-title class="text-h5 font-weight-bold">{{
                              item.word.toUpperCase()
                            }}</v-card-title>

                            <v-card-subtitle
                              ><div>
                                {{ '- Ý nghĩa: ' + item.meaning }}
                              </div>
                              <div>
                                {{ '- Phiên âm: ' + item.pronunciation }}
                              </div>
                              <div>
                                {{ '- Từ loại: ' + item.type }}
                              </div>
                              <div>
                                {{ '- Ví dụ: ' + item.example }}
                              </div>
                              <div>
                                {{ 'Được lưu từ phim: ' }}
                                <nuxt-link
                                  class="linkMovie"
                                  :to="'/movies/' + item.movie.code"
                                >
                                  {{
                                    item.movie.name_en.toUpperCase()
                                  }}</nuxt-link
                                >
                              </div>
                            </v-card-subtitle>

                            <v-card-actions>
                              <v-btn
                                class="ml-2 mt-n3"
                                height="40px"
                                right
                                rounded
                                outlined
                                width="40px"
                                @click="speakWordLookup(item.word)"
                              >
                                Nghe
                              </v-btn>
                              <v-btn
                                class="ml-2 mt-n3"
                                height="40px"
                                right
                                rounded
                                outlined
                                width="40px"
                              >
                                Nói
                              </v-btn>
                            </v-card-actions>
                          </div>
                        </div>
                      </v-card>
                    </v-col>
                    <v-col cols="12" sm="12" lg="12" xl="12" md="12">
                      <v-pagination
                        v-show="words.length > 0"
                        v-model="pageWord"
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
      pageWord: 1,
      lengthPanigation: 0,
      limit: 8,
      offset: 0,
      isLogin: false,
      tabs: null,
      title: '',
      messageEmptyWords: 'Đang tải dữ liệu, vui lòng đợi...',
      words: [],
    }
  },

  mounted() {
    // this.$nuxt.$on('auth', (auth) => {
    //   this.isLogin = auth
    // })
    if (localStorage.getItem('user_id')) {
      this.isLogin = localStorage.getItem('user_id')
    }
    this.loadMovieWords()
  },
  watch: {
    pageWord() {
      console.log(this.pageWord)
      this.offset = (this.pageWord - 1) * this.limit
      this.loadMovieWords()
    },
  },
  methods: {
    async loadMovieWords() {
      if (this.isLogin) {
        try {
          const resData = await axios.get(
            `${process.env.URL_SERVER}/api/get-user-words/${this.isLogin}/${this.limit}/${this.offset}`
          )
          if (resData && resData.data && resData.data.status) {
            if (resData.data && resData.data.dataWords.length > 0) {
              this.words = []
              const arrayCheck = []
              for (
                let index = 0;
                index < resData.data.dataWords.length;
                index++
              ) {
                const element = resData.data.dataWords[index]
                if (
                  arrayCheck.length === 0 ||
                  !arrayCheck.includes(element.id)
                ) {
                  arrayCheck.push(element.id)
                  const wordItem = {}
                  wordItem.id = element.id
                  wordItem.color =
                    '#' + Math.floor(Math.random() * 16777215).toString(16)
                  wordItem.word_id = element.word.id
                  wordItem.word = element.word.word
                  wordItem.type = element.word.type
                  wordItem.meaning = element.word.meaning
                  wordItem.pronunciation =
                    '/' + element.word.pronunciation + '/'
                  wordItem.example = element.word.example
                  wordItem.movie = element.movie

                  this.words.push(wordItem)
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
            this.words = []
            this.messageEmptyWords = 'Bạn chưa lưu từ vựng nào trên WMovies cả'
          }
        } catch (error) {
          console.log(error)
        }
      }
    },
    speakWordLookup(word) {
      if ('speechSynthesis' in window) {
        // Tạo một instance của SpeechSynthesisUtterance
        const utterance = new SpeechSynthesisUtterance()
        const randomColor = Math.floor(Math.random() * 16777215).toString(16)
        console.log(randomColor)
        // Thiết lập ngôn ngữ và nội dung cần đọc
        utterance.lang = 'en-US' // Ngôn ngữ tiếng Anh
        utterance.text = word // Nội dung cần đọc

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
}
.linkMovie:hover {
  color: orange;
  text-decoration: underline;
}
</style>
