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
            <span>Quay lại danh sách Tài khoản người xem</span>
          </v-tooltip>

          <v-toolbar-title v-if="isEdit" class="red--text font-weight-bold">{{
            `Chỉnh sửa tài khoản người xem: ${title_name}`
          }}</v-toolbar-title>
          <v-toolbar-title v-if="!isEdit" class="red--text font-weight-bold">{{
            `Thêm tài khoản người xem `
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
              v-model="user.username"
              label="Tên người dùng"
              class="required"
              color="red"
              outlined
              dense
            ></v-text-field>
          </v-col>

          <v-col cols="12" sm="6" lg="6" xl="6" md="6"> </v-col>

          <v-col
            cols="12"
            sm="6"
            lg="6"
            xl="6"
            md="6"
            style="margin-top: -20px"
          >
            <v-text-field
              v-model="user.email"
              label="Email"
              :disabled="isEdit"
              :rules="emailRules"
              class="required"
              color="red"
              outlined
              dense
            ></v-text-field>
          </v-col>

          <v-col v-if="!isEdit" cols="12" sm="6" lg="6" xl="6" md="6"> </v-col>
          <v-col
            v-if="!isEdit"
            cols="12"
            style="margin-top: -20px"
            sm="6"
            lg="6"
            xl="6"
            md="6"
          >
            <v-text-field
              v-model="user.password"
              :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[rules.min]"
              :type="showPassword ? 'text' : 'password'"
              outlined
              dense
              class="required"
              color="red"
              :label="labelPassword1"
              @click:append="showPassword = !showPassword"
            ></v-text-field>
          </v-col>
          <v-col v-if="!isEdit" cols="12" sm="6" lg="6" xl="6" md="6"> </v-col>
          <v-col
            v-if="!isEdit"
            cols="12"
            style="margin-top: -20px"
            sm="6"
            lg="6"
            xl="6"
            md="6"
          >
            <v-text-field
              v-model="user.passwordRepeat"
              :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[passwordConfirmationRule]"
              :type="showPassword ? 'text' : 'Password'"
              outlined
              class="required"
              color="red"
              dense
              :label="labelPassword2"
              @click:append="showPassword = !showPassword"
            ></v-text-field>
          </v-col>
          <v-col
            v-if="isEdit"
            cols="12"
            style="margin-top: -30px"
            sm="6"
            lg="6"
            xl="6"
            md="6"
          >
            <v-checkbox
              v-model="boolchangePassword"
              label="Reset mật khẩu"
            ></v-checkbox>
          </v-col>
          <v-col
            v-if="isEdit && boolchangePassword"
            cols="12"
            style="margin-top: -20px"
            sm="6"
            lg="6"
            xl="6"
            md="6"
          >
            <v-text-field
              v-model="user.password"
              :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[rules.min]"
              :type="showPassword ? 'text' : 'password'"
              outlined
              dense
              :label="labelPassword1"
              hint="Ít nhất 8 kí tự"
              @click:append="showPassword = !showPassword"
            ></v-text-field>
          </v-col>
          <v-col
            v-if="isEdit && boolchangePassword"
            cols="12"
            sm="6"
            lg="6"
            xl="6"
            md="6"
          >
          </v-col>
          <v-col
            v-if="isEdit && boolchangePassword"
            cols="12"
            style="margin-top: -20px"
            sm="6"
            lg="6"
            xl="6"
            md="6"
          >
            <v-text-field
              v-model="user.passwordRepeat"
              :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[passwordConfirmationRule]"
              :type="showPassword ? 'text' : 'Password'"
              outlined
              dense
              :label="labelPassword2"
              @click:append="showPassword = !showPassword"
            ></v-text-field>
          </v-col>
          <v-col cols="12" sm="6" lg="6" xl="6" md="6"> </v-col>
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
  components: {
    // UploadImage,
  },
  asyncData({ route, params }) {
    let temp = null
    if (route.query.id != null && route.query.id !== undefined) {
      temp = route.query.id
    }
    let isEdit = false
    if (temp !== null && temp !== '0') {
      isEdit = true
    }
    let labelPassword1 = 'Mật khẩu'
    let labelPassword2 = 'Xác nhận mật khẩu'
    if (temp !== null) {
      const objId = `"${temp}"`
      labelPassword1 = 'Mật khẩu mới'
      labelPassword2 = 'Xác nhận mật khẩu mới'
      return { objId, isEdit, labelPassword1, labelPassword2 }
    } else {
      const objId = `""`
      return { objId, isEdit, labelPassword1, labelPassword2 }
    }
  },
  data: () => ({
    valid: true,
    isEdit: true,
    showPassword: false,
    dialogSave: false,
    snackbar: false,
    title_name: '',
    textSnackbar: '',
    boolchangePassword: false,
    user: {
      id: null,
      username: null,
      email: null,
      created_at: null,
      password: '',
      passwordRepeat: '',
    },

    emailRules: [
      (v) =>
        !v ||
        /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(
          v
        ) ||
        'email phải đúng định dạng. vd: nvmau@gmail.com',
    ],
    rules: {
      required: (value) => !!value || 'Bắt buộc nhập.',
      min: (v) => v.length >= 8 || 'Thấp nhất 8 kí tự',
    },
  }),
  apollo: {
    users: {
      query() {
        const query = gql(`query MyQuery {
        users(where: {id: {_eq: ${this.objId}}}) {
          email
          username
          id
          is_delete
          created_at
        }
      }`)
        return query
      },
      update: (data) => {},
      result({ data }) {
        if (data && data.users && data.users.length > 0) {
          this.user = data.users[0]
          this.user.password = ''
          this.user.passwordRepeat = ''
        }
      },
    },
  },

  computed: {
    passwordConfirmationRule() {
      return () =>
        this.user.password === this.user.passwordRepeat ||
        'Mật khẩu xác nhận phải trùng với mật khẩu đã nhập'
    },
  },

  watch: {},
  mounted() {
    console.log(this.$fire.auth)
    // this.$fire.auth().onAuthStateChanged((user) => {
    //   if (user) {
    //     this.user.id = user.uid
    //     this.user.email = user.email
    //     const querySearch = gql`
    //       query MyQuery {
    //         users(
    //           where: { id: { _eq: "${this.user.id}" } }
    //         ) {
    //           employee{
    //             id
    //           }
    //           id
    //             permission_group {
    //             id
    //             code
    //             name
    //             permission_group_details(where: {permission: {code: {_eq: "employees"}}}){
    //               id
    //                 is_delete
    //                 is_edit
    //                 is_export
    //                 is_import
    //                 is_view
    //                 created_at
    //                 is_add
    //                 permission {
    //                   code
    //                   id
    //                   name
    //                 }

    //                 permission_group_id
    //                 permission_id
    //                 updated_at
    //             }
    //           }
    //         }
    //       }
    //     `

    //     this.$apollo
    //       .query({
    //         query: querySearch,
    //         fetchPolicy: 'network-only',
    //       })
    //       .then((response) => {
    //         if (response.data.users.length > 0) {
    //           this.permission =
    //             response.data.users[0].permission_group.permission_group_details[0]
    //           this.user.employee = response.data.users[0].employee
    //           if (this.isEdit && !this.permission.is_edit) {
    //             this.pushTo()
    //           } else if (!this.isEdit && !this.permission.is_add) {
    //             this.pushTo()
    //           }
    //         }
    //       })
    //       .catch((response) => console.log(response))
    //   } else {
    //     this.$router.replace({
    //       name: 'login',
    //       path: '',
    //     })
    //   }
    // })
  },
  created() {},
  methods: {
    openDialogSave() {
      // Thêm mới
      if (!this.isEdit) {
        if (!this.user.username || this.user.username === '') {
          this.snackbar = true
          this.textSnackbar = 'Vui lòng nhập tên người dùng'
          return
        }
        if (!this.user.email || this.user.email === '') {
          this.snackbar = true
          this.textSnackbar = 'Vui lòng nhập email'
          return
        }
        if (!this.user.password || this.user.password === '') {
          this.snackbar = true
          this.textSnackbar = 'Vui lòng nhập mật khẩu'
          return
        }
        if (!this.user.passwordRepeat || this.user.passwordRepeat === '') {
          this.snackbar = true
          this.textSnackbar = 'Vui lòng nhập mật khẩu xác nhận'
          return
        }
        if (
          this.user.passwordRepeat &&
          this.user.passwordRepeat !== this.user.password
        ) {
          this.snackbar = true
          this.textSnackbar = 'Mật khẩu xác nhận không giống mật khẩu đã nhập'
          return
        }
      } else {
        if (!this.user.username || this.user.username === '') {
          this.snackbar = true
          this.textSnackbar = 'Vui lòng nhập tên người dùng'
          return
        }

        if (
          this.boolchangePassword &&
          (!this.user.password || this.user.password === '')
        ) {
          this.snackbar = true
          this.textSnackbar = 'Vui lòng nhập mật khẩu'
          return
        }
        if (
          this.boolchangePassword &&
          (!this.user.passwordRepeat || this.user.passwordRepeat === '')
        ) {
          this.snackbar = true
          this.textSnackbar = 'Vui lòng nhập mật khẩu xác nhận'
          return
        }
        if (
          this.boolchangePassword &&
          this.user.passwordRepeat &&
          this.user.passwordRepeat !== this.user.password
        ) {
          this.snackbar = true
          this.textSnackbar = 'Mật khẩu xác nhận không giống mật khẩu đã nhập'
          return
        }
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
        this.updateUser()
      } else {
        this.addUser()
      }
    },
    closeDelete() {
      this.dialogDelete = false
    },
    addToTableNewServiceDoctor() {
      if (
        this.service_doctor.service === null ||
        this.service_doctor.service.id === null
      ) {
        this.textSnackbar = 'Vui lòng chọn dịch vụ'
        this.snackbar = true
        return
      }
      for (let index = 0; index < this.service_doctors.length; index++) {
        const element = this.service_doctors[index]
        if (this.service_doctor.service.id === element.service.id) {
          this.textSnackbar = 'Dịch vụ đã có trong bảng'
          this.snackbar = true
          return
        }
      }
      if (this.isEdit) {
        this.obj = {
          id: null,
          service: {
            id: this.service_doctor.service.id,
            name: this.service_doctor.service.name,
          },
          is_pause: this.service_doctor.is_pause,
        }
      } else {
        this.obj = {
          id: null,
          service: {
            id: this.service_doctor.service.id,
            name: this.service_doctor.service.name,
          },
          is_pause: this.service_doctor.is_pause,
        }
      }

      this.service_doctors.push(this.obj)
    },
    backToList() {
      this.$router.push({
        path: `/admin/users/users`,
      })
    },
    convertViToEn(str, toUpperCase = true) {
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
    awaitDirect() {
      setTimeout(() => this.backToList(), 1500)
    },
    async addUser() {
      const queryCheckMail = gql(`query MyQuery {
             users(where: {email: {_eq: "${this.user.email}"}, is_delete: {_eq: false}}) {
                id
                username
                email
                password
                created_at
                is_delete
             }
          }`)
      await this.$apollo
        .query({
          query: queryCheckMail,
          fetchPolicy: 'network-only',
        })
        .then(async (response) => {
          if (response.data.users.length > 0) {
            console.log(response.data.users)
            this.snackbar = true
            this.textSnackbar = 'Tài khoản email đã tồn tại'
            // eslint-disable-next-line no-useless-return
          } else {
            const data_insert = {}
            data_insert.username = this.user.username
            data_insert.password = this.user.password
            data_insert.email = this.user.email
            await axios
              .post(`${process.env.URL_SERVER}/api/insert-user`, {
                data_insert,
              })
              .then((response) => {
                if (response && response.data) {
                  if (response.data.status) {
                    this.textSnackbar = 'Thêm tài khoản người xem thành công'
                    this.awaitDirect()
                    this.snackbar = true
                  } else {
                    this.textSnackbar = 'Thêm tài khoản người xem thất bại'
                    this.snackbar = true
                  }
                }
              })
              .catch((error) => {
                console.log(error)
                this.textSnackbar = 'Có lỗi xảy trong quá trình thêm tài khoản'
                this.snackbar = true
              })
          }
        })
        .catch((response) => console.log(response))
    },
    async updateUser() {
      const data_update = {}
      data_update.id = this.user.id
      data_update.username = this.user.username
      data_update.password =
        this.user.password && this.user.password !== ''
          ? this.user.password
          : null
      await axios
        .post(`${process.env.URL_SERVER}/api/update-user`, {
          data_update,
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              this.textSnackbar = 'Cập nhật tài khoản người xem thành công'
              this.awaitDirect()
              this.snackbar = true
            } else {
              this.textSnackbar = 'Cập nhật tài khoản người xem thất bại'
              this.snackbar = true
            }
          }
        })
        .catch((error) => {
          console.log(error)
          this.textSnackbar = 'Có lỗi xảy trong quá trình thêm tài khoản'
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
