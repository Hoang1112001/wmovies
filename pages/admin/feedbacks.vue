<!-- eslint-disable camelcase -->
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
    <v-card style="height: 95vh">
      <v-card-title style="left: 50%" class="red--text font-weight-bold"
        >ĐÓNG GÓP Ý KIẾN CỦA NGƯỜI XEM WMOVIES
      </v-card-title>
      <v-card-text>
        <v-data-table
          :headers="headers"
          :items="feedbacks"
          :footer-props="{
            itemsPerPageText: 'số dòng mỗi trang',
            pageText: '{0}-{1} trên {2}',
          }"
          item-key="id"
          class="elevation-1"
          loading-text="Đang tải...vui lòng đợi"
        >
          <template #[`item.is_delete`]="{ item }">
            <v-simple-checkbox
              v-model="item.is_delete"
              disabled
            ></v-simple-checkbox>
          </template>

          <template #top>
            <v-toolbar flat>
              <v-text-field
                v-model="search"
                append-icon="mdi-magnify"
                label="Nhập thông tin cần tìm ở đây"
                single-line
                outlined
                dense
                hide-details
                class="mt-n7"
                @keyup.enter="searchAll"
              ></v-text-field>
              <v-spacer></v-spacer>
              <v-menu
                v-model="menuDateQueryFeedbacks"
                :close-on-content-click="false"
                :nudge-right="100"
                transition="scale-transition"
                offset-y
                min-width="auto"
              >
                <template #activator="{ on, attrs }">
                  <v-text-field
                    :value="getDisplayRange(dateQueryFeedbacks)"
                    outlined
                    dense
                    label="Thời gian tìm"
                    readonly
                    class="font-weight-bold ml-2"
                    v-bind="attrs"
                    v-on="on"
                  ></v-text-field>
                </template>
                <v-date-picker
                  v-model="dateQueryFeedbacks"
                  range
                ></v-date-picker>
              </v-menu>
              <v-btn
                small
                fab
                color="error"
                class="ml-2 mt-n7"
                @click="loadDataFeedbacks"
              >
                <v-icon>mdi-magnify</v-icon>
              </v-btn>
            </v-toolbar>
          </template>

          <template #no-data>
            <v-btn color="error" @click="loadDataFeedbacks"> Làm mới </v-btn>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>
  </v-container>
</template>
<script>
import moment from 'moment'

import axios from 'axios'
// import gql from 'graphql-tag'
export default {
  layout: 'admin',
  name: 'Homepage',
  data() {
    return {
      dateQueryFeedbacks: ['2023-12-20', '2023-12-20'],
      menuDateQueryFeedbacks: false,
      snackbar: false,
      textSnackbar: '',
      search: '',
      headers: [
        {
          text: 'STT',
          value: 'stt',
          align: 'start',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Tên người dùng',
          value: 'user.username',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Chất lượng phim',
          value: 'quality_movie',
          class: 'error font-weight-medium text-h6 white--text',
        },

        {
          text: 'Cải thiện tiếng Anh',
          value: 'is_improve_Eng',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Chi tiết',
          value: 'note',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Ngày gửi',
          value: 'created_at_string',
          class: 'error font-weight-medium text-h6 white--text',
        },
      ],
      feedbacks: [],
      user: {
        id: null,
        username: null,
        email: null,
        created_at: null,
      },
    }
  },
  mounted() {
    const date = moment().format('YYYY-MM-DD')
    this.dateQueryErrors = [date, date]
    this.loadDataFeedbacks()
  },
  watch: {},
  methods: {
    getDisplayRange(date) {
      if (!date) {
        return
      }
      let temp = moment(date[0]).format('DD-MM-YYYY')

      if (date.length > 0) {
        temp = temp + ' ~ ' + moment(date[date.length - 1]).format('DD-MM-YYYY')
      }
      return temp
    },
    async loadDataFeedbacks() {
      let date1 = null
      let date2 = null
      if (this.dateQueryFeedbacks[0] > this.dateQueryFeedbacks[1]) {
        const temp = this.dateQueryFeedbacks
        this.dateQueryFeedbacks = [temp[1], temp[0]]
      }
      date1 = this.dateQueryFeedbacks[0]
      if (this.dateQueryFeedbacks.length === 1) {
        this.dateQueryFeedbacks.push(this.dateQueryFeedbacks[0])
      }

      date2 = this.dateQueryFeedbacks[1]
      const response = await axios.get(
        `${process.env.URL_SERVER}/api/get-feedbacks/${date1}/${date2}`
      )
      if (response.data && response.data.feedbacks) {
        const temp = []
        for (let index = 0; index < response.data.feedbacks.length; index++) {
          const element = response.data.feedbacks[index]
          element.stt = index + 1
          element.created_at_string = moment(element.created_at).format(
            'DD-MM-YYYY HH:mm:ss'
          )
          temp.push(element)
        }
        this.feedbacks = temp
      } else {
        this.feedbacks = []
      }
    },
    searchAll() {},
  },
  apollo: {},
}
</script>

<style>
.v-sheet--offset {
  top: -24px;
  position: relative;
}
</style>
