<template>
  <!-- Giao diện -->

  <v-app-bar class="error" app fixed dark>
    <v-dialog v-model="dialogSignIn" max-width="600px" min-width="360px">
      <div>
        <v-tabs
          v-model="tab"
          show-arrows
          background-color="error accent-4"
          icons-and-text
          dark
          grow
        >
          <v-tabs-slider color="purple darken-4"></v-tabs-slider>
          <v-tab v-for="i in tabs" :key="i">
            <v-icon large>{{ i.icon }}</v-icon>
            <div class="caption py-1">{{ i.name }}</div>
          </v-tab>
          <v-tab-item>
            <v-card class="px-4">
              <v-card-text>
                <v-form ref="loginForm" v-model="valid" lazy-validation>
                  <v-row>
                    <v-col cols="12">
                      <v-text-field
                        v-model="signInItem.email"
                        :rules="loginEmailRules"
                        label="E-mail"
                        required
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12">
                      <v-text-field
                        v-model="signInItem.password"
                        :append-icon="show1 ? 'eye' : 'eye-off'"
                        :rules="[rules.required, rules.min]"
                        :type="show1 ? 'text' : 'password'"
                        name="input-10-1"
                        label="Mật khẩu"
                        hint="Tối thiểu 8 kí tự"
                        counter
                        @click:append="show1 = !show1"
                      ></v-text-field>
                    </v-col>
                    <v-col class="d-flex" cols="12" sm="6" xsm="12"> </v-col>
                    <v-spacer></v-spacer>
                    <v-col class="d-flex" cols="12" sm="3" xsm="12" align-end>
                      <v-btn
                        block
                        :disabled="!valid"
                        color="error"
                        @click="validate"
                      >
                        Đăng nhập
                      </v-btn>
                    </v-col>
                  </v-row>
                </v-form>
              </v-card-text>
            </v-card>
          </v-tab-item>
          <v-tab-item>
            <v-card class="px-4">
              <v-card-text>
                <v-form ref="registerForm" v-model="valid" lazy-validation>
                  <v-row>
                    <v-col cols="12">
                      <v-text-field
                        v-model="signUpItem.email"
                        :rules="emailRules"
                        label="E-mail"
                        required
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12">
                      <v-text-field
                        v-model="signUpItem.password"
                        :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
                        :rules="[rules.required, rules.min]"
                        :type="show1 ? 'text' : 'password'"
                        name="input-10-1"
                        label="Mật khẩu"
                        hint="Tối thiểu 8 kí tự"
                        counter
                        @click:append="show1 = !show1"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12">
                      <v-text-field
                        block
                        v-model="signUpItem.verify"
                        :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
                        :rules="[rules.required, passwordMatch]"
                        :type="show1 ? 'text' : 'password'"
                        name="input-10-1"
                        label="Xác nhận mật khẩu"
                        counter
                        @click:append="show1 = !show1"
                      ></v-text-field>
                    </v-col>
                    <v-spacer></v-spacer>
                    <v-col class="d-flex ml-auto" cols="12" sm="3" xsm="12">
                      <v-btn
                        block
                        :disabled="!valid"
                        color="error"
                        @click="validate"
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

            <v-tooltip bottom>
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
          </v-layout>
        </v-row>
      </v-col>
      <v-col cols="12" sm="1" lg="1" xl="1" md="1" color="white"> </v-col>
    </v-row>
  </v-app-bar>
</template>
<script>
// Nơi để import package

export default {
  layout: '', // layout chính của file
  props: {}, // Nhận data được truyền vào
  data: () => ({
    dialogSignIn: false,
    tab: 0,
    tabs: [
      { name: 'Đăng nhập', icon: 'mdi-account' },
      { name: 'Đăng ký', icon: 'mdi-television-box' },
    ],
    valid: true,
    signUpItem: {
      email: '',
      password: '',
      verify: '',
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

    show1: false,
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
  mounted() {
    // called after the DOM has been mounted or rendered
  },
  methods: {
    openDialogSignIn() {
      this.dialogSignIn = true
    },
    validate() {
      if (this.$refs.loginForm.validate()) {
        // submit form to server/API here...
      }
    },
    reset() {
      this.$refs.form.reset()
    },
    resetValidation() {
      this.$refs.form.resetValidation()
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
