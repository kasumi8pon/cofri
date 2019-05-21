import Vue from 'vue'
import Nav from 'nav.vue'

document.addEventListener('DOMContentLoaded', () => {
  const nav = document.getElementById('nav')
  const currentUserId = nav.getAttribute('current-user-id')
  if (nav) {
    new Vue({
      render: h => h(Nav, { props: {
        currentUserId: currentUserId
        }
      })
    }).$mount('#nav')
  }
})