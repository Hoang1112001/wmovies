<!-- eslint-disable vue/no-use-v-if-with-v-for -->
<!-- eslint-disable vue/valid-v-on -->
<!-- eslint-disable no-lonely-if -->
<!-- eslint-disable vue/require-v-for-key -->
<!-- eslint-disable vue/valid-v-for -->
<!-- eslint-disable vue/no-v-text-v-html-on-component -->
<template>
  <v-app>
    <v-snackbar v-model="snackbar">
      {{ textSnackbar }}

      <template v-slot:action="{ attrs }">
        <v-btn color="pink" text v-bind="attrs" @click="snackbar = false">
          ĐÓNG
        </v-btn>
      </template>
    </v-snackbar>
    <v-dialog v-model="dialogEditComment" max-width="500">
      <v-card>
        <v-card-text>
          <v-row class="pa-5 mx-auto">
            <v-col cols="12" sm="12" lg="12" xl="12" md="12">
              <p class="font-weight-medium red--text">CHỈNH SỬA BÌNH LUẬN</p>
            </v-col>

            <v-col
              cols="12"
              sm="12"
              lg="12"
              xl="12"
              md="12"
              style="margin-top: -20px"
              v-if="commentItemEdited"
            >
              <v-text-field
                v-model="commentItemEdited.comment"
                label="Bình luận của bạn"
                outlined
                dense
              ></v-text-field>
            </v-col> </v-row
        ></v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="closeEditComment"> Đóng </v-btn>
          <v-btn color="error" text @click="editCommentConfirm"> Lưu </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialogDeleteComment" width="unset">
      <v-sheet outlined color="error" rounded>
        <v-card>
          <v-card-title class="h5 red--text"
            >Bạn có chắc muốn xóa bình luận này?</v-card-title
          >
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="error" text @click="closeDeleteComment">Không</v-btn>
            <v-btn color="error" text @click="deleteCommentConfirm">Có</v-btn>
            <v-spacer></v-spacer>
          </v-card-actions>
        </v-card>
      </v-sheet>
    </v-dialog>
    <v-card elevation="24" width="95%" style="margin: 10px auto" class="white">
      <v-row>
        <v-col cols="12" sm="9" lg="9" xl="9" md="9">
          <v-card-text>
            <v-row>
              <v-col cols="12" sm="4" lg="4" xl="4" md="4" class="pa-1">
                <v-img height="200" width="500" contain :src="movie.image">
                </v-img>
                <!-- <v-layout justify-center>
                  <v-btn class="mt-1 error">Xem trailer</v-btn>
                </v-layout> -->
                <v-card class="d-flex flex-column mt-4">
                  <v-btn
                    @click="toLink('couplet')"
                    class="mt-2 mb-2 error mx-auto"
                    ><v-icon>mdi-pencil-circle</v-icon>Cặp câu đã lưu trong
                    phim</v-btn
                  >
                  <!-- <v-img :src="require('~/static/learnQuotes.png')"> </v-img> -->
                  <v-btn @click="toLink('word')" class="mt-2 mb-2 error mx-auto"
                    ><v-icon>mdi-bookshelf</v-icon>Từ vựng đã lưu trong
                    phim</v-btn
                  >
                  <!-- <v-img :src="require('~/static/learnWord.png')"> </v-img> -->
                </v-card>
              </v-col>
              <v-col cols="12" sm="8" lg="8" xl="8" md="8">
                <v-card-text class="d-flex justify-space-between">
                  <div>
                    <h2 class="orange--text font-weight-bold">
                      {{ movie.name_en }}
                    </h2>
                    <p class="font-italic">{{ movie.name }}</p>
                  </div>

                  <v-btn
                    small
                    color="error"
                    @click="addToFavouriteMovie"
                    outlined
                  >
                    <v-icon v-if="!isLikeMovie"> mdi-heart-outline </v-icon>

                    <v-icon v-else> mdi-heart </v-icon>
                    Yêu thích</v-btn
                  >
                </v-card-text>
                <v-divider></v-divider>
                <v-card-text>
                  <h3>SỐ TẬP TRONG PHIM</h3>
                  <template v-for="item in movie.movie_details">
                    <v-btn
                      @click="toLinkWatch(item)"
                      small
                      class="pa-2 mt-2 ml-2"
                    >
                      {{ item.episode }}
                    </v-btn>
                  </template>
                </v-card-text>
                <v-divider></v-divider>

                <v-tabs v-model="tabs" centered>
                  <v-tab>Giới thiệu phim</v-tab>
                  <v-tab>Bình luận phim {{ '(' + totalComments + ')' }}</v-tab>
                  <!-- <v-tab>Phim liên quan</v-tab> -->
                </v-tabs>

                <v-tabs-items v-model="tabs">
                  <v-tab-item>
                    <v-card flat>
                      <v-card-text>
                        <p class="text-justify font-weight-bold">
                          {{ movie.content }}
                        </p>
                        <!-- <p class="font-weight-bold text-justify">
                          <span>Đạo diễn:</span>
                          <a>{{ movie.director.fullname }}</a>
                        </p> -->
                        <p class="font-weight-bold text-justify">
                          <span>Diễn viên:</span>
                          <template v-for="item in movie.movie_actors">
                            <a @click="toLinkSearch('actor', item)">
                              {{ item.name }}</a
                            >
                            ,
                          </template>
                        </p>
                        <p class="font-weight-bold text-justify">
                          <span>Thời lượng:</span>
                          <span>{{ movie.time }} phút/tập</span>
                        </p>
                        <p class="font-weight-bold text-justify">
                          <span>Quốc gia:</span>
                          <a @click="toLinkSearch('country', movie.country)">{{
                            movie.country && movie.country.name
                              ? movie.country.name
                              : ''
                          }}</a>
                        </p>
                        <p class="font-weight-bold text-justify">
                          <span>Thể loại:</span>
                          <template v-for="item in movie.movie_categories">
                            <a @click="toLinkSearch('category', item)">
                              {{ item.name }}</a
                            >
                            ,
                          </template>
                        </p>
                        <p class="font-weight-bold text-justify">
                          <span>Năm sản xuất:</span>
                          <span>{{ movie.year_of_manufacture }}</span>
                        </p>
                      </v-card-text>
                    </v-card>
                  </v-tab-item>
                  <v-tab-item>
                    <v-list class="d-flex flex-column">
                      <v-list-item>
                        <v-list-item-avatar color="error mt-n5" tile>
                          <v-icon>mdi-account</v-icon>
                        </v-list-item-avatar>

                        <v-list-item-content>
                          <v-textarea
                            v-model="commentUserContent"
                            outlined
                            label="Bình luận của bạn"
                            placeholder="Nhập bình luận của bạn ở đây..."
                            rows="2"
                            auto-grow
                          >
                          </v-textarea>
                        </v-list-item-content>
                      </v-list-item>
                      <v-layout align-end class="mt-n7 mr-4">
                        <v-spacer></v-spacer>
                        <v-btn
                          class="error"
                          small
                          align-end
                          :disabled="commentUserContent === ''"
                          @click="addCommentMovie"
                          >Bình luận</v-btn
                        >
                      </v-layout>
                    </v-list>

                    <v-list three-line class="mt-n2">
                      <template v-for="(item, index) in commentMovies">
                        <v-divider></v-divider>
                        <v-list-item>
                          <v-list-item-avatar>
                            <v-img :src="item.image_user"></v-img>
                            <!-- {{ item.user.username.slice(0, 1).toUpperCase() }} -->
                            <!-- <v-icon>mdi-account</v-icon> -->
                            <!-- <v-img :src="item.image"></v-img> -->
                          </v-list-item-avatar>

                          <v-list-item-content>
                            <v-list-item-title class="font-weight-bold mt-1"
                              >{{ item.user.username
                              }}<span class="caption">
                                {{ '  -  ' + item.timeComment }}</span
                              ></v-list-item-title
                            >
                            <v-list-item-subtitle
                              class="font-weight-medium mt-2"
                              >{{ item.comment }}</v-list-item-subtitle
                            >
                            <v-list-item-subtitle
                              ><v-btn
                                v-if="item.isCommentUser"
                                x-small
                                color="error"
                                text
                                @click="editComment(item)"
                                >[Sửa]</v-btn
                              ><v-btn
                                v-if="item.isCommentUser"
                                x-small
                                color="error"
                                text
                                @click="deleteComment(item)"
                                >[Xóa]</v-btn
                              ><v-btn
                                x-small
                                color="error"
                                text
                                @click="replyComment(item)"
                                >[Phản hồi]</v-btn
                              >
                              <v-btn
                                v-if="item.children && item.children.length > 0"
                                x-small
                                color="error"
                                text
                                @click="showReplyComment(item)"
                              >
                                {{
                                  showReplyCommentIndex === -1
                                    ? `[HIển thị phản hồi](${item.children.length})`
                                    : '[Ẩn phản hồi]'
                                }}</v-btn
                              ></v-list-item-subtitle
                            >

                            <template v-if="replyIndex === index">
                              <v-list class="d-flex flex-column">
                                <v-list-item>
                                  <v-list-item-avatar color="error" tile>
                                    <v-icon>mdi-account</v-icon>
                                  </v-list-item-avatar>

                                  <v-list-item-content>
                                    <v-textarea
                                      outlined
                                      :label="labelReplay"
                                      placeholder="Nhập phản hồi của bạn ở đây..."
                                      v-model="replyUserContent"
                                      rows="2"
                                      auto-grow
                                    >
                                    </v-textarea>
                                  </v-list-item-content>
                                </v-list-item>
                                <v-layout align-end class="mt-n7 mr-4">
                                  <v-spacer></v-spacer>
                                  <v-btn
                                    class="error mr-2"
                                    small
                                    align-end
                                    @click="cancelreplyComment"
                                    >Hủy</v-btn
                                  >
                                  <v-btn
                                    class="error"
                                    small
                                    :disabled="replyUserContent === ''"
                                    align-end
                                    @click="addreplyComment"
                                    >Phản hồi</v-btn
                                  >
                                </v-layout>
                              </v-list>
                            </template>
                            <template
                              v-if="showReplyCommentIndex === index"
                              v-for="(child, indexChild) in item.children"
                            >
                              <v-divider></v-divider>
                              <v-list-item>
                                <v-list-item-avatar>
                                  <v-img :src="item.image_user"></v-img>
                                  <!-- {{
                                    child.user.username
                                      .slice(0, 1)
                                      .toUpperCase()
                                  }} -->
                                </v-list-item-avatar>
                                <v-list-item-content>
                                  <v-list-item-title
                                    class="font-weight-bold mt-1"
                                    >{{ child.user.username
                                    }}<span class="caption">
                                      {{ '  -  ' + child.timeComment }}</span
                                    ></v-list-item-title
                                  >
                                  <v-list-item-subtitle
                                    class="font-weight-medium mt-2"
                                    ><span
                                      class="font-italic font-weight-bold"
                                      >{{
                                        child.user_reply
                                          ? '@' +
                                            child.user_reply.username +
                                            ': '
                                          : ''
                                      }}</span
                                    >
                                    {{ child.comment }}</v-list-item-subtitle
                                  >
                                  <v-list-item-subtitle
                                    v-if="child.isCommentUser"
                                    ><v-btn
                                      x-small
                                      color="error"
                                      text
                                      @click="editComment(child)"
                                      >[Sửa]</v-btn
                                    ><v-btn
                                      x-small
                                      color="error"
                                      text
                                      @click="deleteComment(child)"
                                      >[Xóa]</v-btn
                                    ><v-btn
                                      x-small
                                      color="error"
                                      text
                                      @click="replyComment(child)"
                                      >[Phản hồi]</v-btn
                                    >
                                  </v-list-item-subtitle>
                                </v-list-item-content>
                                <v-list-item-action>
                                  <v-list-item-action-text class="mx-auto">{{
                                    child.user_like
                                  }}</v-list-item-action-text>
                                  <v-btn
                                    icon
                                    @click="
                                      handleLikeComment(child, indexChild)
                                    "
                                  >
                                    <v-icon
                                      v-if="child.isLikeByUser"
                                      color="blue"
                                      >mdi-thumb-up</v-icon
                                    >
                                    <v-icon v-else>mdi-thumb-up</v-icon></v-btn
                                  >
                                </v-list-item-action>
                              </v-list-item>
                            </template>
                          </v-list-item-content>
                          <v-list-item-action>
                            <v-list-item-action-text class="mx-auto">{{
                              item.user_like
                            }}</v-list-item-action-text>
                            <v-btn icon @click="handleLikeComment(item, index)">
                              <v-icon v-if="item.isLikeByUser" color="blue"
                                >mdi-thumb-up</v-icon
                              >
                              <v-icon v-else>mdi-thumb-up</v-icon></v-btn
                            >
                          </v-list-item-action>
                        </v-list-item>
                      </template>
                    </v-list>
                    <v-pagination
                      v-show="commentMovies.length > 0"
                      v-model="pageComments"
                      :length="lengthPanigation"
                      :total-visible="7"
                    ></v-pagination>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row class="mt-2 pa-2">
                      <v-col
                        v-for="(file, f) in hotMoviesItems"
                        :key="f"
                        cols="12"
                        sm="12"
                        lg="6"
                        xl="6"
                        md="6"
                      >
                        <v-card
                          :href="file.link"
                          class="mx-auto"
                          max-width="400"
                        >
                          <v-menu
                            open-on-hover
                            open-delay="1000"
                            :close-on-content-click="false"
                            :nudge-width="200"
                            offset-x
                          >
                            <template v-slot:activator="{ on, attrs }">
                              <v-img
                                v-bind="attrs"
                                v-on="on"
                                class="white--text align-start"
                                height="170px"
                                :src="file.image"
                              >
                                <v-row
                                  class="pa-4 d-flex justify-space-between mt-n1"
                                >
                                  <v-avatar
                                    :color="
                                      file.status === 'HOT' ? 'error' : 'green'
                                    "
                                    size="50"
                                  >
                                    <span class="white--text text-h7">{{
                                      file.status
                                    }}</span>
                                  </v-avatar>
                                  <v-avatar
                                    class="d-flex flex-column"
                                    color="indigo"
                                    size="50"
                                  >
                                    <span class="white--text text-h7">Tập</span>
                                    <span class="white--text text-h7">{{
                                      file.ep
                                    }}</span>
                                  </v-avatar>
                                </v-row>
                              </v-img>
                            </template>
                            <v-card max-height="400">
                              <v-list>
                                <v-list-item>
                                  <v-list-item-content>
                                    <v-list-item-title
                                      class="orange--text font-weight-bold"
                                    >
                                      {{ file.title }}</v-list-item-title
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
                                      >Thời lượng: ~24
                                      phút/tập</v-list-item-title
                                    >
                                  </v-list-item-content>
                                </v-list-item>
                                <v-list-item dense>
                                  <v-list-item-icon>
                                    <v-icon> mdi-account-group </v-icon>
                                  </v-list-item-icon>

                                  <v-list-item-content class="ml-n5">
                                    <v-list-item-title
                                      >Diễn viên: <a>Jennifer Aniston</a>,
                                      <a>Courteney Cox</a>,<a>Lisa Kudrow</a>
                                    </v-list-item-title>
                                  </v-list-item-content>
                                </v-list-item>
                                <v-list-item dense>
                                  <v-list-item-icon>
                                    <v-icon> mdi-multimedia </v-icon>
                                  </v-list-item-icon>

                                  <v-list-item-content class="ml-n5">
                                    <v-list-item-title
                                      >Thể loại: <a>Tình cảm</a
                                      ><a> Hài hước</a></v-list-item-title
                                    >
                                  </v-list-item-content>
                                </v-list-item>
                                <v-list-item dense>
                                  <v-list-item-icon>
                                    <v-icon> mdi-flag </v-icon>
                                  </v-list-item-icon>

                                  <v-list-item-content class="ml-n5">
                                    <v-list-item-title
                                      >Quốc gia: UNITED
                                      STATES</v-list-item-title
                                    >
                                  </v-list-item-content>
                                </v-list-item>
                                <v-list-item dense>
                                  <v-list-item-icon>
                                    <v-icon> mdi-calendar </v-icon>
                                  </v-list-item-icon>

                                  <v-list-item-content class="ml-n5">
                                    <v-list-item-title
                                      >Năm sản xuất: 1994</v-list-item-title
                                    >
                                  </v-list-item-content>
                                </v-list-item>
                              </v-list>
                            </v-card>
                          </v-menu>
                          <v-card-title>
                            <v-row class="d-flex justify-space-between">
                              <v-chip x-small draggable>
                                {{ file.type.toUpperCase() }}
                              </v-chip>
                              <v-chip x-small draggable>
                                <v-icon small left> mdi-eye </v-icon>
                                {{ file.view }} lượt xem
                              </v-chip>
                            </v-row>
                            <span
                              class="d-inline-block text-truncate mt-2 ml-n3"
                              style="max-width: 220px; font-size: 20px"
                            >
                              {{ file.title }}
                            </span></v-card-title
                          >
                          <v-card-subtitle>
                            <span
                              class="d-inline-block text-truncate font-italic ml-n3"
                              style="max-width: 220px"
                            >
                              {{ file.subtitle }}
                            </span>
                          </v-card-subtitle>
                        </v-card></v-col
                      >
                    </v-row>
                  </v-tab-item>
                </v-tabs-items>
                <v-divider class="mt-2"></v-divider>
              </v-col>
            </v-row>
          </v-card-text>
        </v-col>
        <v-col cols="12" sm="3" lg="3" xl="3" md="3">
          <Recommend />
        </v-col>
      </v-row>
    </v-card>
    <!-- Hiển thị thông tin chi tiết về phim -->
  </v-app>
