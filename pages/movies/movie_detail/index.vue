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
                <v-layout justify-center>
                  <v-btn class="mt-1 error">Xem trailer</v-btn>
                </v-layout>
                <v-card class="d-flex flex-column mt-4">
                  <v-btn class="mt-2 mb-2 error mx-auto"
                    ><v-icon>mdi-pencil-circle</v-icon>Cặp câu đã lưu trong
                    phim</v-btn
                  >
                  <v-img :src="require('~/static/learnQuotes.png')"> </v-img>
                  <v-btn class="mt-2 mb-2 error mx-auto"
                    ><v-icon>mdi-bookshelf</v-icon>Từ vựng đã lưu trong
                    phim</v-btn
                  >
                  <v-img :src="require('~/static/learnWord.png')"> </v-img>
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

                  <v-btn small class="error"
                    ><v-icon>mdi-heart</v-icon> Yêu thích</v-btn
                  >
                </v-card-text>
                <v-divider></v-divider>
                <v-card-text>
                  <h3>SỐ TẬP TRONG PHIM</h3>
                  <template v-for="item in movie.episodes">
                    <v-btn :href="item.link" small class="pa-2 mt-2 ml-2">
                      {{ item.ep }}
                    </v-btn>
                  </template>
                </v-card-text>
                <v-divider></v-divider>

                <v-tabs v-model="tabs" centered>
                  <v-tab>Giới thiệu phim</v-tab>
                  <v-tab
                    >Bình luận phim
                    {{ '(' + movie.comments.length + ')' }}</v-tab
                  >
                  <v-tab>Phim liên quan</v-tab>
                </v-tabs>

                <v-tabs-items v-model="tabs">
                  <v-tab-item>
                    <v-card flat>
                      <v-card-text>
                        <p class="text-justify font-weight-bold">
                          {{ movie.content }}
                        </p>
                        <p class="font-weight-bold text-justify">
                          <span>Đạo diễn:</span>
                          <a>{{ movie.director.fullname }}</a>
                        </p>
                        <p class="font-weight-bold text-justify">
                          <span>Diễn viên:</span>
                          <template v-for="item in movie.actors">
                            <a> {{ item.fullname }}</a> ,
                          </template>
                        </p>
                        <p class="font-weight-bold text-justify">
                          <span>Thời lượng:</span>
                          <span>{{ movie.time }}</span>
                        </p>
                        <p class="font-weight-bold text-justify">
                          <span>Quốc gia:</span>
                          <span>{{ movie.country.name }}</span>
                        </p>
                        <p class="font-weight-bold text-justify">
                          <span>Thể loại:</span>
                          <template v-for="item in movie.categories">
                            <a> {{ item.name }}</a> ,
                          </template>
                        </p>
                        <p class="font-weight-bold text-justify">
                          <span>Năm sản xuất:</span>
                          <span>{{ movie.year }}</span>
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
                        <v-btn class="error" small align-end>Bình luận</v-btn>
                      </v-layout>
                    </v-list>

                    <v-list three-line class="mt-n2">
                      <template v-for="(item, index) in commentMovies">
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
                            <v-list-item-title class="font-weight-bold">{{
                              item.userName
                            }}</v-list-item-title>
                            <v-list-item-subtitle>{{
                              item.comment
                            }}</v-list-item-subtitle>
                          </v-list-item-content>
                          <v-list-item-action>
                            <v-list-item-action-text class="mx-auto"
                              >16</v-list-item-action-text
                            >
                            <v-btn icon> <v-icon>mdi-thumb-up</v-icon></v-btn>
                          </v-list-item-action>
                        </v-list-item>
                      </template>
                    </v-list>
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
                                <v-icon small left> mdi-account </v-icon>
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
      tabs: null,
      title: '',
      movie: {
        id: null,
        code: null,
        name: 'Những người bạn mùa 1',
        name_en: 'FRIENDS SEASON 1',
        year: 1994,
        time: '24 phút',
        image: require('~/static/friend-1.jpg'),
        content: `Phim Friends là bộ phim hài rất nổi tiếng ở Mỹ gồm 10
                          seasons được dùng trong hầu hết các trung tâm dạy
                          tiếng anh ở nước Mỹ như là một công cụ trong việc nâng
                          cao về việc luyện nghe nói, phản xạ trong việc học
                          tiếng anh dành cho sinh viên nước ngoài. Một điều quan
                          trọng chính là bộ phim friends phụ đề tiếng anh đã
                          mang lại cho khán giả các nước khác một cái nhìn cực
                          kì chính xác, chân thật về xã hội Mỹ, về phong cách
                          sống, cách xử sự của người Mỹ. Chính vì điều này
                          website WMOVIES đã biên soạn hơn 10 season phim
                          friends phụ đề song ngữ anh việt giúp cho việc học
                          tiếng anh hiệu quả. Hãy cùng trải nghiệm việc học
                          tiếng anh qua phim friends với WMOVIES ngay nhé.`,
        series: {
          id: null,
          name: 'FRIEND',
        },
        director: {
          id: null,
          fullname: 'David Crane',
        },
        comments: [
          {
            id: null,
            movie_id: null,
            user_id: null,
            user: {
              id: null,
              fullname: 'Hoàng đẹp trai',
            },
            like_count: 15,
            users_like: [
              {
                id: null,
                fullname: null,
              },
            ],
          },
          {
            id: null,
            movie_id: null,
            user_id: null,
            user: {
              id: null,
              fullname: 'Hoàng đẹp trai',
            },
            like_count: 15,
            users_like: [
              {
                id: null,
                fullname: null,
              },
            ],
          },
          {
            id: null,
            movie_id: null,
            user_id: null,
            user: {
              id: null,
              fullname: 'Hoàng đẹp trai',
            },
            like_count: 15,
            users_like: [
              {
                id: null,
                fullname: null,
              },
            ],
          },
          {
            id: null,
            movie_id: null,
            user_id: null,
            user: {
              id: null,
              fullname: 'Hoàng đẹp trai',
            },
            like_count: 15,
            users_like: [
              {
                id: null,
                fullname: null,
              },
            ],
          },
          {
            id: null,
            movie_id: null,
            user_id: null,
            user: {
              id: null,
              fullname: 'Hoàng đẹp trai',
            },
            like_count: 15,
            users_like: [
              {
                id: null,
                fullname: null,
              },
            ],
          },
        ],
        country: {
          id: null,
          name: 'United States',
        },
        actors: [
          {
            id: null,
            fullname: 'Jennifer Aniston',
          },
          {
            id: null,
            fullname: ' Courteney Cox',
          },
          {
            id: null,
            fullname: 'Lisa Kudrow',
          },
        ],
        categories: [
          {
            id: null,
            code: 'comic',
            name: 'Hài hước',
          },
          {
            id: null,
            code: 'romantic',
            name: 'Tình cảm',
          },
        ],
        episodes: [
          {
            id: null,
            ep: 1,
            linkDirect: '',
            link: '/movies/friend-season-1/play?episode=1',
            subtitles: [
              {
                id: null,
                type: 'VN',
                name: 'Vietnamese',
                sub_details: [
                  {
                    id: null,
                    start: '',
                    end: '',
                    content: '',
                  },
                ],
              },
              {
                id: null,
                type: 'EN',
                name: 'English',
                sub_details: [
                  {
                    id: null,
                    start: '',
                    end: '',
                    content: '',
                  },
                ],
              },
              {
                id: null,
                type: 'EN-VN',
                name: 'English-Vietnamese',
                sub_details: [
                  {
                    id: null,
                    start: '',
                    end: '',
                    content: '',
                  },
                ],
              },
              {
                id: null,
                type: 'VN-EN',
                name: 'Vietnamese-English',
                sub_details: [
                  {
                    id: null,
                    start: '',
                    end: '',
                    content: '',
                  },
                ],
              },
            ],
          },
          {
            id: null,
            ep: 2,
            linkDirect: '',
            link: '/movies/friend-season-1/play?episode=2',
            subtitles: [
              {
                id: null,
                type: 'VN',
                name: 'Vietnamese',
                sub_details: [
                  {
                    id: null,
                    start: '',
                    end: '',
                    content: '',
                  },
                ],
              },
              {
                id: null,
                type: 'EN',
                name: 'English',
                sub_details: [
                  {
                    id: null,
                    start: '',
                    end: '',
                    content: '',
                  },
                ],
              },
              {
                id: null,
                type: 'EN-VN',
                name: 'English-Vietnamese',
                sub_details: [
                  {
                    id: null,
                    start: '',
                    end: '',
                    content: '',
                  },
                ],
              },
              {
                id: null,
                type: 'VN-EN',
                name: 'Vietnamese-English',
                sub_details: [
                  {
                    id: null,
                    start: '',
                    end: '',
                    content: '',
                  },
                ],
              },
            ],
          },
          {
            id: null,
            ep: 3,
            linkDirect: '',
            link: '/movies/friend-season-1/play?episode=3',
          },
          {
            id: null,
            ep: 4,
            linkDirect: '',
            link: '/movies/friend-season-1/play?episode=4',
          },
          {
            id: null,
            ep: 5,
            linkDirect: '',
            link: '/movies/friend-season-1/play?episode=5',
          },
          {
            id: null,
            ep: 6,
            linkDirect: '',
            link: '/movies/friend-season-1/play?episode=6',
          },
          {
            id: null,
            ep: 7,
            linkDirect: '',
            link: '/movies/friend-season-1/play?episode=7',
          },
          {
            id: null,
            ep: 8,
            linkDirect: '',
            link: '/movies/friend-season-1/play?episode=8',
          },
          {
            id: null,
            ep: 9,
            linkDirect: '',
            link: '/movies/friend-season-1/play?ep=1',
          },
        ],
      },
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
      hotMoviesItems: [
        {
          ep: '24',
          type: 'series',
          view: 15000,
          status: 'HOT',
          image: require('~/static/friend-1.jpg'),
          subtitle: 'Những người bạn mùa 1',
          title: 'FRIENDS SEASON 1',
          link: '/movies/friend-season-1',
        },
        {
          ep: '28',
          type: 'series',
          view: 75412,
          status: 'HOT',
          image: require('~/static/friend-2.jpg'),
          subtitle: 'Những người bạn mùa 2',
          title: 'FRIENDS SEASON 2',
          link: '/movies/friend-season-2',
        },
        {
          ep: '30',
          type: 'series',
          view: 12154,
          status: 'HOT',
          image: require('~/static/friend-3.jpg'),
          subtitle: 'Những người bạn mùa 3',
          title: 'FRIENDS SEASON 3',
          link: '/movies/friend-season-3',
        },
        {
          ep: '24',
          type: 'series',
          view: 21200,
          status: 'HOT',
          image: require('~/static/friend-4.jpg'),
          subtitle: 'Những người bạn mùa 4',
          title: 'FRIENDS SEASON 4',
          link: '/movies/friend-season-4',
        },
        {
          ep: '19',
          type: 'series',
          view: 65187,
          status: 'HOT',
          image: require('~/static/friend-5.jpg'),
          subtitle: 'Những người bạn mùa 5',
          title: 'FRIENDS SEASON 5',
          link: '/movies/friend-season-5',
        },
        {
          ep: '20',
          type: 'series',
          view: 26510,
          status: 'HOT',
          image: require('~/static/friend-6.jpg'),
          subtitle: 'Những người bạn mùa 6',
          title: 'FRIENDS SEASON 6',
          link: '/movies/friend-season-6',
        },
        {
          ep: '26',
          type: 'series',
          view: 1000,
          status: 'NEW',
          image: require('~/static/friend-7.jpg'),
          subtitle: 'Những người bạn mùa 7',
          title: 'FRIENDS SEASON 7',
          link: '/movies/friend-season-7',
        },
        {
          ep: '24',
          type: 'series',
          view: 500,
          status: 'NEW',
          image: require('~/static/friend-8.jpg'),
          subtitle: 'Những người bạn mùa 8',
          title: 'FRIENDS SEASON 8',
          link: '/movies/friend-season-8',
        },
      ],
      commentMovies: [
        {
          action: '',
          image: require('~/static/WMovies1.png'),
          comment: 'Phim hay quá',
          userName: 'Hoàng đẹp trai',
        },
        { divider: true, inset: true },
        {
          action: '',
          image: require('~/static/WMovies2.png'),
          comment: 'Rất bổ ích !!',
          userName: 'Táo thiện xạ',
        },
        { divider: true, inset: true },
        {
          action: '',
          image: require('~/static/WMovies1.png'),
          comment: 'Phim hay quá :))))',
          userName: 'Monkey D Luffy',
        },
        { divider: true, inset: true },
        {
          action: '',
          image: require('~/static/WMovies2.png'),
          comment: 'Quá là sến luôn',
          userName: 'Quýt chiến sĩ',
        },
        { divider: true, inset: true },
        {
          action: '',
          image: require('~/static/WMovies1.png'),
          comment: 'Giao lưu',
          userName: 'Hellu',
        },
      ],
    }
  },
}
</script>
