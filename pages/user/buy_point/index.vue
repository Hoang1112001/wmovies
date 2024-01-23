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
    <v-dialog v-model="dialogConfirmActivePoint" width="unset">
      <v-card>
        <v-card-title class="subtitle-1 red--text">
          Bạn có chắc muốn kích hoạt {{ pointActive }} điểm ?
        </v-card-title>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="dialogConfirmActivePoint = false"
            >Không</v-btn
          >
          <v-btn color="error" text @click="activePoint()">Có</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog
      v-model="dialogHistoryActivePoints"
      transition="dialog-bottom-transition"
    >
      <v-card>
        <v-layout center>
          <v-card-title class="text-h5 font-weight-bold mx-auto">
            LỊCH SỬ GIA HẠN/KÍCH HOẠT VIP
          </v-card-title>
        </v-layout>

        <v-data-table
          :headers="headersActivePoint"
          :items="historyActivePoints"
          item-per-page="5"
          class="pa-3"
        >
        </v-data-table>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="dialogHistoryActivePoints = false">
            THOÁT
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog
      v-model="dialogHistoryBuyPoints"
      transition="dialog-bottom-transition"
    >
      <v-card>
        <v-layout center>
          <v-card-title class="text-h5 font-weight-bold mx-auto">
            LỊCH SỬ NẠP MUA ĐIỂM
          </v-card-title>
        </v-layout>

        <v-data-table
          :headers="headers"
          :items="historyOrders"
          item-per-page="5"
          class="pa-3"
        >
        </v-data-table>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="dialogHistoryBuyPoints = false">
            THOÁT
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-card elevation="24" width="95%" style="margin: 10px auto" class="white">
      <v-row>
        <v-col cols="12" sm="5" lg="5" xl="5" md="5">
          <v-card class="mt-3 ml-3" min-height="330">
            <v-card-text>
              <div class="d-flex">
                <img
                  :src="user.image_user"
                  alt="Logo"
                  height="120"
                  class="logo"
                />
                <div class="d-flex flex-column ml-2">
                  <h2 class="font-weight-bold red--text mt-2 mb-2">
                    {{ user.username }}
                    <v-chip small :color="user.is_active_vip ? 'yellow' : ''"
                      >{{ user.is_active_vip ? 'VIP' : 'THƯỜNG' }}
                    </v-chip>
                  </h2>
                  <div>
                    <span class="font-weight-bold">- EMAIL CỦA BẠN:</span>
                    <span class="font-weight-medium red--text">{{
                      user.email
                    }}</span>
                  </div>
                  <div>
                    <span class="font-weight-bold">- SỐ ĐIỂM CỦA BẠN:</span>
                    <span class="font-weight-medium red--text">{{
                      user.point
                    }}</span>
                  </div>
                  <div>
                    <span class="font-weight-bold">- NGÀY HẾT HẠN:</span>
                    <span class="font-weight-medium red--text">{{
                      user.duration ? user.duration : 'N/A'
                    }}</span>
                  </div>
                </div>
              </div>
            </v-card-text>
            <v-col class="mt-n5 d-flex justify-space-around">
              <v-btn
                color="error"
                :loading="loadingHistoryBuyPoints"
                @click="getHistoryBuyPoint"
                >Lịch sử nạp</v-btn
              >

              <v-btn
                color="error"
                :loading="loadingHistoryActivePoints"
                @click="getHistoryActivePoint"
                >Lịch sử gia hạn</v-btn
              >
            </v-col>
            <v-col>
              <v-card class="pa-3">
                <v-row>
                  <v-col cols="12" sm="12" lg="12" xl="12" md="12">
                    <h3 color="error" class="red--text">
                      KÍCH HOẠT/GIA HẠN TÀI KHOẢN VIP
                    </h3>
                  </v-col>
                  <v-col cols="12" sm="8" lg="8" xl="8" md="8">
                    <p>Điểm hiện tại: {{ user.point }}</p>
                    <p>
                      Điểm sau khi kích hoạt/gia hạn: {{ pointAfterActive }}
                    </p>
                    <p class="font-italic">
                      Lưu ý: Mỗi 1 điểm tương ứng với 1 ngày kích hoạt VIP
                    </p>
                  </v-col>
                  <v-col cols="12" sm="4" lg="4" xl="4" md="4">
                    <v-text-field
                      outlined
                      dense
                      type="number"
                      v-model="pointActive"
                      @change="handleInputPointActive"
                      label="Nhập số điểm bạn muốn kích hoạt"
                    ></v-text-field>
                    <v-btn
                      color="error"
                      :disabled="!isSuccess"
                      @click="dialogConfirmActivePoint = true"
                    >
                      Xác nhận
                    </v-btn>
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
          </v-card>
        </v-col>
        <v-col cols="12" sm="7" lg="7" xl="7" md="7">
          <v-card class="mt-3 mr-3" min-height="430">
            <v-toolbar color="error" dark>
              <v-row class="d-flex justify-space-between ml-2 mt-2">
                <v-toolbar-title class="font-weight-bold"
                  >CÁC GÓI NẠP
                </v-toolbar-title>
                <v-img
                  class="mt-n4"
                  max-height="68"
                  max-width="85"
                  :src="require('~/static/logo.png')"
                ></v-img>
              </v-row>
            </v-toolbar>
            <v-item-group
              active-class="green"
              @change="handleSelectedOptions"
              v-model="selectedOptions"
            >
              <v-container>
                <v-row>
                  <v-col
                    v-for="n in objectOptions"
                    :key="n.code"
                    cols="12"
                    md="4"
                  >
                    <v-item v-slot="{ toggle }">
                      <v-card
                        class="d-flex align-center flex-column"
                        height="200"
                        @click="toggle"
                      >
                        <v-card-title>{{ n.code }}</v-card-title>
                        <v-card-text class="font-weight-bold">
                          Mô tả: {{ n.name }}</v-card-text
                        >
                        <v-card-text class="font-weight-bold mt-n5">
                          Số điểm nhận được: {{ n.point }}</v-card-text
                        >
                        <v-card-text class="font-weight-bold mt-n5">
                          Giá : {{ n.unit_amount }}</v-card-text
                        >
                      </v-card>
                    </v-item>
                  </v-col>
                </v-row>
              </v-container>
            </v-item-group>
            <div class="d-flex justify-space-between">
              <div class="ml-4" v-if="selectedOptions || selectedOptions === 0">
                {{
                  'Bạn đang chọn gói ' +
                  objectOptions[selectedOptions].code +
                  ' - Giá: ' +
                  objectOptions[selectedOptions].unit_amount
                }}
              </div>
              <div v-else></div>

              <v-btn
                :disabled="!selectedOptions && selectedOptions !== 0"
                color="error"
                :loading="loading"
                @click="checkOut"
                >Tiến hành thanh toán <v-icon>mdi-cash</v-icon></v-btn
              >
            </div>
          </v-card>
        </v-col>
      </v-row>
    </v-card>
  </v-layout>
  <!-- </v-main> -->
