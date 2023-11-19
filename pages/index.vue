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
    <v-dialog v-model="dialogLoading" hide-overlay persistent width="500">
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
    </v-dialog>
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
            <v-chip filter outlined> Hài hước </v-chip>
            <v-chip filter outlined> Phiêu lưu </v-chip>
            <v-chip filter outlined> Hành động </v-chip>
            <v-chip filter outlined> Tình cảm </v-chip>
            <v-chip filter outlined> Hoạt hình </v-chip>
            <v-chip filter outlined> Tâm lý </v-chip>
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
            :disabled="dialogLoading"
            :loading="dialogLoading"
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
            :disabled="dialogLoading"
            :loading="dialogLoading"
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
          v-for="(item, i) in slideItems"
          :key="i"
          :src="item.src"
        >
          <v-card
            outlined
            style="margin-top: 60px"
            class="mx-auto lighten-3 card_opacity ml-15"
            max-width="500"
            elevation="5"
          >
            <v-card-text class="card-text">
              <a>Transformers: Quái Thú Trỗi Dậy (2023)</a>

              <p>Transformers: Rise Of The Beasts (2023)</p>

              <div class="font-weight-bold white--text">
                Nội dung: Trong những năm 90, một phe mới của Transformers -
                Maximals - tham gia cùng Autobots với tư cách là đồng minh trong
                cuộc chiến vì Trái đất.
              </div>
            </v-card-text>
            <v-card-actions>
              <v-btn text color="orange"> Xem ngay </v-btn>
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
          <!-- Hot Movies -->
          <v-row class="ml-2">
            <v-col cols="12" sm="12" lg="12" xl="12" md="12" class="card-text">
              <a>DANH MỤC PHIM NỔI BẬT</a>
            </v-col>
          </v-row>
          <v-row class="ml-2">
            <v-col
              v-for="(file, f) in hotMoviesItems"
              :key="f"
              cols="12"
              sm="6"
              lg="3"
              xl="3"
              md="3"
            >
              <v-card :href="file.link" class="mx-auto" max-width="400">
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
                      <v-row class="pa-4 d-flex justify-space-between mt-n1">
                        <v-avatar
                          :color="file.status === 'HOT' ? 'error' : 'green'"
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
                          <span class="white--text text-h7">{{ file.ep }}</span>
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
                            >Thời lượng: ~24 phút/tập</v-list-item-title
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
                            >Quốc gia: UNITED STATES</v-list-item-title
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

            <v-row justify="center">
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
            </v-row>
          </v-row>
          <!-- New Movies -->
          <v-row class="ml-2">
            <v-col
              cols="12"
              sm="12"
              lg="12"
              xl="12"
              md="12"
              class="card-text mt-5"
            >
              <a>DANH MỤC PHIM MỚI CẬP NHẬT</a>
            </v-col>
          </v-row>
          <v-row class="ml-2">
            <v-col cols="12" sm="12" lg="12" xl="12" md="12">
              <v-row>
                <v-col
                  v-for="(file, f) in newMoviesItems"
                  :key="f"
                  cols="12"
                  sm="6"
                  lg="3"
                  xl="3"
                  md="3"
                >
                  <v-card :href="file.link" class="mx-auto" max-width="400">
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
                              :color="file.status === 'HOT' ? 'error' : 'green'"
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
                                >Thời lượng: ~24 phút/tập</v-list-item-title
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
                                >Quốc gia: UNITED STATES</v-list-item-title
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

                <v-row justify="center">
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
                </v-row>
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
                      <v-tab key="date"> Ngày </v-tab>
                      <v-tab key="month"> Tháng </v-tab>
                      <v-tab key="year"> Năm </v-tab>
                    </v-tabs>
                  </template>
                </v-toolbar>
                <v-tabs-items v-model="tabsViewMovie">
                  <v-tab-item>
                    <v-list three-line>
                      <template v-for="(item, index) in listViewMovies">
                        <v-divider
                          v-if="item.divider"
                          :key="index"
                          :inset="item.inset"
                        ></v-divider>

                        <v-list-item v-else :key="item.title" :href="item.link">
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
                      </template>
                    </v-list>
                  </v-tab-item>
                  <v-tab-item>
                    <v-list three-line>
                      <template v-for="(item, index) in listViewMovies">
                        <v-divider
                          v-if="item.divider"
                          :key="index"
                          :inset="item.inset"
                        ></v-divider>

                        <v-list-item v-else :key="item.title" :href="item.link">
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
                      </template>
                    </v-list>
                  </v-tab-item>
                  <v-tab-item>
                    <v-list three-line>
                      <template v-for="(item, index) in listViewMovies">
                        <v-divider
                          v-if="item.divider"
                          :key="index"
                          :inset="item.inset"
                        ></v-divider>

                        <v-list-item v-else :key="item.title" :href="item.link">
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
            <v-card max-height="130" max-width="200" class="pa-2">
              <v-card-tilte class="typing-demo"
                >Bạn đã tìm được phim xem chưa ? Tôi có thể giúp bạn không
                ?</v-card-tilte
              >

              <v-card-actions>
                <v-btn
                  class="mx-auto"
                  color="error"
                  @click="openDialogRecommend"
                >
                  Gợi ý
                </v-btn>
              </v-card-actions>
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
                      <v-tab key="date"> Ngày </v-tab>
                      <v-tab key="month"> Tháng </v-tab>
                      <v-tab key="year"> Năm </v-tab>
                    </v-tabs>
                  </template>
                </v-toolbar>
                <v-tabs-items v-model="tabsViewMovieSeries">
                  <v-tab-item>
                    <v-list three-line>
                      <template v-for="(item, index) in listViewMovieSeries">
                        <v-divider
                          v-if="item.divider"
                          :key="index"
                          :inset="item.inset"
                        ></v-divider>

                        <v-list-item v-else :key="item.title" :href="item.link">
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
                      </template>
                    </v-list>
                  </v-tab-item>
                  <v-tab-item>
                    <v-list three-line>
                      <template v-for="(item, index) in listViewMovieSeries">
                        <v-divider
                          v-if="item.divider"
                          :key="index"
                          :inset="item.inset"
                        ></v-divider>

                        <v-list-item v-else :key="item.title" :href="item.link">
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
                      </template>
                    </v-list>
                  </v-tab-item>
                  <v-tab-item>
                    <v-list three-line>
                      <template v-for="(item, index) in listViewMovieSeries">
                        <v-divider
                          v-if="item.divider"
                          :key="index"
                          :inset="item.inset"
                        ></v-divider>

                        <v-list-item v-else :key="item.title" :href="item.link">
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
            <v-card max-height="130" max-width="200" class="pa-2">
              <v-card-tilte class="typing-demo"
                >Hãy cho tôi cảm nhận của bạn về trang web</v-card-tilte
              >

              <v-card-actions>
                <v-btn
                  class="mx-auto"
                  color="error"
                  @click="openDialogFeedback"
                >
                  Đánh giá
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-row>
        </v-col>
      </v-row>
    </v-card>
  </v-app>
