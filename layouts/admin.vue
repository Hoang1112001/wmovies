<template>
  <v-app dark>
    <v-main>
      <v-dialog v-model="dialogSignOut" width="unset">
        <v-card>
          <v-card-title class="subtitle-1 red--text">
            Bạn có chắc muốn đăng xuất không?</v-card-title
          >
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="error" text @click="dialogSignOut = false"
              >Không</v-btn
            >
            <v-btn color="error" text @click="signOut()">Có</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      <v-dialog v-model="dialogChangeInfo" max-width="500">
        <v-card>
          <v-card-text>
            <v-row class="pa-5 mx-auto">
              <v-col cols="12" sm="12" lg="12" xl="12" md="12">
                <p class="font-weight-medium red--text">THÔNG TIN CƠ BẢN</p>
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
                  v-model="admin.username"
                  label="Tên Admin"
                  outlined
                  disabled
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
                  v-model="admin.email"
                  label="email"
                  disabled
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
                style="margin-top: -35px"
              >
                <v-divider class="py-1"></v-divider>
                <p class="font-weight-medium red--text">ĐỔI MẬT KHẨU</p>
              </v-col>

              <v-col
                cols="12"
                style="margin-top: -20px"
                sm="12"
                lg="12"
                xl="12"
                md="12"
              >
                <v-text-field
                  v-model="admin.oldPassword"
                  :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                  :rules="[rules.required, rules.min]"
                  :type="showPass ? 'text' : 'password'"
                  outlined
                  dense
                  label="Mật khẩu cũ"
                  hint="Ít nhất 8 kí tự"
                  @click:append="showPass = !showPass"
                ></v-text-field>
              </v-col>

              <v-col
                cols="12"
                style="margin-top: -20px"
                sm="12"
                lg="12"
                xl="12"
                md="12"
              >
                <v-text-field
                  v-model="admin.password"
                  :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                  :rules="[rules.required, rules.min]"
                  :type="showPass ? 'text' : 'password'"
                  outlined
                  dense
                  label="Mật khẩu mới"
                  hint="Ít nhất 8 kí tự"
                  @click:append="showPass = !showPass"
                ></v-text-field>
              </v-col>

              <v-col
                cols="12"
                style="margin-top: -20px"
                sm="12"
                lg="12"
                xl="12"
                md="12"
              >
                <v-text-field
                  v-model="admin.passwordRepeat"
                  :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                  :rules="[rules.required, rules.min]"
                  :type="showPass ? 'text' : 'Password'"
                  outlined
                  dense
                  label="Xác nhận mật khẩu mới"
                  hint="Ít nhất 8 kí tự"
                  @click:append="showPass = !showPass"
                ></v-text-field>
              </v-col> </v-row
          ></v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="error" text @click="closeDialogChangeInfo">
              Đóng
            </v-btn>
            <v-btn color="error" text @click="changePassword"> Lưu </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      <v-layout class="d-flex flex-row">
        <v-navigation-drawer
          fixed
          disable-resize-watcher
          disable-route-watcher
          permanent
          app
          color="error white--text"
        >
          <v-list>
            <v-list-item class="px-2">
              <v-list-item-avatar>
                <!-- <v-img
                src="https://randomuser.me/api/portraits/women/85.jpg"
              ></v-img> -->
                <v-icon color="white">mdi-robot</v-icon>
              </v-list-item-avatar>
              <v-list-item-content class="mt-2 white--text">
                <v-list-item-title class="text-h6">
                  {{ admin.username }}
                </v-list-item-title>
                <v-list-item-subtitle class="white--text">{{
                  admin.email
                }}</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
            <v-list-item class="d-flex">
              <v-btn @click="dialogChangeInfo = true" text small color="white"
                >[Đổi mật khẩu]</v-btn
              >
              <v-btn @click="dialogSignOut = true" text small color="white"
                >[Đăng xuất]</v-btn
              >
            </v-list-item>
          </v-list>

          <v-divider></v-divider>

          <v-list>
            <v-list-item link @click="toLink('admin/dashboard')">
              <v-list-item-icon>
                <v-icon color="white">mdi-home</v-icon>
              </v-list-item-icon>

              <v-list-item-title class="white--text font-weight-bold"
                >Trang chủ</v-list-item-title
              >
            </v-list-item>
            <v-list-item link @click="toLink('admin/users/users')">
              <v-list-item-icon>
                <v-icon color="white">mdi-account-group</v-icon>
              </v-list-item-icon>

              <v-list-item-title class="white--text font-weight-bold"
                >Quản lý tài khoản</v-list-item-title
              >
            </v-list-item>
            <v-list-group :value="true">
              <template v-slot:activator>
                <v-list-item-icon>
                  <v-icon color="white">mdi-movie-open</v-icon>
                </v-list-item-icon>
                <v-list-item-title class="white--text font-weight-bold"
                  >Quản lý phim</v-list-item-title
                >
              </template>
              <v-list-item
                v-for="([title, icon, link], i) in subLink"
                :key="i"
                link
                @click="toLink(link)"
              >
                <v-list-item-title class="white--text font-weight-bold">{{
                  title
                }}</v-list-item-title>

                <v-list-item-icon>
                  <v-icon color="white">{{ icon }}</v-icon>
                </v-list-item-icon>
              </v-list-item>
            </v-list-group>
            <v-list-item link @click="toLink('admin/errors')">
              <v-list-item-icon>
                <v-icon color="white">mdi-alert-circle</v-icon>
              </v-list-item-icon>

              <v-list-item-title class="white--text font-weight-bold"
                >Báo lỗi</v-list-item-title
              >
            </v-list-item>
            <v-list-item link @click="toLink('admin/feedbacks')">
              <v-list-item-icon>
                <v-icon color="white">mdi-comment-quote</v-icon>
              </v-list-item-icon>

              <v-list-item-title class="white--text font-weight-bold"
                >Feedbacks</v-list-item-title
              >
            </v-list-item>
          </v-list>
        </v-navigation-drawer>
        <v-container fluid style="margin: 0px; padding: 5px; width: 100%">
          <nuxt
        /></v-container>
      </v-layout>
    </v-main>
  </v-app>
