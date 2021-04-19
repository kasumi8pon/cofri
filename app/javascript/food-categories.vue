<template>
  <div class="food-category list__body">
    <food-category
      class="columns is-vcentered is-centered is-mobile list__body__item"
      v-for="foodCategory in foodCategories" v-bind:foodCategory="foodCategory"
      :key="foodCategory.position"
      @changePosition="changePosition">
    </food-category>
  </div>
</template>

<script>
import FoodCategory from "./food-category.vue"

export default {
  components: {
    "food-category": FoodCategory
    },

  data () {
    return {
      foodCategories: [],
    }
  },

  created: function () {
    this.getFoodCategories()
  },

  methods: {
    token: function() {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },

    getFoodCategories: function() {
      fetch('/graphql', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSRF-Token': this.token()
        },
        body: JSON.stringify(
          {query: "{ foodCategories { id name position} }"}
        )
      })
        .then(r => r.json())
        .then(json => {
          json.data.foodCategories.forEach(category => { this.foodCategories.push(category) });
        })
        .catch(error => {
          console.warn('Failed to parsing', error)
        })
    },
    
    changePosition: function(arg) {
      fetch(`api/food_categories/${arg.id}/position/`, {
        method: 'PUT',
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token()
        },
        credentials: 'same-origin',
        redirect: 'manual',
        body: JSON.stringify({
          "move": arg.move
          })
      })
        .then(response => {
          this.foodCategories.splice(0, this.foodCategories.length)
          this.getFoodCategories()
        })
        .catch(error => {
          console.warn('Failed to parsing', error)
        })
    }
  }
}
</script>
