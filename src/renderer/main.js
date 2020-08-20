import Vue from 'vue'
import axios from 'axios'

import App from './App'
import router from './router'
import store from './store'

import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

import * as sc from 'supercolliderjs'

Vue.use(BootstrapVue)
Vue.use(IconsPlugin)
Vue.use(sc)

if (!process.env.IS_WEB) Vue.use(require('vue-electron'))
Vue.http = Vue.prototype.$http = axios
Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  components: { App },
  router,
  store,
  template: '<App/>'
}).$mount('#app')
sc.server.boot({ scsynth: 'C:/Program Files/SuperCollider-3.11.0/scsynth.exe'}).then(async server => {
  // await server.callAndResponse(sc.server.msg.defLoadDir("./sc/synthdefs/"));
  console.log(sc.File)
})