<!-- eslint-disable camelcase -->
<template>
  <v-container fluid color="error">
    <v-snackbar v-model="snackbar">
      {{ textSnackbar }}

      <template v-slot:action="{ attrs }">
        <v-btn color="pink" text v-bind="attrs" @click="snackbar = false">
          Close
        </v-btn>
      </template>
    </v-snackbar>
    <v-dialog v-model="dialogDelete" width="unset">
      <v-sheet outlined color="error" rounded>
        <v-card>
          <v-card-title class="h5 red--text"
            >Bạn có chắc muốn xóa phim không?</v-card-title
          >
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="error" text @click="closeDelete">Không</v-btn>
            <v-btn color="error" text @click="deleteMovieConfirm">Có</v-btn>
            <v-spacer></v-spacer>
          </v-card-actions>
        </v-card>
      </v-sheet>
    </v-dialog>
    <v-card>
      <v-card-title style="left: 50%" class="red--text font-weight-bold"
        >QUẢN LÝ PHIM TRÊN WMOVIES
      </v-card-title>
      <v-card-text>
        <v-data-table
          :headers="headers"
          :items="movies"
          :footer-props="{
            itemsPerPageText: 'số dòng mỗi trang',
            pageText: '{0}-{1} trên {2}',
          }"
          item-key="id"
          class="elevation-1"
          loading-text="Đang tải...vui lòng đợi"
        >
          <template #[`item.is_delete`]="{ item }">
            <v-simple-checkbox
              v-model="item.is_delete"
              disabled
            ></v-simple-checkbox>
          </template>

          <template #top>
            <v-snackbar v-model="snackbar">
              {{ textSnackbar }}

              <template v-slot:action="{ attrs }">
                <v-btn
                  color="pink"
                  text
                  v-bind="attrs"
                  @click="snackbar = false"
                >
                  Close
                </v-btn>
              </template>
            </v-snackbar>
            <v-toolbar flat>
              <v-text-field
                v-model="search"
                append-icon="mdi-magnify"
                label="Tìm kiếm phim ..."
                single-line
                hide-details
                @keyup.enter="searchAll"
              ></v-text-field>
              <v-spacer></v-spacer>
              <v-btn outlined color="error" class="mb-2" @click="addMovie()">
                Thêm mới phim
              </v-btn>
            </v-toolbar>
          </template>

          <template #[`item.actions`]="{ item }">
            <v-icon small class="mr-2" @click="editMovie(item)">
              mdi-pencil
            </v-icon>
            <v-icon small @click="deleteMovie(item)"> mdi-delete </v-icon>
          </template>
          <template #no-data>
            <v-btn color="error" @click="loadDataMovies"> Làm mới </v-btn>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>
  </v-container>
</template>
<script>
// import axios from 'axios'
import gql from 'graphql-tag'
import moment from 'moment'
export default {
  layout: 'admin',
  name: 'AdminMovie',
  data() {
    return {
      snackbar: false,
      textSnackbar: '',
      search: '',
      dialogDelete: false,
      headers: [
        {
          text: 'STT',
          value: 'stt',
          align: 'start',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Mã phim',
          value: 'code',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Tên phim',
          value: 'name',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Tên phim (English)',
          value: 'name_en',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Lượt xem',
          value: 'view',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Ngày tạo',
          value: 'created_at_string',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: '',
          value: 'actions',
          sortable: false,
          class: 'error font-weight-medium text-h6 white--text',
        },
      ],
      movies: [],
      editedIndex: -1,
    }
  },
  mounted() {},
  watch: {},
  methods: {
    closeDelete() {
      this.dialogDelete = false
      this.editedIndex = -1
    },
    editMovie(item) {
      this.$router.push({
        path: `/admin/movies/movies_edit`,
        query: { id: item.id },
      })
    },
    deleteMovie(item) {
      this.editedIndex = this.movies.indexOf(item)
      if (this.editedIndex !== -1) {
        this.dialogDelete = true
      } else {
        this.snackbar = true
        this.textSnackbar = 'Không tìm thấy phim'
      }
    },
    loadDataMovies() {},
    deleteMovieConfirm() {
      const getItem = this.movies[this.editedIndex]
      const updateemployeeGraphl = gql` mutation MyMutation {
          update_movies(
            where: { id: { _eq: "${getItem.id}" } }
            _set: {
              is_delete: true
            }
          ) {
            affected_rows
          }
  
        
        }`
      this.$apollo.mutate({
        mutation: updateemployeeGraphl,
        variables: {},
        // eslint-disable-next-line camelcase
        update: (store, { data: { update_movies } }) => {
          // eslint-disable-next-line camelcase
          if (update_movies.affected_rows) {
            this.$apollo.queries.getData.refetch()
            this.textSnackbar = 'Xóa phim thành công'
            this.snackbar = true
            // this.movies.splice(this.editedIndex, 1)
            this.closeDelete()
          } else {
            this.textSnackbar = 'Xóa phim thất bại'
            this.snackbar = true
            this.closeDelete()
          }
        },
      })
    },
    addMovie() {
      this.$router.push({
        path: `/admin/movies/movies_edit`,
        query: { id: 0 },
      })
    },
  },
  apollo: {
    getData: {
      query() {
        const query = gql(`query MyQuery {
               movies(where: {is_delete: {_eq: false}}) {
                  id
                  code
                  name
                  name_en
                  view
                  created_at
               }
            }`)
        return query
      },
      update: (data) => {},
      result({ data }) {
        this.movies = []
        if (data && data.movies && data.movies.length > 0) {
          for (let index = 0; index < data.movies.length; index++) {
            const element = data.movies[index]

            element.stt = index + 1
            element.created_at_string = moment(element.created_at)
              .add('hours', 7)
              .format('DD-MM-YYYY HH:mm:ss')

            this.movies.push(element)
          }
        }
      },
    },
  },
}
</script>

<style>
.v-sheet--offset {
  top: -24px;
  position: relative;
}
</style>
