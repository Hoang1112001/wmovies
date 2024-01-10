<template>
  <v-app-bar class="error" app fixed dark>
    <v-dialog v-model="dialogSignOut" width="unset">
      <v-card>
        <v-card-title class="subtitle-1 red--text">
          Bạn có chắc muốn đăng xuất không?</v-card-title
        >
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="dialogSignOut = false">Không</v-btn>
          <v-btn color="error" text @click="signOut()">Có</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialogChangeInfo" max-width="500" eager>
      <v-card>
        <v-card-text>
          <v-form ref="formChange" v-model="valid" lazy-validation>
            <v-row class="pa-5 mx-auto">
              <v-col cols="12" sm="12" lg="12" xl="12" md="12">
                <h3 class="font-weight-medium red--text">
                  THÔNG TIN NGƯỜI DÙNG
                </h3>
              </v-col>

              <v-col cols="12" sm="12" lg="12" xl="12" md="12">
                <v-text-field
                  v-model="user.username"
                  label="Tên người dùng"
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
                  v-model="user.email"
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
                <div class="d-flex">
                  <v-checkbox
                    small
                    color="error"
                    class="mt-n2"
                    v-model="isChangePassword"
                  >
                    <template v-slot:label>
                      <p class="mt-4 font-weight-medium red--text h5">
                        ĐỔI MẬT KHẨU
                      </p>
                    </template>
                  </v-checkbox>
                </div>
              </v-col>

              <v-col
                v-show="isChangePassword"
                cols="12"
                style="margin-top: -30px"
                sm="12"
                lg="12"
                xl="12"
                md="12"
              >
                <v-text-field
                  v-model="user.oldPassword"
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
                v-show="isChangePassword"
                cols="12"
                style="margin-top: -20px"
                sm="12"
                lg="12"
                xl="12"
                md="12"
              >
                <v-text-field
                  v-model="user.password"
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
                v-show="isChangePassword"
                cols="12"
                style="margin-top: -20px"
                sm="12"
                lg="12"
                xl="12"
                md="12"
              >
                <v-text-field
                  v-model="user.verify"
                  :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                  :rules="[rules.required, rules.min, passwordMatch]"
                  :type="showPass ? 'text' : 'Password'"
                  outlined
                  dense
                  label="Xác nhận mật khẩu mới"
                  hint="Ít nhất 8 kí tự"
                  @click:append="showPass = !showPass"
                ></v-text-field>
              </v-col> </v-row
          ></v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="closeDialogChangeInfo(false)">
            Đóng
          </v-btn>
          <v-btn color="error" text @click="changeChangeInfo"> Lưu </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialogSignIn" max-width="600px" min-width="360px" eager>
      <div>
        <v-tabs
          v-model="tab"
          show-arrows
          background-color="error accent-4"
          icons-and-text
          dark
          grow
          eager
        >
          <v-tabs-slider color="purple darken-4"></v-tabs-slider>
          <v-tab v-for="i in tabs" :key="i.name">
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
    <v-row>
      <v-col cols="12" sm="1" lg="1" xl="1" md="1" color="white"> </v-col>
      <v-col cols="12" sm="10" lg="10" xl="10" md="10" color="white">
        <v-row>
          <v-layout style="margin-top: 17px">
            <v-tooltip bottom>
              <template v-slot:activator="{ on, attrs }">
                <NuxtLink to="/">
                  <v-btn v-bind="attrs" v-on="on" text small>
                    <v-icon style="margin-top: -3px">mdi-home</v-icon>
                    Home</v-btn
                  >
                </NuxtLink>
              </template>
              <span>Trang chủ</span>
            </v-tooltip>
            <v-tooltip bottom>
              <template v-slot:activator="{ on, attrs }">
                <NuxtLink to="/methods">
                  <v-btn v-bind="attrs" v-on="on" text small>
                    <v-icon style="margin-top: -3px">mdi-headset-dock</v-icon>
                    Guide</v-btn
                  >
                </NuxtLink>
              </template>

              <span>Hướng dẫn</span>
            </v-tooltip>
            <v-tooltip bottom>
              <template v-slot:activator="{ on, attrs }">
                <NuxtLink to="/search">
                  <v-btn v-bind="attrs" v-on="on" text small>
                    <v-icon style="margin-top: -3px">mdi-magnify</v-icon>
                    Search</v-btn
                  >
                </NuxtLink>
              </template>

              <span>Tìm kiếm phim</span>
            </v-tooltip>
            <v-spacer></v-spacer>
            <v-img
              style="margin-top: -20px"
              max-height="68"
              max-width="80"
              :src="require('~/static/logo.png')"
            ></v-img>
            <v-spacer></v-spacer>
            <v-spacer></v-spacer>

            <v-tooltip v-if="!isLogin" bottom>
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  @click="openDialogSignIn"
                  text
                  small
                  v-bind="attrs"
                  v-on="on"
                >
                  <v-icon style="margin-top: -3px">mdi-account</v-icon>
                  Sign in/Sign up
                </v-btn>
              </template>
              <span>Đăng nhập / Đăng ký</span>
            </v-tooltip>
            <v-menu v-else bottom offset-y :close-on-content-click="false">
              <template v-slot:activator="{ on, attrs }">
                <v-btn small color="white" text v-bind="attrs" v-on="on">
                  Hi, {{ user.username }} <v-icon small>mdi-menu-down</v-icon>
                </v-btn>
              </template>

              <v-card class="mx-auto" max-width="344" outlined>
                <v-list-item three-line>
                  <v-list-item-avatar tile size="80" color="grey">
                    <v-img
                      v-if="user.image_user"
                      :src="user.image_user"
                    ></v-img>
                    <v-icon v-else>mdi-account</v-icon></v-list-item-avatar
                  >
                  <v-list-item-content>
                    <div class="d-flex">
                      <v-list-item-title class="text-h6 ml-2">
                        {{ user.username }}
                      </v-list-item-title>
                    </div>

                    <v-list-item-subtitle class="ml-2 mt-1">{{
                      user.email
                    }}</v-list-item-subtitle>
                    <v-list-item-subtitle class="mt-1"
                      ><v-btn
                        color="error"
                        class="mt-n2"
                        text
                        x-small
                        @click="openDialogChangeInfo"
                        >[Cập nhật thông tin]</v-btn
                      >
                      <v-btn
                        class="mt-n2"
                        color="error"
                        text
                        x-small
                        @click="dialogSignOut = true"
                      >
                        [Đăng xuất]</v-btn
                      ></v-list-item-subtitle
                    >
                  </v-list-item-content>
                </v-list-item>

                <v-card-actions clas="d-flex">
                  <v-btn
                    @click="toLink('dictionary/word')"
                    outlined
                    rounded
                    text
                    x-small
                  >
                    Từ vựng
                  </v-btn>
                  <v-btn
                    @click="toLink('history')"
                    outlined
                    rounded
                    text
                    x-small
                  >
                    Phim đã xem
                  </v-btn>
                  <v-btn
                    @click="toLink('favourite')"
                    outlined
                    rounded
                    text
                    x-small
                  >
                    Phim yêu thích</v-btn
                  >
                </v-card-actions>
              </v-card>
            </v-menu>
          </v-layout>
        </v-row>
      </v-col>
      <v-col cols="12" sm="1" lg="1" xl="1" md="1" color="white"> </v-col>
    </v-row>
  </v-app-bar>
