<template>
  <v-layout lign-center justify-center color="red">
    <v-flex xs12 sm8 md3 lg3>
      <v-card class="elevation-1 pa-3 mt-5 mb-5" height="425">
        <v-card-text>
          <div class="layout column align-center mt-15">
            <v-icon color="success" x-large size="100">
              mdi-check-circle-outline
            </v-icon>
            <h2 class="flex my-4 green--text" align="center">
              THANH TOÁN THÀNH CÔNG
            </h2>
            <h3 class="font-weight-bold">CHUYỂN VỀ TRANG KÍCH HOẠT VIP SAU:</h3>
            <span class="countdown">{{ countdown }}</span>
            <span class="countdown">GIÂY</span>
          </div>
        </v-card-text>
      </v-card>
    </v-flex>
    <!-- <v-alert type="success" icon="mdi-check-circle-outline">
      <v-row>
        <v-col>
          <span class="headline">THANH TOÁN THÀNH CÔNG</span>
        </v-col>
      </v-row>
      <v-row>
        <v-col>
          <span>Cảm ơn bạn đã mua hàng.</span>
        </v-col>
      </v-row>
      <v-row>
        <v-col>
          <span>Trang này sẽ tự động chuyển về trang chủ sau:</span>
          <span class="countdown">{{ countdown }}</span>
        </v-col>
      </v-row>
    </v-alert> -->
  </v-layout>
</template>

<script>
export default {
  data() {
    return {
      countdown: 3,
    }
  },
  mounted() {
    this.startCountdown()
  },
  methods: {
    startCountdown() {
      const interval = setInterval(() => {
        if (this.countdown > 0) {
          this.countdown--
        } else {
          clearInterval(interval)
          this.$router.push('/user/buy_point')
        }
      }, 1000)
    },
  },
}
</script>

<style scoped>
.headline {
  font-size: 24px;
  font-weight: bold;
}

.countdown {
  font-size: 20px;
  font-weight: bold;
  color: red;
}
</style>
