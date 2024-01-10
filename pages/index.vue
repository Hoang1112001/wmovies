<!-- eslint-disable vue/require-v-for-key -->
<!-- eslint-disable vue/no-v-for-template-key -->
<!-- eslint-disable vue/valid-v-for -->
<!-- eslint-disable vue/no-v-text-v-html-on-component -->
<!-- eslint-disable vue/no-multiple-template-root -->
<template>
  <v-app class="red-lighten-1">
    <!-- Snackbar  -->
    <v-snackbar v-model="snackbar">
      {{ textSnackbar }}

      <template v-slot:action="{ attrs }">
        <v-btn color="pink" text v-bind="attrs" @click="snackbar = false">
          Close
        </v-btn>
      </template>
    </v-snackbar>
    <!-- <v-dialog v-model="loadingMovie" hide-overlay persistent width="500">
      <v-card color="error" dark>
        <v-card-text>
          {{ loadingText }}
          <v-progress-linear
            indeterminate
            color="white"
            class="mb-0"
          ></v-progress-linear>
        </v-card-text>
      </v-card>
    </v-dialog> -->
    <v-overlay :value="loadingMovie">
      <v-layout class="d-flex flex-column" justify-center align-center>
        <v-progress-circular indeterminate size="64"></v-progress-circular>
        <span class="h4"> {{ loadingText }}</span>
      </v-layout>
    </v-overlay>
    <!-- Dialog Recommend -->
    <v-dialog
      v-model="dialogRecommend"
      transition="dialog-bottom-transition"
      max-width="600"
    >
      <v-card>
        <v-card-title
          ><v-img
            class="mx-auto"
            max-height="70"
            max-width="70"
            :src="require('~/static/icon.png')"
          ></v-img
        ></v-card-title>
        <v-card-text>
          <h2 class="text-h6 mb-2">Hãy chọn thể loại phim bạn yêu thích:</h2>

          <v-chip-group
            v-model="categoryRecommend"
            column
            multiple
            active-class="error--text"
          >
            <v-chip filter outlined v-for="category in categoryLists">
              {{ category.name }}</v-chip
            >
            <!-- <v-chip filter outlined> Hài hước </v-chip>
            <v-chip filter outlined> Phiêu lưu </v-chip>
            <v-chip filter outlined> Hành động </v-chip>
            <v-chip filter outlined> Tình cảm </v-chip>
            <v-chip filter outlined> Hoạt hình </v-chip>
            <v-chip filter outlined> Tâm lý </v-chip> -->
          </v-chip-group>
        </v-card-text>

        <v-card-text>
          <h2 class="text-h6 mb-2">Bạn thích xem phim nhiều tập hay không ?</h2>

          <v-chip-group
            v-model="isLikeWatchMovieSeries"
            column
            active-class="error--text"
          >
            <v-chip filter outlined> Có </v-chip>
            <v-chip filter outlined> Không </v-chip>
          </v-chip-group>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="success"
            :disabled="loadingMovie"
            :loading="loadingMovie"
            @click="sendRecommend"
            text
            >Đồng ý</v-btn
          >
          <v-btn color="error" text @click="dialogRecommend = false"
            >Thoát</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>
    <!-- Dialog Feedback -->
    <v-dialog
      v-model="dialogFeedback"
      transition="dialog-bottom-transition"
      max-width="600"
    >
      <v-card>
        <v-card-title
          ><v-img
            class="mx-auto"
            max-height="70"
            max-width="70"
            :src="require('~/static/icon.png')"
          ></v-img
        ></v-card-title>
        <v-card-text>
          <h2 class="text-h6 mb-2">
            Bạn cảm thấy chất lượng phim như thế nào ?
          </h2>

          <v-chip-group
            v-model="qualityMovies"
            column
            active-class="error--text"
          >
            <v-chip filter outlined> Tốt </v-chip>
            <v-chip filter outlined> Trung bình </v-chip>
            <v-chip filter outlined> Kém </v-chip>
          </v-chip-group>
        </v-card-text>

        <v-card-text>
          <h2 class="text-h6 mb-2">
            Bạn có cải thiện khả năng học Tiếng Anh ?
          </h2>

          <v-chip-group
            v-model="isImproveEnglish"
            column
            active-class="error--text"
          >
            <v-chip filter outlined> Có </v-chip>
            <v-chip filter outlined> Không </v-chip>
          </v-chip-group>
        </v-card-text>
        <v-card-text>
          <h2 class="text-h6 mb-2">Đề xuất và đóng góp ý kiến của bạn:</h2>
          <v-textarea
            outlined
            dense
            grow="2"
            auto-grow
            label="Đề xuất của bạn"
            v-model="textFeedback"
          ></v-textarea>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="success"
            :disabled="loadingMovie"
            :loading="loadingMovie"
            @click="sendFeedback"
            text
            >Gửi</v-btn
          >
          <v-btn color="error" text @click="dialogFeedback = false"
            >Thoát</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>
    <!-- Slide -->
    <v-card elevation="24" width="100%" class="grey lighten-3">
      <v-carousel
        :continuous="true"
        :cycle="cycle"
        show-arrows-on-hover
        hide-delimiter-background
        delimiter-icon="mdi-minus"
        height="400"
      >
        <v-carousel-item
          v-for="(item, i) in newMoviesItems"
          :key="i"
          :src="item.banner"
        >
          <v-card
            outlined
            style="margin-top: 60px"
            class="mx-auto lighten-3 card_opacity ml-15"
            max-width="500"
            elevation="5"
          >
            <v-card-text class="card-text">
              <a> {{ item.subtitle.toUpperCase() }}</a>

              <p>{{ item.title }}</p>

              <div class="font-weight-bold white--text">
                Nội dung: Trong những năm 90, một phe mới của Transformers -
                Maximals - tham gia cùng Autobots với tư cách là đồng minh trong
                cuộc chiến vì Trái đất.
              </div>
            </v-card-text>
            <v-card-actions>
              <v-btn text color="orange" :to="item.link"> Xem ngay </v-btn>
            </v-card-actions>
          </v-card>
        </v-carousel-item>
      </v-carousel>
    </v-card>
    <!-- Introduce -->
    <v-card
      elevation="24"
      width="95%"
      style="margin: 40px auto"
      class="grey lighten-3"
    >
      <v-row>
        <v-col cols="12" sm="4" lg="4" xl="4" md="4">
          <v-card-title class="card-text"
            ><a>Luyện nói Tiếng Anh thông minh</a></v-card-title
          >
          <v-card-text class="font-weight-bold black--text text-justify"
            >Thực hành luyện nói tiếng anh mỗi ngày thông qua phụ đề song ngữ
            thông minh. Giúp trau dồi được khả năng phát âm tiếng anh qua việc
            xem phim có engsub, ngữ điệu cùng phản xạ nói cực kỳ nhanh
            chóng.</v-card-text
          >
        </v-col>
        <v-col cols="12" sm="4" lg="4" xl="4" md="4">
          <v-card-title class="card-text"
            ><a>Chế độ luyện nghe hiệu quả</a></v-card-title
          >
          <v-card-text class="font-weight-bold black--text text-justify"
            >Cung cấp chế độ luyện nghe tiếng anh qua phim riêng biệt cho người
            học, nâng cao khả năng nghe cực kỳ hiệu quả mà chưa có phương pháp
            luyện nghe tiếng anh nào làm được.</v-card-text
          >
        </v-col>
        <v-col cols="12" sm="4" lg="4" xl="4" md="4">
          <v-card-title class="card-text">
            <a>Nâng cao vốn từ vựng tiếng anh</a></v-card-title
          >
          <v-card-text class="font-weight-bold black--text text-justify"
            >Gia tăng vốn từ tiếng anh của bạn với vô số từ mới dùng trong giao
            tiếp thông qua việc xem phim phụ đề tiếng anh. Phụ đề tiếng anh song
            ngữ Anh-Việt giúp việc học và ghi chép từ vựng tiếng anh chưa bao
            giờ dễ dàng hơn.</v-card-text
          >
        </v-col>
      </v-row>
    </v-card>
    <!-- Main -->
    <v-card
      elevation="24"
      width="95%"
      style="margin: 10px auto"
      class="grey lighten-3"
    >
      <v-row>
        <!-- Left Component -->
        <v-col cols="12" sm="12" lg="8" xl="8" md="8" class="mt-5 mb-5">
          <v-row class="ml-2" v-if="isShowRecommend">
            <v-col cols="12" sm="12" lg="12" xl="12" md="12" class="card-text">
              <a>GỢI Ý PHIM ({{ totalRecommended }})</a>
            </v-col>
          </v-row>
          <v-row class="ml-2" v-if="isShowRecommend">
            <v-col
              v-for="(file, i) in recommendMovieList"
              :key="i"
              cols="12"
              sm="6"
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
                    <div class="image-container" v-bind="attrs" v-on="on">
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
                              file.title + ' (' + file.year_of_manufacture + ')'
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
                            <template v-for="movie_actor in file.movie_actors">
                              <a
                                @click="toLinkSearch('actor', movie_actor)"
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
                                  toLinkSearch('category', movie_category)
                                "
                                style="text-decoration: none"
                                >{{ movie_category.category.name + ' ' }},
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
                            <a @click="toLinkSearch('country', file.country)"
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
                            file.title + ' (' + file.year_of_manufacture + ')'
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
            <v-col
              v-if="loadingRecommended"
              cols="12"
              sm="6"
              lg="3"
              xl="3"
              md="3"
            >
              <v-skeleton-loader
                class="mx-auto"
                max-width="400"
                type="card"
              ></v-skeleton-loader>
            </v-col>
            <v-row justify="center">
              <v-layout
                v-if="
                  totalRecommended > 1 &&
                  offsetRecommended + limit < totalRecommended
                "
                cols="12"
                sm="12"
                lg="12"
                xl="12"
                md="12"
                justify-center
                class="mt-5"
              >
                <!-- <v-container> -->

                <v-btn
                  v-if="!loadingRecommended"
                  @click="loadMoreRecommendededMovie"
                  color="error"
                  class="mb-5"
                  >Load More</v-btn
                >
                <!-- <v-pagination
                    v-model="page"
                    class="my-4"
                    :length="15"
                    navigation-color="error"
                    color="error"
                  ></v-pagination> -->
                <!-- </v-container> -->
              </v-layout>
            </v-row>
          </v-row>
          <!-- New Movies -->
          <v-row class="ml-2">
            <v-col cols="12" sm="12" lg="12" xl="12" md="12" class="card-text">
              <a @click="toLinkSearch('status', 'latest')"
                >DANH MỤC PHIM MỚI CẬP NHẬT ({{ totalLatest }})</a
              >
            </v-col>
          </v-row>
          <v-row class="ml-2">
            <v-col
              v-for="(file, i) in newMoviesItems"
              :key="i"
              cols="12"
              sm="6"
              lg="3"
              xl="3"
              md="3"
            >
              <v-card
                class="mx-auto"
                max-width="400"
                :color="i % 2 === 0 ? '#FFEBEE' : ''"
              >
                <v-menu
                  open-on-hover
                  open-delay="1000"
                  :close-on-content-click="false"
                  :nudge-width="200"
                  offset-x
                >
                  <template v-slot:activator="{ on, attrs }">
                    <div class="image-container" v-bind="attrs" v-on="on">
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
                              file.title + ' (' + file.year_of_manufacture + ')'
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
                            <template v-for="movie_actor in file.movie_actors">
                              <a
                                @click="toLinkSearch('actor', movie_actor)"
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
                                  toLinkSearch('category', movie_category)
                                "
                                style="text-decoration: none"
                                >{{ movie_category.category.name + ' ' }},
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
                            <a @click="toLinkSearch('country', file.country)"
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
                            file.title + ' (' + file.year_of_manufacture + ')'
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
            <v-col v-if="loadingLatest" cols="12" sm="6" lg="3" xl="3" md="3">
              <v-skeleton-loader
                class="mx-auto"
                max-width="400"
                type="card"
              ></v-skeleton-loader>
            </v-col>
            <v-row justify="center">
              <v-layout
                v-if="totalLatest > 1 && offsetLatest + limit < totalLatest"
                cols="12"
                sm="12"
                lg="12"
                xl="12"
                md="12"
                justify-center
                class="mt-5"
              >
                <!-- <v-container> -->

                <v-btn
                  v-if="!loadingLatest"
                  @click="loadMoreLatestMovie"
                  color="error"
                  class="mb-5"
                  >Load More</v-btn
                >
                <!-- <v-pagination
                    v-model="page"
                    class="my-4"
                    :length="15"
                    navigation-color="error"
                    color="error"
                  ></v-pagination> -->
                <!-- </v-container> -->
              </v-layout>
            </v-row>
          </v-row>
          <!-- Hot Movies -->
          <v-row class="ml-2">
            <v-col
              cols="12"
              sm="12"
              lg="12"
              xl="12"
              md="12"
              class="card-text mt-5"
            >
              <a @click="toLinkSearch('status', 'recommended')"
                >DANH MỤC PHIM NỔI BẬT ({{ totalRecommend }})</a
              >
            </v-col>
          </v-row>
          <v-row class="ml-2">
            <v-col cols="12" sm="12" lg="12" xl="12" md="12">
              <v-row>
                <v-col
                  v-for="(file, i) in hotMoviesItems"
                  :key="i"
                  cols="12"
                  sm="6"
                  lg="3"
                  xl="3"
                  md="3"
                >
                  <v-card
                    class="mx-auto"
                    max-width="400"
                    :color="i % 2 === 0 ? 'white' : '#FFEBEE'"
                  >
                    <v-menu
                      open-on-hover
                      open-delay="1000"
                      :close-on-content-click="false"
                      :nudge-width="200"
                      offset-x
                    >
                      <template v-slot:activator="{ on, attrs }">
                        <div class="image-container" v-bind="attrs" v-on="on">
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
                                    @click="toLinkSearch('actor', movie_actor)"
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
                                      toLinkSearch('category', movie_category)
                                    "
                                    style="text-decoration: none"
                                    >{{ movie_category.category.name + ' ' }},
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
                                  @click="toLinkSearch('country', file.country)"
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
                <v-col
                  v-if="loadingRecommend"
                  cols="12"
                  sm="6"
                  lg="3"
                  xl="3"
                  md="3"
                >
                  <v-skeleton-loader
                    class="mx-auto"
                    max-width="400"
                    type="card"
                  ></v-skeleton-loader>
                </v-col>
                <v-row justify="center">
                  <v-layout
                    v-if="
                      totalRecommend > 0 &&
                      offsetRecommend + limit < totalRecommend
                    "
                    cols="12"
                    sm="12"
                    lg="12"
                    xl="12"
                    md="12"
                    justify-center
                    class="mt-5"
                  >
                    <!-- <v-container> -->
                    <v-btn
                      v-if="!loadingRecommend"
                      @click="loadMoreRecommendedMovie"
                      color="error"
                      class="mb-5"
                      >Load More</v-btn
                    >
                    <!-- <v-pagination
                    v-model="page"
                    class="my-4"
                    :length="15"
                    navigation-color="error"
                    color="error"
                  ></v-pagination> -->
                    <!-- </v-container> -->
                  </v-layout>
                </v-row>
                <!-- <v-row justify="center">
                  <v-col cols="12">
                    <v-container class="max-width">
                      <v-pagination
                        v-model="page"
                        class="my-4"
                        :length="15"
                        navigation-color="error"
                        color="error"
                      ></v-pagination>
                    </v-container>
                  </v-col>
                </v-row> -->
              </v-row>
            </v-col>
          </v-row>
        </v-col>
        <!-- Right Component -->
        <v-col cols="12" lg="4" xl="4" md="4" class="mt-7 mb-5">
          <!-- Top Views Movies -->
          <v-row class="mr-2">
            <v-col cols="12" sm="12" lg="12" xl="12" md="12">
              <v-card max-width="450" class="mx-auto">
                <v-toolbar color="error" dark>
                  <v-row class="d-flex justify-space-between ml-2 mt-2">
                    <v-toolbar-title class="font-weight-bold"
                      >PHIM LẺ XEM NHIỀU
                    </v-toolbar-title>
                    <v-img
                      class="mt-n2"
                      max-height="68"
                      max-width="85"
                      :src="require('~/static/logo.png')"
                    ></v-img>
                  </v-row>

                  <template v-slot:extension>
                    <v-tabs v-model="tabsViewMovie" centered>
                      <v-tab v-if="listViewMovies.length > 0" key="daily">
                        Ngày
                      </v-tab>
                      <v-tab v-if="listViewMoviesWeek.length > 0" key="week">
                        Tuần
                      </v-tab>
                      <v-tab v-if="listViewMoviesMonth.length > 0" key="month">
                        Tháng
                      </v-tab>
                    </v-tabs>
                  </template>
                </v-toolbar>
                <v-tabs-items v-model="tabsViewMovie">
                  <v-tab-item>
                    <v-list three-line>
                      <template v-for="item in listViewMovies">
                        <v-list-item :href="item.link">
                          <a class="d-flex">
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
                          </a>
                        </v-list-item>
                        <v-divider></v-divider>
                      </template>
                    </v-list>
                  </v-tab-item>
                  <v-tab-item>
                    <v-list three-line>
                      <template v-for="item in listViewMoviesWeek">
                        <v-list-item :href="item.link">
                          <a class="d-flex">
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
                          </a>
                        </v-list-item>
                        <v-divider></v-divider>
                      </template>
                    </v-list>
                  </v-tab-item>
                  <v-tab-item>
                    <v-list three-line>
                      <template v-for="item in listViewMoviesMonth">
                        <v-list-item :href="item.link">
                          <a class="d-flex">
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
                          </a>
                        </v-list-item>
                        <v-divider></v-divider>
                      </template>
                    </v-list>
                  </v-tab-item>
                </v-tabs-items>
              </v-card>
            </v-col>
          </v-row>
          <!-- Recommend Movies -->
          <v-row class="mr-2 d-flex">
            <v-img
              max-height="200"
              max-width="200"
              :src="require('~/static/WMovies2.png')"
            ></v-img>
            <v-card
              ripple
              @click="openDialogRecommend"
              max-height="130"
              max-width="200"
            >
              <v-card-text class="typing-demo"
                >Bạn đã tìm được phim xem chưa ? Tôi có thể giúp bạn không
                ?</v-card-text
              >

              <!-- <v-card-actions>
                <v-btn
                  class="mx-auto"
                  color="error"
                  @click="openDialogRecommend"
                >
                  Gợi ý
                </v-btn>
              </v-card-actions> -->
            </v-card>
          </v-row>
          <!-- Top Views Movie Serires -->
          <v-row class="mr-2">
            <v-col cols="12" sm="12" lg="12" xl="12" md="12">
              <v-card max-width="450" class="mx-auto">
                <v-toolbar color="error" dark>
                  <v-row class="d-flex justify-space-between ml-2 mt-2">
                    <v-toolbar-title class="font-weight-bold"
                      >PHIM BỘ XEM NHIỀU
                    </v-toolbar-title>
                    <v-img
                      class="mt-n2"
                      max-height="68"
                      max-width="85"
                      :src="require('~/static/logo.png')"
                    ></v-img>
                  </v-row>

                  <template v-slot:extension>
                    <v-tabs v-model="tabsViewMovieSeries" centered>
                      <v-tab v-if="listViewMoviesSeries.length > 0" key="daily">
                        Ngày
                      </v-tab>
                      <v-tab
                        v-if="listViewMoviesSeriesWeek.length > 0"
                        key="week"
                      >
                        Tuần
                      </v-tab>
                      <v-tab
                        v-if="listViewMoviesSeriesMonth.length > 0"
                        key="month"
                      >
                        Tháng
                      </v-tab>
                    </v-tabs>
                  </template>
                </v-toolbar>
                <v-tabs-items v-model="tabsViewMovieSeries">
                  <v-tab-item>
                    <v-list three-line>
                      <template v-for="item in listViewMoviesSeries">
                        <v-list-item :href="item.link">
                          <a class="d-flex">
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
                          </a>
                        </v-list-item>
                        <v-divider></v-divider>
                      </template>
                    </v-list>
                  </v-tab-item>
                  <v-tab-item>
                    <v-list three-line>
                      <template v-for="item in listViewMoviesSeriesWeek">
                        <v-list-item :href="item.link">
                          <a class="d-flex">
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
                          </a>
                        </v-list-item>
                        <v-divider></v-divider>
                      </template>
                    </v-list>
                  </v-tab-item>
                  <v-tab-item>
                    <v-list three-line>
                      <template v-for="item in listViewMoviesSeriesMonth">
                        <v-list-item :href="item.link">
                          <a class="d-flex">
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
                          </a>
                        </v-list-item>
                        <v-divider></v-divider>
                      </template>
                    </v-list>
                  </v-tab-item>
                </v-tabs-items>
              </v-card>
            </v-col>
          </v-row>
          <!-- Feedback  -->
          <v-row class="mr-2 d-flex">
            <v-img
              max-height="200"
              max-width="200"
              :src="require('~/static/WMovies1.png')"
            ></v-img>
            <v-card
              ripple
              @click="openDialogFeedback"
              max-height="130"
              max-width="200"
            >
              <v-card-text class="typing-demo"
                >Hãy cho tôi cảm nhận của bạn về trang web</v-card-text
              >

              <!-- <v-card-actions>
                <v-btn
                  class="mx-auto"
                  color="error"
                  @click="openDialogFeedback"
                >
                  Đánh giá
                </v-btn>
              </v-card-actions> -->
            </v-card>
          </v-row>
        </v-col>
      </v-row>
    </v-card>
  </v-app>
