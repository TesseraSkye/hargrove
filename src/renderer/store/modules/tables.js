const state = {
  tables: [],
  paths: ["","",""]
}

const mutations = {
  genTables (state,data) {
    state.tables(data)
  },
  setPath(state,data) {
    state.paths[data["tableNum"]] = data['path']
  }
}

const actions = {
  genTables ({ commit }) {
    let paths = state.paths
    let data = 
    commit('genTables',data)
  },
  setPath({ comit }, data) {
    
  }
}

export default {
  state,
  mutations,
  actions
}
