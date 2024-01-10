<template>
  <v-footer dark class="error" light style="width: 100%">
    <v-card flat tile class="white--text text-center error">
      <v-divider></v-divider>
      <v-card-text></v-card-text>
      <v-card-text class="white--text pt-0 text-center">
        WMovies phát triển phục vụ cho nhu cầu tìm hiểu, thực hiện đồ án tốt
        nghiệp, không vì mục đích thương mại. Cảm ơn các bạn đã ghé thăm trang
        web, mọi đóng góp của các bạn xin được phép ghi nhận để cải thiện trang
        web tốt hơn. Trân trọng cảm ơn !
      </v-card-text>

      <v-divider></v-divider>

      <v-card-text class="white--text">
        {{ new Date().getFullYear() }} — <strong>Copyright by HuyHoang</strong>
      </v-card-text>
    </v-card>
  </v-footer>
</template>
<script>
// Nơi để import package
// import gql from 'graphql-tag'

export default {
  layout: '', // layout chính của file
  props: {}, // Nhận data được truyền vào
  data: () => ({}),
  computed: {
    // compute field xài trên giao diện
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
  methods: {},
  apollo: {},
}
</script>