</template>
<script>
import cookie from 'cookiejs'
import axios from 'axios'
export default {
  layout: 'admin',
  name: 'Homepage',
  data() {
    return {
      rules: {
        required: (value) => !!value || 'Bắt buộc nhập.',
        min: (v) => v.length >= 8 || 'Thấp nhất 8 kí tự',
      },
      showPass: false,
      snackbar: true,
      textSnackbar: '',
      dialogSignOut: false,
      dialogChangeInfo: false,
      subLink: [
        ['Danh sách phim', 'mdi-movie-search', 'admin/movies/movies'],
        ['Danh sách diễn viên', 'mdi-account-search', 'admin/actors/actors'],
        ['Danh sách thể loại', 'mdi-shape-plus', 'admin/categories/categories'],
        ['Danh sách nơi SX', 'mdi-earth', 'admin/countries/countries'],
      ],
      admin: {
        id: null,
        tempUsername: '',
        username: '',
        email: '',
        password: '',
        passwordRepeat: '',
        oldPassword: '',
      },
    }
  },
  async mounted() {
    try {
      const requestGetUser = await fetch(
        `${process.env.URL_SERVER}/account/get-admin`,
        {
          method: 'GET', // *GET, POST, PUT, DELETE, etc.
          mode: 'cors', // no-cors, *cors, same-origin
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Credentials': true,
            'Content-Type': 'application/json',
          },
          credentials: 'include',
        }
      )
      const response = await requestGetUser.json()

      if (response.status) {
        this.$router.push('/admin/dashboard')
        const dataUser = response.data
        this.admin = {
          id: dataUser.id,
          username: dataUser.username,
          email: dataUser.email,
          password: '',
          passwordRepeat: '',
          oldPassword: '',
        }
        this.$nuxt.$emit('auth-admin', this.admin.id)
      } else {
        this.$router.push('/admin')
        this.$nuxt.$emit('auth-admin', this.admin.id)
      }
    } catch (error) {
      console.log(error)
    }
  },
  watch: {},
  methods: {
    async changePassword() {
      if (this.admin.oldPassword === '') {
        this.$toast.error('Vui lòng nhập mật khẩu cũ', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }
      if (this.admin.password === '') {
        this.$toast.error('Vui lòng nhập mật khẩu mới', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }
      if (this.admin.passwordRepeat === '') {
        this.$toast.error('Vui lòng nhập mật khẩu xác nhận', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }
      if (
        this.admin.password !== '' &&
        this.admin.passwordRepeat !== '' &&
        this.admin.passwordRepeat !== this.admin.password
      ) {
        this.$toast.error('Mật khẩu xác nhận phải trùng với mật khẩu mới', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }

      const dataUpdate = {}
      dataUpdate.id = this.admin.id
      dataUpdate.oldPassword = this.admin.oldPassword
      dataUpdate.newPassword = this.admin.password

      await axios
        .post(`${process.env.URL_SERVER}/account/change-password-admin`, {
          // eslint-disable-next-line camelcase
          data_update: dataUpdate,
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              this.$toast.success(`${response.data.message}`, {
                duration: 3000,
                position: 'top-center',
              })
              if (
                response.data.data &&
                response.data.data === 'update_password_success'
              ) {
                this.closeDialogChangeInfo()
                setTimeout(() => {
                  this.signOut()
                }, 3000)
              }
            } else {
              this.$toast.error(`${response.data.message}`, {
                duration: 2000,
                position: 'top-center',
              })
              if (
                response.data.data &&
                response.data.data === 'incorret_old_password'
              ) {
                //
              } else {
                this.closeDialogChangeInfo()
              }
            }
          }
        })
        .catch((error) => {
          console.log(error)
          this.$toast.error('Có lỗi xảy trong quá trình đổi mật khấu', {
            duration: 2000,
            position: 'top-center',
          })
          this.closeDialogChangeInfo()
        })
    },
    signOut() {
      cookie.remove('jwt-login-admin')
      this.$router.replace({
        path: `/admin`,
      })
    },
    closeDialogChangeInfo() {
      this.dialogChangeInfo = false
      this.admin.password = ''
      this.admin.passwordRepeat = ''
      this.admin.oldPassword = ''
    },
    toLink(link) {
      this.$router.push({
        path: `/${link}`,
      })
    },
  },
}
</script>

<style></style>