</template>
<script>
// Nơi để import package
import axios from 'axios'
import cookie from 'cookiejs'
export default {
  layout: '', // layout chính của file
  props: {}, // Nhận data được truyền vào
  data: () => ({
    isLogin: false,
    dialogSignOut: false,
    dialogChangeInfo: false,
    dialogSignIn: false,
    tab: 0,
    tabs: [
      { name: 'Đăng nhập', icon: 'mdi-account' },
      { name: 'Đăng ký', icon: 'mdi-television-box' },
    ],
    valid: true,
    user: {
      id: null,
      tempUsername: '',
      username: '',
      email: '',
      password: '',
      verify: '',
      oldPassword: '',
    },
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
    isChangePassword: false,
    showPass: false,
    rules: {
      required: (value) => !!value || 'Mật khẩu không được để trống',
      min: (v) => (v && v.length >= 8) || 'Tối thiểu 8 kí tự',
    },
  }),
  computed: {
    // compute field xài trên giao diện
    passwordMatch() {
      return () =>
        this.signUpItem.password === this.signUpItem.verify ||
        'Mật khẩu xác nhận không trùng với mật khẩu đã nhập'
    },
  },
  watch: {
    // theo dõi các field
  },
  created() {
    // called before the DOM has been mounted or rendered
  },

  async mounted() {
    try {
      const requestGetUser = await fetch(
        `${process.env.URL_SERVER}/account/get-user`,
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
        const dataUser = response.data
        this.user = {
          image_user: dataUser.image_user ? dataUser.image_user : null,
          id: dataUser.id,
          tempUsername: dataUser.username,
          username: dataUser.username,
          email: dataUser.email,
          password: '',
          verify: '',
          oldPassword: '',
        }
        this.isLogin = true
        localStorage.setItem('user_id', this.user.id)
        // this.$nuxt.$emit('auth', this.user.id)
      } else {
        localStorage.removeItem('user_id')
        // this.$nuxt.$emit('auth', this.user.id)
      }
    } catch (error) {
      localStorage.removeItem('user_id')
    }
  },

  methods: {
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
        .post(`${process.env.URL_SERVER}/account/login-user`, {
          // eslint-disable-next-line camelcase
          data_login,
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              cookie.set('jwt-login', response.data.data.token, 1)
              this.dialogSignIn = false
              this.$toast.success('Đăng nhập thành công', {
                duration: 2000,
                position: 'top-center',
              })
              setTimeout(() => {
                location.reload()
              }, 3000)
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
    openDialogSignIn() {
      this.dialogSignIn = true
      this.$refs.formLogin.resetValidation()
      this.$refs.formRegister.resetValidation()
    },
    signOut() {
      cookie.remove('jwt-login')
      localStorage.removeItem('user_id')
      location.reload()
    },
    openDialogChangeInfo() {
      this.isChangePassword = false
      this.dialogChangeInfo = true
    },
    closeDialogChangeInfo(isUpdate) {
      this.$refs.formChange.resetValidation()
      this.dialogChangeInfo = false
      if (!isUpdate) {
        this.user.username = this.user.tempUsername
      }
      this.user.password = ''
      this.user.verify = ''
      this.user.oldPassword = ''
    },
    async changeChangeInfo() {
      if (this.user.username === '') {
        this.$toast.error('Vui lòng nhập tên người dùng', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }
      if (this.isChangePassword) {
        if (this.user.oldPassword === '') {
          this.$toast.error('Vui lòng nhập mật khẩu cũ', {
            duration: 2000,
            position: 'top-center',
          })
          return
        }
        if (this.user.password === '') {
          this.$toast.error('Vui lòng nhập mật khẩu mới', {
            duration: 2000,
            position: 'top-center',
          })
          return
        }
        if (this.user.verify === '') {
          this.$toast.error('Vui lòng nhập mật khẩu xác nhận', {
            duration: 2000,
            position: 'top-center',
          })
          return
        }
        if (
          this.user.password !== '' &&
          this.user.verify !== '' &&
          this.user.verify !== this.user.password
        ) {
          this.$toast.error('Mật khẩu xác nhận phải trùng với mật khẩu mới', {
            duration: 2000,
            position: 'top-center',
          })
          return
        }
      }
      const dataUpdate = {}
      dataUpdate.id = this.user.id
      dataUpdate.username = this.user.username
      if (this.isChangePassword) {
        dataUpdate.oldPassword = this.user.oldPassword
        dataUpdate.newPassword = this.user.password
      }
      await axios
        .post(`${process.env.URL_SERVER}/account/update-user-client`, {
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
                this.closeDialogChangeInfo(true)
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
                this.closeDialogChangeInfo(true)
              }
            }
          }
        })
        .catch((error) => {
          console.log(error)
          this.$toast.error('Có lỗi xảy trong quá trình cập nhật thông tin', {
            duration: 2000,
            position: 'top-center',
          })
          this.closeDialogChangeInfo(false)
        })
    },
    toLink(link) {
      this.$router.push(`/user/${link}`)
      this.dialogSignIn = false
    },
    loginUserWithGoogle() {
      window.location.href = `${process.env.URL_SERVER}/auth/google`
    },
  },
}
</script>
<style scoped>
/* When the input field gets focus, change its width to 100% */
.hot-search:focus {
  width: 100%;
}
</style>
