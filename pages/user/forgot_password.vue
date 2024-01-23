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
            <h2
              v-if="!statusSendMail"
              class="flex my-4 red--text"
              align="center"
            >
              NHẬP ĐỊA CHỈ EMAIL CỦA BẠN
            </h2>
          </div>
          <v-form v-if="!statusSendMail">
            <v-text-field
              v-model="model.email"
              prepend-icon="mdi-account"
              name="login"
              label="Email"
              type="text"
              @keyup.enter="checkEmailUser"
            ></v-text-field>
          </v-form>
          <div v-else class="d-flex flex-column">
            <p class="font-weight-medium text-justify">{{ message }}</p>
            <p>
              <span class="font-italic">
                Bạn vẫn chưa nhận được email từ chúng tôi ?</span
              >
              <a @click="checkEmailUser">Click vào đây</a>
            </p>
          </div>
        </v-card-text>

        <v-col v-if="!statusSendMail" align="center" class="mt-n5">
          <v-btn
            block
            color="error"
            :loading="loading"
            width="15"
            @click="checkEmailUser"
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
  layout: 'default',
  data: () => ({
    userInfo: null,
    statusSendMail: false,
    loading: false,
    snackbar: false,
    message: '',
    textSnackbar: '',
    user: {},
    model: {
      email: '',
    },
  }),
  apollo: {},
  created() {},

  methods: {
    async checkEmailUser() {
      this.loading = true
      if (this.model.email === '') {
        this.$toast.error('Vui lòng nhập email', {
          duration: 2000,
          position: 'top-center',
        })
        this.loading = false
        return
      }

      await axios
        .post(`${process.env.URL_SERVER}/account/send-email-user`, {
          // eslint-disable-next-line camelcase
          emailUser: this.model.email,
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              this.loading = false
              this.statusSendMail = true
              this.message = response.data.message
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
          this.$toast.error(
            'Có lỗi xảy trong quá trình gửi email, vui lòng thử lại',
            {
              duration: 2000,
              position: 'top-center',
            }
          )
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
