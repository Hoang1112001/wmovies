<!-- eslint-disable vue/valid-v-for -->
<template>
  <v-container fluid>
    <v-snackbar v-model="snackbar">
      {{ textSnackbar }}
      <template v-slot:action="{ attrs }">
        <v-btn color="pink" text v-bind="attrs" @click="snackbar = false">
          Close
        </v-btn>
      </template>
    </v-snackbar>
    <v-dialog v-model="dialogSave" width="unset">
      <v-card>
        <v-card-title class="h5 red--text">
          Bạn có muốn lưu không?</v-card-title
        >
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="dialogSave = false">Không</v-btn>
          <v-btn color="error" text @click="save()">Có</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialogDeleteEpisode" width="unset">
      <v-sheet outlined color="error" rounded>
        <v-card>
          <v-card-title class="h5 red--text"
            >Bạn có chắc muốn xóa tập phim này không?</v-card-title
          >
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="error" text @click="closeDelete">Không</v-btn>
            <v-btn color="error" text @click="deleteEpisodeConfirm">Có</v-btn>
            <v-spacer></v-spacer>
          </v-card-actions>
        </v-card>
      </v-sheet>
    </v-dialog>
    <v-dialog v-model="dialogEditEpisode" max-width="500">
      <v-card>
        <v-card-text>
          <v-row class="pa-5 mx-auto">
            <v-col cols="12" sm="12" lg="12" xl="12" md="12">
              <p class="font-weight-medium red--text">
                CHỈNH SỬA THÔNG TIN TẬP PHIM
              </p>
            </v-col>

            <v-col
              cols="12"
              sm="12"
              lg="12"
              xl="12"
              md="12"
              style="margin-top: -20px"
            >
              <v-text-field
                v-model="editedEpisode.episode"
                label="Tập"
                outlined
                dense
              ></v-text-field>
            </v-col>

            <v-col
              cols="12"
              sm="12"
              lg="12"
              xl="12"
              md="12"
              style="margin-top: -20px"
            >
              <v-text-field
                v-model="editedEpisode.url_movie"
                label="URL Phim"
                outlined
                dense
              ></v-text-field>
            </v-col>

            <v-col
              cols="12"
              sm="12"
              lg="12"
              xl="12"
              md="12"
              style="margin-top: -20px"
            >
              <v-text-field
                v-model="editedEpisode.url_sub_en"
                label="URL phụ đề tiếng Anh"
                outlined
                dense
              ></v-text-field>
            </v-col>

            <v-col
              cols="12"
              sm="12"
              lg="12"
              xl="12"
              md="12"
              style="margin-top: -20px"
            >
              <v-text-field
                v-model="editedEpisode.url_sub_vi"
                label="URL phụ đề tiếng Việt"
                outlined
                dense
              ></v-text-field>
            </v-col> </v-row
        ></v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="dialogEditEpisode = false">
            Đóng
          </v-btn>
          <v-btn color="error" text @click="saveEditEpisode"> Lưu </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-card>
      <v-toolbar flat class="mb-2">
        <v-tooltip bottom>
          <template #activator="{ on, attrs }">
            <v-btn icon v-bind="attrs" v-on="on" @click="backToList()">
              <v-icon>mdi-arrow-left</v-icon>
            </v-btn>
          </template>
          <span>Quay lại danh sách phim</span>
        </v-tooltip>

        <v-toolbar-title v-if="isEdit" class="red--text font-weight-bold">{{
          `Chỉnh sửa phim: ${title_name}`
        }}</v-toolbar-title>
        <v-toolbar-title v-if="!isEdit" class="red--text font-weight-bold">{{
          `Thêm mới phim `
        }}</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn tile color="error" :disabled="!valid" @click="openDialogSave">
          <v-icon color="white" left>mdi-content-save</v-icon>
          Lưu
        </v-btn>
      </v-toolbar>
      <v-row class="px-3 mt-2">
        <v-tabs background-color="error" dark no-animation>
          <v-tab>THÔNG TIN PHIM</v-tab>
          <v-tab>THÔNG TIN TẬP PHIM</v-tab>

          <v-tab-item
            v-for="n in 2"
            :key="n"
            :transition="false"
            :reverse-transition="false"
          >
            <v-container fluid style="background-color: white">
              <v-row v-if="n == 1" style="background-color: white">
                <v-col cols="12" sm="3" lg="3" xl="3" md="3">
                  <v-text-field
                    v-model="movie.code"
                    outlined
                    disabled
                    dense
                    label="Mã phim"
                    class="required"
                    color="red"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="3" lg="3" xl="3" md="3">
                  <v-text-field
                    v-model="movie.name"
                    outlined
                    dense
                    label="Tên phim"
                    class="required"
                    color="red"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="3" lg="3" xl="3" md="3">
                  <v-text-field
                    v-model="movie.name_en"
                    outlined
                    dense
                    label="Tên phim (tiếng Anh)"
                    class="required"
                    color="red"
                    @change="parseCodeMovie"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="3" lg="3" xl="3" md="3">
                  <v-text-field
                    v-model="movie.time"
                    type="number"
                    outlined
                    dense
                    label="Thời lượng"
                    class="required"
                    color="red"
                    suffix="phút/tập"
                    @change="checkTimeMovie"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="2" lg="2" xl="2" md="2">
                  <!-- <v-menu
                    v-model="menu2"
                    :close-on-content-click="false"
                    :nudge-right="100"
                    transition="scale-transition"
                    offset-y
                    min-width="auto"
                  >
                 
                    <template #activator="{ on, attrs }">
                      <v-text-field
                        v-model="yearFormatted"
                        outlined
                        dense
                        label="Năm sản xuất"
                        maxlength="4"
                        hint="Năm (VD: 2023)"
                        class="required"
                        color="red"
                        style="margin-top: -20px"
                      >
                        <template #append-outer>
                          <v-btn
                            class="mt-n2"
                            elevation="1"
                            fab
                            small
                            v-bind="attrs"
                            v-on="on"
                          >
                            <v-icon>mdi-calendar-month-outline</v-icon>
                          </v-btn>
                        </template></v-text-field
                      >
                    </template>
                  <v-date-picker
                      v-model="movie.year_of_manufacture"
                      @input="menu2 = false"
                    ></v-date-picker> 
                  </v-menu> -->
                  <v-text-field
                    v-model="movie.year_of_manufacture"
                    outlined
                    dense
                    type="number"
                    label="Năm sản xuất"
                    maxlength="4"
                    hint="Năm (VD: 2023)"
                    class="required"
                    color="red"
                    @change="checkYearMovie"
                    style="margin-top: -20px"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="3" lg="3" xl="3" md="3">
                  <v-autocomplete
                    style="margin-top: -20px"
                    v-model="movie.country"
                    label="Quốc gia"
                    :items="countries"
                    item-text="name"
                    item-value="code"
                    return-object
                    class="required"
                    color="red"
                    outlined
                    dense
                  ></v-autocomplete>
                </v-col>
                <v-col cols="12" sm="3" lg="3" xl="3" md="3">
                  <v-autocomplete
                    style="margin-top: -20px"
                    v-model="movie.movie_status"
                    label="Trạng thái phim"
                    :items="movie_status"
                    item-text="name"
                    item-value="code"
                    class="required"
                    color="red"
                    outlined
                    dense
                  ></v-autocomplete>
                </v-col>
                <v-col cols="12" sm="3" lg="3" xl="3" md="3">
                  <v-autocomplete
                    style="margin-top: -20px"
                    v-model="movie.movie_type"
                    label="Loại phim"
                    :items="movie_types"
                    item-text="name"
                    item-value="code"
                    class="required"
                    color="red"
                    outlined
                    dense
                  ></v-autocomplete>
                </v-col>
                <v-col
                  v-if="movie.movie_type === 'series'"
                  cols="12"
                  style="margin-top: -20px"
                  sm="1"
                  lg="1"
                  xl="1"
                  md="1"
                >
                  <v-text-field
                    v-model="movie.total_episode"
                    type="number"
                    outlined
                    dense
                    label="Số tập"
                    @change="checkEpMovie"
                  >
                  </v-text-field>
                </v-col>
                <v-col
                  cols="12"
                  style="margin-top: -20px"
                  sm="6"
                  lg="6"
                  xl="6"
                  md="6"
                >
                  <v-textarea
                    v-model="movie.content"
                    outlined
                    auto-grow
                    rows="4"
                    name="input-7-4"
                    color="error"
                    class="required"
                    label="Giới thiệu phim"
                  ></v-textarea>
                </v-col>
                <v-col
                  cols="12"
                  style="margin-top: -20px"
                  sm="6"
                  lg="6"
                  xl="6"
                  md="6"
                >
                  <v-autocomplete
                    v-model="movie_categories"
                    :items="categories"
                    dense
                    outlined
                    chips
                    class="required"
                    color="error"
                    label="Thể loại"
                    item-text="name"
                    item-value="name"
                    return-object
                    multiple
                  >
                    <template v-slot:selection="data">
                      <v-chip
                        v-bind="data.attrs"
                        :input-value="data.selected"
                        close
                        @click="data.select"
                        @click:close="removeCategory(data.item)"
                      >
                        {{ data.item.name }}
                      </v-chip>
                    </template>
                    <template v-slot:item="data">
                      <v-list-item-content>
                        <v-list-item-title
                          >{{ data.item.name }}
                        </v-list-item-title>
                      </v-list-item-content>
                    </template>
                  </v-autocomplete>
                  <v-autocomplete
                    v-model="movie_actors"
                    :items="actors"
                    dense
                    outlined
                    chips
                    class="required"
                    color="error"
                    label="Diễn viên"
                    item-text="name"
                    item-value="name"
                    return-object
                    multiple
                  >
                    <template v-slot:selection="data">
                      <v-chip
                        v-bind="data.attrs"
                        :input-value="data.selected"
                        close
                        @click="data.select"
                        @click:close="removeActor(data.item)"
                      >
                        <v-avatar left>
                          <v-img
                            v-show="data.item.url"
                            :src="data.item.url"
                          ></v-img>
                        </v-avatar>
                        {{ data.item.name }}
                      </v-chip>
                    </template>
                    <template v-slot:item="data">
                      <v-list-item-avatar>
                        <v-img
                          v-show="data.item.url"
                          :src="data.item.url"
                        ></v-img>
                      </v-list-item-avatar>
                      <v-list-item-content>
                        <v-list-item-title
                          >{{ data.item.name }}
                        </v-list-item-title>
                      </v-list-item-content>
                    </template>
                  </v-autocomplete>
                </v-col>

                <v-col cols="12" sm="6" lg="6" xl="6" md="6">
                  <v-file-input
                    v-model="fileImageMovie"
                    @change="selectImageMovie"
                    dense
                    style="margin-top: -20px"
                    accept="image/png, image/jpeg, image/bmp"
                    prepend-icon="mdi-camera"
                    label="Chọn ảnh phim"
                    class="required"
                    outlined
                  ></v-file-input>
                </v-col>
                <v-col cols="12" sm="6" lg="6" xl="6" md="6">
                  <v-file-input
                    v-model="fileImageBanner"
                    @change="selectImageBanner"
                    dense
                    style="margin-top: -20px"
                    accept="image/png, image/jpeg, image/bmp"
                    prepend-icon="mdi-camera"
                    label="Chọn ảnh banner phim"
                    class="required"
                    outlined
                  ></v-file-input>
                </v-col>
                <v-col cols="12" sm="6" lg="6" xl="6" md="6" class="mt-n5">
                  <p class="text-decoration-none font-weight-medium red--text">
                    PREVIEW ẢNH PHIM: {{ editedImageMovie.filename }}
                  </p>
                  <v-img
                    v-if="editedImageMovie.url"
                    :src="editedImageMovie.url"
                    height="200"
                    width="200"
                  >
                  </v-img>
                </v-col>
                <v-col cols="12" sm="6" lg="6" xl="6" md="6" class="mt-n5">
                  <p class="text-decoration-none font-weight-medium red--text">
                    PREVIEW BANNER PHIM: {{ editedImageBanner.filename }}
                  </p>
                  <v-img
                    v-if="editedImageBanner.url"
                    :src="editedImageBanner.url"
                    height="200"
                    width="500"
                  >
                  </v-img>
                </v-col>
              </v-row>
              <v-row v-if="n == 2" style="background-color: white">
                <v-col cols="12" sm="12" lg="12" xl="12" md="12">
                  <template v-for="detail in movie_details">
                    <v-row class="mt-n4">
                      <v-col cols="12" sm="1" lg="1" xl="1" md="1">
                        <v-text-field
                          outlined
                          dense
                          class="required"
                          label="Tập"
                          v-model="detail.episode"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" sm="3" lg="3" xl="3" md="3">
                        <v-text-field
                          outlined
                          dense
                          class="required"
                          label="Link tập phim"
                          v-model="detail.url_movie"
                        ></v-text-field
                      ></v-col>
                      <v-col cols="12" sm="3" lg="3" xl="3" md="3">
                        <v-text-field
                          outlined
                          dense
                          class="required"
                          label="Link phụ đề Eng"
                          v-model="detail.url_sub_en"
                        ></v-text-field
                      ></v-col>
                      <v-col cols="12" sm="3" lg="3" xl="3" md="3">
                        <v-text-field
                          outlined
                          dense
                          class="required"
                          label="Link phụ đề Vi"
                          v-model="detail.url_sub_vi"
                        ></v-text-field
                      ></v-col>
                      <v-col cols="12" sm="2" lg="2" xl="2" md="2">
                        <v-btn
                          class="error"
                          @click="removeEpMovieFromList(detail)"
                          >Xóa</v-btn
                        >
                      </v-col>
                    </v-row>
                  </template>
                  <v-btn
                    outlined
                    color="error"
                    class="mb-2"
                    @click="addEpMovieToList()"
                  >
                    Thêm tập phim
                  </v-btn>
                  <v-data-table
                    :search="searchMovie"
                    :headers="headers"
                    :items="movie.movie_details"
                    :footer-props="{
                      itemsPerPageText: 'số dòng mỗi trang',
                      pageText: '{0}-{1} trên {2}',
                    }"
                    item-key="id"
                    class="elevation-1"
                    loading-text="Đang tải...vui lòng đợi"
                  >
                    <template #top>
                      <v-toolbar flat>
                        <v-text-field
                          v-model="searchMovie"
                          append-icon="mdi-magnify"
                          label="Tìm tập phim"
                          single-line
                          hide-details
                          @keyup.enter="searchAll"
                        ></v-text-field>
                        <v-spacer></v-spacer>
                      </v-toolbar>
                    </template>

                    <template #[`item.actions`]="{ item }">
                      <v-icon small class="mr-2" @click="editEpMovie(item)">
                        mdi-pencil
                      </v-icon>
                      <v-icon small @click="deleteEpMovie(item)">
                        mdi-delete
                      </v-icon>
                    </template>
                    <template #no-data>
                      <v-btn color="error" @click="loadMovieDetails">
                        Làm mới
                      </v-btn>
                    </template>
                  </v-data-table>
                </v-col>
              </v-row>
            </v-container></v-tab-item
          ></v-tabs
        >
      </v-row>
    </v-card>
  </v-container>
