import Vue from 'vue'
import FoodCategories from 'food-categories.vue'
import { library } from '@fortawesome/fontawesome-svg-core'
import { far } from '@fortawesome/free-regular-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

library.add(far)

Vue.component('font-awesome-icon', FontAwesomeIcon)

Vue.config.productionTip = false

document.addEventListener('DOMContentLoaded', () => {
  const foodCategories = document.getElementById('food-categories')
  if (foodCategories) {
    new Vue({
      render: h => h(FoodCategories, { 
      })
    }).$mount('#food-categories')
  }
})