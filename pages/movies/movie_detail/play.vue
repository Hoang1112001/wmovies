<!-- eslint-disable vue/require-v-for-key -->
<!-- eslint-disable vue/valid-v-for -->
<!-- eslint-disable vue/no-v-text-v-html-on-component -->
<template>
  <v-app>
    <v-card elevation="24" width="95%" style="margin: 10px auto" class="white">
      <v-row>
        <v-col cols="12" sm="8" lg="8" xl="8" md="8">
          <video-player :options="videoOptions" />
        </v-col>
        <v-col cols="12" sm="4" lg="4" xl="4" md="4">
          <v-card max-width="450" class="mx-auto mt-2 mr-2"> </v-card>
        </v-col>
      </v-row>
    </v-card>
    <!-- Hiển thị thông tin chi tiết về phim -->
  </v-app>
</template>
<script>
import VideoPlayer from '~/components/VideoPlayer.vue'

export default {
  asyncData({ route, params }) {
    console.log('route', route)
    console.log('params', params)
  },
  name: 'VideoPlay',
  components: {
    VideoPlayer,
  },
  //   asyncData({ params }) {
  //     // Lấy dữ liệu chi tiết về phim từ API hoặc nguồn dữ liệu khác bằng slug name
  //     const slug = params.slug
  //     console.log(slug)

  //     const movieE = slug // Hàm fetch phim theo slug name

  //     return { movieE }
  //   },
  data() {
    return {
      videoOptions: {
        autoplay: true,
        controls: true,
        sources: [
          {
            src: 'https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv',
            type: 'video/mp4',
          },
        ],
      },
    }
  },
  mounted() {},
  methods: {},
}
</script>
<style>
/* Tùy chỉnh CSS cho Video.js và Vuetify tại đây */
</style>
