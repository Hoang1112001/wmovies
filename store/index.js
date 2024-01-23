export const state = () => ({
  data: null,
})

export const mutations = {
  setDataUser(state, payload) {
    state.data = payload
  },
}
