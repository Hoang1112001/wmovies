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
      <v-card class="elevation-1 pa-3 mt-3 mb-2" height="450">
        <v-card-text>
          <div class="layout column align-center">
            <img
              src="../../static/icon.png"
              alt="Logo"
              height="120"
              class="logo"
            />
            <h2 v-if="!statusCheck" class="flex my-4 red--text" align="center">
              RESET MẬT KHẨU MỚI
            </h2>
          </div>
          <v-form v-if="!statusCheck">
            <v-text-field
              v-model="model.password"
              :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[rules.required, rules.min]"
              :type="showPass ? 'text' : 'password'"
              outlined
              dense
              label="Mật khẩu mới"
              hint="Ít nhất 8 kí tự"
              @click:append="showPass = !showPass"
            ></v-text-field>
            <v-text-field
              v-model="model.verify"
              :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[rules.required, rules.min]"
              :type="showPass ? 'text' : 'Password'"
              outlined
              dense
              label="Xác nhận mật khẩu mới"
              hint="Ít nhất 8 kí tự"
              @click:append="showPass = !showPass"
            ></v-text-field>
          </v-form>
          <div v-else class="d-flex flex-column">
            <p class="font-weight-medium text-justify">{{ message }}</p>
          </div>
        </v-card-text>

        <v-col v-if="!statusCheck" align="center" class="mt-n5">
          <v-btn
            block
            color="error"
            :loading="loading"
            width="15"
            @click="resetPassword"
            >Xác nhận</v-btn
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
export default {
  async asyncData({ route, params, redirect }) {
    let dataUser = null
    if (route.query && route.query.email && route.query.token) {
      const dataCheck = {}
      dataCheck.email = decodeURIComponent(route.query.email)
      dataCheck.token = route.query.token

      await axios
        .post(`${process.env.URL_SERVER}/account/check-email-token`, {
          dataCheck,
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              dataUser = response.data.data
              dataUser.token = route.query.token
            } else {
              return redirect('/')
            }
          }
        })
        .catch((error) => {
          console.log(error)
        })
    } else {
      return redirect('/')
    }

    return { dataUser }
  },
  layout: 'default',
  data: () => ({
    userInfo: null,
    rules: {
      required: (value) => !!value || 'Bắt buộc nhập.',
      min: (v) => v.length >= 8 || 'Thấp nhất 8 kí tự',
    },
    showPass: false,
    statusCheck: false,
    loading: false,
    snackbar: false,
    message: '',
    textSnackbar: '',
    user: {},
    model: {
      password: '',
      verify: '',
    },
  }),
  apollo: {},
  created() {},

  methods: {
    async resetPassword() {
      this.loading = true
      if (this.model.password === '') {
        this.$toast.error('Vui lòng nhập mật khẩu', {
          duration: 2000,
          position: 'top-center',
        })
        this.loading = false
        return
      }
      if (this.model.verify === '') {
        this.$toast.error('Vui lòng nhập mật khẩu xác nhận', {
          duration: 2000,
          position: 'top-center',
        })
        this.loading = false
        return
      }
      if (
        this.model.password !== '' &&
        this.model.password !== '' &&
        this.model.verify !== this.model.password
      ) {
        this.$toast.error('Mật khẩu xác nhận phải trùng với mật khẩu mới', {
          duration: 2000,
          position: 'top-center',
        })
        return
      }
      await axios
        .post(`${process.env.URL_SERVER}/account/reset-password`, {
          // eslint-disable-next-line camelcase
          dataReset: {
            id: this.dataUser.id,
            token: this.dataUser.token,
            password: this.model.password,
          },
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              this.loading = false
              this.statusCheck = true
              this.message = response.data.message
              setTimeout(() => {
                this.$router.push('/')
              }, 2000)
            } else {
              this.loading = false
              this.$toast.error(response.data.message, {
                duration: 2000,
                position: 'top-center',
              })
            }
          }
        })
        .catch((error) => {
          console.log(error)
          this.loading = false
          this.$toast.error('Bạn đã đổi mật khẩu bằng link này trước đó', {
            duration: 2000,
            position: 'top-center',
          })
        })
    },
  },
}
</script>
<style scoped lang="css">
.logo {
  max-width: 100%; /* only this one important */
}
</style>
