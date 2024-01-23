<!-- eslint-disable vue/no-unused-vars -->
<!-- eslint-disable vue/no-use-v-if-with-v-for -->
<!-- eslint-disable vue/valid-v-for -->
<!-- eslint-disable vue/require-v-for-key -->
<template>
  <v-app>
    <v-card max-width="450" class="mx-auto mt-2 mr-2 mb-2">
      <v-toolbar color="error" dark>
        <v-row class="d-flex justify-space-between ml-2 mt-2">
          <v-toolbar-title class="font-weight-bold"
            >PHIM ĐỀ XUẤT
          </v-toolbar-title>
          <v-img
            class="mt-n4"
            max-height="68"
            max-width="85"
            :src="require('~/static/logo.png')"
          ></v-img>
        </v-row>
      </v-toolbar>

      <v-list three-line>
        <template v-for="(item, index) in recommendMovies">
          <v-divider
            v-if="item.divider"
            :key="index"
            :inset="item.inset"
          ></v-divider>

          <v-list-item v-else :key="item.title" :href="item.link">
            <v-list-item-avatar tile>
              <v-img :src="item.image"></v-img>
            </v-list-item-avatar>

            <v-list-item-content>
              <v-list-item-title class="orange--text font-weight-bold">{{
                item.title
              }}</v-list-item-title>
              <v-list-item-subtitle class="font-italic">{{
                item.subtitle
              }}</v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        </template>
        <template v-if="isLoadingData">
          <v-skeleton-loader
            type="list-item-avatar-three-line"
          ></v-skeleton-loader>
        </template>
      </v-list>
    </v-card>
  </v-app>
</template>

<script>
// import axios from 'axios'
import gql from 'graphql-tag'

export default {
  name: 'RecommendMovie',
  data() {
    return {
      isLoadingData: false,
      recommendMovies: [],
      user: null,
    }
  },
  mounted() {
    if (this.$nuxt.$store.state.data) {
      this.isLogin = this.$nuxt.$store.state.data.id
      this.user = this.$nuxt.$store.state.data
    } else {
      this.$nuxt.$on('auth', (auth) => {
        if (auth && auth.id) {
          this.isLogin = auth.id
          this.user = { ...auth }
        }
      })
    }
  },
  watch: {},
  methods: {
    sendMessage(message) {},
  },
  apollo: {
    getData: {
      query() {
        this.isLoadingData = true
        const query = gql(`query MyQuery {
            movies_recommended: movies(where: { movie_status: {_eq: "recommended"} }){
              id
              code
              name
              name_en
              movie_status
              movie_type
              content
              time
              view
              year_of_manufacture
              total_episode
              country_id
              country {
                id
                code
                name
              }
              movie_images {
                id
                type_image
                url
              }
              movie_categories(where: {is_delete: {_eq: false}}){
                id
                movie_id
                category_id
                category {
                  id
                  code
                  name
                }
              }
              movie_actors(where: {is_delete: {_eq: false}}){
                id
                movie_id
                actor_id
                actor {
                  id
                  code
                  name
                }
              }
              movie_details(where: {is_delete: {_eq: false}}){
                id
                movie_id
                episode
                url_movie
                url_sub_en
                url_sub_vi
              }
            }
          }`)
        return query
      },
      update: (data) => {},
      async result({ data }) {
        this.recommendMovies = []
        if (data && data.movies_recommended.length > 0) {
          for (let index = 0; index < data.movies_recommended.length; index++) {
            const element = data.movies_recommended[index]
            const movieItem = {}
            movieItem.id = element.id
            movieItem.ep = element.total_episode
            movieItem.type = element.movie_type
            movieItem.status = element.movie_status
            movieItem.view = element.view
            movieItem.title = element.name_en.toUpperCase()
            movieItem.subtitle = element.name
            movieItem.link = '/movies/movie_detail?code=' + element.code
            movieItem.country = element.country.name
            movieItem.year_of_manufacture = element.year_of_manufacture
            movieItem.time = element.time
            for (
              let indexI = 0;
              indexI < element.movie_images.length;
              indexI++
            ) {
              const elementImage = element.movie_images[indexI]
              if (elementImage.type_image === 'image' && elementImage.url) {
                const images = this.$fire.storage.ref().child('movies/images/')
                const image = images.child(elementImage.url)
                await image.getDownloadURL().then((url) => {
                  movieItem.image = url
                })
              }
            }
            if (element.movie_categories.length > 0) {
              movieItem.movie_categories = element.movie_categories
            }
            if (element.movie_actors.length > 0) {
              movieItem.movie_actors = element.movie_actors
            }
            this.recommendMovies.push(movieItem)
          }
        }
        this.isLoadingData = false
      },
    },
  },
}
</script>

<style scoped></style>