</template>

<script>
// import gql from 'graphql-tag'
import axios from 'axios'
import moment from 'moment'
// import cookie from 'cookiejs'
export default {
  layout: 'default',
  data: () => ({
    userInfo: null,
    isSuccess: false,
    showActivePoint: false,
    pointActive: 0,
    pointAfterActive: 0,
    isLogin: null,
    loadingHistoryBuyPoints: false,
    loadingHistoryActivePoints: false,
    dialogHistoryBuyPoints: false,
    dialogConfirmActivePoint: false,
    dialogHistoryActivePoints: false,
    loading: false,
    snackbar: false,
    textSnackbar: '',
    historyOrders: [],
    historyActivePoints: [],
    selectedOptions: null,
    headers: [
      {
        text: 'STT',
        value: 'stt',
        align: 'start',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Mã giao dịch',
        value: 'session_id',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Số điểm nạp',
        value: 'point',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Số tiền thanh toán',
        value: 'price_string',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Mô tả',
        value: 'description',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Ngày giao dịch',
        value: 'time_order_string',
        class: 'error font-weight-medium text-h6 white--text',
      },
    ],
    headersActivePoint: [
      {
        text: 'STT',
        value: 'stt',
        align: 'start',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Điểm trước khi gia hạn/kích hoạt',
        value: 'point_before_active',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Điểm gia hạn/kích hoạt',
        value: 'point_active',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Điểm sau khi gia hạn/kích hoạt',
        value: 'point_after_active',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Ngày hết hạn',
        value: 'duration_string',
        class: 'error font-weight-medium text-h6 white--text',
      },
      {
        text: 'Ngày gia hạn/kích hoạt',
        value: 'created_at_string',
        class: 'error font-weight-medium text-h6 white--text',
      },
    ],
    user: {
      id: null,
      email: null,
      username: '',
      point: 0,
      duration: '16/01/2024',
      is_active_vip: false,
      point_active: 0,
      image_user: null,
    },
    objectOptions: [
      {
        code: '50POINTS',
        name: 'Gói 50 điểm',
        unit_amount: 1000,
        point: 50,
        quantity: 1,
      },
      {
        code: '100POINTS',
        name: 'Gói 100 điểm',
        unit_amount: 2000,
        point: 100,
        quantity: 1,
      },
      {
        code: '300POINTS',
        name: 'Gói 300 điểm',
        unit_amount: 6000,
        point: 300,
        quantity: 1,
      },
    ],
  }),
  apollo: {},
  created() {},
  mounted() {
    if (this.$nuxt.$store.state.data) {
      this.isLogin = this.$nuxt.$store.state.data.id
      this.user = this.$nuxt.$store.state.data
    } else {
      this.$nuxt.$on('auth', (auth) => {
        if (auth && auth.id) {
          this.isLogin = auth.id
          this.user = auth
        } else {
          this.$router.push('/')
        }
      })
    }

    // const response = await axios.get(
    //   `${process.env.URL_SERVER}/account/get-user`,
    //   {
    //     headers: {
    //       // 'Access-Control-Allow-Origin': '*',
    //       'Access-Control-Allow-Credentials': 'true',
    //       'Content-Type': 'application/json',
    //     },
    //     withCredentials: true,
    //   }
    // )
    // if (response.data.status) {
    //   const dataUser = response.data.data
    //   this.user = {
    //     id: dataUser.id,
    //     username: dataUser.username,
    //     email: dataUser.email,
    //     point: dataUser.point,
    //     durationOriginal: dataUser.duration,
    //     duration: dataUser.duration
    //       ? moment(dataUser.duration)
    //           .add('hours', 7)
    //           .format('DD-MM-YYYY HH:mm:ss')
    //       : '',
    //     is_active_vip: dataUser.is_active_vip,
    //     point_active: dataUser.point_active,
    //     image_user: dataUser.image_user
    //       ? dataUser.image_user
    //       : require('~/static/icon.png'),
    //   }
    //   this.isLogin = true
    // } else {
    //   this.$router.push('/')
    // }
  },
  methods: {
    handleInputPointActive() {
      if (Number(this.pointActive) <= 0) {
        this.snackbar = true
        this.textSnackbar = 'Điểm kích hoạt phải lớn hơn hoặc bằng 1'
        this.pointActive = null
        this.isSuccess = false
        this.pointAfterActive = 0
        return
      }
      if (!Number.isInteger(Number(this.pointActive))) {
        this.snackbar = true
        this.textSnackbar = 'Điểm kích hoạt phải là số nguyên'
        this.pointActive = null
        this.isSuccess = false
        this.pointAfterActive = 0
        return
      }
      if (Number(this.pointActive) > this.user.point) {
        this.snackbar = true
        this.textSnackbar = 'Điểm kích hoạt phải nhỏ hơn hoặc bằng điểm hiện có'
        this.pointActive = null
        this.isSuccess = false
        this.pointAfterActive = 0
        return
      }
      this.pointAfterActive = this.user.point - Number(this.pointActive)
      this.isSuccess = true
    },
    handleSelectedOptions() {},
    async getHistoryBuyPoint() {
      if (!this.isLogin) {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng đăng nhập để thực hiện chức năng'
        return
      }
      this.loadingHistoryBuyPoints = true
      const response = await axios.get(
        `${process.env.URL_SERVER}/stripe/get-history-buy-point/${this.user.id}`
      )
      if (
        response.data &&
        response.data.orders &&
        response.data.orders.length > 0
      ) {
        const temp = []
        for (let index = 0; index < response.data.orders.length; index++) {
          const element = response.data.orders[index]
          element.stt = index + 1
          element.price_string = element.price.toLocaleString('VND')
          element.time_order_string = moment(element.time_order).format(
            'DD-MM-YYYY HH:mm:ss'
          )
          temp.push(element)
        }
        this.historyOrders = []
        this.historyOrders = temp
        this.dialogHistoryBuyPoints = true
        this.loadingHistoryBuyPoints = false
      } else {
        this.loadingHistoryBuyPoints = false
        this.snackbar = true
        this.textSnackbar = 'Bạn chưa nạp điểm lần nào'
      }
    },
    async getHistoryActivePoint() {
      if (!this.isLogin) {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng đăng nhập để thực hiện chức năng'
        return
      }
      this.loadingHistoryActivePoints = true
      const response = await axios.get(
        `${process.env.URL_SERVER}/stripe/get-history-active-point/${this.user.id}`
      )
      if (
        response.data &&
        response.data.active_point_logs &&
        response.data.active_point_logs.length > 0
      ) {
        const temp = []
        for (
          let index = 0;
          index < response.data.active_point_logs.length;
          index++
        ) {
          const element = response.data.active_point_logs[index]
          element.stt = index + 1

          element.duration_string = moment(element.duration).format(
            'DD-MM-YYYY HH:mm:ss'
          )
          element.created_at_string = moment(element.created_at).format(
            'DD-MM-YYYY HH:mm:ss'
          )
          temp.push(element)
        }
        this.historyActivePoints = []
        this.historyActivePoints = temp
        this.dialogHistoryActivePoints = true
        this.loadingHistoryActivePoints = false
      } else {
        this.loadingHistoryActivePoints = false
        this.snackbar = true
        this.textSnackbar = 'Bạn chưa nạp điểm lần nào'
      }
    },
    async checkOut() {
      if (!this.isLogin) {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng đăng nhập để thực hiện chức năng'
        return
      }
      const response = await axios.post(
        `${process.env.URL_SERVER}/stripe/create-checkout-session`,
        {
          email: this.user.email,
          user_id: this.user.id,
          option: this.selectedOptions,
        },
        {
          headers: {
            'Access-Control-Allow-Headers': '*',
            'Content-Type': 'application/json',
          },
        }
      )
      if (response.data && response.data.url) {
        window.location.href = response.data.url
      }
    },
    async activePoint() {
      const dataSend = {}
      dataSend.user_id = this.user.id
      dataSend.point_active = Number(this.pointActive)
      dataSend.duration = this.user.durationOriginal
        ? moment(this.user.durationOriginal).add('days', this.pointActive)
        : moment().add('days', this.pointActive)
      const response = await axios.post(
        `${process.env.URL_SERVER}/stripe/active-point`,
        {
          point: this.user.point,
          point_active: dataSend.point_active,
          user_id: dataSend.user_id,
          duration: dataSend.duration,
        }
      )
      if (response.data && response.data.status) {
        this.snackbar = true
        this.textSnackbar = 'Kích hoạt/gia hạn VIP thành công'
        setTimeout(() => {
          window.location.reload()
        }, 2000)
      } else {
        this.snackbar = true
        this.textSnackbar = 'Kích hoạt/gia hạn VIP thất bại'
      }
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
