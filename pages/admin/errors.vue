<!-- eslint-disable camelcase -->
<template>
  <v-container fluid color="error">
    <v-snackbar v-model="snackbar">
      {{ textSnackbar }}

      <template v-slot:action="{ attrs }">
        <v-btn color="pink" text v-bind="attrs" @click="snackbar = false">
          Đóng
        </v-btn>
      </template>
    </v-snackbar>
    <v-card style="height: 95vh">
      <v-card-title style="left: 50%" class="red--text font-weight-bold"
        >LỖI PHIM ĐƯỢC BÁO TỪ NGƯỜI XEM WMOVIES
      </v-card-title>
      <v-card-text>
        <v-data-table
          :headers="headers"
          :items="errors"
          :footer-props="{
            itemsPerPageText: 'số dòng mỗi trang',
            pageText: '{0}-{1} trên {2}',
          }"
          item-key="id"
          class="elevation-1"
          loading-text="Đang tải...vui lòng đợi"
        >
          <template #[`item.is_error_subtitle`]="{ item }">
            <v-simple-checkbox
              v-model="item.is_error_subtitle"
              disabled
            ></v-simple-checkbox>
          </template>
          <template #[`item.is_error_movie`]="{ item }">
            <v-simple-checkbox
              v-model="item.is_error_movie"
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
                v-model="menuDateQueryErrors"
                :close-on-content-click="false"
                :nudge-right="100"
                transition="scale-transition"
                offset-y
                min-width="auto"
              >
                <template #activator="{ on, attrs }">
                  <v-text-field
                    :value="getDisplayRange(dateQueryErrors)"
                    outlined
                    dense
                    label="Thời gian tìm"
                    readonly
                    class="font-weight-bold ml-2"
                    v-bind="attrs"
                    v-on="on"
                  ></v-text-field>
                </template>
                <v-date-picker v-model="dateQueryErrors" range></v-date-picker>
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

// import axios from 'axios'
// import gql from 'graphql-tag'
// import moment from 'moment'
export default {
  layout: 'admin',
  name: 'Error',
  data() {
    return {
      dateQueryErrors: ['2023-12-20', '2023-12-20'],
      menuDateQueryErrors: false,
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
          text: 'Tên phim',
          value: 'movie.name',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Lỗi tải phim',
          value: 'is_error_movie',
          class: 'error font-weight-medium text-h6 white--text',
        },

        {
          text: 'Lỗi phụ đề',
          value: 'is_error_subtitle',
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
      errors: [
        {
          stt: 1,
          id: null,
          movie: {
            id: null,
            name: 'Friends Season 1',
          },
          is_error_subtitle: true,
          is_error_movie: false,
          note: 'Sub nhanh hơn phim',
          created_at_string: moment().format('DD-MM-YYYY HH:mm:ss'),
        },
      ],
      user: {
        id: null,
        username: null,
        email: null,
        created_at: null,
      },
    }
  },
  mounted() {},
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
    loadDataFeedbacks() {},
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
