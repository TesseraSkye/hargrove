const state = {
  data: 0
}

const mutations = {
  updateData (state,data) {
    state.data = data
  }
}

const actions = {
  updateData ({ commit },data) {
    commit('updateData',data)
  }
}

export default {
  state,
  mutations,
  actions
}
