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
                    searchStatus || searchCategory || searchSortBy || searchType
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
          </v-row>
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
        </v-col>
        <v-col cols="12" sm="1" lg="1" xl="1" md="1"></v-col>
      </v-row>
    </v-card>
  </v-app>
</template>

<script>
export default {
  layout: 'default',
  data() {
    return {
      loadingText: 'Đang cập nhật dữ liệu, bạn chờ tí nhé ...',
      snackbar: false,
      textSnackbar: '',
      dialogLoading: false,
      page: 1,
      cycle: true,
      tabsViewMovie: null,
      tabsViewMovieSeries: null,
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
      isSearching: false,
      isLoading: false,
      textSearchMovie: '',
      selectedSearchMovie: null,
      searchMovieItems: [
        {
          action: '',
          image: require('~/static/friend-1.jpg'),
          subtitle: 'Những người bạn mùa 1',
          title: 'FRIENDS SEASON 1',
          link: '/movies/friend-season-1',
        },
        {
          action: '',
          image: require('~/static/friend-2.jpg'),
          subtitle: 'Những người bạn mùa 2',
          title: 'FRIENDS SEASON 2',
          link: '/movies/friend-season-2',
        },
        {
          action: '',
          image: require('~/static/friend-3.jpg'),
          subtitle: 'Những người bạn mùa 3',
          title: 'FRIENDS SEASON 3',
          link: '/movies/friend-season-3',
        },
        {
          action: '',
          image: require('~/static/friend-4.jpg'),
          subtitle: 'Những người bạn mùa 4',
          title: 'FRIENDS SEASON 4',
          link: '/movies/friend-season-4',
        },
        {
          action: '',
          image: require('~/static/friend-5.jpg'),
          subtitle: 'Những người bạn mùa 5',
          title: 'FRIENDS SEASON 5',
          link: '/movies/friend-season-5',
        },
        {
          action: '',
          image: require('~/static/friend-6.jpg'),
          subtitle: 'Những người bạn mùa 6',
          title: 'FRIENDS SEASON 6',
          link: '/movies/friend-season-6',
        },
        {
          action: '',
          image: require('~/static/friend-7.jpg'),
          subtitle: 'Những người bạn mùa 7',
          title: 'FRIENDS SEASON 7',
          link: '/movies/friend-season-7',
        },
        {
          action: '',
          image: require('~/static/friend-8.jpg'),
          subtitle: 'Những người bạn mùa 8',
          title: 'FRIENDS SEASON 8',
          link: '/movies/friend-season-8',
        },
      ],
      categoryMovieLists: [
        {
          code: 'action',
          name: 'Hành động',
        },
        {
          code: 'romantic',
          name: 'Tình cảm',
        },
      ],
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
        {
          code: 'popular',
          name: 'Phim xem nhiều',
        },
        {
          code: 'recommended',
          name: 'Phim nổi bật',
        },
      ],
      sortByLists: [
        {
          code: 'year',
          name: 'Năm sản xuất',
        },
        {
          code: 'view',
          name: 'Lượt xem',
        },
      ],
      searchCategory: null,
      searchType: null,
      searchStatus: null,
      searchSortBy: null,
    }
  },
  mounted() {
    this.removeQueryParams()
  },
  computed: {},
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
    typeSearchInput() {
      if (this.textSearchMovie && this.textSearchMovie.length > 0) {
        this.isSearching = true
      } else {
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
      window.history.replaceState({}, '', url.href)
      this.searchCategory = null
      this.searchType = null
      this.searchSortBy = null
      this.searchStatus = null
    },
    removeQueryParams() {
      const url = new URL(window.location.href)
      url.search = ''
      window.history.replaceState({}, '', url.href)
    },
    searchMovies() {
      const queryParams = {}
      if (this.textSearchMovie && this.textSearchMovie !== '') {
        const textSearch = this.textSearchMovie.split(' ').join('+')
        queryParams.text = textSearch
      }
      if (this.searchCategory) {
        const categorySearch = this.searchCategory.code
        queryParams.category = categorySearch
      }
      if (this.searchType) {
        const typeSearch = this.searchType.code
        queryParams.type = typeSearch
      }
      if (this.searchStatus) {
        const statusSearch = this.searchStatus.code
        queryParams.status = statusSearch
      }
      if (this.searchSortBy) {
        const sortSearch = this.searchSortBy.code
        queryParams.sortBy = sortSearch
      }
      this.$router.push({ path: '/search', query: queryParams })
    },
    linkToMovieDetail(item) {
      this.$router.push({
        path: `/movies/${item.title}`,
      })
    },
  },
}
</script>
<style scoped>
.card-search {
  position: absolute;
  z-index: 2;
  margin-top: -20px;
}
</style>
