<!-- eslint-disable vue/require-v-for-key -->
<!-- eslint-disable vue/attributes-order -->
<template>
  <v-footer dark class="error" light style="width: 100%">
    <v-card flat tile class="white--text text-center error">
      <v-divider></v-divider>
      <!-- <v-card-text>
        <v-btn
          v-for="link in links"
          :key="link"
          color="white"
          text
          rounded
          class="my-2"
        >
          {{ link }}
        </v-btn>
      </v-card-text> -->
      <v-divider></v-divider>
      <v-card-text>
        <a target="_blank" v-bind:href="social.url" v-for="social in socials">
          <v-btn class="mx-4 white--text" icon>
            <v-icon size="24px">{{ social.icon }}</v-icon>
          </v-btn>
        </a>
      </v-card-text>
      <v-divider></v-divider>
      <v-card-text class="white--text pt-0 text-center">
        Chào mừng đến với WMovies ! Hãy thưởng thức những bộ phim mình yêu thích
        sau một ngày làm việc căng thẳng. Đừng quên đánh giá trang web của chúng
        tôi. Mọi đóng góp của bạn sẽ giúp chúng tôi cải thiện trang web tốt hơn.
        Trân trọng cảm ơn !
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
  data: () => {
    return {
      links: ['Home', 'About Us', 'Team', 'Services', 'Blog', 'Contact Us'],
      socials: [
        {
          name: 'facebook',
          icon: 'mdi-facebook',
          url: 'https://wmovies.tech',
        },
        {
          name: 'twitter',
          icon: 'mdi-twitter',
          url: 'https://wmovies.tech',
        },
        {
          name: 'google',
          icon: 'mdi-google',
          url: 'https://wmovies.tech',
        },
        {
          name: 'linkedin',
          icon: 'mdi-linkedin',
          url: 'https://wmovies.tech',
        },
        {
          name: 'instagram',
          icon: 'mdi-instagram',
          url: 'https://wmovies.tech',
        },
      ],
    }
  },
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
