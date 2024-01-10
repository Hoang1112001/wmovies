<!-- eslint-disable camelcase -->
<template>
  <v-container fluid color="error">
    <v-snackbar v-model="snackbar">
      {{ textSnackbar }}

      <template v-slot:action="{ attrs }">
        <v-btn color="pink" text v-bind="attrs" @click="snackbar = false">
          Đóng
        </v-btn>
      </template>
    </v-snackbar>
    <v-dialog v-model="dialogDelete" width="unset">
      <v-sheet outlined color="error" rounded>
        <v-card>
          <v-card-title class="h5 red--text"
            >Bạn có chắc muốn xóa không?</v-card-title
          >
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="error" text @click="closeDelete">Không</v-btn>
            <v-btn color="error" text @click="deleteCountryConfirm">Có</v-btn>
            <v-spacer></v-spacer>
          </v-card-actions>
        </v-card>
      </v-sheet>
    </v-dialog>
    <v-card>
      <v-card-title style="left: 50%" class="red--text font-weight-bold"
        >QUẢN LÝ QUỐC GIA SẢN XUẤT PHIM TRÊN WMOVIES
      </v-card-title>
      <v-card-text>
        <v-data-table
          :search="search"
          :headers="headers"
          :items="countries"
          :footer-props="{
            itemsPerPageText: 'số dòng mỗi trang',
            pageText: '{0}-{1} trên {2}',
          }"
          item-key="id"
          class="elevation-1"
          loading-text="Đang tải...vui lòng đợi"
        >
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
                label="Tìm quốc gia sản xuất phim..."
                single-line
                hide-details
                @keyup.enter="searchAll"
              ></v-text-field>
              <v-spacer></v-spacer>
              <v-btn outlined color="error" class="mb-2" @click="addCountry()">
                Thêm quốc gia SX
              </v-btn>
            </v-toolbar>
          </template>

          <template #[`item.actions`]="{ item }">
            <v-icon small class="mr-2" @click="editCountry(item)">
              mdi-pencil
            </v-icon>
            <v-icon small @click="deleteCountry(item)"> mdi-delete </v-icon>
          </template>
          <template #no-data>
            <v-btn color="error" @click="loadCategories"> Làm mới </v-btn>
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
  name: 'Categories',
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
          text: 'Mã quốc gia',
          value: 'code',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Tên quốc gia',
          value: 'name',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Tên quốc gia (Tiếng Anh)',
          value: 'name_en',
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
      countries: [],
      country: {
        id: null,
        code: null,
        name: null,
        name_en: null,
        created_at: null,
      },
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
    getTotalData(data) {},
    editCountry(item) {
      this.$router.push({
        path: `/admin/countries/countries_edit`,
        query: { id: item.id },
      })
    },
    deleteCountry(item) {
      this.editedIndex = this.countries.indexOf(item)
      if (this.editedIndex !== -1) {
        const queryCheck = gql` query MyQuery {
            movies(where: { country_id: { _eq: ${item.id} },  is_delete: {_eq: false} }) 
            {
              id
            }
          }`
        this.$apollo
          .query({
            query: queryCheck,
            fetchPolicy: 'no-cache',
          })
          .then((response) => {
            if (
              response &&
              response.data &&
              response.data.movies &&
              response.data.movies.length > 0
            ) {
              this.textSnackbar = 'Vui lòng xóa phim thuộc quốc gia này'
              this.snackbar = true
            } else {
              this.dialogDelete = true
            }
          })
          .catch((response) => {
            console.log(response)
            this.textSnackbar = 'Có lỗi xảy ra, vui lòng thử lại'
            this.snackbar = true
          })
      } else {
        this.snackbar = true
        this.textSnackbar = 'Không tìm thấy quốc gia trên hệ thống'
      }
    },
    loadCategories() {
      this.$apollo.queries.getData.refetch()
    },
    deleteCountryConfirm() {
      const getItem = this.countries[this.editedIndex]
      const updateGraphl = gql` mutation MyMutation {
            update_countries(
              where: { id: { _eq: "${getItem.id}" } }
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
        update: (store, { data: { update_countries } }) => {
          // eslint-disable-next-line camelcase
          if (update_countries.affected_rows) {
            this.$apollo.queries.getData.refetch()
            this.textSnackbar = 'Xóa quốc gia sản xuất phim thành công'
            this.snackbar = true
            this.closeDelete()
          } else {
            this.textSnackbar = 'Xóa quốc gia sản xuất phim thất bại'
            this.snackbar = true
            this.closeDelete()
          }
        },
      })
    },
    addCountry() {
      this.$router.push({
        path: `/admin/countries/countries_edit`,
        query: { id: 0 },
      })
    },
    searchAll() {},
  },
  apollo: {
    getData: {
      query() {
        const query = gql(`query MyQuery {
                 countries(where: {is_delete: {_eq: false}}) {
                    id
                    code
                    name
                    name_en
                    created_at
                 }
              }`)
        return query
      },
      update: (data) => {},
      result({ data }) {
        this.countries = []
        if (data && data.countries && data.countries.length > 0) {
          for (let index = 0; index < data.countries.length; index++) {
            const element = data.countries[index]
            element.stt = index + 1
            element.created_at_string = moment(element.created_at)
              .add('hours', 7)
              .format('DD-MM-YYYY HH:mm:ss')

            this.countries.push(element)
          }
        }
      },
    },
  },
}
</script>

<style></style>
