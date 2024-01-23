<!-- eslint-disable nuxt/no-globals-in-created -->
<!-- eslint-disable nuxt/no-globals-in-created -->
<!-- eslint-disable vue/no-use-v-if-with-v-for -->
<!-- eslint-disable no-undef -->
<!-- eslint-disable no-undef -->
<!-- eslint-disable no-unused-vars -->
<!-- eslint-disable no-unused-vars -->
<!-- eslint-disable vue/no-useless-template-attributes -->
<!-- eslint-disable vue/no-v-for-template-key -->
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
    <v-dialog v-model="dialogSetup" persistent max-width="600px">
      <v-card>
        <v-card-text class="mt-2">
          <v-row class="d-flex flex-column">
            <v-col>
              <span class="red--text font-weight-bold">
                * Thiết lập xem phim</span
              >
            </v-col>
            <v-col class="d-flex mt-n4">
              <span class="font-weight-bold"> Tốc độ </span>
              <div class="d-flex mt-n2" style="margin-left: 90px">
                <!-- <v-btn x-small><v-icon small>mdi-minus</v-icon></v-btn> -->
                <v-text-field
                  dense
                  style="width: 200px"
                  class="centered-input"
                  disabled
                  v-model="setupVideo.speedMovie"
                >
                  <template v-slot:append-outer>
                    <v-btn
                      :disabled="Number(setupVideo.speedMovie) === 2.0"
                      x-small
                      @click="plusSpeedMovie"
                      ><v-icon small>mdi-plus</v-icon></v-btn
                    >
                  </template>
                  <template v-slot:prepend>
                    <v-btn
                      :disabled="Number(setupVideo.speedMovie) === 0.25"
                      x-small
                      @click="minusSpeedMovie"
                      ><v-icon small>mdi-minus</v-icon></v-btn
                    >
                  </template>
                </v-text-field>
              </div>
            </v-col>
            <v-col class="mt-n7">
              <span class="red--text font-weight-bold">
                * Thiết lập phụ đề xem phim</span
              >
            </v-col>
            <v-col class="d-flex mt-n4">
              <span class="font-weight-bold"> Màu nền</span>
              <div class="d-flex mt-n2" style="margin-left: 80px">
                <!-- <v-btn x-small><v-icon small>mdi-minus</v-icon></v-btn> -->
                <v-text-field
                  dense
                  style="width: 200px"
                  class="centered-input"
                  disabled
                  :value="viewRGBA(setupVideo.backgroundColor)"
                >
                  <template v-slot:append-outer>
                    <v-btn
                      x-small
                      @click="
                        menuOptionColorBackground = !menuOptionColorBackground
                      "
                      ><v-icon
                        small
                        :color="viewRGBA(setupVideo.backgroundColor)"
                        >mdi-square</v-icon
                      ></v-btn
                    >
                  </template>
                </v-text-field>
                <v-menu
                  v-model="menuOptionColorBackground"
                  top
                  :close-on-content-click="false"
                  :offset-x="true"
                >
                  <v-color-picker
                    v-model="setupVideo.backgroundColor"
                    class="ma-2"
                  ></v-color-picker>
                </v-menu>
              </div>
            </v-col>
            <v-col class="d-flex mt-n4">
              <span class="font-weight-bold"> Màu chữ tiếng Việt</span>
              <div class="d-flex mt-n2 ml-4">
                <!-- <v-btn x-small><v-icon small>mdi-minus</v-icon></v-btn> -->
                <v-text-field
                  dense
                  style="width: 200px"
                  class="centered-input"
                  disabled
                  :value="setupVideo.colorSubVi"
                >
                  <template v-slot:append-outer>
                    <v-btn
                      x-small
                      @click="menuOptionColorSubVi = !menuOptionColorSubVi"
                      ><v-icon small :color="setupVideo.colorSubVi"
                        >mdi-square</v-icon
                      ></v-btn
                    >
                  </template>
                </v-text-field>
                <v-menu
                  v-model="menuOptionColorSubVi"
                  top
                  :close-on-content-click="false"
                  :offset-x="true"
                >
                  <v-color-picker
                    v-model="setupVideo.colorSubVi"
                    class="ma-2"
                  ></v-color-picker>
                </v-menu>
              </div>
            </v-col>
            <v-col class="d-flex mt-n4">
              <span class="font-weight-bold"> Màu chữ tiếng Anh</span>
              <div class="d-flex mt-n2 ml-4">
                <!-- <v-btn x-small><v-icon small>mdi-minus</v-icon></v-btn> -->
                <v-text-field
                  dense
                  style="width: 200px"
                  class="centered-input"
                  disabled
                  :value="setupVideo.colorSubEn"
                >
                  <template v-slot:append-outer>
                    <v-btn
                      x-small
                      @click="menuOptionColorSubEn = !menuOptionColorSubEn"
                      ><v-icon small :color="setupVideo.colorSubEn"
                        >mdi-square</v-icon
                      ></v-btn
                    >
                  </template>
                </v-text-field>
                <v-menu
                  v-model="menuOptionColorSubEn"
                  top
                  :close-on-content-click="false"
                  :offset-x="true"
                >
                  <v-color-picker
                    v-model="setupVideo.colorSubEn"
                    class="ma-2"
                  ></v-color-picker>
                </v-menu>
              </div>
            </v-col>
            <v-col class="d-flex mt-n4">
              <span class="font-weight-bold"> Cỡ chữ (em)</span>
              <div class="d-flex mt-n2 ml-14">
                <v-text-field
                  dense
                  style="width: 200px"
                  class="centered-input"
                  disabled
                  v-model="setupVideo.fontSize"
                >
                  <template v-slot:append-outer>
                    <v-btn
                      :disabled="setupVideo.fontSize === 1.9000000000000001"
                      x-small
                      @click="plusFontSizeMovie"
                      ><v-icon small>mdi-plus</v-icon></v-btn
                    >
                  </template>
                  <template v-slot:prepend>
                    <v-btn
                      :disabled="setupVideo.fontSize === 1.0"
                      x-small
                      @click="minusFontSizeMovie"
                      ><v-icon small>mdi-minus</v-icon></v-btn
                    >
                  </template>
                </v-text-field>
              </div>
            </v-col>
            <v-col class="d-flex mt-n4">
              <span class="font-weight-bold">Phụ đề</span>
              <div class="d-flex mt-n2" style="margin-left: 88px">
                <v-select
                  style="width: 200px"
                  v-model="selectedSubtitle"
                  :items="menuSubtitles"
                  label="Phụ đề phim"
                  item-value="code"
                  item-text="label"
                  dense
                  solo
                ></v-select>
              </div>
            </v-col>
            <v-col class="mt-n7">
              <span class="red--text font-weight-bold">
                * Thiết lập phụ đề bên cạnh</span
              >
              <v-checkbox v-model="isShowTransScript" dense>
                <template v-slot:label>
                  <span class="font-weight-bold custom-checkbox">Hiển thị</span>
                </template></v-checkbox
              >
              <v-checkbox class="mt-n3" v-model="isHideSubViTranscript" dense
                ><template v-slot:label>
                  <span class="font-weight-bold custom-checkbox"
                    >Ẩn phụ đề tiếng Việt</span
                  >
                </template></v-checkbox
              >
              <!-- <v-checkbox class="mt-n3" v-model="isHideSubEnTranscript" dense
                ><template v-slot:label>
                  <span class="font-weight-bold custom-checkbox"
                    >Ẩn phụ đề tiếng Anh</span
                  >
                </template></v-checkbox
              > -->
            </v-col>
          </v-row>
        </v-card-text>
        <v-card-actions>
          <v-btn small color="error" text @click="getDefaultSetup">
            Thông số mặc định
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn small color="error" text @click="getDefaultSetup">
            Đóng
          </v-btn>
          <v-btn small color="error" text @click="setupMovie"> Lưu </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialogErrorMovie" persistent max-width="600px">
      <v-card>
        <v-card-text class="mt-2">
          <v-row class="d-flex flex-column">
            <v-col>
              <span class="red--text font-weight-bold">
                * Thông báo lỗi phim/phụ đề và các chức năng trang web</span
              >
              <v-checkbox v-model="errorMovie.isErrorMovie" dense>
                <template v-slot:label>
                  <span class="font-weight-bold custom-checkbox">Lỗi phim</span>
                </template></v-checkbox
              >
              <v-checkbox class="mt-n3" v-model="errorMovie.isErrorSub" dense
                ><template v-slot:label>
                  <span class="font-weight-bold custom-checkbox"
                    >Lỗi phụ đề</span
                  >
                </template></v-checkbox
              >
              <v-textarea
                v-model="errorMovie.noteError"
                outlined
                label="Ghi chú"
                auto-grow
              >
              </v-textarea>
              <!-- <v-checkbox class="mt-n3" v-model="isHideSubEnTranscript" dense
                ><template v-slot:label>
                  <span class="font-weight-bold custom-checkbox"
                    >Ẩn phụ đề tiếng Anh</span
                  >
                </template></v-checkbox
              > -->
            </v-col>
          </v-row>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn small color="error" text @click="dialogErrorMovie = false">
            Đóng
          </v-btn>
          <v-btn small color="error" text @click="sendErrorMovie"> Gửi </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialogSignIn" max-width="600px" min-width="360px" eager>
      <div>
        <v-tabs
          v-model="tabSignIn"
          show-arrows
          background-color="error accent-4"
          icons-and-text
          dark
          grow
          eager
        >
          <v-tabs-slider color="purple darken-4"></v-tabs-slider>
          <v-tab v-for="i in tabsSignIn" :key="i.name">
            <v-icon large>{{ i.icon }}</v-icon>
            <div class="caption py-1">{{ i.name }}</div>
          </v-tab>
          <v-tab-item eager>
            <v-card class="px-4">
              <v-card-text>
                <v-form ref="formLogin" v-model="valid" lazy-validation>
                  <v-row>
                    <v-col cols="12">
                      <v-text-field
                        outlined
                        dense
                        prepend-icon="mdi-email-outline"
                        v-model="signInItem.email"
                        :rules="loginEmailRules"
                        label="E-mail"
                        required
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12">
                      <v-text-field
                        outlined
                        dense
                        prepend-icon="mdi-key-variant"
                        v-model="signInItem.password"
                        :append-icon="showPass ? 'eye' : 'eye-off'"
                        :rules="[rules.required, rules.min]"
                        :type="showPass ? 'text' : 'password'"
                        name="input-10-1"
                        label="Mật khẩu"
                        class="mt-n5"
                        hint="Tối thiểu 8 kí tự"
                        counter
                        @click:append="showPass = !showPass"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" class="d-flex justify-space-between mt-n3">
                      <v-btn
                        @click="toLink('forgot_password')"
                        color="error"
                        small
                        dense
                        text
                        >Quên mật khẩu</v-btn
                      >
                      <v-spacer></v-spacer>

                      <v-col cols="12" lg="3" md="3" sm="3" xsm="3">
                        <v-btn
                          block
                          dense
                          color="error"
                          @click="loginUser()"
                          class="mt-n3"
                        >
                          Đăng nhập
                        </v-btn>
                      </v-col>
                    </v-col>

                    <v-col cols="12" class="d-flex justify-space-between">
                      <v-divider></v-divider
                      ><span class="pa-2 mt-n5">HOẶC</span>
                      <v-divider></v-divider>
                    </v-col>
                    <v-col cols="12" class="d-flex justify-space-around">
                      <v-btn
                        outlined
                        color="warning"
                        @click="loginUserWithGoogle"
                        ><v-icon>mdi-google</v-icon>Đăng nhập với google</v-btn
                      >
                    </v-col>
                    <v-col class="d-flex" cols="12" sm="6" xsm="12"></v-col>
                  </v-row>
                </v-form>
              </v-card-text>
            </v-card>
          </v-tab-item>
          <v-tab-item eager>
            <v-card class="px-4">
              <v-card-text>
                <v-form ref="formRegister" v-model="valid" lazy-validation>
                  <v-row>
                    <v-col cols="12">
                      <v-text-field
                        outlined
                        dense
                        prepend-icon="mdi-account"
                        v-model="signUpItem.username"
                        label="Tên người dùng"
                        required
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12">
                      <v-text-field
                        outlined
                        dense
                        class="mt-n5"
                        prepend-icon="mdi-email-outline"
                        v-model="signUpItem.email"
                        :rules="emailRules"
                        label="E-mail"
                        required
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12">
                      <v-text-field
                        outlined
                        dense
                        class="mt-n5"
                        prepend-icon="mdi-key-variant"
                        v-model="signUpItem.password"
                        :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                        :rules="[rules.required, rules.min]"
                        :type="showPass ? 'text' : 'password'"
                        name="input-10-1"
                        label="Mật khẩu"
                        hint="Tối thiểu 8 kí tự"
                        counter
                        @click:append="showPass = !showPass"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12">
                      <v-text-field
                        block
                        outlined
                        dense
                        class="mt-n5"
                        prepend-icon="mdi-key-change"
                        v-model="signUpItem.verify"
                        :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                        :rules="[rules.required, passwordMatch]"
                        :type="showPass ? 'text' : 'password'"
                        name="input-10-1"
                        label="Xác nhận mật khẩu"
                        counter
                        @click:append="showPass = !showPass"
                      ></v-text-field>
                    </v-col>
                    <v-spacer></v-spacer>
                    <v-col class="d-flex ml-auto" cols="12" sm="3" xsm="12">
                      <v-btn block color="error" @click="registerUser"
                        >Đăng ký</v-btn
                      >
                    </v-col>
                  </v-row>
                </v-form>
              </v-card-text>
            </v-card>
          </v-tab-item>
        </v-tabs>
      </div>
    </v-dialog>
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
        <v-col
          cols="12"
          :sm="colVideo"
          :lg="colVideo"
          :xl="colVideo"
          :md="colVideo"
        >
          <!-- <video-player :options="videoOptions" /> -->
          <v-container fluid>
            <v-row>
              <v-col cols="12">
                <div
                  class="video-container"
                  @mouseover="isHoverVideo = true"
                  @mouseleave="isHoverVideo = false"
                >
                  <video
                    id="video"
                    ref="videoPlayer"
                    :muted="isMuted"
                    autoplay
                    disablepictureinpicture
                    playsinline
                    crossorigin="anonymous"
                    controlslist="nodownload noremoteplayback"
                  >
                    <source type="video/mp4" :src="dataEpisode.url_movie" />
                    <track
                      label="English"
                      kind="captions"
                      srclang="en"
                      :src="dataEpisode.url_sub_en"
                    />
                    <track
                      label="VietNam"
                      kind="captions"
                      srclang="vi"
                      :src="dataEpisode.url_sub_vi"
                    />
                  </video>
                  <div v-if="!isEndTimeTrial" class="subtitles-container">
                    <div
                      v-if="
                        selectedSubtitle === 'en' ||
                        selectedSubtitle === 'en-vi' ||
                        selectedSubtitle === 'vi-en'
                      "
                      class="subtitle-row"
                      ref="subtitleTrackWrapperEN"
                    >
                      <span class="subtitle-eng"></span>
                    </div>
                    <div
                      v-if="
                        selectedSubtitle === 'vi' ||
                        selectedSubtitle === 'en-vi' ||
                        selectedSubtitle === 'vi-en'
                      "
                      class="subtitle-row"
                      ref="subtitleTrackWrapperVN"
                    >
                      <span class="subtitle-vn"></span>
                    </div>
                    <div v-if="isShowMenuSubtitles" class="menu-subtitle">
                      <v-radio-group
                        v-model="selectedSubtitle"
                        column
                        dense
                        dark
                      >
                        <template
                          class="d-flex align-center item-menu-subtitle"
                          v-for="todo in menuSubtitles"
                        >
                          <v-radio
                            color="white"
                            :label="todo.label"
                            :value="todo.code"
                          ></v-radio>
                        </template>
                      </v-radio-group>
                      <!-- <ul>
                        <li
                          class="d-flex align-center item-menu-subtitle"
                          v-for="(todo, index) in menuSubtitles"
                        >
                          <v-checkbox
                            color="white"
                            light
                            class="custom-checkbox"
                            @click="getOptionSubtitle(index)"
                          ></v-checkbox
                          ><span>{{ todo.label }}</span>
                        </li>
                      </ul> -->
                      <!-- <v-menu
                        v-model="isShowMenuSubtitles"
                        class="subtitles-container menu-subtitle"
                        top
                        offset-y
                        absolute
                      >
                        <v-list dense>
                          <v-list-item
                            dense
                            v-for="color in menuSubtitles"
                            :key="color.code"
                          >
                            <v-list-item-action>
                              <v-checkbox
                                v-model="selectedSubtitle"
                                :value="color.code"
                              />
                            </v-list-item-action>
                            <v-list-item-content>
                              <v-list-item-title>{{
                                color.label
                              }}</v-list-item-title>
                            </v-list-item-content>
                          </v-list-item>
                        </v-list>
                      </v-menu> -->
                    </div>
                    <div
                      class="control-row d-flex justify-center"
                      v-if="isHoverVideo"
                    >
                      <v-col
                        class="d-flex justify-start align-center"
                        cols="12"
                        sm="2"
                        lg="3"
                        xl="2"
                        md="3"
                      >
                        <v-btn @click="togglePlayPause" fab small color="error">
                          <v-icon>
                            {{ isPlaying ? 'mdi-pause' : 'mdi-play' }}</v-icon
                          >
                        </v-btn>
                        <v-btn
                          fab
                          small
                          color="error"
                          @click="toggleMute"
                          class="volume-btn ml-2"
                        >
                          <v-icon>{{
                            isMuted ? 'mdi-volume-off' : 'mdi-volume-high'
                          }}</v-icon>
                        </v-btn>
                        <v-slider
                          v-model="volume"
                          thumb-color="white"
                          track-color="grey"
                          track-fill-color="error"
                          min="0"
                          max="100"
                          class="custom-volume mt-6"
                          @input="setVolume"
                        ></v-slider
                      ></v-col>
                      <v-col
                        class="d-flex align-center"
                        cols="12"
                        sm="8"
                        lg="7"
                        xl="8"
                        md="7"
                      >
                        <span class="time-display">{{
                          formatTime(currentTime)
                        }}</span>
                        <v-slider
                          thumb-color="white"
                          track-color="grey"
                          track-fill-color="error"
                          v-model="currentTime"
                          :max="duration"
                          step="1"
                          class="custom-slider mt-6"
                          @input="seekToTime"
                        ></v-slider>

                        <span class="time-display">{{
                          formatTime(duration)
                        }}</span></v-col
                      >
                      <v-col
                        class="d-flex justify-end align-center"
                        cols="12"
                        sm="2"
                        lg="2"
                        xl="2"
                        md="2"
                      >
                        <v-btn
                          @click="hideShowMenuSubtitles"
                          small
                          fab
                          color="error"
                          dark
                        >
                          <v-icon>mdi-closed-caption</v-icon>
                        </v-btn>

                        <v-btn
                          class="ml-2"
                          small
                          fab
                          color="error"
                          dark
                          @click="toggleFullscreen"
                        >
                          <v-icon>mdi-fullscreen</v-icon>
                        </v-btn>
                      </v-col>
                    </div>
                  </div>
                  <div v-else class="subtitles-container">
                    <div class="overlay-movie d-flex flex-column">
                      <h3>
                        Bạn đã hết thời gian trải nghiệm, vui lòng đăng nhập và
                        tiến hành kích hoạt VIP để tiếp tục
                      </h3>
                      <v-btn class="mt-2" color="yellow" @click="activeVIP"
                        >Kích hoạt vip <v-icon>mdi-chess-queen</v-icon></v-btn
                      >
                    </div>

                    <!-- <v-overlay absolute opacity>
                      Bạn đã hết thời gian trải nghiệm, vui lòng nạp vip để tiếp
                      tục</v-overlay
                    > -->
                  </div>
                </div>
              </v-col>
            </v-row>
          </v-container>
        </v-col>
        <v-col v-if="isShowTransScript" cols="12" sm="4" lg="4" xl="4" md="4">
          <v-container fluid>
            <v-card class="mx-auto" max-width="600">
              <v-container
                style="height: 75vh; max-height: 75vh"
                class="overflow-y-auto"
                id="container-subtitle"
              >
                <v-row
                  v-for="(item, index) in transcript"
                  :key="item.id"
                  :id="'cue-' + item.id"
                  class="d-flex cueHoverTranscript"
                  @click="moveToScript(item)"
                >
                  <v-col
                    v-if="cueActive && cueActive.id && cueActive.id === item.id"
                    cols="12"
                    sm="12"
                    lg="12"
                    xl="12"
                    md="12"
                    class="pa-4 cueActiveTranscript"
                  >
                    <v-row>
                      <v-col cols="12" sm="10" lg="10" xl="10" md="10">
                        <v-layout class="d-flex flex-column">
                          <span class="subtitle-1" v-html="item.text"></span>

                          <span
                            v-show="!isHideSubViTranscript"
                            class="subtitle-2 font-italic"
                            v-html="item.textVN"
                          ></span>
                        </v-layout>
                      </v-col>
                      <v-col cols="12" sm="2" lg="2" xl="2" md="2">
                        <v-btn block color="error " @click="saveCouplet(item)"
                          ><v-icon align-center>mdi-content-save</v-icon></v-btn
                        >
                      </v-col>
                    </v-row>
                    <v-row>
                      <v-divider
                        v-if="index < transcript.length - 1"
                        :key="index"
                      ></v-divider>
                    </v-row>
                  </v-col>
                  <v-col
                    v-else
                    cols="12"
                    sm="12"
                    lg="12"
                    xl="12"
                    md="12"
                    class="pa-4"
                  >
                    <v-row>
                      <v-col cols="12" sm="10" lg="10" xl="10" md="10">
                        <v-layout class="d-flex flex-column">
                          <span class="subtitle-1" v-html="item.text"></span>
                          <span
                            v-show="!isHideSubViTranscript"
                            class="subtitle-2 font-italic"
                            v-html="item.textVN"
                          ></span>
                        </v-layout>
                      </v-col>
                      <v-col cols="12" sm="2" lg="2" xl="2" md="2">
                        <v-btn block color="error " @click="saveCouplet(item)"
                          ><v-icon align-center>mdi-content-save</v-icon></v-btn
                        >
                      </v-col>
                    </v-row>
                    <v-row>
                      <v-divider
                        v-if="index < transcript.length - 1"
                        :key="index"
                      ></v-divider>
                    </v-row>
                  </v-col>
                </v-row>
              </v-container>
            </v-card>
          </v-container>
        </v-col>
      </v-row>
      <v-row>
        <v-col
          cols="12"
          sm="8"
          lg="8"
          xl="8"
          md="8"
          class="d-flex justify-space-between mt-n3"
        >
          <div>
            <v-btn
              @click="hidePracticeListening"
              small
              color="error"
              class="ml-3 mt-n3"
              ><v-icon small>
                {{
                  isPracticeListening
                    ? 'mdi-checkbox-marked'
                    : 'mdi-checkbox-blank-outline'
                }}</v-icon
              >
              Luyện nghe
            </v-btn>
            <v-btn
              @click="showLookUpWordSheet"
              small
              color="error"
              class="ml-2 mt-n3"
            >
              <v-icon small>
                {{
                  lookUpWordSheet
                    ? 'mdi-checkbox-marked'
                    : 'mdi-checkbox-blank-outline'
                }}</v-icon
              >Tra từ
            </v-btn>
            <v-btn
              @click="dialogSetup = true"
              small
              color="error"
              class="ml-2 mt-n3"
            >
              Tùy chỉnh
            </v-btn>
            <v-btn
              @click="isLoopCue = !isLoopCue"
              small
              color="error"
              class="ml-2 mt-n3"
            >
              <v-icon small>
                {{
                  isLoopCue
                    ? 'mdi-checkbox-marked'
                    : 'mdi-checkbox-blank-outline'
                }}</v-icon
              >Lặp lại
            </v-btn>
          </div>
          <div>
            <v-responsive class="mr-4 mt-n4" width="300px">
              <v-text-field
                dense
                width="50px"
                suffix="giây"
                class="time-input"
                type="number"
                v-model="setupVideo.changeCurrentTime"
              >
                <template v-slot:append-outer>
                  <v-btn small color="error" @click="forwardVideo"
                    >Tăng lên
                  </v-btn>
                </template>
                <template v-slot:prepend>
                  <v-btn small color="error" @click="rewindVideo"
                    >Lùi lại</v-btn
                  >
                </template>
              </v-text-field>
            </v-responsive>
          </div>
        </v-col>
        <v-col cols="12" sm="4" lg="4" xl="4" md="4"></v-col>
      </v-row>
      <v-row>
        <v-col cols="12" sm="8" lg="8" xl="8" md="8">
          <v-card-text class="d-flex justify-space-between">
            <div>
              <h2 class="orange--text font-weight-bold">
                {{ movie.name_en }}
              </h2>
              <p class="font-italic">{{ movie.name }}</p>
            </div>
            <div>
              <v-btn small class="error" @click="addToFavouriteMovie">
                <v-icon v-if="!isLikeMovie"> mdi-heart-outline </v-icon>

                <v-icon v-else> mdi-heart </v-icon>
                Yêu thích</v-btn
              >
              <v-btn @click="openDialogError" small color="error" class="ml-2">
                <v-icon>mdi-flag-variant</v-icon> Báo lỗi
              </v-btn>
            </div>
          </v-card-text>
          <v-divider></v-divider>
          <v-card-text>
            <h3>SỐ TẬP TRONG PHIM</h3>
            <template v-for="item in movie.movie_details">
              <v-btn @click="toLinkWatch(item)" small class="pa-2 mt-2 ml-2">
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
                      movie.country.name
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
                      <!-- {{ item.user.username.slice(0, 1).toUpperCase() }} -->
                      <!-- <v-icon>mdi-account</v-icon> -->
                      <v-img :src="item.image_user"></v-img>
                    </v-list-item-avatar>

                    <v-list-item-content>
                      <v-list-item-title class="font-weight-bold mt-1"
                        >{{ item.user.username
                        }}<span class="caption">
                          {{ '  -  ' + item.timeComment }}</span
                        ></v-list-item-title
                      >
                      <v-list-item-subtitle class="font-weight-medium mt-2">{{
                        item.comment
                      }}</v-list-item-subtitle>
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
                            <v-img :src="child.image_user"></v-img>
                            <!-- {{ child.user.username.slice(0, 1).toUpperCase() }} -->
                          </v-list-item-avatar>
                          <v-list-item-content>
                            <v-list-item-title class="font-weight-bold mt-1"
                              >{{ child.user.username
                              }}<span class="caption">
                                {{ '  -  ' + child.timeComment }}</span
                              ></v-list-item-title
                            >
                            <v-list-item-subtitle
                              class="font-weight-medium mt-2"
                              ><span class="font-italic font-weight-bold">{{
                                child.user_reply
                                  ? '@' + child.user_reply.username + ': '
                                  : ''
                              }}</span>
                              {{ child.comment }}</v-list-item-subtitle
                            >
                            <v-list-item-subtitle v-if="child.isCommentUser"
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
                              @click="handleLikeComment(child, indexChild)"
                            >
                              <v-icon v-if="child.isLikeByUser" color="blue"
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
                v-show="commentMovies.length > 0 && lengthPanigation > 1"
                v-model="pageComments"
                :length="lengthPanigation"
                :total-visible="7"
              ></v-pagination>
            </v-tab-item>
            <!-- <v-tab-item>
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
              </v-row>
            </v-tab-item> -->
          </v-tabs-items>
        </v-col>
        <v-col cols="12" sm="4" lg="4" xl="4" md="4">
          <Recommend />
        </v-col>
      </v-row>
      <ChatBox />
      <v-bottom-sheet
        v-model="lookUpWordSheet"
        persistent
        no-click-animation
        hide-overlay
        eager
      >
        <v-sheet class="text-center" height="100px" width="100%">
          <v-btn
            class="mt-2"
            text
            small
            color="error"
            @click="lookUpWordSheet = !lookUpWordSheet"
          >
            Đóng
          </v-btn>
          <div v-if="cueActive && cueActive.arrayWord">
            <span
              v-for="word in cueActive.arrayWord"
              @click="lookUpWord(word, $event)"
              class="wordInLookUpSheet"
              v-html="word + ' '"
            >
            </span>
            <v-menu
              v-model="cardLookUp"
              offset-y
              :close-on-content-click="false"
              top
              :position-x="x"
              :position-y="y - 20"
            >
              <v-card class="mx-auto" width="250">
                <v-card-text>
                  <p class="text-h4 red--text">
                    {{ wordLookup.word }}
                  </p>
                  <div class="font-weight-bold">
                    <v-icon @click="speakWordLookup" color="error" small
                      >mdi-volume-high</v-icon
                    >
                    {{ `/${wordLookup.pronunciation}/` }}
                  </div>
                  <p>{{ wordLookup.partOfSpeech }}</p>
                  <div class="text--primary text-justify">
                    {{ wordLookup.definition }}
                  </div>
                </v-card-text>
                <v-card-actions class="d-flex justify-space-between">
                  <v-btn
                    @click="saveWordLookup"
                    small
                    text
                    :loading="loadingSaveWord"
                    :disabled="loadingSaveWord"
                    color="error accent-4"
                  >
                    Lưu
                  </v-btn>
                  <v-btn
                    @click="closeDialogLookup"
                    small
                    text
                    color="error accent-4"
                  >
                    Đóng
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-menu>
          </div>
        </v-sheet>
      </v-bottom-sheet>
    </v-card>
  </v-app>
