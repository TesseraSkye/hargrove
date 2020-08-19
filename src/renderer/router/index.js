import Vue from 'vue'
import Router from 'vue-router'
import Home from '../views/Home.vue'
Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },

    //wildcard so that weird requests aren't unhandeled
    {
      path: '*',
      redirect: '/'
    }
  ]
})
