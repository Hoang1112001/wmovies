export default (context) => {
  return {
    httpEndpoint: process.env.HASURA_ENDPOINT,

    httpLinkOptions: {
      headers: {
        'x-hasura-admin-secret': process.env.HASURA_KEY,
      },
    },

    /*
     * For permanent authentication provide `getAuth` function.
     * The string returned will be used in all requests as authorization header
     */
    // getAuth: () => 'Bearer my-static-token',
  }
}