</template>

<script>
import gql from 'graphql-tag'
import moment from 'moment'
import axios from 'axios'
import Recommend from '~/components/Recommend.vue'

export default {
  asyncData({ params, route }) {
    const slug = decodeURIComponent(route.query.code)
    const movieE = slug // Hàm fetch phim theo slug name

    return { movieE }
  },
  components: {
    Recommend,
  },
  data() {
    return {
      tempEdited: null,
      userInfo: null,
      dialogDeleteComment: false,
      dialogEditComment: false,
      pageComments: 1,
      lengthPanigation: 0,
      limit: 5,
      offset: 0,
      commentUserContent: '',
      replyUserContent: '',
      snackbar: false,
      textSnackbar: '',
      isLikeMovie: false,
      isLogin: null,
      tabs: null,
      title: '',
      movie: {
        id: null,
        code: null,
        name: '',
        name_en: '',
        year_of_manufacture: null,
        time: null,
        image: null,
        content: ``,
      },
      hotMoviesItems: [],
      totalComments: 0,
      commentMovies: [],
      movie_favourite: null,
      commentItemEdited: null,
      replyItemEdited: null,
      replyIndex: -1,
      editedIndex: -1,
      showReplyCommentIndex: -1,
      labelReplay: 'Phản hồi của bạn',
    }
  },

  mounted() {
    if (this.$nuxt.$store.state.data) {
      this.isLogin = this.$nuxt.$store.state.data.id
      this.userInfo = this.$nuxt.$store.state.data
    } else {
      this.$nuxt.$on('auth', (auth) => {
        if (auth && auth.id) {
          this.isLogin = auth.id
          this.userInfo = { ...auth }
        }
      })
    }
    this.loadDataMovie()
    this.loadComment(true)
  },
  watch: {
    pageComments() {
      console.log(this.pageComments)
      this.offset = (this.pageComments - 1) * this.limit
      this.loadComment()
    },
  },
  methods: {
    toLink(type) {
      if (!this.isLogin) {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng đăng nhập để thực hiện chức năng'
        return
      }

      if (type === 'word') {
        this.$router.push({
          path: `/movies/word`,
          query: { code: this.movie.code },
        })
      }

      if (type === 'couplet') {
        this.$router.push({
          path: `/movies/couplet`,
          query: { code: this.movie.code },
        })
      }
    },
    loadDataMovie() {
      const queryMovie = gql(`query MyQuery {
          ${
            this.isLogin
              ? `movie_favourite(where: {user_id: {_eq: "${this.isLogin}"}, movie: {code: {_eq:  "${this.movieE}"}} }){
                id
                movie_id
                user_id
              }  `
              : ''
          }

          movies(where: { code: {_eq: "${this.movieE}"} }){
                      id
                      code
                      name
                      name_en
                      movie_status
                      movie_type
                      content
                      time
                      view
                      year_of_manufacture
                      total_episode
                      country_id
                      country {
                        id
                        code
                        name
                      }
                      movie_images {
                        id
                        type_image
                        url
                      }
                      movie_categories(where: {is_delete: {_eq: false}}){
                        id
                        movie_id
                        category_id
                        category {
                          id
                          code
                          name
                        }
                      }
                      movie_actors(where: {is_delete: {_eq: false}}){
                        id
                        movie_id
                        actor_id
                        actor {
                          id
                          code
                          name
                        }
                      }
                      movie_details(where: {is_delete: {_eq: false}}){
                        id
                        movie_id
                        episode
                        url_movie
                        url_sub_en
                        url_sub_vi
                      }
                      movie_logs(where: {date: {_eq: "${moment().format(
                        'YYYY-MM-DD'
                      )}"}}) {
                        id
                        count_view
                      }
              }
            }`)
      this.$apollo
        .query({
          query: queryMovie,
          fetchPolicy: 'network-only',
        })
        .then(async (response) => {
          if (
            response.data.movie_favourite &&
            response.data.movie_favourite.length > 0
          ) {
            this.movie_favourite = response.data.movie_favourite[0]
            if (this.movie_favourite.is_delete) {
              this.isLikeMovie = false
            } else {
              this.isLikeMovie = true
            }
          } else {
            this.isLikeMovie = false
          }
          if (response.data.movies.length > 0) {
            const element = response.data.movies[0]
            console.log(element)
            const movieItem = {}
            movieItem.id = element.id
            movieItem.code = element.code
            movieItem.ep = element.total_episode
            movieItem.type = element.movie_type
            movieItem.content = element.content
            movieItem.status = element.movie_status
            movieItem.view = element.view
            movieItem.name_en = element.name_en.toUpperCase()
            movieItem.name = element.name
            movieItem.link = '/movies/' + element.code
            movieItem.country = element.country
            movieItem.year_of_manufacture = element.year_of_manufacture
            movieItem.time = element.time
            movieItem.movie_details = element.movie_details
            movieItem.movie_logs = element.movie_logs
            for (
              let indexI = 0;
              indexI < element.movie_images.length;
              indexI++
            ) {
              const elementImage = element.movie_images[indexI]
              if (elementImage.type_image === 'image' && elementImage.url) {
                const images = this.$fire.storage.ref().child('movies/images/')
                const image = images.child(elementImage.url)
                await image.getDownloadURL().then((url) => {
                  movieItem.image = url
                })
              }
              // if (elementImage.type_image === 'banner' && elementImage.url) {
              //   const images = this.$fire.storage.ref().child('movies/banners/')
              //   const image = images.child(elementImage.url)
              //   await image.getDownloadURL().then((url) => {
              //     movieItem.banner = url
              //   })
              // }
            }
            if (element.movie_categories.length > 0) {
              const listCategories = []
              for (
                let index = 0;
                index < element.movie_categories.length;
                index++
              ) {
                const elementCategory = element.movie_categories[index]
                const itemPush = {}
                itemPush.id = elementCategory.category.id
                itemPush.code = elementCategory.category.code
                itemPush.name = elementCategory.category.name
                listCategories.push(itemPush)
              }
              movieItem.movie_categories = listCategories
            }
            if (element.movie_actors.length > 0) {
              const listActors = []
              for (
                let index = 0;
                index < element.movie_actors.length;
                index++
              ) {
                const elementActor = element.movie_actors[index]
                const itemPush = {}
                itemPush.id = elementActor.actor.id
                itemPush.code = elementActor.actor.code
                itemPush.name = elementActor.actor.name
                listActors.push(itemPush)
              }
              movieItem.movie_actors = listActors
            }
            this.movie = movieItem
          } else {
            //
          }
        })
        .catch((response) => console.log(response))
    },
    loadComment(isLoadFirst) {
      const queryComment = gql(`query MyQuery {
            comments_aggregate(where: {movie: {code: {_eq: "${this.movieE}"}} , is_delete: {_eq: false}}) {
              aggregate {
                count
              }
            }
            comments(where: { movie: {code: {_eq: "${this.movieE}"} }, is_delete: {_eq: false} }, limit:${this.limit} , offset: ${this.offset}, order_by: {created_at: desc}){
              id
              user_id
              user {
                id
                username
                image_user
              }
              user_reply {
                id
                username
                image_user
              }
              movie_id
              movie{
                id
                code
                name
              }
              comment
              user_like
              user_likes (where: {is_unlike: {_eq: false}})
              {
                id
                is_unlike
                user_like_id
              }
              parent_comment_id
              created_at
            }
          }`)

      this.$apollo
        .query({
          query: queryComment,
          fetchPolicy: 'network-only',
        })
        .then((response) => {
          if (
            response.data.comments_aggregate &&
            response.data.comments_aggregate &&
            response.data.comments_aggregate.aggregate.count &&
            response.data.comments_aggregate.aggregate.count > 0
          ) {
            this.totalComments =
              response.data.comments_aggregate.aggregate.count
            this.lengthPanigation = Math.ceil(
              response.data.comments_aggregate.aggregate.count / this.limit
            )
          }
          if (response.data.comments && response.data.comments.length > 0) {
            const tempData = response.data.comments
            const tempArray = []
            for (let index = 0; index < tempData.length; index++) {
              const element = tempData[index]
              const itemPush = {}
              itemPush.color =
                '#' + Math.floor(Math.random() * 16777215).toString(16)
              itemPush.id = element.id
              itemPush.timeComment = moment(element.created_at)
                .add('hours', 7)
                .fromNow()
              itemPush.user_reply = element.user_reply
              itemPush.parent_comment_id = element.parent_comment_id
              itemPush.user_like = element.user_like
              itemPush.comment = element.comment
              itemPush.isCommentUser = false
              itemPush.isLikeByUser = false
              itemPush.image_user = element.image_user
                ? element.image_user
                : require('~/static/icon.png')
              if (this.isLogin && this.isLogin === element.user_id) {
                itemPush.isCommentUser = true
                itemPush.color = 'error'
              }
              if (element.user_likes.length > 0 && this.isLogin) {
                for (
                  let indexL = 0;
                  indexL < element.user_likes.length;
                  indexL++
                ) {
                  const elementL = element.user_likes[indexL]
                  if (
                    elementL.user_like_id === this.isLogin &&
                    !element.is_unlike
                  ) {
                    itemPush.isLikeByUser = true
                    break
                  }
                }
              }

              itemPush.user = element.user
              itemPush.movie = element.movie
              tempArray.push(itemPush)
            }
            this.commentMovies = this.buildCommentTree(tempArray)
          } else {
            //
          }
        })
        .catch((response) => console.log(response))
    },
    addToFavouriteMovie() {
      if (this.isLogin) {
        // Bỏ thích
        if (this.isLikeMovie) {
          const updateGraphl = gql` mutation MyMutation {
            update_movie_favourite(
              where: { user_id: {_eq: "${this.isLogin}" }, movie_id: {_eq: ${this.movie.id}} }
              _set: {
                is_delete: true
              }
            ) {
              affected_rows
            }
          }`
          this.$apollo.mutate({
            mutation: updateGraphl,
            variables: {},
            // eslint-disable-next-line camelcase
            update: (store, { data: { update_movie_favourite } }) => {
              // eslint-disable-next-line camelcase
              if (update_movie_favourite.affected_rows) {
                this.textSnackbar = 'Bỏ yêu thích phim thành công'
                this.snackbar = true
                this.isLikeMovie = false
              } else {
                this.textSnackbar = 'Bỏ yêu thích phim thất bại'
                this.snackbar = true
              }
            },
          })
        } else {
          // Đã thêm vào database
          // eslint-disable-next-line no-lonely-if
          if (this.movie_favourite) {
            const updateGraphl = gql` mutation MyMutation {
            update_movie_favourite(
              where: { user_id: { _eq: "${this.isLogin}" }, movie_id: {_eq: "${this.movie.id}"} }
              _set: {
                is_delete: false
              }
            ) {
              affected_rows
            }
          }`
            this.$apollo.mutate({
              mutation: updateGraphl,
              variables: {},
              // eslint-disable-next-line camelcase
              update: (store, { data: { update_movie_favourite } }) => {
                // eslint-disable-next-line camelcase
                if (update_movie_favourite.affected_rows) {
                  this.textSnackbar = 'Yêu thích phim thành công'
                  this.snackbar = true
                  this.isLikeMovie = true
                } else {
                  this.textSnackbar = 'Yêu thích phim thất bại'
                  this.snackbar = true
                  this.isLikeMovie = false
                }
              },
            })
          }
          // Thêm mới
          else {
            const itemInsert = {}
            itemInsert.movie_id = this.movie.id
            itemInsert.user_id = this.isLogin
            const insertGraphl = gql`
              mutation MyMutation($objects: [movie_favourite_insert_input!]!) {
                insert_movie_favourite(objects: $objects) {
                  affected_rows
                  returning {
                    id
                  }
                }
              }
            `
            this.$apollo.mutate({
              mutation: insertGraphl,
              variables: { objects: itemInsert },
              // eslint-disable-next-line camelcase
              update: (store, { data: { insert_movie_favourite } }) => {
                // eslint-disable-next-line camelcase
                if (insert_movie_favourite.affected_rows) {
                  this.textSnackbar = 'Yêu thích phim thành công'
                  this.snackbar = true
                  this.isLikeMovie = true
                } else {
                  this.textSnackbar = 'Yêu thích phim thất bại'
                  this.snackbar = true
                  this.isLikeMovie = false
                }
              },
            })
          }
        }
        console.log(this.isLogin)
      } else {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng đăng nhập để thực hiện chức năng này'
      }
    },
    addCommentMovie() {
      if (this.isLogin) {
        const itemInsert = {}
        itemInsert.movie_id = this.movie.id
        itemInsert.user_id = this.isLogin
        itemInsert.comment = this.commentUserContent
        const insertGraphl = gql`
          mutation MyMutation($objects: [comments_insert_input!]!) {
            insert_comments(objects: $objects) {
              affected_rows
              returning {
                id
              }
            }
          }
        `
        this.$apollo.mutate({
          mutation: insertGraphl,
          variables: { objects: itemInsert },
          // eslint-disable-next-line camelcase
          update: (store, { data: { insert_comments } }) => {
            // eslint-disable-next-line camelcase
            if (insert_comments.affected_rows) {
              this.textSnackbar = 'Bình luận phim thành công'
              this.snackbar = true
              this.commentUserContent = ''

              if (this.pageComments !== 1) {
                this.pageComments = 1
              } else {
                this.loadComment()
              }
            } else {
              this.textSnackbar = 'Bình luận phim thất bại'
              this.snackbar = true
              this.isLikeMovie = false
            }
          },
        })
      } else {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng đăng nhập để thực hiện chức năng này'
      }
    },
    handleLikeComment(item, index) {
      if (this.isLogin) {
        const tempItem = item

        const itemInsert = {}
        itemInsert.comment_id = item.id
        itemInsert.user_like_id = this.isLogin
        if (item.isLikeByUser) {
          tempItem.user_like -= 1
          tempItem.isLikeByUser = false
          tempItem.is_unlike = false
          itemInsert.is_unlike = true
        } else {
          tempItem.user_like += 1
          tempItem.is_unlike = true
          tempItem.isLikeByUser = true
          itemInsert.is_unlike = false
        }
        const insertLikeComment = gql`mutation MyMutation(
            $objects: [comment_likes_insert_input!]!){
            update_comments (
              where: { id: {_eq: ${item.id}} }
              _set: {
                user_like: ${tempItem.user_like}
              }
            ) {
              affected_rows
            }
            insert_comment_likes(objects: $objects
                on_conflict: {
                    constraint: comment_likes_comment_id_user_like_id_key
                    update_columns: [
                        is_unlike
                    ]
                }
            ){
                affected_rows
                returning {
                    id
                }
            }
          }`
        this.$apollo.mutate({
          mutation: insertLikeComment,
          variables: {
            objects: itemInsert,
          },
          // eslint-disable-next-line camelcase
          update: (store, { data: { insert_comment_likes } }) => {
            // eslint-disable-next-line camelcase
            if (insert_comment_likes.affected_rows) {
              this.commentMovies[index] = tempItem
              this.textSnackbar = 'Thích/Bỏ thích bình luận thành công'
              this.snackbar = true
              this.isLikeMovie = false
            } else {
              this.textSnackbar = 'Thích/Bỏ thích bình luận thất bại'
              this.snackbar = true
            }
          },
        })
      } else {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng đăng nhập để thực hiện chức năng này'
      }
    },
    editComment(item) {
      this.commentItemEdited = structuredClone(item)
      this.dialogEditComment = true
      this.editedIndex = this.commentMovies.indexOf(item)
    },
    deleteComment(item) {
      this.commentItemEdited = item
      this.dialogDeleteComment = true
      this.editedIndex = this.commentMovies.indexOf(item)
    },
    closeDeleteComment() {
      this.commentItemEdited = null
      this.dialogDeleteComment = false
      this.editedIndex = -1
    },
    deleteCommentConfirm() {
      if (this.commentItemEdited && this.commentItemEdited.id) {
        const updateGraphl = gql` mutation MyMutation {
            update_comments(
              where: { id: { _eq: ${this.commentItemEdited.id} }}
              _set: {
                is_delete: true
              }
            ) {
              affected_rows
            }
          }`
        this.$apollo.mutate({
          mutation: updateGraphl,
          variables: {},
          // eslint-disable-next-line camelcase
          update: (store, { data: { update_comments } }) => {
            // eslint-disable-next-line camelcase
            if (update_comments.affected_rows) {
              this.textSnackbar = 'Xóa bình luận thành công'
              this.snackbar = true
              this.closeDeleteComment()
              if (this.pageComments === 1) {
                this.loadComment(false)
              } else {
                this.pageComments = 1
              }
            } else {
              this.textSnackbar = 'Xóa bình luận thất bại'
              this.snackbar = true
              this.closeDeleteComment()
            }
          },
        })
      } else {
        this.commentItemEdited = null
        this.dialogDeleteComment = false
      }
    },
    closeEditComment() {
      this.dialogEditComment = false
      this.commentItemEdited = null
      this.editedIndex = -1
    },
    editCommentConfirm() {
      if (this.commentItemEdited && this.commentItemEdited.id) {
        if (this.commentItemEdited.comment === '') {
          this.snackbar = true
          this.textSnackbar = 'Vui lòng nhập bình luận'
          return
        }
        const updateGraphl = gql` mutation MyMutation($comment: String) {
            update_comments(
              where: { id: { _eq: ${this.commentItemEdited.id} }}
              _set: {
                comment:  $comment
              }
            ) {
              affected_rows
            }
          }`
        this.$apollo.mutate({
          mutation: updateGraphl,
          variables: { comment: this.commentItemEdited.comment },
          // eslint-disable-next-line camelcase
          update: (store, { data: { update_comments } }) => {
            // eslint-disable-next-line camelcase
            if (update_comments.affected_rows) {
              this.commentMovies[this.editedIndex].comment =
                this.commentItemEdited.comment
              this.textSnackbar = 'Chỉnh sửa bình luận thành công'
              this.snackbar = true
              this.closeEditComment()
            } else {
              this.textSnackbar = 'Chỉnh sửa bình luận thất bại'
              this.snackbar = true
              this.closeEditComment()
            }
          },
        })
      } else {
        this.commentItemEdited = null
        this.dialogDeleteComment = false
      }
    },
    replyComment(item) {
      if (item.parent_comment_id) {
        const check = this.commentMovies.find(
          (e) => e.id === item.parent_comment_id
        )
        if (check) {
          this.replyIndex = check.children.indexOf(item)
          this.replyItemEdited = item
          this.labelReplay = 'Phản hồi của bạn đối với @' + item.user.username
        }
      } else {
        this.labelReplay = 'Phản hồi của bạn'
        this.replyIndex = this.commentMovies.indexOf(item)
        this.replyItemEdited = item
      }
    },
    addreplyComment() {
      if (this.isLogin) {
        const itemInsert = {}
        itemInsert.movie_id = this.movie.id
        itemInsert.user_id = this.isLogin
        itemInsert.comment = this.replyUserContent
        if (this.replyItemEdited && !this.replyItemEdited.parent_comment_id) {
          itemInsert.parent_comment_id = this.replyItemEdited.id
        }
        if (this.replyItemEdited && this.replyItemEdited.parent_comment_id) {
          itemInsert.parent_comment_id = this.replyItemEdited.parent_comment_id
          itemInsert.user_id_reply = this.replyItemEdited.user.id
        }
        const insertGraphl = gql`
          mutation MyMutation($objects: [comments_insert_input!]!) {
            insert_comments(objects: $objects) {
              affected_rows
              returning {
                id
              }
            }
          }
        `
        this.$apollo.mutate({
          mutation: insertGraphl,
          variables: { objects: itemInsert },
          // eslint-disable-next-line camelcase
          update: (store, { data: { insert_comments } }) => {
            // eslint-disable-next-line camelcase
            if (insert_comments.affected_rows) {
              this.textSnackbar = 'Phản hồi bình luận thành công'
              this.snackbar = true
              this.replyUserContent = ''
              this.cancelreplyComment()
              if (this.pageComments !== 1) {
                this.pageComments = 1
              } else {
                this.loadComment(false)
              }
            } else {
              this.textSnackbar = 'Phản hồi bình luận thất bại'
              this.snackbar = true
              this.isLikeMovie = false
            }
          },
        })
      } else {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng đăng nhập để thực hiện chức năng này'
      }
    },
    cancelreplyComment() {
      this.replyIndex = -1
      this.replyItemEdited = null
      this.labelReplay = 'Phản hồi của bạn'
    },
    showReplyComment(item) {
      if (this.showReplyCommentIndex !== -1) {
        this.showReplyCommentIndex = -1
      } else {
        this.showReplyCommentIndex = this.commentMovies.indexOf(item)
      }
    },
    buildCommentTree(comments, parentId = null) {
      const tree = []
      for (const comment of comments) {
        if (comment.parent_comment_id === parentId) {
          const children = this.buildCommentTree(comments, comment.id)
          if (children.length > 0) {
            comment.children = children
          }
          tree.push(comment)
        }
      }
      return tree
    },
    toLinkSearch(type, item) {
      if (type === 'country') {
        this.$router.push({ path: '/search', query: { country: item.code } })
      }
      if (type === 'category') {
        this.$router.push({ path: '/search', query: { category: item.code } })
      }
      if (type === 'actor') {
        this.$router.push({ path: `/actors`, query: { code: item.code } })
      }
    },
    toLinkWatch(item) {
      const itemSend = {}
      if (this.isLogin) {
        itemSend.user_id = this.isLogin
      }
      if (this.movie.movie_logs && this.movie.movie_logs.length > 0) {
        itemSend.count_view = this.movie.movie_logs[0].count_view
      }
      itemSend.movie_id = this.movie.id
      itemSend.date = moment().format('YYYY-MM-DD')
      itemSend.episode = item.episode
      axios.post(`${process.env.URL_SERVER}/api/update-movie-view-history`, {
        itemSend,
      })

      this.$router.push({
        path: `/movies/movie_detail/play`,
        query: { code: this.movie.code, ep: item.episode },
      })
    },
  },
  apollo: {},
}
</script>
