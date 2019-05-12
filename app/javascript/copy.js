import Vue from 'vue'
import Copy from 'copy.vue'

document.addEventListener('DOMContentLoaded', () => {
  const copy = document.getElementById('copy')
  if (copy) {
    new Vue({
      render: h => h(Copy, { 
      })
    }).$mount('#copy')
  }
})