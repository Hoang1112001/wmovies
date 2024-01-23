<!-- eslint-disable vue/require-v-for-key -->
<!-- eslint-disable nuxt/no-globals-in-created -->
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
        <span class="h4"> Đang tải dữ liệu, vui lòng đợi ...</span>
      </v-layout>
    </v-overlay>
    <!-- Main -->
    <v-card elevation="24" width="95%" style="margin: 10px auto" class="white">
      <v-row>
        <v-col cols="12" sm="1" lg="1" xl="1" md="1"></v-col>
        <v-col cols="12" sm="10" lg="10" xl="10" md="10" class="mt-5 mb-5">
          <v-row>
            <v-col cols="12" sm="2" lg="2" xl="2" md="2"></v-col>
            <v-col cols="12" sm="8" lg="8" xl="8" md="8">
              <v-row class="d-flex pa-2">
                <v-text-field
                  v-model="textSearchMovie"
                  color="error"
                  label="Tìm kiếm phim"
                  placeholder="Nhập tên phim cần tìm kiếm ở đây ..."
                  outlined
                  clearable
                  @input="typeSearchInput"
                  @blur="blurSearchInput"
                  @enter="searchMovies"
                  class="rounded-0"
                >
                </v-text-field>
                <v-btn
                  style="height: 56px"
                  tile
                  x-large
                  class="error"
                  @click="searchMovies"
                >
                  <v-icon>mdi-magnify</v-icon>
                  Tìm kiếm
                </v-btn></v-row
              >
              <v-row>
                <v-card
                  v-if="isSearching"
                  style="width: 50%"
                  class="white card-search"
                >
                  <v-layout
                    v-if="
                      isSearching &&
                      isGetSameMovieTypeSearching &&
                      searchMovieItems.length === 0
                    "
                    class="d-flex flex-column mt-2"
                    justify-center
                    align-center
                  >
                    <v-progress-circular
                      :size="64"
                      color="black"
                      indeterminate
                    ></v-progress-circular>
                    <span class="h3 font-italic font-weight-bold">
                      Đang tìm kiếm phim phù hợp, vui lòng đợii ...</span
                    >
                  </v-layout>
                  <v-layout
                    v-if="
                      isSearching &&
                      !isGetSameMovieTypeSearching &&
                      searchMovieItems.length === 0
                    "
                    class="mt-5 ml-5"
                    align-start
                  >
                    <span class="h3 font-italic font-weight-bold">
                      Không tìm thấy phim phù hợp.</span
                    >
                  </v-layout>
                  <v-list two-line>
                    <v-list-item-group v-model="selectedSearchMovie">
                      <v-list-item
                        v-for="(item, i) in searchMovieItems"
                        :key="i"
                        :href="item.link"
                      >
                        <v-list-item-avatar left>
                          <v-img
                            max-width="60"
                            max-height="60"
                            :src="item.image"
                          ></v-img>
                        </v-list-item-avatar>
                        <v-list-item-content>
                          <v-list-item-title
                            class="font-weight-bold orange--text"
                            v-text="item.title"
                          ></v-list-item-title>

                          <v-list-item-subtitle
                            class="text--primary font-italic"
                            v-text="item.subtitle"
                          ></v-list-item-subtitle>
                        </v-list-item-content>
                        <v-list-item-action>
                          <v-icon> mdi-arrow-right </v-icon>
                        </v-list-item-action>
                      </v-list-item>
                    </v-list-item-group>
                  </v-list>
                </v-card>
              </v-row>
            </v-col>
            <v-col cols="12" sm="2" lg="2" xl="2" md="2"></v-col>
          </v-row>
          <v-row>
            <v-col cols="12" sm="1" lg="1" xl="1" md="1"></v-col>
            <v-col cols="12" sm="10" lg="10" xl="10" md="10">
              <v-row class="d-flex justify-space-around">
                <v-col>
                  <v-autocomplete
                    v-model="searchStatus"
                    :items="statusMovieLists"
                    item-text="name"
                    @change="searchMovies"
                    label="Trạng thái"
                    outlined
                    dense
                    return-object
                  >
                  </v-autocomplete>
                </v-col>

                <v-col>
                  <v-autocomplete
                    v-model="searchType"
                    :items="typeMovieLists"
                    item-text="name"
                    @change="searchMovies"
                    label="Loại phim"
                    outlined
                    dense
                    return-object
                  >
                  </v-autocomplete
                ></v-col>
                <v-col>
                  <v-autocomplete
                    v-model="searchCategory"
                    :items="categoryMovieLists"
                    item-text="name"
                    @change="searchMovies"
                    label="Thể loại"
                    outlined
                    dense
                    return-object
                  >
                  </v-autocomplete
                ></v-col>
                <v-col>
                  <v-autocomplete
                    v-model="searchCountry"
                    :items="countryMovieLists"
                    item-text="name"
                    @change="searchMovies"
                    label="Quốc gia"
                    outlined
                    dense
                    return-object
                  >
                  </v-autocomplete
                ></v-col>
                <v-col>
                  <v-autocomplete
                    v-model="searchSortBy"
                    :items="sortByLists"
                    item-text="name"
                    @change="searchMovies"
                    label="Sắp xếp theo"
                    outlined
                    dense
                    return-object
                  >
                  </v-autocomplete
                ></v-col>
                <v-col
                  v-if="
                    searchStatus ||
                    searchCategory ||
                    searchSortBy ||
                    searchType ||
                    searchCountry
                  "
                >
                  <v-btn color="error" @click="removeFilterSearch"
                    ><v-icon>mdi-filter</v-icon>Bỏ lọc</v-btn
                  >
                </v-col>
              </v-row>
            </v-col>
            <v-col cols="12" sm="1" lg="1" xl="1" md="1"></v-col>
          </v-row>
          <v-row>
            <v-col
              v-if="
                itemMovieLists.length === 0 &&
                textSnackbar === 'Không tìm thấy phim phù hợp'
              "
              cols="12"
              sm="12"
              lg="12"
              xl="12"
              md="12"
              >{{ textSnackbar }}
              <v-icon>mdi-emoticon-sad-outline</v-icon></v-col
            >
            <v-col
              v-for="(file, f) in itemMovieLists"
              :key="f"
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
            <v-col v-if="loadingMovie" cols="12" sm="6" lg="3" xl="3" md="3">
              <v-skeleton-loader
                class="mx-auto"
                max-width="400"
                type="card"
              ></v-skeleton-loader>
            </v-col>
          </v-row>
          <v-row justify="center">
            <v-col cols="12">
              <v-container class="max-width">
                <v-pagination
                  v-if="itemMovieLists.length > 0"
                  v-model="page"
                  class="my-4"
                  :length="totalMovie"
                  navigation-color="error"
                  color="error"
                ></v-pagination>
              </v-container>
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="12" sm="1" lg="1" xl="1" md="1"></v-col>
      </v-row>
    </v-card>
  </v-app>
