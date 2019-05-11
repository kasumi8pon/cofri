import Vue from 'vue'
import Foods from 'foods.vue'

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