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

    <v-card style="height: 95vh">
      <v-card-title>
        <v-toolbar flat>
          <v-tooltip bottom>
            <template #activator="{ on, attrs }">
              <v-btn
                icon
                v-bind="attrs"
                v-on="on"
                color="error"
                @click="backToList()"
              >
                <v-icon>mdi-arrow-left</v-icon>
              </v-btn>
            </template>
            <span>Quay lại danh sách Quốc gia SX phim</span>
          </v-tooltip>

          <v-toolbar-title v-if="isEdit" class="red--text font-weight-bold">{{
            `Chỉnh sửa nơi SX: ${title_name}`
          }}</v-toolbar-title>
          <v-toolbar-title v-if="!isEdit" class="red--text font-weight-bold">{{
            `Thêm nơi SX`
          }}</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn tile color="error" :disabled="!valid" @click="openDialogSave">
            <v-icon color="white" left>mdi-content-save</v-icon>
            Lưu
          </v-btn>
        </v-toolbar></v-card-title
      >
      <v-card-text>
        <v-row class="mt-2 ml-2">
          <v-col
            cols="12"
            sm="6"
            lg="6"
            xl="6"
            md="6"
            style="margin-top: -20px"
          >
            <v-text-field
              v-model="country.code"
              label="Mã quốc gia"
              class="required"
              color="red"
              outlined
              dense
            ></v-text-field>
          </v-col>
          <v-col cols="12" sm="6" lg="6" xl="6" md="6"></v-col>
          <v-col
            cols="12"
            sm="6"
            lg="6"
            xl="6"
            md="6"
            style="margin-top: -20px"
          >
            <v-text-field
              v-model="country.name"
              label="Tên quốc gia"
              class="required"
              color="red"
              outlined
              dense
            ></v-text-field>
          </v-col>
          <v-col cols="12" sm="6" lg="6" xl="6" md="6"></v-col>
          <v-col
            cols="12"
            sm="6"
            lg="6"
            xl="6"
            md="6"
            style="margin-top: -20px"
          >
            <v-text-field
              v-model="country.name_en"
              label="Tên quốc gia (Tiếng Anh)"
              class="required"
              color="red"
              outlined
              dense
            ></v-text-field>
          </v-col>
          <v-col cols="12" sm="6" lg="6" xl="6" md="6"></v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script>
/* eslint-disable camelcase */
import axios from 'axios'
import gql from 'graphql-tag'
// import moment from 'moment'

export default {
  layout: 'admin',
  components: {},
  asyncData({ route, params }) {
    let temp = null
    if (route.query.id != null && route.query.id !== undefined) {
      temp = route.query.id
    }
    let isEdit = false
    if (temp !== null && temp !== '0') {
      isEdit = true
    }
    if (temp !== null) {
      const objId = temp
      return { objId, isEdit }
    } else {
      const objId = 0
      return { objId, isEdit }
    }
  },
  data: () => ({
    valid: true,
    isEdit: true,
    dialogSave: false,
    snackbar: false,
    title_name: '',
    textSnackbar: '',
    country: {
      id: null,
      code: null,
      name: null,
      name_en: null,
      created_at: null,
    },
  }),
  apollo: {
    countries: {
      query() {
        const query = gql(`query MyQuery {
          countries(where: {id: {_eq: ${this.objId}}}) {
              id
              code
              name
              name_en
              is_delete
              created_at
            }
          }`)
        return query
      },
      update: (data) => {},
      result({ data }) {
        if (data && data.countries && data.countries.length > 0) {
          this.country = data.countries[0]
        }
      },
    },
  },

  computed: {},

  watch: {},
  mounted() {
    console.log(this.$fire.auth)
  },
  created() {},
  methods: {
    openDialogSave() {
      // Thêm mới

      if (!this.country.code || this.country.code === '') {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng nhập mã quốc gia SX phim'
        return
      }
      if (!this.country.name || this.country.name === '') {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng nhập tên quốc gia SX phim'
        return
      }
      if (!this.country.name_en || this.country.name_en === '') {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng nhập tên quốc gia (Tiếng Anh) SX phim'
        return
      }

      this.dialogSave = true
    },

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
    save() {
      this.dialogSave = false
      if (this.isEdit === true) {
        this.updateCountry()
      } else {
        this.addCountry()
      }
    },
    backToList() {
      this.$router.push({
        path: `/admin/countries/countries`,
      })
    },
    awaitDirect() {
      setTimeout(() => this.backToList(), 1500)
    },
    async addCountry() {
      const queryCheck = gql(`query MyQuery {
                 countries(where: {name: {_ilike: "${this.country.name}"}, is_delete: {_eq: false}}) {
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
          if (response.data.countries.length > 0) {
            console.log(response.data.countries)
            this.snackbar = true
            this.textSnackbar = 'Quốc gia đã tồn tại'
          } else {
            const data_insert = {}
            data_insert.code = this.country.code
            data_insert.name = this.country.name
            data_insert.name_en = this.country.name_en
            // data_insert.created_by = this.country.created_by
            await axios
              .post(`${process.env.URL_SERVER}/api/insert-country`, {
                data_insert,
              })
              .then((response) => {
                if (response && response.data) {
                  if (response.data.status) {
                    this.textSnackbar = 'Thêm nơi SX thành công'
                    this.awaitDirect()
                    this.snackbar = true
                  } else {
                    this.textSnackbar = 'Thêm nơi SX thất bại'
                    this.snackbar = true
                  }
                }
              })
              .catch((error) => {
                console.log(error)
                this.textSnackbar =
                  'Có lỗi xảy trong quá trình thêm quốc gia SX phim'
                this.snackbar = true
              })
          }
        })
        .catch((response) => console.log(response))
    },
    async updateCountry() {
      const data_update = {}
      data_update.id = this.country.id
      data_update.code = this.country.code
      data_update.name = this.country.name
      data_update.name_en = this.country.name_en
      await axios
        .post(`${process.env.URL_SERVER}/api/update-country`, {
          data_update,
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              this.textSnackbar = 'Cập nhật nơi SX thành công'
              this.awaitDirect()
              this.snackbar = true
            } else {
              this.textSnackbar = 'Cập nhật nơi SX thất bại'
              this.snackbar = true
            }
          }
        })
        .catch((error) => {
          console.log(error)
          this.textSnackbar = 'Có lỗi xảy trong quá trình cập nhật nơi SX'
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
