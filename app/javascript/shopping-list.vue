<template>
  <div class="shopping-list-vue">
    <div class="columns" v-if="this.shoppingList.length != 0">
      <div class="column">
      </div>
      <div class="column is-narrow">
        <a v-on:click="postSlack" class="button is-hidden-mobile">
          <span class="icon is-large has-text-primary">
            <i class="fab fa-slack"></i>
          </span>
          <span>買い物を頼む</span>
        </a>
      </div>
    </div>
    <div v-else>
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
  methods: {
    askUrl: function() {
      var shoppingItemsName = []
      for(var i = 0; i < this.shoppingList.length; i++) {
        shoppingItemsName.push(this.shoppingList[i].name);
      };
      return "https://slackbutton.herokuapp.com/post/new?url=帰りに" + shoppingItemsName.join('と') + "を買ってきて";
    },

    postSlack: function() {
      window.open(this.askUrl(), 'Slackで共有する', 'height=400, width=600');
      return false;
    },
  }
}
</script>