</template>

<script>
import axios from 'axios'
import gql from 'graphql-tag'

export default {
  async fetch() {
    // Gọi các truy vấn GraphQL thông qua Apollo Client
    const data = await this.$apollo.query({
      query: gql(`query MyQuery {
            categories(where: {is_delete: {_eq: false}}) {
              id
              code
              name
            }
            countries(where: {is_delete: {_eq: false}}) {
              id
              code
              name
            }
          }
           `),
    })
    if (data && data.data) {
      this.categoryMovieLists = []
      this.countryMovieLists = []
      this.categoryMovieLists = data.data.categories
      this.countryMovieLists = data.data.countries
      if (
        this.$router.currentRoute.name === 'search' &&
        this.$router.currentRoute.query.status
      ) {
        const checkStatus = this.statusMovieLists.find(
          (e) => e.code === this.$router.currentRoute.query.status
        )
        if (checkStatus) {
          this.searchStatus = checkStatus
        }
      }
      if (
        this.$router.currentRoute.name === 'search' &&
        this.$router.currentRoute.query.category
      ) {
        const checkCategory = this.categoryMovieLists.find(
          (e) => e.code === this.$router.currentRoute.query.category
        )

        if (checkCategory) {
          this.searchCategory = checkCategory
        }
      }

      if (
        this.$router.currentRoute.name === 'search' &&
        this.$router.currentRoute.query.country
      ) {
        const checkCountry = this.countryMovieLists.find(
          (e) => e.code === this.$router.currentRoute.query.country
        )
        if (checkCountry) {
          this.searchCountry = checkCountry
        }
      }
    }
    this.searchMovies()
  },
  layout: 'default',
  data() {
    return {
      userInfo: null,
      loadingText: 'Đang cập nhật dữ liệu, bạn chờ tí nhé ...',
      snackbar: false,
      textSnackbar: '',
      loadingMovie: false,
      page: 1,
      limit: 8,
      offset: 0,
      totalMovie: 0,
      cycle: true,
      tabsViewMovie: null,
      tabsViewMovieSeries: null,
      itemMovieLists: [],
      isSearching: false,
      isGetSameMovieTypeSearching: false,
      isLoading: false,
      textSearchMovie: '',
      selectedSearchMovie: null,
      searchMovieItems: [],
      categoryMovieLists: [],
      countryMovieLists: [],
      typeMovieLists: [
        {
          code: 'single',
          name: 'Phim lẻ',
        },
        {
          code: 'series',
          name: 'Phim bộ',
        },
      ],
      statusMovieLists: [
        {
          code: 'latest',
          name: 'Mới cập nhật',
        },
        // {
        //   code: 'popular',
        //   name: 'Phim xem nhiều',
        // },
        {
          code: 'recommended',
          name: 'Phim nổi bật',
        },
      ],
      sortByLists: [
        {
          code: 'year_of_manufacture',
          type: 'desc',
          name: 'Năm sản xuất (Từ cao xuống thấp)',
        },
        {
          code: 'year_of_manufacture',
          type: 'asc',
          name: 'Năm sản xuất (Từ thấp lên cao)',
        },
        {
          code: 'view',
          type: 'desc',
          name: 'Lượt xem (Từ cao xuống thấp)',
        },
        {
          code: 'view',
          type: 'asc',
          name: 'Lượt xem (Từ thấp lên cao)',
        },
      ],
      searchCountry: null,
      searchCategory: null,
      searchType: null,
      searchStatus: null,
      searchSortBy: null,
    }
  },
  created() {
    // this.searchMovies()
  },
  mounted() {},
  computed: {},
  watch: {
    loadingMovie(val) {
      if (!val) return

      setTimeout(() => this.closeDialog(), 4000)
    },
    page() {
      this.offset = (this.page - 1) * this.limit
      this.searchMovies()
    },
  },
  methods: {
    closeDialog() {
      this.loadingMovie = false
      // this.loadingText = 'Đang cập nhật dữ liệu, bạn chờ tí nhé ...'
      // this.snackbar = true
      // this.textSnackbar = 'Hệ thống đã ghi nhận, cảm ơn bạn đã đánh giá'
    },
    async typeSearchInput() {
      if (this.isGetSameMovieTypeSearching) {
        console.log('Đang tiến hành search')
        return
      }
      if (this.textSearchMovie && this.textSearchMovie.length > 0) {
        this.isGetSameMovieTypeSearching = true
        this.isSearching = true
        this.searchMovieItems = []
        try {
          const stringSearch = `where: {_or: [
          {name: {_ilike: "%${this.textSearchMovie}%"}},
          {name_en: {_ilike: "%${this.textSearchMovie}%"}}
          ]},`
          const resData = await axios.post(
            `${process.env.URL_SERVER}/api/get-movie-type-input-search`,
            { textSearch: stringSearch }
          )
          if (resData && resData.data && resData.data.status) {
            if (resData.data && resData.data.dataMovies.length > 0) {
              const tempMovieItem = []
              for (
                let index = 0;
                index < resData.data.dataMovies.length;
                index++
              ) {
                const element = resData.data.dataMovies[index]
                const movieItem = {}
                movieItem.id = element.id
                movieItem.view = element.view
                movieItem.title = element.name_en.toUpperCase()
                movieItem.subtitle = element.name
                movieItem.link = '/movies/movie_detail?code=' + element.code
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
                tempMovieItem.push(movieItem)
              }
              this.searchMovieItems = tempMovieItem
              this.isGetSameMovieTypeSearching = false
            }
          } else {
            this.searchMovieItems = []
            this.isGetSameMovieTypeSearching = false
          }
        } catch (error) {
          console.log(error)
          this.isGetSameMovieTypeSearching = false
          this.isSearching = false
        }
      } else {
        this.isGetSameMovieTypeSearching = false
        this.isSearching = false
      }
    },
    blurSearchInput() {
      setTimeout(() => (this.isSearching = false), 1000)
    },
    removeFilterSearch() {
      const url = new URL(window.location.href)
      if (this.searchCategory) {
        url.searchParams.delete('category')
      }
      if (this.searchType) {
        url.searchParams.delete('type')
      }
      if (this.searchStatus) {
        url.searchParams.delete('status')
      }
      if (this.searchSortBy) {
        url.searchParams.delete('sortBy')
      }
      if (this.searchCountry) {
        url.searchParams.delete('country')
      }
      window.history.replaceState({}, '', url.href)
      this.textSnackbar = ''
      this.snackbar = false
      this.searchCategory = null
      this.searchType = null
      this.searchSortBy = null
      this.searchStatus = null
      this.searchCountry = null
      this.page = 1
      this.offset = 0
      this.searchMovies()
    },
    removeQueryParams() {
      const url = new URL(window.location.href)
      url.search = ''
      window.history.replaceState({}, '', url.href)
    },
    async searchMovies() {
      let stringOrder = ''
      let stringSearch = ''
      const queryParams = {}
      if (this.textSearchMovie && this.textSearchMovie !== '') {
        const textSearch = this.textSearchMovie.split(' ').join('+')
        stringSearch = `_or: [
          {name: {_ilike: "%${this.textSearchMovie}%"}},
          {name_en: {_ilike: "%${this.textSearchMovie}%"}}
      ],
        `
        queryParams.text = textSearch
      }
      if (this.searchCategory) {
        const categorySearch = this.searchCategory.code
        stringSearch += `
        movie_categories: {category: {code: {_eq: "${this.searchCategory.code}"}}},
        `
        queryParams.category = categorySearch
      }
      if (this.searchCountry) {
        const countrySearch = this.searchCountry.code
        stringSearch += `
        country: {code: {_eq: ${this.searchCountry.code}}},
        `
        queryParams.country = countrySearch
      }
      if (this.searchType) {
        const typeSearch = this.searchType.code
        stringSearch += `
        movie_type: {_eq: "${this.searchType.code}"},
        `
        queryParams.type = typeSearch
      }
      if (this.searchStatus) {
        const statusSearch = this.searchStatus.code
        stringSearch += `
        movie_status: {_eq: "${this.searchStatus.code}"},
        `
        queryParams.status = statusSearch
      }
      if (this.searchSortBy) {
        stringOrder = `, order_by : {${this.searchSortBy.code} : ${this.searchSortBy.type} }`
        const sortSearch = this.searchSortBy.code
        queryParams.sortBy = sortSearch
      }
      const stringSearchSend = `where: {${stringSearch}}`
      this.$router.push({ path: '/search', query: queryParams })
      const stringSearchParams = {}
      stringSearchParams.sort = stringOrder
      stringSearchParams.stringSearch = stringSearchSend
      stringSearchParams.limit = this.limit
      stringSearchParams.offset = this.offset
      try {
        this.loadingMovie = true
        const resData = await axios.post(
          `${process.env.URL_SERVER}/api/get-movie-search`,
          stringSearchParams
        )
        if (resData && resData.data && resData.data.status) {
          if (resData.data && resData.data.dataMovies.length > 0) {
            this.itemMovieLists = []
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
              this.itemMovieLists.push(movieItem)
            }
            this.loadingMovie = false
          }
          if (resData.data && resData.data.dataTotal) {
            this.totalMovie = Math.ceil(resData.data.dataTotal / this.limit)
          }
        } else {
          this.itemMovieLists = []
          this.loadingMovie = false
          this.snackbar = true
          this.textSnackbar = 'Không tìm thấy phim phù hợp'
        }
      } catch (error) {
        console.log(error)
      }
    },
    toLinkSearch(type, item) {
      if (type === 'country') {
        this.$router.push({ path: '/search', query: { country: item.code } })
        this.searchCountry = item
        this.searchMovies()
      }
      if (type === 'category') {
        this.$router.push({
          path: '/search',
          query: { category: item.category.code },
        })
        this.searchCategory = item.category
        this.searchMovies()
      }
      if (type === 'actor') {
        this.$router.push({ path: `/actors`, query: { code: item.actor.code } })
      }
    },
    linkToMovieDetail(item) {
      this.$router.push({
        path: `/movies/${item.title}`,
      })
    },
    toLink(item) {
      this.$router.push({
        path: '/movies/movie_detail',
        query: { code: item.code },
      })
    },
  },
  apollo: {},
}
</script>
<style scoped>
.card-search {
  position: absolute;
  z-index: 2;
  margin-top: -20px;
}
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
