import Vue from 'vue'
import ShoppingList from 'shopping-list.vue'

document.addEventListener('DOMContentLoaded', () => {
  const shoppingList = document.getElementById('shopping-list')
  if (shoppingList) {
    new Vue({
      render: h => h(ShoppingList, { props: {

      } })
    }).$mount('#shopping-list')
  }
})