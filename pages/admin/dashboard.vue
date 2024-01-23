<template>
  <v-container fluid color="error">
    <v-card style="height: 95vh">
      <v-card-title style="left: 50%" class="red--text font-weight-bold"
        >CHÀO MỪNG ĐẾN VỚI WMOVIES ADMIN</v-card-title
      >
      <v-card-text>
        <v-row>
          <v-col cols="12" sm="4" lg="4" xl="4" md="4">
            <v-card max-width="344" height="168">
              <v-card-text>
                <v-list-item class="mt-3 ml-n3">
                  <v-list-item-avatar>
                    <v-btn color="error"> <v-icon>mdi-robot</v-icon></v-btn>
                  </v-list-item-avatar>

                  <v-list-item-content>
                    <v-list-item-title class="red--text font-weight-bold"
                      >Số lượt xem phim trong ngày:</v-list-item-title
                    ><v-list-item-subtitle class="red--text font-weight-bold"
                      ><h2>{{ movies }}</h2></v-list-item-subtitle
                    >
                  </v-list-item-content>
                </v-list-item>
              </v-card-text>
              <!-- <v-card-actions>
                <v-btn disabled text color="error" @click="reveal = true">
                  Xem chi tiết
                </v-btn>
              </v-card-actions> -->
            </v-card>
          </v-col>

          <v-col cols="12" sm="4" lg="4" xl="4" md="4">
            <v-card max-width="344">
              <v-card-text>
                <v-list-item class="mt-3 ml-n3">
                  <v-list-item-avatar>
                    <v-btn color="error"> <v-icon>mdi-robot</v-icon></v-btn>
                  </v-list-item-avatar>

                  <v-list-item-content>
                    <v-list-item-title class="red--text font-weight-bold"
                      >Số lượt báo lỗi phim trong ngày:</v-list-item-title
                    ><v-list-item-subtitle class="red--text font-weight-bold"
                      ><h2>{{ errors }}</h2></v-list-item-subtitle
                    >
                  </v-list-item-content>
                </v-list-item>
              </v-card-text>
              <v-card-actions>
                <v-btn text color="error" to="/admin/errors">
                  Xem chi tiết
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
          <v-col cols="12" sm="4" lg="4" xl="4" md="4">
            <v-card max-width="344">
              <v-card-text>
                <v-list-item class="mt-3 ml-n3">
                  <v-list-item-avatar>
                    <v-btn color="error"> <v-icon>mdi-robot</v-icon></v-btn>
                  </v-list-item-avatar>

                  <v-list-item-content>
                    <v-list-item-title class="red--text font-weight-bold"
                      >Số lượt feedbacks trong ngày:</v-list-item-title
                    ><v-list-item-subtitle class="red--text font-weight-bold"
                      ><h2>{{ feedbacks }}</h2></v-list-item-subtitle
                    >
                  </v-list-item-content>
                </v-list-item>
              </v-card-text>
              <v-card-actions>
                <v-btn text color="error" to="/admin/feedbacks">
                  Xem chi tiết
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
        </v-row>
        <v-row>
          <v-col>
            <v-card class="mt-4 mx-auto" max-width="1000">
              <v-sheet
                class="v-sheet--offset mx-auto"
                color="error"
                elevation="12"
                max-width="calc(100% - 32px)"
              >
                <v-sparkline
                  :labels="labels"
                  :value="value"
                  color="white"
                  line-width="2"
                  padding="16"
                ></v-sparkline>
              </v-sheet>

              <v-card-text class="pt-0">
                <div class="text-h6 font-weight-light mb-2">
                  Biểu đồ lượt xem 7 ngày gần nhất
                </div>
                <v-divider class="my-2"></v-divider>
                <v-icon class="mr-2" small> mdi-clock </v-icon>
                <span class="text-caption grey--text font-weight-light">
                  Cập nhật 26 giây trước</span
                >
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-container>
</template>
<script>
import axios from 'axios'
import moment from 'moment'

export default {
  layout: 'admin',
  name: 'Homepage',
  data() {
    return {
      errors: 0,
      feedbacks: 0,
      movies: 0,
      labels: [
        '13/12',
        '14/12',
        '15/12',
        '16/12',
        '17/12',
        '18/12',
        '19/12',
        '20/12',
      ],
      value: [200, 675, 410, 390, 310, 460, 250, 240],
    }
  },
  mounted() {
    this.getTotalData()
  },
  watch: {},
  methods: {
    async getTotalData() {
      const date = moment().format('YYYY-MM-DD')
      const response = await axios.get(
        `${process.env.URL_SERVER}/api/get-total/${date}/${date}`
      )
      if (response.data && response.data.error_logs) {
        this.feedbacks = response.data.feedbacks
        this.errors = response.data.error_logs
        this.movies = response.data.movies
      } else {
        this.feedbacks = response.data.feedbacks
        this.errors = response.data.error_logs
        this.movies = response.data.movies
      }
    },
  },
}
</script>

<style>
.v-sheet--offset {
  top: -24px;
  position: relative;
}
</style>