</template>

<script>
export default {
  layout: 'default',
  name: 'IndexPage',
  data() {
    return {
      loadingText: 'Đang cập nhật dữ liệu, bạn chờ tí nhé ...',
      snackbar: false,
      textSnackbar: '',
      dialogRecommend: false,
      dialogLoading: false,
      dialogFeedback: false,
      page: 1,
      cycle: true,
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
          status: 'HOT',
          image: require('~/static/friend-7.jpg'),
          subtitle: 'Những người bạn mùa 7',
          title: 'FRIENDS SEASON 7',
          link: '/movies/friend-season-7',
        },
        {
          ep: '24',
          type: 'series',
          view: 500,
          status: 'HOT',
          image: require('~/static/friend-8.jpg'),
          subtitle: 'Những người bạn mùa 8',
          title: 'FRIENDS SEASON 8',
          link: '/movies/friend-season-8',
        },
      ],
      newMoviesItems: [
        {
          ep: '24',
          type: 'series',
          view: 15000,
          status: 'NEW',
          image: require('~/static/friend-1.jpg'),
          subtitle: 'Những người bạn mùa 1',
          title: 'FRIENDS SEASON 1',
          link: '/movies/friend-season-1',
        },
        {
          ep: '28',
          type: 'series',
          view: 75412,
          status: 'NEW',
          image: require('~/static/friend-2.jpg'),
          subtitle: 'Những người bạn mùa 2',
          title: 'FRIENDS SEASON 2',
          link: '/movies/friend-season-2',
        },
        {
          ep: '30',
          type: 'series',
          view: 12154,
          status: 'NEW',
          image: require('~/static/friend-3.jpg'),
          subtitle: 'Những người bạn mùa 3',
          title: 'FRIENDS SEASON 3',
          link: '/movies/friend-season-3',
        },
        {
          ep: '24',
          type: 'series',
          view: 21200,
          status: 'NEW',
          image: require('~/static/friend-4.jpg'),
          subtitle: 'Những người bạn mùa 4',
          title: 'FRIENDS SEASON 4',
          link: '/movies/friend-season-4',
        },
        {
          ep: '19',
          type: 'series',
          view: 65187,
          status: 'NEW',
          image: require('~/static/friend-5.jpg'),
          subtitle: 'Những người bạn mùa 5',
          title: 'FRIENDS SEASON 5',
          link: '/movies/friend-season-5',
        },
        {
          ep: '20',
          type: 'series',
          view: 26510,
          status: 'NEW',
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
      listViewMovieSeries: [
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
      categoryLists: [],
      categoryRecommend: [1, 4],
      isLikeWatchMovieSeries: null,
      isImproveEnglish: null,
      qualityMovies: null,
      textFeedback: null,
    }
  },
  watch: {
    dialogLoading(val) {
      if (!val) return

      setTimeout(() => this.closeDialog(), 4000)
    },
  },
  methods: {
    closeDialog() {
      this.dialogLoading = false
      this.dialogFeedback = false
      this.dialogRecommend = false
      this.loadingText = 'Đang cập nhật dữ liệu, bạn chờ tí nhé ...'
      this.snackbar = true
      this.textSnackbar = 'Hệ thống đã ghi nhận, cảm ơn bạn đã đánh giá'
    },
    openDialogRecommend() {
      this.dialogRecommend = true
      this.categoryRecommend = []
      this.isLikeWatchMovieSeries = null
    },
    sendRecommend() {
      this.loadingText = 'Đang tìm kiếm phim phù hợp, bạn chờ tí nhé ...'
      this.dialogLoading = true
    },
    openDialogFeedback() {
      this.dialogFeedback = true
      this.isImproveEnglish = null
      this.qualityMovies = null
      this.textFeedback = ''
    },
    sendFeedback() {
      this.dialogLoading = true
    },
  },
}
</script>
<style scoped>
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
  letter-spacing: 0.05em; /* Adjust as needed */

  font-size: 15px;
}
</style>
