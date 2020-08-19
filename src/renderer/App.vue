<template>
  <div id="app" class="bg-dark text-light vh-100">
      <b-navbar type="dark" variant="dark" class="shadow drag-area">
        <router-link to="/" class="text-light no-drag">
          <b-navbar-brand class="no-drag">
            <b-img class="wordmark" :src="require('./assets/hargrove_wordmark_light.png')"></b-img>
          </b-navbar-brand>
        </router-link>

        <b-navbar-toggle class="no-drag" target="nav-collapse"></b-navbar-toggle>

        <b-collapse id="nav-collapse" is-nav>
          <!-- <b-navbar-nav>
            <router-link to="/settings" class="text-light no-drag">Settings</router-link>
          </b-navbar-nav> -->
        </b-collapse>
        <b-button @click="minimise()" size="sm" class="float-right no-drag" variant="transparent">
            <b-icon-dash class="border rounded-circle border-dark bg-light my-2 grab" style="width: 20px; height: 20px;" variant="dark"/>
        </b-button>
        <b-button @click="quit()" size="sm" class="float-right no-drag" variant="transparent">
            <b-icon-x class="border rounded-circle border-dark bg-light my-2 grab" style="width: 20px; height: 20px;" variant="dark"/>
        </b-button>
    </b-navbar>
    <br>
    <transition name="global-transition" mode="out-in">
          <router-view/>
    </transition>
  </div>
</template>

<script>
import { remote } from 'electron'
  export default {
    name: 'hargrove',
    methods: {
      minimise() {
        remote.BrowserWindow.getFocusedWindow().minimize();
      },
      quit() {
        window.close()
      }
    }
  }
</script>

<style>
  /* CSS */

.wordmark {
  height: 40pt;
  -webkit-user-drag: none;
  -khtml-user-drag: none;
  -moz-user-drag: none;
  -o-user-drag: none;
}


 /* disable hover */
:not(input):not(textarea),
:not(input):not(textarea)::after,
:not(input):not(textarea)::before {
    -webkit-user-select: none;
    user-select: none;
    cursor: default;
}
input, button, textarea, :focus {
    outline: none;
}

  /* General Restyling */
.text-shadow,
.text-shadow-md,
.text-shadow-medium {
   text-shadow: 4px 4px 4px rgba(80, 80, 80, 0.1)
}
.text-white {
  color: #fff;
}
.text-grey,
.text-gray {
  color: #6c757d;
}

.vh-75 {
  height: 75vh;
}
.vh-50 {
  height: 50vh;
}
.vh-25 {
  height: 25vh;
}
.vh-10 {
  height: 10vh;
}

.inverted {
	filter: invert(100%);
}

.text-center {
  text-align: center;
}

.fit-fill {
  object-fit: fill;
}
.fit-contain {
  object-fit: contain;
}
.fit-cover {
  object-fit: cover;
}
.fit-scale-down {
  object-fit: scale-down;
}
.fit-none {
  object-fit: none;
}
::placeholder {
  color: #f8f9fa !important;
  opacity: 1 !important;
}
input:active,
input:focus,
button:active,
button:focus {
  box-shadow: none !important;
}

a{
  text-decoration: none !important;
}

.drag-area {
  -webkit-app-region: drag
}
.no-drag {
  -webkit-app-region: no-drag;
  cursor: auto;
}
.grab {
  cursor: pointer;
}

/* Transition Styling */
.global-transition-enter-active, .global-transition-leave-active {
  transition: opacity .5s;
}
.global-transition-enter, .global-transition-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}
</style>