</template>

<script>
/* eslint-disable camelcase */
import axios from 'axios'
import gql from 'graphql-tag'
import moment from 'moment'

export default {
  layout: 'admin',
  name: 'MovieEdit',
  components: {
    // UploadImage,
  },
  asyncData({ route, params }) {
    let objId = 0
    if (route.query.id != null && route.query.id !== undefined) {
      objId = route.query.id
    }
    let isEdit = false
    if (objId !== null && objId !== '0') {
      isEdit = true
    }
    return { objId, isEdit }
  },
  data: () => ({
    categories: [],
    actors: [],
    countries: [],
    movie_details: [],
    movie_categories: [],
    movie_actors: [],
    movie_types: [
      {
        code: 'single',
        name: 'Phim lẻ',
      },
      {
        code: 'series',
        name: 'Phim bộ',
      },
    ],
    movie_status: [
      {
        code: 'latest',
        name: 'Mới cập nhật',
      },
      {
        code: 'popular',
        name: 'Phim xem nhiều',
      },
      {
        code: 'recommended',
        name: 'Phim nổi bật',
      },
    ],
    movie: {
      id: null,
      code: '',
      name: '',
      name_en: '',
      content: '',
      time: 30,
      total_episode: 30,
      movie_type: 'series',
      movie_status: 'latest',
      country_id: null,
      country: {
        id: null,
        name: null,
      },
      year_of_manufacture: 2023,
      movie_categories: [],
      movie_actors: [],
      movie_details: [],
    },
    fileImageMovie: null,
    editedImageMovie: {
      filename: '',
      info: null,
      url: null,
    },
    fileImageBanner: null,
    editedImageBanner: {
      filename: '',
      info: null,
      url: null,
    },
    editedEpisode: {
      id: null,
      episode: '',
      url_movie: '',
      url_sub_en: '',
      url_sub_vi: '',
    },
    searchMovie: '',

    headers: [
      {
        text: 'Tập',
        value: 'episode',
        align: 'start',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Link tập phim',
        value: 'url_movie',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Link sub VI',
        value: 'url_sub_vi',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Link sub EN',
        value: 'url_sub_en',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: '',
        value: 'actions',
        sortable: false,
        class: 'error font-weight-medium text-h6 white--text',
      },
    ],
    editedIndex: -1,
    valid: true,
    menu2: false,
    dialogDeleteEpisode: false,
    dialogEditEpisode: false,
    isEdit: true,
    dialogSave: false,
    snackbar: false,
    textSnackbar: '',
    title_name: '',
  }),
  apollo: {
    getData: {
      query() {
        const query = gql(`query MyQuery {
            countries(where: {is_delete: {_eq: false}}) {
              id
              code
              name
            }
            categories(where: {is_delete: {_eq: false}}) {
              id
              code
              name
            }
            actors(where: {is_delete: {_eq: false}}) {
              id
              code
              name
              image_actor
            }
            movies(where: {id: {_eq: ${this.objId}}}){
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
        return query
      },
      update: (data) => {},
      result({ data }) {
        this.actors = []
        this.movie_categories = []
        this.movie_actors = []
        this.countries = data.countries
        this.categories = data.categories

        if (data && data.actors && data.actors.length > 0) {
          for (let index = 0; index < data.actors.length; index++) {
            const element = data.actors[index]
            if (element.image_actor) {
              const images = this.$fire.storage.ref().child('actors')
              const image = images.child(element.image_actor)
              image.getDownloadURL().then((url) => {
                element.url = url
                this.actors.push(element)
              })
            }
          }
        }
        if (data && data.movies && data.movies.length > 0) {
          this.movie = data.movies[0]
          // this.movie_details = data.movies[0].movie_details
          if (data.movies[0].movie_categories.length > 0) {
            for (
              let index = 0;
              index < data.movies[0].movie_categories.length;
              index++
            ) {
              const element = data.movies[0].movie_categories[index]
              const item = {}

              item.id = element.category.id
              item.code = element.category.code
              item.name = element.category.name
              this.movie_categories.push(item)
            }
          }
          if (data.movies[0].movie_actors.length > 0) {
            for (
              let index = 0;
              index < data.movies[0].movie_actors.length;
              index++
            ) {
              const element = data.movies[0].movie_actors[index]
              const item = {}

              item.id = element.actor.id
              item.code = element.actor.code
              item.name = element.actor.name
              this.movie_actors.push(item)
            }
          }

          for (
            let index = 0;
            index < data.movies[0].movie_images.length;
            index++
          ) {
            const element = data.movies[0].movie_images[index]
            if (element.type_image === 'image' && element.url) {
              const images = this.$fire.storage.ref().child('movies/images/')
              const image = images.child(element.url)
              image.getDownloadURL().then((url) => {
                this.editedImageMovie.url = url
                this.editedImageMovie.filename = element.url
              })
            }
            if (element.type_image === 'banner' && element.url) {
              const images = this.$fire.storage.ref().child('movies/banners/')
              const image = images.child(element.url)
              image.getDownloadURL().then((url) => {
                this.editedImageBanner.url = url
                this.editedImageBanner.filename = element.url
              })
            }
          }
        }
      },
    },
    getMovieDetails: {
      query() {
        const query = gql(`query MyQuery {
              movie_details(where: {movie_id: {_eq: ${this.objId}}, is_delete: {_eq: false}}){
                id
                movie_id
                episode
                url_movie
                url_sub_en
                url_sub_vi
              }

          }`)
        return query
      },
      update: (data) => {},
      result({ data }) {
        if (data.movie_details && data.movie_details.length > 0) {
          this.movie.movie_details = data.movie_details
        }
      },
    },
  },

  computed: {},

  watch: {},
  mounted() {
    this.movie.year_of_manufacture = Number(moment().year())
  },
  created() {},
  methods: {
    pushTo() {
      this.$toast.error(`Tài khoản không có quyền truy cập trang này`, {
        duration: 2000,
        position: 'top-center',
      })
      setTimeout(
        () =>
          this.$router.push({
            path: `/dashboard`,
          }),
        1500
      )
    },
    openDialogSave() {
      if (this.checkInfo()) {
        return
      }
      this.dialogSave = true
    },
    save() {
      if (this.isEdit === true) {
        this.updateMovie()
      } else {
        this.addMovie()
      }
      this.dialogSave = false
    },
    deleteEpisodeConfirm() {
      this.movie.movie_details.splice(this.editedIndex, 1)
      this.closeDelete()
      return 'sucess'
    },
    checkInfo() {
      if (!this.movie.name || this.movie.name === '') {
        this.textSnackbar = 'Vui lòng nhập tên phim'
        this.snackbar = true
        return true
      }
      if (!this.movie.name_en || this.movie.name_en === '') {
        this.textSnackbar = 'Vui lòng nhập tên phim tiếng Anh'
        this.snackbar = true
        return true
      }
      if (!this.movie.content || this.movie.content === '') {
        this.textSnackbar = 'Vui lòng nhập giới thiệu phim'
        this.snackbar = true
        return true
      }
      if (!this.movie.time || this.movie.time === '') {
        this.textSnackbar = 'Vui lòng nhập thời lượng phim'
        this.snackbar = true
        return true
      }
      if (
        !this.movie.year_of_manufacture ||
        this.movie.year_of_manufacture === ''
      ) {
        this.textSnackbar = 'Vui lòng nhập năm sản xuất phim'
        this.snackbar = true
        return true
      }
      if (!this.movie.country.id) {
        this.textSnackbar = 'Vui lòng chọn quốc gia sản xuất phim'
        this.snackbar = true
        return true
      }
      if (!this.movie.country.id) {
        this.textSnackbar = 'Vui lòng chọn quốc gia sản xuất phim'
        this.snackbar = true
        return true
      }
      if (this.movie_categories.length === 0) {
        this.textSnackbar = 'Vui lòng chọn thể loại phim'
        this.snackbar = true
        return true
      }
      if (this.movie_actors.length === 0) {
        this.textSnackbar = 'Vui lòng chọn diễn viên phim'
        this.snackbar = true
        return true
      }
      if (!this.isEdit && this.movie_details.length === 0) {
        this.textSnackbar = 'Vui lòng thêm tập phim cho phim'
        this.snackbar = true
        return true
      }
      if (!this.isEdit && this.movie_details.length > 0) {
        for (let index = 0; index < this.movie_details.length; index++) {
          const element = this.movie_details[index]
          if (
            element.episode === '' ||
            element.url_movie === '' ||
            element.url_sub_en === '' ||
            element.url_sub_vi === ''
          ) {
            this.textSnackbar = 'Vui lòng nhập thông tin tập phim'
            this.snackbar = true
            return true
          }
        }
      }
      if (this.movie.movie_type === 'series' && !this.movie.total_episode) {
        this.textSnackbar = 'Vui lòng nhập số tập phim'
        this.snackbar = true
        return true
      }

      if (this.editedImageMovie.filename === '') {
        this.textSnackbar = 'Vui lòng chọn ảnh phim'
        this.snackbar = true
        return true
      }

      if (this.editedImageBanner.filename === '') {
        this.textSnackbar = 'Vui lòng chọn banner phim'
        this.snackbar = true
        return true
      }
      return false
    },
    closeDelete() {
      this.dialogDeleteEpisode = false
    },
    async selectImageMovie(e) {
      if (this.movie.name_en === '') {
        this.snackbar = true
        this.textSnackbar =
          'Vui lòng nhập tên phim tiếng Anh trước khi chọn hình'
        this.fileImageMovie = null
      } else {
        const file = e
        if (!file) {
          this.editedImageMovie = {
            filename: '',
            info: null,
            url: null,
          }
          return
        }
        const readData = (f) =>
          new Promise((resolve) => {
            const reader = new FileReader()
            reader.onloadend = () => resolve(reader.result)
            reader.readAsDataURL(f)
          })
        const data = await readData(file)

        this.editedImageMovie = {
          filename:
            this.movie.code +
            '-image-' +
            moment().format('DD-MM-YYYY') +
            '.' +
            file.type.split('/')[1],
          url: data,
          infoImage: file,
        }
      }
    },
    async selectImageBanner(e) {
      if (this.movie.name_en === '') {
        this.snackbar = true
        this.textSnackbar =
          'Vui lòng nhập tên phim tiếng Anh trước khi chọn hình'
        this.fileImageBanner = null
      } else {
        const file = e

        if (!file) {
          this.editedImageBanner = {
            filename: '',
            info: null,
            url: null,
          }
          return
        }

        const readData = (f) =>
          new Promise((resolve) => {
            const reader = new FileReader()
            reader.onloadend = () => resolve(reader.result)
            reader.readAsDataURL(f)
          })
        const data = await readData(file)
        this.editedImageBanner = {
          filename:
            this.movie.code +
            '-banner-' +
            moment().format('DD-MM-YYYY') +
            '.' +
            file.type.split('/')[1],
          url: data,
          infoImage: file,
        }
      }
    },
    parseCodeMovie() {
      if (this.movie.name_en !== '') {
        this.movie.code = this.convertViToEn(
          this.movie.name_en,
          false
        ).replaceAll(' ', '-')
      }
    },
    checkYearMovie() {
      if (
        this.movie.year_of_manufacture === '' ||
        !this.movie.year_of_manufacture
      ) {
        this.snackbar = true
        this.textSnackbar = 'Năm sản xuất không được để trống'
        this.movie.year_of_manufacture = Number(moment().year())
      }
      if (
        this.movie.year_of_manufacture &&
        !Number.isInteger(Number(this.movie.year_of_manufacture))
      ) {
        this.snackbar = true
        this.textSnackbar = 'Dữ liệu phải là số nguyên'
        this.movie.year_of_manufacture = Number(moment().year())
      }
      if (
        this.movie.year_of_manufacture &&
        this.movie.year_of_manufacture < 0
      ) {
        this.snackbar = true
        this.textSnackbar = 'Năm sản xuất không được âm'
        this.movie.year_of_manufacture = Number(moment().year())
      }
      if (
        this.movie.year_of_manufacture &&
        (this.movie.year_of_manufacture < 1900 ||
          this.movie.year_of_manufacture > Number(moment().year()))
      ) {
        this.snackbar = true
        this.textSnackbar = 'Năm sản xuất nằm trong khoảng từ 1900 đến hiện tại'
        this.movie.year_of_manufacture = Number(moment().year())
      }
    },
    checkTimeMovie() {
      if (this.movie.time === '' || !this.movie.time) {
        this.snackbar = true
        this.textSnackbar = 'Thời lượng phim không được để trống'
        this.movie.time = 30
      }
      if (this.movie.time && !Number.isInteger(Number(this.movie.time))) {
        this.snackbar = true
        this.textSnackbar = 'Dữ liệu phải là số nguyên'
        this.movie.time = 30
      }
      if (this.movie.time && Number(this.movie.time) < 0) {
        this.snackbar = true
        this.textSnackbar = 'Thời gian không được âm'
        this.movie.time = 30
      }
      if (this.movie.time && Number(this.movie.time) > 10000) {
        this.snackbar = true
        this.textSnackbar = 'Thời lượng không quá 10000 phút/tập'
        this.movie.time = 30
      }
    },
    checkEpMovie() {
      if (
        this.movie.movie_type === 'series' &&
        (this.movie.total_episode === '' || !this.movie.total_episode)
      ) {
        this.snackbar = true
        this.textSnackbar = 'Số tập phim không được để trống'
        this.movie.total_episode = 10
      }
      if (
        this.movie.total_episode &&
        !Number.isInteger(Number(this.movie.total_episode))
      ) {
        this.snackbar = true
        this.textSnackbar = 'Dữ liệu phải là số nguyên'
        this.movie.total_episode = 10
      }
      if (this.movie.total_episode && Number(this.movie.total_episode) < 0) {
        this.snackbar = true
        this.textSnackbar = 'Số tập không được âm'
        this.movie.time = 10
      }
    },
    removeCategory(item) {
      if (this.movie.id) {
        const check = this.movie.movie_categories.find(
          (e) => e.category_id === item.id
        )
        if (check) {
          if (this.movie.movie_categories.length === 1) {
            this.snackbar = true
            this.textSnackbar =
              'Vui lòng thêm ít nhất một thể loại trước khi xóa'
            return
          }
          // Xóa có id
          const updateGraphl = gql` mutation MyMutation {
            update_movie_categories(
              where: { id: { _eq: ${check.id} } }
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
            update: (store, { data: { update_movie_categories } }) => {
              // eslint-disable-next-line camelcase
              if (update_movie_categories.affected_rows) {
                this.$apollo.queries.getData.refetch()

                this.textSnackbar = 'Xóa thể loại thành công'
                this.snackbar = true
              } else {
                this.textSnackbar = 'Xóa thể loại thất bại'
                this.snackbar = true
              }
            },
          })
        } else {
          const index = this.movie_categories.indexOf(item)
          if (index >= 0) this.movie_categories.splice(index, 1)
        }
      } else {
        const index = this.movie_categories.indexOf(item)
        if (index >= 0) this.movie_categories.splice(index, 1)
      }
    },
    removeActor(item) {
      if (this.movie.id) {
        const check = this.movie.movie_actors.find(
          (e) => e.actor_id === item.id
        )
        if (check) {
          if (this.movie.movie_actors.length === 1) {
            this.snackbar = true
            this.textSnackbar =
              'Vui lòng thêm ít nhất một diễn viên trước khi xóa'
            return
          }
          // Xóa có id
          const updateGraphl = gql` mutation MyMutation {
            update_movie_actors(
              where: { id: { _eq: ${check.id} } }
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
            update: (store, { data: { update_movie_actors } }) => {
              // eslint-disable-next-line camelcase
              if (update_movie_actors.affected_rows) {
                this.$apollo.queries.getData.refetch()

                this.textSnackbar = 'Xóa diễn viên thành công'
                this.snackbar = true
              } else {
                this.textSnackbar = 'Xóa diễn viên thất bại'
                this.snackbar = true
              }
            },
          })
        } else {
          const index = this.movie_actors.indexOf(item)
          if (index >= 0) this.movie_actors.splice(index, 1)
        }
      } else {
        const index = this.movie_actors.indexOf(item)
        if (index >= 0) this.movie_actors.splice(index, 1)
      }
    },
    backToList() {
      this.$router.push({
        path: `/admin/movies/movies`,
      })
    },
    convertViToEn(str, toUpperCase = true) {
      if (!str || str === '') {
        return ''
      }
      str = str.toLowerCase()
      str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, 'a')
      str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, 'e')
      str = str.replace(/ì|í|ị|ỉ|ĩ/g, 'i')
      str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, 'o')
      str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, 'u')
      str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, 'y')
      str = str.replace(/đ/g, 'd')
      // Some system encode vietnamese combining accent as individual utf-8 characters
      str = str.replace(/\u0300|\u0301|\u0303|\u0309|\u0323/g, '') // Huyền sắc hỏi ngã nặng
      str = str.replace(/\u02C6|\u0306|\u031B/g, '') // Â, Ê, Ă, Ơ, Ư

      return toUpperCase ? str.toUpperCase() : str
    },

    addEpMovieToList() {
      this.movie_details.push({
        episode: '1',
        url_movie:
          'https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv',
        url_sub_en:
          'https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt',
        url_sub_vi:
          'https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt',
      })
    },
    removeEpMovieFromList(detail) {
      const index = this.movie_details.indexOf(detail)
      if (index >= 0) this.movie_details.splice(index, 1)
    },
    editEpMovie(item) {
      this.dialogEditEpisode = true

      this.editedEpisode = {
        id: item.id,
        episode: item.episode,
        url_movie: item.url_movie,
        url_sub_en: item.url_sub_en,
        url_sub_vi: item.url_sub_vi,
      }
    },
    saveEditEpisode() {
      if (this.editedEpisode.id) {
        const updateGraphl = gql` mutation MyMutation {
            update_movie_details(
              where: { id: { _eq: ${this.editedEpisode.id} } }
              _set: {
                episode: "${this.editedEpisode.episode}"
                url_movie: "${this.editedEpisode.url_movie}"
                url_sub_en: "${this.editedEpisode.url_sub_en}"
                url_sub_vi: "${this.editedEpisode.url_sub_vi}"
              }
            ) {
              affected_rows
            }
          }`
        this.$apollo.mutate({
          mutation: updateGraphl,
          variables: {},
          // eslint-disable-next-line camelcase
          update: (store, { data: { update_movie_details } }) => {
            // eslint-disable-next-line camelcase
            if (update_movie_details.affected_rows) {
              this.$apollo.queries.getMovieDetails.refetch()
              this.textSnackbar = 'Chỉnh sửa tập phim thành công'
              this.editedEpisode = {
                id: null,
                episode: '',
                url_movie: '',
                url_sub_en: '',
                url_sub_vi: '',
              }
              this.dialogEditEpisode = false
              this.snackbar = true
            } else {
              this.editedEpisode = {
                id: null,
                episode: '',
                url_movie: '',
                url_sub_en: '',
                url_sub_vi: '',
              }
              this.dialogEditEpisode = false
              this.textSnackbar = 'Chỉnh sửa tập phim thất bại'
              this.snackbar = true
            }
          },
        })
      }
    },
    deleteEpMovie(item) {
      this.editedIndex = this.movie.movie_details.indexOf(item)
      if (this.editedIndex !== -1) {
        this.dialogDeleteEpisode = true
      }
    },
    searchAll() {},
    loadMovieDetails() {},
    awaitDirect() {
      setTimeout(() => this.backToList(), 1500)
    },

    async addMovie() {
      const queryCheck = gql(`query MyQuery {
               movies(where: {code: {_ilike: "${this.movie.code}"}, is_delete: {_eq: false}}) {
                  id
                  code
                  name
                  created_at
               }
            }`)
      await this.$apollo
        .query({
          query: queryCheck,
          fetchPolicy: 'network-only',
        })
        .then(async (response) => {
          if (response.data.movies.length > 0) {
            this.snackbar = true
            this.textSnackbar = 'Phim đã tồn tại'
          } else {
            const data_insert = {}
            data_insert.code = this.movie.code
            data_insert.name = this.movie.name
            data_insert.name_en = this.movie.name_en
            data_insert.content = this.movie.content
            data_insert.time = this.movie.time
            data_insert.year_of_manufacture = this.movie.year_of_manufacture
            data_insert.movie_type = this.movie.movie_type
            data_insert.movie_status = this.movie.movie_status
            data_insert.country_id = this.movie.country.id
            if (this.movie.movie_type === 'series') {
              data_insert.total_episode = this.movie.total_episode
            } else {
              data_insert.total_episode = 1
            }
            const movieCategories = []
            const movieActors = []
            const movieImages = []
            const movieDetails = []
            for (let index = 0; index < this.movie_details.length; index++) {
              const element = this.movie_details[index]
              const tempDetailInsert = {}
              tempDetailInsert.episode = element.episode
              tempDetailInsert.url_movie = element.url_movie
              tempDetailInsert.url_sub_en = element.url_sub_en
              tempDetailInsert.url_sub_vi = element.url_sub_vi
              // tempDetailInsert.created_by =
              movieDetails.push(tempDetailInsert)
            }
            for (let index = 0; index < this.movie_categories.length; index++) {
              const element = this.movie_categories[index]
              const tempCategoryInsert = {}
              tempCategoryInsert.category_id = element.id
              tempCategoryInsert.is_delete = false
              movieCategories.push(tempCategoryInsert)
              // tempCategoryInsert.created_by =
            }
            for (let index = 0; index < this.movie_actors.length; index++) {
              const element = this.movie_actors[index]
              const tempActorInsert = {}
              tempActorInsert.actor_id = element.id
              tempActorInsert.is_delete = false
              movieActors.push(tempActorInsert)
              // tempActorInsert.created_by =
            }
            if (this.editedImageMovie.filename !== '') {
              const tempInsert = {}
              tempInsert.type_image = 'image'
              tempInsert.url = this.editedImageMovie.filename
              // tempInsert.created_by =
              movieImages.push(tempInsert)
            }
            if (this.editedImageBanner.filename !== '') {
              const tempInsert = {}
              tempInsert.type_image = 'banner'
              tempInsert.url = this.editedImageBanner.filename
              // tempInsert.created_by =
              movieImages.push(tempInsert)
            }
            const movieCategoriesInsert = {}
            movieCategoriesInsert.data = movieCategories
            const movieActorsInsert = {}
            movieActorsInsert.data = movieActors
            const movieImagesInsert = {}
            movieImagesInsert.data = movieImages
            const movieDetailsInsert = {}
            movieDetailsInsert.data = movieDetails
            data_insert.movie_categories = movieCategoriesInsert
            data_insert.movie_actors = movieActorsInsert
            data_insert.movie_images = movieImagesInsert
            data_insert.movie_details = movieDetailsInsert
            // data_insert.created_by =
            await axios
              .post(`${process.env.URL_SERVER}/api/insert-movie`, {
                data_insert,
              })
              .then((response) => {
                if (response && response.data) {
                  if (response.data.status) {
                    this.textSnackbar = 'Thêm mới phim thành công'
                    const storageRefImage = this.$fire.storage.ref(
                      'movies/images/' + this.editedImageMovie.filename
                    )
                    // Upload Image
                    const uploadTaskImage = storageRefImage.put(
                      this.editedImageMovie.infoImage
                    )
                    uploadTaskImage.on(
                      'state_changed',
                      (snapshot) => {},
                      (error) => {
                        this.snackbar = true
                        this.textSnackbar =
                          'Thêm ảnh thất bại, vui lòng thử lại'
                        console.log('Error is ', error)
                      }
                    )
                    // Upload Banner
                    const storageRefBanner = this.$fire.storage.ref(
                      'movies/banners/' + this.editedImageBanner.filename
                    )
                    const uploadTaskBanner = storageRefBanner.put(
                      this.editedImageBanner.infoImage
                    )
                    uploadTaskBanner.on(
                      'state_changed',
                      (snapshot) => {},
                      (error) => {
                        this.snackbar = true
                        this.textSnackbar =
                          'Thêm banner thất bại, vui lòng thử lại'
                        console.log('Error is ', error)
                      }
                    )
                    this.awaitDirect()
                    this.snackbar = true
                  } else {
                    this.textSnackbar = 'Thêm mới phim thất bại'
                    this.snackbar = true
                  }
                }
              })
              .catch((error) => {
                console.log(error)
                this.textSnackbar = 'Có lỗi xảy trong quá trình thêm mới phim'
                this.snackbar = true
              })
          }
        })
        .catch((response) => console.log(response))
    },
    async updateMovie() {
      const data_update = {}
      data_update.id = this.movie.id
      data_update.code = this.movie.code
      data_update.name = this.movie.name
      data_update.name_en = this.movie.name_en
      data_update.content = this.movie.content
      data_update.time = Number(this.movie.time)
      data_update.year_of_manufacture = Number(this.movie.year_of_manufacture)
      data_update.movie_type = this.movie.movie_type
      data_update.movie_status = this.movie.movie_status
      data_update.country_id = this.movie.country.id
      if (this.movie.movie_type === 'series') {
        data_update.total_episode = Number(this.movie.total_episode)
      } else {
        data_update.total_episode = 1
      }
      const movieCategories = []
      const movieActors = []
      const movieImages = []
      const movieDetails = []
      if (this.movie_details.length > 0) {
        for (let index = 0; index < this.movie_details.length; index++) {
          const element = this.movie_details[index]
          const tempDetailInsert = {}
          tempDetailInsert.movie_id = this.movie.id
          tempDetailInsert.episode = element.episode
          tempDetailInsert.url_movie = element.url_movie
          tempDetailInsert.url_sub_en = element.url_sub_en
          tempDetailInsert.url_sub_vi = element.url_sub_vi
          // tempDetailInsert.created_by =
          movieDetails.push(tempDetailInsert)
        }
      }

      for (let index = 0; index < this.movie_categories.length; index++) {
        const element = this.movie_categories[index]
        const checkInsert = this.movie.movie_categories.find(
          (e) => e.category_id === element.id
        )
        if (checkInsert) {
          // Đã thêm
        } else {
          const tempCategoryInsert = {}
          tempCategoryInsert.movie_id = this.movie.id
          tempCategoryInsert.category_id = element.id
          tempCategoryInsert.is_delete = false
          movieCategories.push(tempCategoryInsert)
          // tempCategoryInsert.created_by =
        }
      }
      for (let index = 0; index < this.movie_actors.length; index++) {
        const element = this.movie_actors[index]
        const checkInsert = this.movie.movie_actors.find(
          (e) => e.actor_id === element.id
        )
        if (checkInsert) {
          // Đã thêm
        } else {
          const tempActorInsert = {}
          tempActorInsert.movie_id = this.movie.id
          tempActorInsert.actor_id = element.id
          tempActorInsert.is_delete = false
          movieActors.push(tempActorInsert)
          // tempActorInsert.created_by =
        }
      }
      if (this.editedImageMovie.filename !== '') {
        const tempInsert = {}
        tempInsert.movie_id = this.movie.id
        tempInsert.type_image = 'image'
        tempInsert.url = this.editedImageMovie.filename
        // tempInsert.created_by =
        movieImages.push(tempInsert)
      }
      if (this.editedImageBanner.filename !== '') {
        const tempInsert = {}
        tempInsert.movie_id = this.movie.id
        tempInsert.type_image = 'banner'
        tempInsert.url = this.editedImageBanner.filename
        // tempInsert.created_by =
        movieImages.push(tempInsert)
      }
      // const movieCategoriesInsert = {}
      // movieCategoriesInsert.data = movieCategories
      // const movieActorsInsert = {}
      // movieActorsInsert.data = movieActors
      // const movieImagesInsert = {}
      // movieImagesInsert.data = movieImages
      // const movieDetailsInsert = {}
      // movieDetailsInsert.data = movieDetails
      if (movieDetails.length > 0) {
        data_update.movie_details = movieDetails
      }
      if (movieCategories.length > 0) {
        data_update.movie_categories = movieCategories
      }
      if (movieActors.length > 0) {
        data_update.movie_actors = movieActors
      }

      data_update.movie_images = movieImages

      // data_update.created_by =
      await axios
        .post(`${process.env.URL_SERVER}/api/update-movie`, {
          data_update,
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              this.textSnackbar = 'Cập nhật phim thành công'
              // Upload Image
              if (this.editedImageMovie.infoImage) {
                const storageRefImage = this.$fire.storage.ref(
                  'movies/images/' + this.editedImageMovie.filename
                )

                const uploadTaskImage = storageRefImage.put(
                  this.editedImageMovie.infoImage
                )
                uploadTaskImage.on(
                  'state_changed',
                  (snapshot) => {},
                  (error) => {
                    this.snackbar = true
                    this.textSnackbar = 'Thêm ảnh thất bại, vui lòng thử lại'
                    console.log('Error is ', error)
                  }
                )
              }

              // Upload Banner
              if (this.editedImageBanner.infoImage) {
                const storageRefBanner = this.$fire.storage.ref(
                  'movies/banners/' + this.editedImageBanner.filename
                )
                const uploadTaskBanner = storageRefBanner.put(
                  this.editedImageBanner.infoImage
                )
                uploadTaskBanner.on(
                  'state_changed',
                  (snapshot) => {},
                  (error) => {
                    this.snackbar = true
                    this.textSnackbar = 'Thêm banner thất bại, vui lòng thử lại'
                    console.log('Error is ', error)
                  }
                )
              }

              this.awaitDirect()
              this.snackbar = true
            } else {
              this.textSnackbar = 'Cập nhật phim thất bại'
              this.snackbar = true
            }
          }
        })
        .catch((error) => {
          console.log(error)
          this.textSnackbar = 'Có lỗi xảy trong quá trình cập nhật phim'
          this.snackbar = true
        })
    },
  },
}
</script>
<style>
.required label::after {
  content: ' * ';
  color: red;
}
.required .v-label {
  color: red;
  opacity: 1;
}
</style>
