import Vue from 'vue'
import Foods from 'foods.vue'
import { library } from '@fortawesome/fontawesome-svg-core'
import { far } from '@fortawesome/free-regular-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

library.add(far)

Vue.component('font-awesome-icon', FontAwesomeIcon)

Vue.config.productionTip = false

document.addEventListener('DOMContentLoaded', () => {
  const foods = document.getElementById('foods')
  if (foods) {
    const name = foods.getAttribute('data-column-name')
    const amount = foods.getAttribute('data-column-amount')
    const foodCategory = foods.getAttribute('data-column-food-category')
    new Vue({
      render: h => h(Foods, { props: {
        name: name,
        amount: amount,
        foodCategory: foodCategory
      } })
    }).$mount('#foods')
  }
})