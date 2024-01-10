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
            <span>Quay lại danh sách Thể loại phim</span>
          </v-tooltip>

          <v-toolbar-title v-if="isEdit" class="red--text font-weight-bold">{{
            `Chỉnh sửa thể loại: ${title_name}`
          }}</v-toolbar-title>
          <v-toolbar-title v-if="!isEdit" class="red--text font-weight-bold">{{
            `Thêm thể loại`
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
              v-model="category.code"
              label="Mã thể loại"
              class="required"
              color="red"
              outlined
              dense
            ></v-text-field>
          </v-col>
          <v-col
            cols="12"
            sm="6"
            lg="6"
            xl="6"
            md="6"
            style="margin-top: -20px"
          >
            <v-text-field
              v-model="category.name"
              label="Tên thể loại"
              class="required"
              color="red"
              outlined
              dense
            ></v-text-field>
          </v-col>
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
    category: {
      id: null,
      code: null,
      name: null,
      created_at: null,
    },
  }),
  apollo: {
    categories: {
      query() {
        const query = gql(`query MyQuery {
        categories(where: {id: {_eq: ${this.objId}}}) {
            id
            code
            name
            is_delete
            created_at
          }
        }`)
        return query
      },
      update: (data) => {},
      result({ data }) {
        if (data && data.categories && data.categories.length > 0) {
          this.category = data.categories[0]
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

      if (!this.category.code || this.category.code === '') {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng nhập mã thể loại'
        return
      }
      if (!this.category.name || this.category.name === '') {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng nhập tên thể loại'
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
        this.updateCategory()
      } else {
        this.addCategory()
      }
    },
    backToList() {
      this.$router.push({
        path: `/admin/categories/categories`,
      })
    },
    awaitDirect() {
      setTimeout(() => this.backToList(), 1500)
    },
    async addCategory() {
      const queryCheck = gql(`query MyQuery {
               categories(where: {name: {_ilike: "${this.category.name}"}, is_delete: {_eq: false}}) {
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
          if (response.data.categories.length > 0) {
            console.log(response.data.categories)
            this.snackbar = true
            this.textSnackbar = 'Thể loại đã tồn tại'
          } else {
            const data_insert = {}
            data_insert.code = this.category.code
            data_insert.name = this.category.name
            // data_insert.created_by = this.category.created_by
            await axios
              .post(`${process.env.URL_SERVER}/api/insert-category`, {
                data_insert,
              })
              .then((response) => {
                if (response && response.data) {
                  if (response.data.status) {
                    this.textSnackbar = 'Thêm thể loại thành công'
                    this.awaitDirect()
                    this.snackbar = true
                  } else {
                    this.textSnackbar = 'Thêm thể loại thất bại'
                    this.snackbar = true
                  }
                }
              })
              .catch((error) => {
                console.log(error)
                this.textSnackbar = 'Có lỗi xảy trong quá trình thêm thể loại'
                this.snackbar = true
              })
          }
        })
        .catch((response) => console.log(response))
    },
    async updateCategory() {
      const data_update = {}
      data_update.id = this.category.id
      data_update.code = this.category.code
      data_update.name = this.category.name
      await axios
        .post(`${process.env.URL_SERVER}/api/update-category`, {
          data_update,
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              this.textSnackbar = 'Cập nhật thể loại thành công'
              this.awaitDirect()
              this.snackbar = true
            } else {
              this.textSnackbar = 'Cập nhật thể loại thất bại'
              this.snackbar = true
            }
          }
        })
        .catch((error) => {
          console.log(error)
          this.textSnackbar = 'Có lỗi xảy trong quá trình cập nhật thể loại'
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
