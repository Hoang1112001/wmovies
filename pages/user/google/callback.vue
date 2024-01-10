<template>
  <v-layout align-center justify-center color="red">
    <v-flex xs12 sm8 md3 lg3> </v-flex>
  </v-layout>
  <!-- </v-main> -->
</template>

<script>
// import gql from 'graphql-tag'
import cookie from 'cookiejs'
import axios from 'axios'
export default {
  async asyncData({ route, params, redirect }) {
    if (route.query && route.query.user && route.query.token) {
      const dataCheck = {}
      dataCheck.google_id = route.query.user
      dataCheck.token = route.query.token

      await axios
        .post(`${process.env.URL_SERVER}/account/check-user-login-google`, {
          dataCheck,
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              cookie.set('jwt-login', response.data.data.token, 1)
              return redirect('/')
            } else {
              return redirect('/')
            }
          }
        })
        .catch((error) => {
          console.log(error)
        })
    } else {
      return redirect('/')
    }

    return {}
  },
  layout: 'auth',
  data: () => ({}),
  apollo: {},
  created() {},

  methods: {},
}
</script>
<style scoped lang="css">
.logo {
  max-width: 100%; /* only this one important */
}
</style>
