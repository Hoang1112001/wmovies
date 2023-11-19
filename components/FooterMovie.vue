<template>
  <v-footer dark class="error" light style="width: 100%">
    <v-card flat tile class="white--text text-center error">
      <v-divider></v-divider>
      <v-card-text></v-card-text>
      <v-card-text class="white--text pt-0">
        Phasellus feugiat arcu sapien, et iaculis ipsum elementum sit amet.
        Mauris cursus commodo interdum. Praesent ut risus eget metus luctus
        accumsan id ultrices nunc. Sed at orci sed massa consectetur dignissim a
        sit amet dui. Duis commodo vitae velit et faucibus. Morbi vehicula
        lacinia malesuada. Nulla placerat augue vel ipsum ultrices, cursus
        iaculis dui sollicitudin. Vestibulum eu ipsum vel diam elementum tempor
        vel ut orci. Orci varius natoque penatibus et magnis dis parturient
        montes, nascetur ridiculus mus.
      </v-card-text>

      <v-divider></v-divider>

      <v-card-text class="white--text">
        {{ new Date().getFullYear() }} — <strong>Vuetify</strong>
      </v-card-text>
    </v-card>
  </v-footer>
</template>
<script>
// Nơi để import package
import gql from 'graphql-tag'

export default {
  layout: '', // layout chính của file
  props: {}, // Nhận data được truyền vào
  data: () => ({
    test2222: 'data test2222', // khai báo biến
    test1111: 'data test1111',
    userModel: null,
    userId: null,
    users: [],
    clickTime: 0,
  }),
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
  methods: {
    changeDataTest2222() {
      this.clickTime++
    },
  },
  apollo: {
    movies: {
      query: gql(`query MyQuery {
        movies {
          code
          id
          name

        }

      }`),
      update: (data) => {},
      result({ data }) {
        console.log('connect hasura ', data)

        // this.movies = data.movies

        // this.modelUser.internal_hospital = data.internal_hospitals[1]
      },
    },
  },
}
</script>