</template>

<script>
import gql from 'graphql-tag'
import moment from 'moment'
import axios from 'axios'
export default {
  layout: 'default',
  name: 'IndexPage',
  data() {
    return {
      isLogin: false,
      loadingText: 'Đang cập nhật dữ liệu, bạn chờ tí nhé ...',
      snackbar: false,
      textSnackbar: '',
      dialogRecommend: false,
      loadingMovie: false,
      dialogFeedback: false,
      page: 1,
      cycle: true,
      limit: 4,
      totalLatest: 0,
      totalRecommend: 0,
      totalRecommended: 0,
      offsetLatest: 0,
      offsetRecommend: 0,
      offsetRecommended: 0,
      tabsViewMovie: null,
      tabsViewMovieSeries: null,
      slideItems: [
        {
          src: 'https://cdn.vuetifyjs.com/images/carousel/squirrel.jpg',
        },
        {
          src: 'https://cdn.vuetifyjs.com/images/carousel/sky.jpg',
        },
        {
          src: 'https://cdn.vuetifyjs.com/images/carousel/bird.jpg',
        },
        {
          src: 'https://cdn.vuetifyjs.com/images/carousel/planet.jpg',
        },
        {
          src: 'https://cdn.vuetifyjs.com/images/carousel/planet.jpg',
        },
        {
          src: 'https://cdn.vuetifyjs.com/images/carousel/planet.jpg',
        },
        {
          src: 'https://cdn.vuetifyjs.com/images/carousel/planet.jpg',
        },
        {
          src: 'https://cdn.vuetifyjs.com/images/carousel/planet.jpg',
        },
      ],
      hotMoviesItems: [],
      newMoviesItems: [],
      recommendMovieList: [],
      listViewMovies: [],
      listViewMoviesWeek: [],
      listViewMoviesMonth: [],
      listViewMoviesSeries: [],
      listViewMoviesSeriesWeek: [],
      listViewMoviesSeriesMonth: [],
      categoryLists: [],
      categoryRecommend: [1, 4],
      isLikeWatchMovieSeries: null,
      isImproveEnglish: null,
      qualityMovies: null,
      textFeedback: null,
      loadingLatest: false,
      loadingRecommend: false,
      loadingRecommended: false,
      isShowRecommend: false,
      tempStringSearch: null,
    }
  },
  mounted() {
    // this.$nuxt.$on('auth', (auth) => {
    //   this.isLogin = auth
    // })
    if (localStorage.getItem('user_id')) {
      this.isLogin = localStorage.getItem('user_id')
    }
    this.loadDataMovieLatest()
    this.loadDataMovieRecommend()
    this.loadMovieTable()
  },
  watch: {},
  methods: {
    async loadMovieTable() {
      try {
        const dayNow = moment().format('YYYY-MM-DD')

        const firstDayWeek = moment(dayNow)
          .startOf('isoWeek')
          .subtract(1, 'days')
          .format('YYYY-MM-DD')

        const lastDayWeek = moment(dayNow).endOf('isoWeek').format('YYYY-MM-DD')

        const firstDayMonth = moment(dayNow)
          .startOf('month')
          .format('YYYY-MM-DD')

        const lastDayMonth = moment(dayNow).endOf('month').format('YYYY-MM-DD')

        this.loadingRecommend = true
        const resData = await axios.get(
          `${process.env.URL_SERVER}/api/get-list-movie-table/${dayNow}/${firstDayWeek}/${lastDayWeek}/${firstDayMonth}/${lastDayMonth}`
        )
        if (resData && resData.data && resData.data.status) {
          if (
            resData.data &&
            resData.data.movie_views_daily &&
            resData.data.movie_views_daily.length > 0
          ) {
            const arrayID = []
            const movie = resData.data.movie_views_daily
            for (let index = 0; index < movie.length; index++) {
              const element = movie[index].movie
              const movieItem = {}
              movieItem.id = element.id
              movieItem.ep = element.total_episode
              movieItem.type = element.movie_type
              movieItem.status = element.movie_status
              movieItem.view = element.view
              movieItem.title = element.name_en.toUpperCase()
              movieItem.subtitle = element.name
              movieItem.link = '/movies/' + element.code
              movieItem.country = element.country
              movieItem.year_of_manufacture = element.year_of_manufacture
              movieItem.time = element.time
              for (
                let indexI = 0;
                indexI < element.movie_images.length;
                indexI++
              ) {
                const elementImage = element.movie_images[indexI]
                if (elementImage.type_image === 'image' && elementImage.url) {
                  const images = this.$fire.storage
                    .ref()
                    .child('movies/images/')
                  const image = images.child(elementImage.url)
                  await image.getDownloadURL().then((url) => {
                    movieItem.image = url
                  })
                }
              }
              if (arrayID.length === 0 || !arrayID.includes(element.id)) {
                arrayID.push(element.id)
                if (element.movie_type === 'single') {
                  this.listViewMovies.push(movieItem)
                } else {
                  this.listViewMoviesSeries.push(movieItem)
                }
              }
            }
          }
          if (
            resData.data &&
            resData.data.movie_views_week &&
            resData.data.movie_views_week.length > 0
          ) {
            const arrayID = []
            const movie = resData.data.movie_views_week
            for (let index = 0; index < movie.length; index++) {
              const element = movie[index].movie
              const movieItem = {}
              movieItem.id = element.id
              movieItem.ep = element.total_episode
              movieItem.type = element.movie_type
              movieItem.status = element.movie_status
              movieItem.view = element.view
              movieItem.title = element.name_en.toUpperCase()
              movieItem.subtitle = element.name
              movieItem.link = '/movies/' + element.code
              movieItem.country = element.country
              movieItem.year_of_manufacture = element.year_of_manufacture
              movieItem.time = element.time
              for (
                let indexI = 0;
                indexI < element.movie_images.length;
                indexI++
              ) {
                const elementImage = element.movie_images[indexI]
                if (elementImage.type_image === 'image' && elementImage.url) {
                  const images = this.$fire.storage
                    .ref()
                    .child('movies/images/')
                  const image = images.child(elementImage.url)
                  await image.getDownloadURL().then((url) => {
                    movieItem.image = url
                  })
                }
              }
              if (arrayID.length === 0 || !arrayID.includes(element.id)) {
                arrayID.push(element.id)
                if (element.movie_type === 'single') {
                  this.listViewMoviesWeek.push(movieItem)
                } else {
                  this.listViewMoviesSeriesWeek.push(movieItem)
                }
              }
            }
          }
          if (
            resData.data &&
            resData.data.movie_views_month &&
            resData.data.movie_views_month.length > 0
          ) {
            const arrayID = []
            const movie = resData.data.movie_views_month
            for (let index = 0; index < movie.length; index++) {
              const element = movie[index].movie
              const movieItem = {}
              movieItem.id = element.id
              movieItem.ep = element.total_episode
              movieItem.type = element.movie_type
              movieItem.status = element.movie_status
              movieItem.view = element.view
              movieItem.title = element.name_en.toUpperCase()
              movieItem.subtitle = element.name
              movieItem.link = '/movies/' + element.code
              movieItem.country = element.country
              movieItem.year_of_manufacture = element.year_of_manufacture
              movieItem.time = element.time
              for (
                let indexI = 0;
                indexI < element.movie_images.length;
                indexI++
              ) {
                const elementImage = element.movie_images[indexI]
                if (elementImage.type_image === 'image' && elementImage.url) {
                  const images = this.$fire.storage
                    .ref()
                    .child('movies/images/')
                  const image = images.child(elementImage.url)
                  await image.getDownloadURL().then((url) => {
                    movieItem.image = url
                  })
                }
              }
              if (arrayID.length === 0 || !arrayID.includes(element.id)) {
                arrayID.push(element.id)
                if (element.movie_type === 'single') {
                  this.listViewMoviesMonth.push(movieItem)
                } else {
                  this.listViewMoviesSeriesMonth.push(movieItem)
                }
              }
            }
          }
        } else {
          this.loadingRecommend = false
          this.snackbar = true
          this.textSnackbar = 'Không tìm thấy phim phù hợp'
        }
      } catch (error) {
        console.log(error)
      }
    },
    loadMoreLatestMovie() {
      this.offsetLatest = this.newMoviesItems.length
      this.loadDataMovieLatest()
    },
    loadMoreRecommendedMovie() {
      this.offsetRecommend = this.hotMoviesItems.length
      this.loadDataMovieRecommend()
    },
    loadMoreRecommendededMovie() {
      this.offsetRecommended = this.recommendMovieList.length
      this.sendRecommend()
    },
    async loadDataMovieLatest() {
      try {
        this.loadingLatest = true
        const resData = await axios.get(
          `${process.env.URL_SERVER}/api/get-list-movie/latest/${this.limit}/${this.offsetLatest}`
        )
        if (resData && resData.data && resData.data.status) {
          if (resData.data && resData.data.movies.length > 0) {
            for (let index = 0; index < resData.data.movies.length; index++) {
              const element = resData.data.movies[index]
              const movieItem = {}
              movieItem.id = element.id
              movieItem.ep = element.total_episode
              movieItem.type = element.movie_type
              movieItem.status = element.movie_status
              movieItem.view = element.view
              movieItem.title = element.name_en.toUpperCase()
              movieItem.subtitle = element.name
              movieItem.link = '/movies/' + element.code
              movieItem.country = element.country
              movieItem.year_of_manufacture = element.year_of_manufacture
              movieItem.time = element.time
              for (
                let indexI = 0;
                indexI < element.movie_images.length;
                indexI++
              ) {
                const elementImage = element.movie_images[indexI]

                if (elementImage.type_image === 'image' && elementImage.url) {
                  const images = this.$fire.storage
                    .ref()
                    .child('movies/images/')
                  const image = images.child(elementImage.url)
                  await image.getDownloadURL().then((url) => {
                    movieItem.image = url
                  })
                }
                if (elementImage.type_image === 'banner' && elementImage.url) {
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
              this.newMoviesItems.push(movieItem)
            }
            this.loadingLatest = false
          }
          if (resData.data && resData.data.movieTotal) {
            this.totalLatest = resData.data.movieTotal
          }
        } else {
          this.loadingLatest = false
          this.snackbar = true
          this.textSnackbar = 'Không tìm thấy phim phù hợp'
        }
      } catch (error) {
        console.log(error)
      }
    },
    async loadDataMovieRecommend() {
      try {
        this.loadingRecommend = true
        const resData = await axios.get(
          `${process.env.URL_SERVER}/api/get-list-movie/recommended/${this.limit}/${this.offsetRecommend}`
        )
        if (resData && resData.data && resData.data.status) {
          if (resData.data && resData.data.movies.length > 0) {
            for (let index = 0; index < resData.data.movies.length; index++) {
              const element = resData.data.movies[index]
              const movieItem = {}
              movieItem.id = element.id
              movieItem.ep = element.total_episode
              movieItem.type = element.movie_type
              movieItem.status = element.movie_status
              movieItem.view = element.view
              movieItem.title = element.name_en.toUpperCase()
              movieItem.subtitle = element.name
              movieItem.link = '/movies/' + element.code
              movieItem.country = element.country
              movieItem.year_of_manufacture = element.year_of_manufacture
              movieItem.time = element.time
              for (
                let indexI = 0;
                indexI < element.movie_images.length;
                indexI++
              ) {
                const elementImage = element.movie_images[indexI]

                if (elementImage.type_image === 'image' && elementImage.url) {
                  const images = this.$fire.storage
                    .ref()
                    .child('movies/images/')
                  const image = images.child(elementImage.url)
                  await image.getDownloadURL().then((url) => {
                    movieItem.image = url
                  })
                }
                if (elementImage.type_image === 'banner' && elementImage.url) {
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
              this.hotMoviesItems.push(movieItem)
            }
            this.loadingRecommend = false
          }
          if (resData.data && resData.data.movieTotal) {
            this.totalRecommend = resData.data.movieTotal
          }
        } else {
          this.loadingRecommend = false
          this.snackbar = true
          this.textSnackbar = 'Không tìm thấy phim phù hợp'
        }
      } catch (error) {
        console.log(error)
      }
    },

    closeDialog() {
      this.loadingMovie = false
      this.dialogFeedback = false
      this.dialogRecommend = false
      this.loadingText = 'Đang cập nhật dữ liệu, bạn chờ tí nhé ...'
      // this.snackbar = true
      // this.textSnackbar = 'Hệ thống đã ghi nhận, cảm ơn bạn đã đánh giá'
    },
    openDialogRecommend() {
      this.dialogRecommend = true
      this.categoryRecommend = []
      this.isLikeWatchMovieSeries = null
    },
    async sendRecommend() {
      this.loadingText = 'Đang tìm kiếm phim phù hợp, bạn chờ tí nhé ...'
      this.loadingMovie = true
      this.loadingRecommended = true
      let stringSearch = ''
      if (this.categoryRecommend.length > 0) {
        this.offsetRecommended = 0
        this.tempStringSearch = null
        this.recommendMovieList = []
        const arrayID = []
        for (let index = 0; index < this.categoryRecommend.length; index++) {
          const element = this.categoryRecommend[index]
          arrayID.push(this.categoryLists[element].id)
        }
        if (arrayID.length > 0) {
          const stringID = arrayID.join(',')
          stringSearch = `movie_categories: {category_id: {_in: [${stringID}]}}`
        }
      }

      if (!this.isLikeWatchMovieSeries) {
        //
      } else {
        this.offsetRecommended = 0
        this.recommendMovieList = []
        this.tempStringSearch = null
        stringSearch += ', movie_type: {_eq:"series"}'
      }
      const dataSend = {}
      dataSend.limit = this.limit
      dataSend.offset = this.offsetRecommended
      dataSend.stringSearch = this.tempStringSearch
        ? this.tempStringSearch
        : stringSearch
      try {
        this.loadingMovie = true
        const resData = await axios.post(
          `${process.env.URL_SERVER}/api/get-movie-recommended`,
          dataSend
        )
        if (resData && resData.data && resData.data.status) {
          if (resData.data && resData.data.dataTotal) {
            this.totalRecommended = resData.data.dataTotal
          }
          if (resData.data && resData.data.dataMovies.length > 0) {
            for (
              let index = 0;
              index < resData.data.dataMovies.length;
              index++
            ) {
              const element = resData.data.dataMovies[index]
              const movieItem = {}
              movieItem.id = element.id
              movieItem.ep = element.total_episode
              movieItem.type = element.movie_type
              movieItem.status = element.movie_status
              movieItem.view = element.view
              movieItem.title = element.name_en.toUpperCase()
              movieItem.subtitle = element.name
              movieItem.link = '/movies/' + element.code
              movieItem.country = element.country
              movieItem.year_of_manufacture = element.year_of_manufacture
              movieItem.time = element.time
              for (
                let indexI = 0;
                indexI < element.movie_images.length;
                indexI++
              ) {
                const elementImage = element.movie_images[indexI]

                if (elementImage.type_image === 'image' && elementImage.url) {
                  const images = this.$fire.storage
                    .ref()
                    .child('movies/images/')
                  const image = images.child(elementImage.url)
                  await image.getDownloadURL().then((url) => {
                    movieItem.image = url
                  })
                }
                if (elementImage.type_image === 'banner' && elementImage.url) {
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
              this.recommendMovieList.push(movieItem)
            }
            if (this.recommendMovieList.length > 0) {
              this.isShowRecommend = true
            }
            this.tempStringSearch = stringSearch
            this.loadingRecommended = false
            this.categoryRecommend = []
            this.isLikeWatchMovieSeries = null
            this.closeDialog()
            // this.snackbar = true
            // this.textSnackbar =
            //   'Tìm kiếm phim thành công, di chuyển đến danh mục gợi ý phim để chọn bộ phim phù hợp với bạn nhé'
          }
        } else {
          this.loadingRecommended = false
          this.isShowRecommend = false
          this.recommendMovieList = []
          this.closeDialog()
          this.snackbar = true
          this.textSnackbar = 'Không tìm thấy phim phù hợp'
        }
      } catch (error) {
        this.loadingRecommended = false
        console.log(error)
      }
    },
    openDialogFeedback() {
      this.dialogFeedback = true
      this.isImproveEnglish = null
      this.qualityMovies = null
      this.textFeedback = ''
    },
    sendFeedback() {
      if (
        !this.qualityMovies &&
        !this.isImproveEnglish &&
        this.textFeedback === ''
      ) {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng nhập đánh giá của bạn'
      }
      this.loadingMovie = true
      const itemInsert = {}
      if (this.qualityMovies !== null) {
        if (this.qualityMovies === 0) {
          itemInsert.quality_movie = 'Tốt'
        }
        if (this.qualityMovies === 1) {
          itemInsert.quality_movie = 'Trung bình'
        }
        if (this.qualityMovies === 2) {
          itemInsert.quality_movie = 'Kém'
        }
      }
      if (this.isImproveEnglish !== null) {
        if (this.isImproveEnglish === 0) {
          itemInsert.is_improve_Eng = true
        }
        if (this.isImproveEnglish === 1) {
          itemInsert.is_improve_Eng = false
        }
      }
      itemInsert.note = this.textFeedback
      itemInsert.user_id = this.isLogin

      const insertGraphl = gql`
        mutation MyMutation($objects: [feedbacks_insert_input!]!) {
          insert_feedbacks(objects: $objects) {
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
        update: (store, { data: { insert_feedbacks } }) => {
          // eslint-disable-next-line camelcase
          if (insert_feedbacks.affected_rows) {
            this.textSnackbar = 'Hệ thống đã ghi nhận, cảm ơn bạn đã đánh giá'
            this.snackbar = true
            this.loadingMovie = false
            this.closeDialog()
          } else {
            this.textSnackbar = 'Hệ thống ghi nhận thất bại'
            this.snackbar = true
            this.loadingMovie = false
            this.closeDialog()
          }
        },
      })
    },
    toLink(link) {
      this.$router.push(link)
    },
    toLinkSearch(type, item) {
      if (type === 'status') {
        this.$router.push({ path: '/search', query: { status: item } })
      }
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
        this.$router.push({ path: `/actors/${item.actor.code}` })
      }
    },
  },
  apollo: {
    getData: {
      query() {
        const query = gql(`query MyQuery {
            categories(where: {is_delete: {_eq: false}}) {
              id
              code
              name
            }
          }`)
        return query
      },
      update: (data) => {},
      result({ data }) {
        this.categoryLists = []
        this.categoryLists = data.categories
      },
    },
  },
}
</script>
<style scoped>
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
.card_opacity {
  text-align: justify;
  text-justify: inter-word;
  background-color: rgba(9, 9, 9, 0.5); /* Đặt màu nền với độ mờ mong muốn */
  backdrop-filter: blur(10px); /* Áp dụng hiệu ứng mờ */
}
.card-text p {
  color: darkkhaki;
  font-weight: bold;
}
.card-text a {
  color: orange;
  font-weight: bold;
  font-size: 22px;
}
.card-text a:hover {
  color: red;
  font-weight: bold;
  text-decoration: underline;
  font-size: 22px;
}
.card-hover span {
  font-size: 15px;
  color: orange;
  font-weight: bold;
}
.card-hover p {
  font-size: 15px;
  color: orange;
  font-weight: bold;
}
/* DEMO-SPECIFIC STYLES */
.typing-demo {
  color: black;
  font-family: monospace;

  margin: 0 auto; /* Gives that scrolling effect as the typing happens */
  letter-spacing: 0.1em; /*Adjust as needed */
  font-weight: bold;
  font-size: 15px;
}
</style>
