<template>
  <v-layout align-center justify-center color="red">
    <v-snackbar v-model="snackbar">
      {{ textSnackbar }}

      <template v-slot:action="{ attrs }">
        <v-btn color="pink" text v-bind="attrs" @click="snackbar = false">
          Đóng
        </v-btn>
      </template>
    </v-snackbar>
    <v-flex xs12 sm8 md3 lg3>
      <v-card class="elevation-1 pa-3">
        <v-card-text>
          <div class="layout column align-center">
            <img
              src="../../static/icon.png"
              alt="Logo"
              height="120"
              class="logo"
            />
            <h2 class="flex my-4 red--text" align="center">
              ADMIN WEBSITE WMOVIES
            </h2>
          </div>
          <v-form>
            <v-text-field
              v-model="model.email"
              prepend-icon="mdi-account"
              name="login"
              label="Email"
              type="text"
              @keyup.enter="loginUser"
            ></v-text-field>
            <v-text-field
              id="password"
              v-model="model.password"
              prepend-icon="mdi-lock"
              name="password"
              label="Mật khẩu"
              type="password"
              @keyup.enter="loginUser"
            ></v-text-field>
          </v-form>
        </v-card-text>

        <v-col align="center" class="mt-n5">
          <v-btn
            block
            color="error"
            :loading="loading"
            width="15"
            @click="loginUser"
            >Đăng nhập</v-btn
          >
        </v-col>
      </v-card>
    </v-flex>
  </v-layout>
  <!-- </v-main> -->
</template>

<script>
// import gql from 'graphql-tag'
import axios from 'axios'
import cookie from 'cookiejs'
export default {
  layout: 'auth',
  data: () => ({
    dialogSignOut: false,
    loading: false,
    snackbar: false,
    textSnackbar: '',
    user: {},
    model: {
      email: '',
      password: '',
    },
  }),
  apollo: {},
  created() {},
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
      } else {
        //
      }
    } catch (error) {
      console.log(error)
    }
  },
  methods: {
    async loginUser() {
      this.loading = true
      if (this.model.email === '') {
        this.$toast.error('Vui lòng nhập email', {
          duration: 2000,
          position: 'top-center',
        })
        this.loading = false
        return
      }
      if (this.model.password === '') {
        this.$toast.error('Vui lòng nhập mật khẩu', {
          duration: 2000,
          position: 'top-center',
        })
        this.loading = false
        return
      }

      // eslint-disable-next-line camelcase
      const data_login = {
        email: this.model.email,
        password: this.model.password,
      }
      await axios
        .post(`${process.env.URL_SERVER}/account/login-admin`, {
          // eslint-disable-next-line camelcase
          data_login,
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              cookie.set('jwt-login-admin', response.data.data.token, 1)
              this.$toast.success('Đăng nhập thành công', {
                duration: 2000,
                position: 'top-center',
              })
              this.loading = false
              setTimeout(() => {
                this.$router.push('/admin/dashboard')
              }, 2000)
            } else if (
              response.data &&
              response.data.data &&
              response.data.data === 'is_guest'
            ) {
              this.$toast.error(`${response.data.message}`, {
                duration: 2000,
                position: 'top-center',
              })
              this.loading = false
              setTimeout(() => {
                this.$router.push('/')
              }, 2000)
            } else {
              this.loading = false
              this.$toast.error(`${response.data.message}`, {
                duration: 2000,
                position: 'top-center',
              })
            }
          }
        })
        .catch((error) => {
          console.log(error)
          this.loading = false
          this.$toast.error('Có lỗi xảy trong quá trình đăng nhập', {
            duration: 2000,
            position: 'top-center',
          })
        })
    },
  },
}
</script>
<style scoped lang="css">
#login {
  height: 50%;
  width: 100%;
  position: absolute;
  top: 0;
  left: 0;
  content: '';
  z-index: 0;
}
.logo {
  max-width: 100%; /* only this one important */
}
</style>