</template>

<script>
import axios from 'axios'
import gql from 'graphql-tag'
import moment from 'moment'
import cookie from 'cookiejs'
import ChatBox from '~/components/ChatBot.vue'
import Recommend from '~/components/Recommend.vue'

export default {
  name: 'VideoPlay',
  components: {
    Recommend,
    ChatBox,
  },
  async asyncData({ route, params }) {
    const movieE = decodeURIComponent(route.query.code)
    const dataQuery = {}
    let dataEpisode = null
    dataQuery.code = decodeURIComponent(route.query.code)
    dataQuery.episode = route.query.ep

    await axios
      .get(
        `${process.env.URL_SERVER}/api/get-episode-movie/${decodeURIComponent(
          route.query.code
        )}/${route.query.ep}`,
        { dataQuery }
      )
      .then((response) => {
        if (response && response.data) {
          if (response.data.status) {
            dataEpisode = response.data.data
            // return { dataEpisode, movieE }
          } else {
            console.log(response)
          }
        }
      })
      .catch((error) => {
        console.log(error)
      })

    return { movieE, dataEpisode }
  },
  data() {
    return {
      isEndTimeTrial: false,
      userInfo: null,
      wordLookup: {
        word: '',
        pronunciation: '',
        definition: '',
        partOfSpeech: '',
      },
      errorMovie: {
        isErrorMovie: false,
        isErrorSub: false,
        noteError: '',
      },
      tabs: null,
      title: '',
      dialogSignIn: false,
      tabSignIn: 0,
      tabsSignIn: [
        { name: 'Đăng nhập', icon: 'mdi-account' },
        { name: 'Đăng ký', icon: 'mdi-television-box' },
      ],
      valid: true,
      signUpItem: {
        username: '',
        email: '',
        password: '',
        verify: '',
        oldPassword: '',
      },
      signInItem: {
        email: '',
        password: '',
      },
      loginEmailRules: [
        (v) => !!v || 'E-mail không được để trống',
        (v) => /.+@.+\..+/.test(v) || 'E-mail không hợp lệ',
      ],
      emailRules: [
        (v) => !!v || 'E-mail không được để trống',
        (v) => /.+@.+\..+/.test(v) || 'E-mail không hợp lệ',
      ],
      showPass: false,
      rules: {
        required: (value) => !!value || 'Mật khẩu không được để trống',
        min: (v) => (v && v.length >= 8) || 'Tối thiểu 8 kí tự',
      },
      menuOptionColorBackground: false,
      menuOptionColorSubEn: false,
      menuOptionColorSubVi: false,
      setupVideo: {
        changeCurrentTime: 5,
        speedMovie: 1,
        colorSubEn: '#ffff00',
        colorSubVi: '#ffffff',
        fontSize: 1,
        backgroundColor: {
          r: 0,
          g: 0,
          b: 0,
          a: 1,
        },
      },
      x: 0,
      y: 0,
      dialogSetup: false,
      dialogErrorMovie: false,
      colVideo: 8,
      cueActive: {},
      transcript: [],
      cardLookUp: false,
      lookUpWordSheet: false,
      currentCueIndex: -1,
      volume: 50,
      currentTime: 0,
      duration: 0,
      isLogin: null,
      isMuted: true,
      isPlaying: true,
      isPracticeListening: false,
      isShowMenuSubtitles: false,
      isShowTransScript: true,
      isHideSubViTranscript: false,
      isLoopCue: false,
      loadingSaveWord: false,
      menuSubtitles: [
        {
          code: 'off',
          label: 'Off Sub',
        },
        {
          code: 'en',
          label: 'English',
        },
        {
          code: 'vi',
          label: 'Vietnam',
        },
        {
          code: 'en-vi',
          label: 'English-Vietnam',
        },
        // {
        //   code: 'vi-en',
        //   label: 'Vietnam-English',
        // },
      ],
      selectedSubtitle: null,
      // offset: true,
      textTrack: '',
      isHoverVideo: false,
      showTextTrack: true,
      player: null,
      sources: [
        {
          src: 'https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv',
          type: 'video/mp4',
        },
      ],
      userID: {},
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
      movie: {
        id: null,
        code: null,
        name: '',
        name_en: '',
        year_of_manufacture: null,
        time: null,
        image: null,
        content: ``,
        country: {
          id: null,
          name: '',
        },
      },
      currentEpisode: {
        id: null,
        episode: '',
        url_movie: '',
        url_sub_en: '',
        url_sub_vi: '',
      },

      isLookingUp: false,
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
  async mounted() {
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

    await this.loadDataMovie()
    this.loadComment(true)
    const video = this.$refs.videoPlayer
    const videoWorks = !!document.createElement('video').canPlayType
    if (videoWorks) {
      console.log('Có hỗ trợ HTML5')
      video.controls = false
    }

    this.$refs.videoPlayer.addEventListener('loadedmetadata', this.setDuration)
    this.$refs.videoPlayer.addEventListener('timeupdate', this.setCurrentTime)
    this.selectedSubtitle = 'en'
    const textTrack = this.$refs.videoPlayer.textTracks[0]

    textTrack.mode = 'hidden'
    textTrack.addEventListener('cuechange', () => {
      const cues = textTrack.activeCues

      if (
        this.selectedSubtitle === 'en' ||
        this.selectedSubtitle === 'en-vi' ||
        this.selectedSubtitle === 'vi-en'
      ) {
        if (cues.length > 0) {
          this.cueActive = {}
          this.cueActive = cues[0]
          const textLookup = cues[0].text
          const replaceTagHTML = textLookup
            .replaceAll(/\n/g, ' ')
            .replace('<i>', '')
            .replace('</i>', '')
            .replaceAll('-', '')
          const stringSearch = replaceTagHTML.replace(
            /[&/\\#,+()$~%:*"?<>{}]/g,
            ' '
          )
          this.cueActive.arrayWord =
            stringSearch && stringSearch.length > 0
              ? stringSearch.split(' ')
              : []

          const styleSpan =
            this.$refs.subtitleTrackWrapperEN.querySelector('span')
          styleSpan.innerHTML = cues[0].text
          styleSpan.style.border = '1px solid black'
          styleSpan.style['border-radius'] = '5px'
          styleSpan.style.padding = '1px'
          styleSpan.style['font-weight'] = 'bold'
          styleSpan.style['text-align'] = 'center'
          styleSpan.style.color = this.setupVideo.colorSubEn
          styleSpan.style['background-color'] = this.viewRGBA(
            this.setupVideo.backgroundColor
          )
          styleSpan.style['font-size'] = `${this.setupVideo.fontSize}em`

          //
        }
      }
    })
    const textTrackVN = this.$refs.videoPlayer.textTracks[1]

    textTrackVN.mode = 'hidden'
    textTrackVN.addEventListener('cuechange', () => {
      if (
        this.selectedSubtitle === 'vi' ||
        this.selectedSubtitle === 'en-vi' ||
        this.selectedSubtitle === 'vi-en'
      ) {
        const cues = textTrackVN.activeCues
        if (cues.length > 0) {
          const styleSpan2 =
            this.$refs.subtitleTrackWrapperVN.querySelector('span')
          styleSpan2.innerHTML = cues[0].text
          styleSpan2.style.border = '1px solid black'
          styleSpan2.style['border-radius'] = '5px'
          styleSpan2.style.padding = '1px'
          styleSpan2.style['font-weight'] = 'bold'
          styleSpan2.style['text-align'] = 'center'
          styleSpan2.style.color = this.setupVideo.colorSubVi
          styleSpan2.style['background-color'] = this.viewRGBA(
            this.setupVideo.backgroundColor
          )
          styleSpan2.style['font-size'] = `${this.setupVideo.fontSize}em`
        }
      }
    })
  },
  created() {
    // eslint-disable-next-line nuxt/no-globals-in-created
    window.addEventListener('unload', async function (event) {
      await cookie.set(this.movie.code, this.currentTime)
    })
  },
  computed: {
    // compute field xài trên giao diện
    passwordMatch() {
      return () =>
        this.signUpItem.password === this.signUpItem.verify ||
        'Mật khẩu xác nhận không trùng với mật khẩu đã nhập'
    },
  },
  watch: {
    pageComments() {
      console.log(this.pageComments)
      this.offset = (this.pageComments - 1) * this.limit
      this.loadComment()
    },
    cueActive() {
      if (this.cueActive && this.cueActive.id) {
        const container = document.querySelector('#container-subtitle')
        if (container.childNodes && container.childNodes.length > 0) {
          //  eslint-disable-next-line no-unused-vars
          const targetElement = container.querySelector(
            `#cue-${this.cueActive.id}`
          )
          const distance = targetElement.offsetTop - container.offsetTop

          container.scrollTop = distance
        }
      }
    },
    isHoverVideo() {
      if (!this.isHoverVideo) {
        this.isShowMenuSubtitles = false
      }
    },
    isLoopCue() {
      if (this.isLoopCue) {
        if (
          this.cueActive &&
          this.$refs.videoPlayer.currentTime === this.cueActive.endTime
        ) {
          this.$refs.videoPlayer.currentTime = this.cueActive.startTime
        }
        console.log(this.cueActive)
      }
    },
    'setupVideo.speedMovie'() {
      this.$refs.videoPlayer.playbackRate = this.setupVideo.speedMovie
    },
  },
  methods: {
    openDialogError() {
      this.dialogErrorMovie = true
      this.errorMovie = {
        isErrorMovie: false,
        isErrorSub: false,
        noteError: '',
      }
    },
    viewRGBA(option) {
      return `rgba(${option.r},${option.g},${option.b},${option.a})`
    },
    setDuration() {
      const textTrack = this.$refs.videoPlayer.textTracks[0]
      const textTrackVN = this.$refs.videoPlayer.textTracks[1]
      this.duration = Math.floor(this.$refs.videoPlayer.duration)
      if (textTrack && textTrack.cues && textTrack.cues.length > 0) {
        for (let index = 0; index < textTrack.cues.length; index++) {
          const element = textTrack.cues[index]
          element.id = index + 1
          element.textVN = textTrackVN.cues[index].text
          this.transcript.push(element)
        }
      }
    },
    seekToTime() {
      this.$refs.videoPlayer.currentTime = this.currentTime
    },
    setCurrentTime() {
      if (
        (!this.isLogin ||
          !this.userInfo ||
          (this.isLogin && this.userInfo && !this.userInfo.is_active_vip)) &&
        this.$refs.videoPlayer.currentTime >= 300
      ) {
        this.isPlaying = false
        this.isEndTimeTrial = true
        this.$refs.videoPlayer.pause()
        return
      }
      this.currentTime = Math.floor(this.$refs.videoPlayer.currentTime)
      if (this.isLoopCue) {
        if (this.$refs.videoPlayer.currentTime >= this.cueActive.endTime) {
          this.$refs.videoPlayer.currentTime = this.cueActive.startTime
        }
      }
    },
    formatTime(time) {
      const minutes = Math.floor(time / 60)
      const seconds = Math.floor(time % 60)
      return `${this.padTime(minutes)}:${this.padTime(seconds)}`
    },
    padTime(time) {
      return time.toString().padStart(2, '0')
    },
    setVolume() {
      this.$refs.videoPlayer.volume = this.volume / 100
      if (this.$refs.videoPlayer.volume === 0) {
        this.isMuted = true
      } else {
        this.isMuted = false
      }
    },
    toggleMute() {
      if (this.isMuted) {
        this.$refs.videoPlayer.volume = this.volume / 100
        this.isMuted = false
      } else {
        this.$refs.videoPlayer.volume = 0
        this.isMuted = true
      }
    },
    togglePlayPause() {
      if (this.$refs.videoPlayer.paused) {
        this.isPlaying = true
        this.$refs.videoPlayer.play()
      } else {
        this.isPlaying = false
        this.$refs.videoPlayer.pause()
      }
    },
    toggleFullscreen() {
      const containerVideo = document.querySelector('.video-container')
      if (document.fullscreenElement) {
        // Nếu đã ở chế độ fullscreen, thoát fullscreen
        if (document.exitFullscreen) {
          document.exitFullscreen()
        }
      } else {
        // Nếu chưa ở chế độ fullscreen, vào fullscreen
        // eslint-disable-next-line no-lonely-if
        if (containerVideo.requestFullscreen) {
          containerVideo.requestFullscreen()
        }
      }
    },
    saveCouplet(item) {
      if (this.isLogin) {
        const queryMovie = gql(`
        query MyQuery {
        movie_couplets(where: { movie_id: {_eq: ${
          this.movie.id
        } }, user_id: {_eq: "${
          this.isLogin
        }"}, couplet: {_ilike: "%${item.text.replaceAll(
          /(\r\n|\n|\r)/gm,
          ''
        )}%"}, is_delete: {_eq: false} }){
          id
          movie_id
          user_id
          couplet
          meaning
          is_delete
        }

            }`)
        this.$apollo
          .query({
            query: queryMovie,

            fetchPolicy: 'network-only',
          })
          .then((response) => {
            // Đã lưu
            if (
              response.data.movie_couplets &&
              response.data.movie_couplets.length > 0
            ) {
              this.snackbar = true
              this.textSnackbar = 'Cặp câu đã được lưu'
            } else {
              const itemInsert = {}
              itemInsert.movie_id = this.movie.id
              itemInsert.user_id = this.isLogin
              itemInsert.meaning = item.textVN
              itemInsert.couplet = item.text
              itemInsert.is_delete = false
              const insertGraphl = gql`
                mutation MyMutation($objects: [movie_couplets_insert_input!]!) {
                  insert_movie_couplets(
                    objects: $objects
                    on_conflict: {
                      constraint: movie_couplets_user_id_couplet_key
                      update_columns: [is_delete]
                    }
                  ) {
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
                update: (store, { data: { insert_movie_couplets } }) => {
                  // eslint-disable-next-line camelcase
                  if (insert_movie_couplets.affected_rows) {
                    this.textSnackbar = 'Lưu cặp câu thành công'
                    this.snackbar = true
                  } else {
                    this.textSnackbar = 'Lưu cặp câu thất bại'
                    this.snackbar = true
                  }
                },
              })
            }
          })
          .catch((response) => console.log(response))
      } else {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng đăng nhập để thực hiện chức năng này'
      }
      const itemPush = {}
      itemPush.color = '#' + Math.floor(Math.random() * 16777215).toString(16)
      itemPush.coupletVi = item.textVN
      itemPush.coupletEng = item.text
      if (localStorage.getItem('couplet')) {
        const arrayCouplet = JSON.parse(localStorage.getItem('couplet'))
        arrayCouplet.push(itemPush)
        localStorage.setItem('couplet', JSON.stringify(arrayCouplet))
      } else {
        localStorage.setItem('couplet', JSON.stringify([itemPush]))
      }
    },
    saveWordLookup() {
      if (this.isLogin) {
        this.loadingSaveWord = true
        const queryWord = gql(`
        query MyQuery {
          movie_words(where: { user_id: {_eq: "${this.isLogin}"}, word_id: {_eq: ${this.wordLookup.id}}, is_delete: {_eq: false} }){
            id
            movie_id
            user_id
            is_delete
          }
        }`)
        this.$apollo
          .query({
            query: queryWord,

            fetchPolicy: 'network-only',
          })
          .then((response) => {
            // Đã lưu
            if (
              response.data.movie_words &&
              response.data.movie_words.length > 0
            ) {
              this.snackbar = true
              this.textSnackbar = 'Từ đã được lưu trước đó'
              this.loadingSaveWord = false
            } else {
              const itemInsert = {}
              itemInsert.movie_id = this.movie.id
              itemInsert.user_id = this.isLogin
              itemInsert.word_id = this.wordLookup.id
              itemInsert.is_delete = false
              const insertGraphl = gql`
                mutation MyMutation($objects: [movie_words_insert_input!]!) {
                  insert_movie_words(objects: $objects) {
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
                update: (store, { data: { insert_movie_words } }) => {
                  // eslint-disable-next-line camelcase
                  if (insert_movie_words.affected_rows) {
                    this.textSnackbar = 'Lưu từ thành công'
                    this.snackbar = true
                    this.loadingSaveWord = false
                  } else {
                    this.textSnackbar = 'Lưu từ thất bại'
                    this.snackbar = true
                    this.loadingSaveWord = false
                  }
                },
              })
            }
          })
          .catch((response) => console.log(response))
      } else {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng đăng nhập để thực hiện chức năng này'
      }
    },
    closeDialogLookup() {
      this.wordLookup = {
        word: '',
        pronunciation: '',
        definition: '',
        partOfSpeech: '',
      }
      this.$refs.videoPlayer.play()
      this.cardLookUp = false
    },
    async lookUpWord(word, event) {
      if (this.isLookingUp) {
        this.snackbar = true
        this.textSnackbar =
          'Hệ thống đang tiến hành tra từ vui lòng đợi tí nhé !!'
        return
      }
      this.cardLookUp = false
      this.x = event.clientX
      this.y = event.clientY
      let dataWord = null
      if (this.$refs.videoPlayer.paused) {
        // this.isPlaying = true
        // this.$refs.videoPlayer.play()
      } else {
        this.isPlaying = false
        this.$refs.videoPlayer.pause()
      }
      const stringSearch = word.replace(/[&/\\#,+().$~%:*"?<>{}]/g, '')

      if (word && word.length !== 0) {
        this.isLookingUp = true
        const queryWord = gql(`query MyQuery {
                dictionaries(where: {word : {_eq: "${stringSearch}"}}){
                  id
                  word
                  pronunciation
                  type
                  meaning
                  example
                }
        }`)
        await this.$apollo
          .query({
            query: queryWord,
            fetchPolicy: 'network-only',
          })
          .then((response) => {
            if (
              response.data.dictionaries &&
              response.data.dictionaries.length > 0
            ) {
              dataWord = response.data.dictionaries[0]
            } else {
              //
            }
          })
          .catch((response) => console.log(response))
        if (dataWord) {
          this.isLookingUp = false
          this.wordLookup = {
            id: null,
            word: '',
            pronunciation: '',
            definition: '',
            partOfSpeech: '',
          }
          this.wordLookup.id = dataWord.id
          this.wordLookup.word = dataWord.word
          this.wordLookup.pronunciation = dataWord.pronunciation
          this.wordLookup.definition = dataWord.meaning
          this.wordLookup.partOfSpeech = dataWord.type
          this.cardLookUp = true
          if ('speechSynthesis' in window) {
            // Tạo một instance của SpeechSynthesisUtterance
            const utterance = new SpeechSynthesisUtterance()

            // Thiết lập ngôn ngữ và nội dung cần đọc
            utterance.lang = 'en-US' // Ngôn ngữ tiếng Anh
            utterance.text = dataWord.word // Nội dung cần đọc

            // Gọi phương thức speechSynthesis.speak() để đọc nội dung
            window.speechSynthesis.speak(utterance)
          } else {
            console.error('Trình duyệt không hỗ trợ API Web Speech.')
          }
        } else {
          try {
            await axios
              .post(`${process.env.URL_SERVER}/chatbot/look-up-word`, {
                message: `Cho biết các thông tin sau của từ "${stringSearch}",
            trả lời theo cấu trúc json:
            {
              word: Từ cần tra ,
              pronunciation: Phiên âm từ,
              description: Mô tả ý nghĩa (tiếng Việt),
              example: Ví dụ một câu có sử dụng từ (tiếng Anh),
              type: Loại từ (tiếng Anh)
            },
         ,`,
              })
              .then((response) => {
                this.isLookingUp = false
                if (response && response.data) {
                  if (response.data.status) {
                    dataWord = response.data.data[0]
                    this.wordLookup = {
                      id: null,
                      word: '',
                      pronunciation: '',
                      definition: '',
                      partOfSpeech: '',
                    }
                    this.wordLookup.id = dataWord.id
                    this.wordLookup.word = dataWord.word
                    this.wordLookup.pronunciation = dataWord.pronunciation

                    this.wordLookup.definition = dataWord.meaning
                    this.wordLookup.partOfSpeech = dataWord.type
                    this.cardLookUp = true
                    if ('speechSynthesis' in window) {
                      // Tạo một instance của SpeechSynthesisUtterance
                      const utterance = new SpeechSynthesisUtterance()

                      // Thiết lập ngôn ngữ và nội dung cần đọc
                      utterance.lang = 'en-US' // Ngôn ngữ tiếng Anh
                      utterance.text = dataWord.word // Nội dung cần đọc
                      console.log('GỌi NÈ')
                      // Gọi phương thức speechSynthesis.speak() để đọc nội dung
                      window.speechSynthesis.speak(utterance)
                    } else {
                      console.error('Trình duyệt không hỗ trợ API Web Speech.')
                    }
                  } else {
                    this.snackbar = true
                    this.textSnackbar =
                      'Có lỗi xảy ra trong quá trình tra từ ! Vui lòng thử lại'
                  }
                } else {
                  this.snackbar = true
                  this.textSnackbar =
                    'Có lỗi xảy ra trong quá trình tra từ ! Vui lòng thử lại'
                }
              })
              .catch((error) => {
                this.isLookingUp = false
                console.log(error)
                this.snackbar = true
                this.textSnackbar =
                  'Có lỗi xảy ra trong quá trình tra từ ! Vui lòng thử lại'
              })
          } catch (error) {
            this.isLookingUp = false
            console.error(error)
            this.wordLookup = {
              word,
              pronunciation: '',
              definition: 'Unknown',
              partOfSpeech: '',
            }
            this.cardLookUp = true
            if ('speechSynthesis' in window) {
              // Tạo một instance của SpeechSynthesisUtterance
              const utterance = new SpeechSynthesisUtterance()

              // Thiết lập ngôn ngữ và nội dung cần đọc
              utterance.lang = 'en-US' // Ngôn ngữ tiếng Anh
              utterance.text = word // Nội dung cần đọc
              // Gọi phương thức speechSynthesis.speak() để đọc nội dung
              window.speechSynthesis.speak(utterance)
            } else {
              console.error('Trình duyệt không hỗ trợ API Web Speech.')
            }
          }
        }
        // const optionsEng = {
        //   method: 'GET',
        //   url: `https://wordsapiv1.p.rapidapi.com/words/${stringSearch}`,
        //   headers: {
        //     'X-RapidAPI-Key':
        //       'fbbcdfe519msha9eaa36f2d2be6dp1fa690jsnb3d27daa66d1',
        //     'X-RapidAPI-Host': 'wordsapiv1.p.rapidapi.com',
        //   },
        // }
        // const responseEng = await axios.request(optionsEng)
        // if (responseEng && responseEng.data) {
        //   this.wordLookup = {
        //     word: '',
        //     pronunciation: '',
        //     definition: '',
        //     partOfSpeech: '',
        //   }
        //   const elementEng = responseEng.data
        //   this.wordLookup.word = elementEng.word
        //   this.wordLookup.pronunciation = elementEng.pronunciation.all
        //     ? elementEng.pronunciation.all
        //     : elementEng.pronunciation
        //   if (elementEng.results && elementEng.results.length > 0) {
        //     this.wordLookup.definition = elementEng.results[0].definition
        //     this.wordLookup.partOfSpeech = elementEng.results[0].partOfSpeech
        //   } else {
        //     this.wordLookup.definition = 'Unknown'
        //     this.wordLookup.partOfSpeech = ''
        //   }

        //   this.cardLookUp = true
        //   if ('speechSynthesis' in window) {
        //     // Tạo một instance của SpeechSynthesisUtterance
        //     const utterance = new SpeechSynthesisUtterance()

        //     // Thiết lập ngôn ngữ và nội dung cần đọc
        //     utterance.lang = 'en-US' // Ngôn ngữ tiếng Anh
        //     utterance.text = elementEng.word // Nội dung cần đọc

        //     // Gọi phương thức speechSynthesis.speak() để đọc nội dung
        //     window.speechSynthesis.speak(utterance)
        //   } else {
        //     console.error('Trình duyệt không hỗ trợ API Web Speech.')
        //   }
        //   // const optionsVN = {
        //   //   method: 'POST',
        //   //   url: 'https://microsoft-translator-text.p.rapidapi.com/translate',
        //   //   params: {
        //   //     // to: 'vi',
        //   //     'api-version': '3.0',
        //   //     'to[0]': 'vi',
        //   //     profanityAction: 'NoAction',
        //   //     textType: 'plain',
        //   //     // from: 'en',
        //   //   },
        //   //   headers: {
        //   //     'content-type': 'application/json',
        //   //     'X-RapidAPI-Key':
        //   //       'fbbcdfe519msha9eaa36f2d2be6dp1fa690jsnb3d27daa66d1',
        //   //     'X-RapidAPI-Host': 'microsoft-translator-text.p.rapidapi.com',
        //   //   },
        //   //   data: [
        //   //     {
        //   //       Text: stringSearch,
        //   //     },
        //   //   ],
        //   // }
        // }
      }
    },
    speakWordLookup() {
      if ('speechSynthesis' in window) {
        // Tạo một instance của SpeechSynthesisUtterance
        const utterance = new SpeechSynthesisUtterance()

        // Thiết lập ngôn ngữ và nội dung cần đọc
        utterance.lang = 'en-US' // Ngôn ngữ tiếng Anh
        utterance.text = this.wordLookup.word // Nội dung cần đọc

        // Gọi phương thức speechSynthesis.speak() để đọc nội dung
        window.speechSynthesis.speak(utterance)
      } else {
        console.error('Trình duyệt không hỗ trợ API Web Speech.')
      }
    },
    moveToScript(item) {
      if (item.startTime) {
        this.$refs.videoPlayer.currentTime = item.startTime
      }
    },
    showLookUpWordSheet() {
      this.lookUpWordSheet = !this.lookUpWordSheet
    },
    hideShowMenuSubtitles() {
      this.isShowMenuSubtitles = !this.isShowMenuSubtitles
    },
    hidePracticeListening() {
      if (this.isPracticeListening) {
        //
        this.isPracticeListening = false
        this.selectedSubtitle = 'en'
        this.lookUpWordSheet = false
        this.isShowTransScript = true
        this.colVideo = 8
      } else {
        this.isPracticeListening = true
        this.selectedSubtitle = 'off'
        this.lookUpWordSheet = false
        this.isShowTransScript = false
        this.colVideo = 8
      }
    },
    plusSpeedMovie() {
      this.setupVideo.speedMovie = Number(this.setupVideo.speedMovie) + 0.25
    },
    minusSpeedMovie() {
      this.setupVideo.speedMovie = Number(this.setupVideo.speedMovie) - 0.25
    },
    plusFontSizeMovie() {
      this.setupVideo.fontSize = Number(this.setupVideo.fontSize) + 0.3
    },
    minusFontSizeMovie() {
      this.setupVideo.fontSize = Number(this.setupVideo.fontSize) - 0.3
    },
    getDefaultSetup() {
      this.setupVideo = {
        speedMovie: 1,
        colorSubEn: '#ffff00',
        colorSubVi: '#ffffff',
        fontSize: 1,
        backgroundColor: {
          r: 0,
          g: 0,
          b: 0,
          a: 1,
        },
      }
      this.isShowTransScript = true
      this.isHideSubViTranscript = false
      this.selectedSubtitle = 'en'
      this.dialogSetup = false
    },
    setupMovie() {},
    getOptionSubtitle(index) {},
    sendErrorMovie() {
      if (
        !this.errorMovie.isErrorMovie &&
        !this.errorMovie.isErrorSub &&
        this.errorMovie.noteError === ''
      ) {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng cung cấp lỗi cho chúng tôi ! Xin cảm ơn'
      } else {
        const itemInsert = {}
        itemInsert.movie_id = this.movie.id
        if (this.isLogin) {
          itemInsert.user_id = this.isLogin
        }
        itemInsert.is_error_movie = this.errorMovie.isErrorMovie
        itemInsert.is_error_subtitle = this.errorMovie.isErrorSub
        itemInsert.note = this.errorMovie.noteError
        const insertGraphl = gql`
          mutation MyMutation($objects: [error_logs_insert_input!]!) {
            insert_error_logs(objects: $objects) {
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
          update: (store, { data: { insert_error_logs } }) => {
            // eslint-disable-next-line camelcase
            if (insert_error_logs.affected_rows) {
              this.textSnackbar =
                'Cảm ơn bạn đã báo lỗi ! Hệ thống sẽ khắc phục trong thời gian sớm nhất !'
              this.snackbar = true
              this.dialogErrorMovie = false
            } else {
              this.textSnackbar = 'Báo lỗi thất bại'
              this.snackbar = true
              this.dialogErrorMovie = false
            }
          },
        })
      }
    },
    rewindVideo() {
      this.$refs.videoPlayer.pause()
      this.$refs.videoPlayer.currentTime -= this.setupVideo.changeCurrentTime
      this.$refs.videoPlayer.play()
    },
    forwardVideo() {
      this.$refs.videoPlayer.pause()
      this.$refs.videoPlayer.currentTime =
        this.$refs.videoPlayer.currentTime + this.setupVideo.changeCurrentTime
      this.$refs.videoPlayer.play()
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
    async toLinkWatch(item) {
      console.log(this.$router.currentRoute)
      if (
        this.$router.currentRoute.query.ep &&
        Number(this.$router.currentRoute.query.ep) === item.episode
      ) {
        this.snackbar = true
        this.textSnackbar = 'Bạn đang xem tập này'
        return
      }
      const currentRoute = this.$router.currentRoute
      const updatedQuery = { code: this.movie.code, ep: item.episode }

      await this.$router.replace({
        path: currentRoute.path,
        query: updatedQuery,
      })
      window.location.reload()
    },
    async loginUser() {
      if (this.signInItem.email === '') {
        this.$toast.error('Vui lòng nhập email', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }
      if (this.signInItem.password === '') {
        this.$toast.error('Vui lòng nhập mật khẩu', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }

      // eslint-disable-next-line camelcase
      const data_login = {
        email: this.signInItem.email,
        password: this.signInItem.password,
      }
      await axios
        .post(
          `${process.env.URL_SERVER}/account/login-user`,
          // eslint-disable-next-line camelcase
          { data_login },
          {
            // eslint-disable-next-line camelcase
            headers: {
              'Content-Type': 'application/json',
            },
            withCredentials: true,
          }
        )
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              // cookie.set('jwt-login', response.data.data.token, 1)
              this.dialogSignIn = false
              this.$toast.success('Đăng nhập thành công', {
                duration: 2000,
                position: 'top-center',
              })
              localStorage.setItem('user_id', response.data.data.id)
              setTimeout(() => {
                window.location.href = `${process.env.URL_CLIENT}/user/buy_point`
              }, 2000)
            } else {
              this.$toast.error(`${response.data.message}`, {
                duration: 2000,
                position: 'top-center',
              })
              this.isLogin = false
            }
          }
        })
        .catch((error) => {
          console.log(error)
          this.$toast.error('Có lỗi xảy trong quá trình đăng nhập', {
            duration: 2000,
            position: 'top-center',
          })
          this.isLogin = false
        })
    },
    async registerUser() {
      if (this.signUpItem.username === '') {
        this.$toast.error('Vui lòng nhập tên người dùng', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }
      if (this.signUpItem.email === '') {
        this.$toast.error('Vui lòng nhập email', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }
      if (this.signUpItem.password === '') {
        this.$toast.error('Vui lòng nhập mật khẩu', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }
      if (this.signUpItem.verify === '') {
        this.$toast.error('Vui lòng nhập xác nhận mật khẩu', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }
      if (
        this.signUpItem.password !== '' &&
        this.signUpItem.verify !== '' &&
        this.signUpItem.password !== this.signUpItem.verify
      ) {
        this.$toast.error('Mật khẩu và xác nhận mật khẩu không trùng khớp', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }
      // eslint-disable-next-line camelcase
      const data_insert = {
        username: this.signUpItem.username,
        email: this.signUpItem.email,
        password: this.signUpItem.password,
      }
      await axios
        .post(`${process.env.URL_SERVER}/api/insert-user`, {
          // eslint-disable-next-line camelcase
          data_insert,
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              this.dialogSignIn = false
              this.$toast.success('Đăng ký thành công', {
                duration: 2000,
                position: 'top-center',
              })
              this.tabSignIn = 0
            } else {
              this.$toast.error(`${response.data.message}`, {
                duration: 2000,
                position: 'top-center',
              })
              this.isLogin = false
            }
          }
        })
        .catch((error) => {
          console.log(error)
          this.$toast.error('Có lỗi xảy trong quá trình đăng ký', {
            duration: 2000,
            position: 'top-center',
          })
          this.isLogin = false
        })
    },
    openDialogSignIn() {
      this.dialogSignIn = true
      this.$refs.formLogin.resetValidation()
      this.$refs.formRegister.resetValidation()
    },
    loginUserWithGoogle() {
      window.location.href = `${process.env.URL_SERVER}/auth/google`
    },
    activeVIP() {
      if (!this.isLogin || !this.userInfo) {
        this.openDialogSignIn()
      } else {
        this.$router.push('/user/buy_point')
      }
    },
  },
  beforeDestroy() {
    this.$refs.videoPlayer.removeEventListener(
      'loadedmetadata',
      this.setDuration
    )
    this.$refs.videoPlayer.removeEventListener(
      'timeupdate',
      this.setCurrentTime
    )

    const textTrack = this.$refs.videoPlayer.textTracks[0]
    textTrack.removeEventListener('cuechange', () => {
      const cues = textTrack.activeCues
      if (cues.length > 0) {
        const styleSpan =
          this.$refs.subtitleTrackWrapperEN.querySelector('span')
        styleSpan.innerHTML = cues[0].text
        styleSpan.style.border = '1px solid black'
        styleSpan.style['border-radius'] = '5px'
        styleSpan.style.padding = '1px'
        styleSpan.style.color = 'yellow'
        // styleSpan.style.display = 'flex'
        styleSpan.style['background-color'] = 'black'
        styleSpan.style['font-size'] = '20px'
        styleSpan.style['font-weight'] = 'bold'
        styleSpan.style['text-align'] = 'center'
        //

        const styleSpan2 =
          this.$refs.subtitleTrackWrapperVN.querySelector('span')
        styleSpan2.innerHTML = cues[0].text
        styleSpan2.style.border = '1px solid black'
        styleSpan2.style['border-radius'] = '5px'
        styleSpan2.style.padding = '1px'
        styleSpan2.style.color = 'white'
        // styleSpan.style.display = 'flex'
        styleSpan2.style['background-color'] = 'black'
        styleSpan2.style['font-size'] = '20px'
        styleSpan2.style['font-weight'] = 'bold'
        styleSpan2.style['text-align'] = 'center'
      }
    })

    const textTrackVN = this.$refs.videoPlayer.textTracks[1]
    textTrackVN.removeEventListener('cuechange', () => {
      const cues = textTrackVN.activeCues
      if (cues.length > 0) {
        const styleSpan2 =
          this.$refs.subtitleTrackWrapperVN.querySelector('span')
        styleSpan2.innerHTML = cues[0].text
        styleSpan2.style.border = '1px solid black'
        styleSpan2.style['border-radius'] = '5px'
        styleSpan2.style.padding = '1px'
        styleSpan2.style.color = 'white'
        // styleSpan.style.display = 'flex'
        styleSpan2.style['background-color'] = 'black'
        styleSpan2.style['font-size'] = '20px'
        styleSpan2.style['font-weight'] = 'bold'
        styleSpan2.style['text-align'] = 'center'
      }
    })
  },
  apollo: {},
}
</script>
<style scoped>
.v-ripple__container {
  opacity: 0 !important;
}

/* Thanh thời lượng */
.time-display {
  font-weight: bold;
  color: white;
}
.custom-slider .v-slider__track-container {
  height: 15px !important;
}
.custom-slider .v-slider__track {
  height: 15px !important;
}
.custom-slider .v-slider__thumb:before {
  opacity: 0 !important;
}

.custom-slider .v-slider__thumb {
  cursor: pointer;
  width: 24px; /* Chỉnh kích thước chiều ngang */
  height: 24px; /* Chỉnh kích thước chiều dọc */
}
/* Thanh volume */
.custom-volume .v-slider__track-container {
  height: 15px !important;
  width: 100px;
}
.custom-volume .v-slider__track {
  height: 15px !important;
}
.custom-volume .v-slider .v-slider__thumb {
  display: none;
}

.video-container {
  position: relative;
  width: 100%;
}

video {
  width: 100%;
  height: auto;
}

.subtitles-container {
  position: absolute;
  bottom: 1%;
  left: 0;
  width: 100%;
  color: white;
}
.subtitle-row {
  justify-content: center;
  text-align: center;
  padding: 5px;
}
.subtitle-eng {
  text-align: center;
}

.subtitle-vn {
  margin-bottom: 15px;
}
.control-row {
  background-color: rgba(0, 0, 0, 0.2);
  max-height: 50px;
  justify-content: center;
  margin-bottom: 0px;
}
.overlay-movie {
  background-color: rgba(0, 0, 0, 0.8);
  min-height: 100vh;
  justify-content: center;
  align-items: center;
  text-align: center;

  /* margin-bottom: 0px; */
}
.highlighted {
  font-weight: bold;
  color: #ff0000; /* Màu hoặc kiểu đánh dấu tùy thuộc vào ý muốn của bạn */
}
.cueActiveTranscript {
  background-color: rgba(255, 82, 82, 0.5);
}
.cueHoverTranscript:hover {
  cursor: pointer;
  background-color: rgba(255, 82, 82, 0.5);
}
.wordInLookUpSheet {
  cursor: pointer;
  font-size: 25px;
}
.wordInLookUpSheet:hover {
  color: rgba(255, 82, 82);
}
.menu-subtitle {
  padding: 10px;
  position: absolute;
  bottom: 60%;
  right: 5%;
  background-color: rgba(0, 0, 0, 0.2);
  align-items: center;
}
.item-menu-subtitle {
  color: white;
  margin-top: -15px;
}
.centered-input >>> input {
  text-align: center;
}
.time-input >>> input {
  text-align: center;
  width: 50px !important;
}
.time-input >>> input[type='number'] {
  -moz-appearance: textfield;
}
.time-input >>> input::-webkit-outer-spin-button,
.time-input >>> input::-webkit-inner-spin-button {
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
}
.custom-checkbox {
  font-size: 15px;
}
</style>
