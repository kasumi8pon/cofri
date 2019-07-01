<template>
  <div class="shopping-list-vue">
    <div v-if="this.shoppingList.length == 0">
      <p>
        買いものリストには何もありません。<br>
        冷蔵庫から買うものをリストに追加しましょう。
      </p>
    </div>
    <div class="list__body">
      <shopping-item class="columns is-vcentered is-mobile is-multiline list__body__item" v-for="food in shoppingList" :key="food.id" v-bind:food="food">
      </shopping-item>
    </div>
  </div>
</template>

<script>
import ShoppingItem from "./shopping-item.vue"

export default {
  props: [],
  components: {
      "shopping-item": ShoppingItem
    },
  data () {
    return {
      shoppingList: [],
      categories: []
    }
  },

  created: function () {
    fetch(`api/shopping_items`, {
        method: 'GET',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
        },
        credentials: 'same-origin',
        redirect: 'manual'
      })
        .then(response => {
          return response.json()
        })
        .then(json => {
          json.forEach(food => { this.shoppingList.push(food) });
        })
        .catch(error => {
          console.warn('Failed to parsing', error)
        })

    fetch(`api/food_categories`, {
        method: 'GET',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
        },
        credentials: 'same-origin',
        redirect: 'manual'
      })
        .then(response => {
          return response.json()
        })
        .then(json => {
          json.forEach(category => { this.categories.push(category) });
        })
        .catch(error => {
          console.warn('Failed to parsing', error)
        })
  },

  computed: {
    
  },

  methods: {
    
  }
}
</script>