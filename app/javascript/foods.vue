<template>
  <div class="foods-vue">
    <div class="food__header columns">
      <div class="column filter">
        <div class="field has-addons">
          <div class="control">
            <div class="select">
              <select v-model="selectedCategory" id="category">
                <option v-for="category in categories" name="category" :value="category.id" :key=category.id>
                  {{ category.name }}
                </option>
              </select>
            </div>
          </div>
          <div class="control has-icons-right search">
            <input id="search" v-model="searchQuery" class="input">
            <span class="icon is-small is-right" :class="{ times: searchQuery != '' }" @click="deleteSearchQuery">
              <font-awesome-icon :icon="searchIcon"/>
            </span>
          </div>
        </div>
        <div class="amount-checkbox columns">
          <div @click="clickCheck('empty')" class="amount-checkbox column is-narrow">
            <label class="checkbox">
              <span class="icon">
                <font-awesome-icon v-model="selectEmpty" :icon="emptyIcon" />
              </span>
              empty
            </label>
          </div>
          <span @click="clickCheck('short')" class="amount-checkbox column is-narrow">
            <label class="checkbox">
              <span class="icon">
                <font-awesome-icon  v-model="selectShort" :icon="shortIcon" />
              </span>
              short
            </label>
          </span>
          <span @click="clickCheck('enough')" class="amount-checkbox column is-narrow">
            <label class="checkbox">
              <span class="icon">
                <font-awesome-icon  v-model="selectEnough" :icon="enoughIcon" />
              </span>
              enough
            </label>
          </span>
        </div>
      </div>
      <div class="column slack is-hidden-mobile">
        <a v-on:click="postSlack" class="button" :class="{'is-static': isButtonDisabled }">
          <span class="icon is-large has-text-primary">
            <i class="fab fa-slack"></i>
          </span>
          <span>買い物を頼む</span>
        </a>
      </div>
    </div>
    <div v-if="foods.length == 0">
      <p>冷蔵庫のなかに食材を追加しましょう</p>
    </div>
    <div class="list__body">
      <food class="columns is-centered is-vcentered is-variable is-1-mobile is-mobile is-multiline list__body__item" v-for="food in computedFoods" v-bind:food="food" :key="food.id">
      </food>
    </div>
  </div>
</template>

<script>
import Food from "./food.vue"

export default {
  props: ['name', 'amount', 'foodCategory'],
  components: {
      "food": Food
    },
  data () {
    return {
      foods: [],
      categories: [
        { id: -1, name: 'すべて'}
      ],
      selectedCategory: -1,
      selectEmpty: true,
      selectShort: true,
      selectEnough: true,
      onlyToBuy: 0,
      onlyNotEmpty: 0,
      searchQuery: '',
      isAllSelected: false
    }
  },

  created: function () {
    fetch(`api/foods`, {
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
          json.forEach(food => { this.foods.push(food) });
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
    emptyIcon: function() {
      return this.selectEmpty ? 'check-square' : ['far', 'square']
    },
    shortIcon: function() {
      return this.selectShort ? 'check-square' : ['far', 'square']
    },
    enoughIcon: function() {
      return this.selectEnough ? 'check-square' : ['far', 'square']
    },

    searchIcon: function() {
      return this.searchQuery == "" ? 'search' : 'times-circle'
    },

    amountList: function() {
      return this.amounts.filter(amount => amount.value >= 0)
    },

    computedFoods: function() {
      var foods = this.foods.filter(function(el) {
        return this.selectedCategory < 0 ? true: this.selectedCategory === el.food_category.id
      }, this)
      .filter(function(el) {
        return this.selectEmpty ? true : el.amount != 0
      }, this).filter(function(el) {
        return this.selectShort ? true : el.amount != 1
      }, this).filter(function(el) {
        return this.selectEnough ? true : el.amount != 2
      }, this)
      var searchQuery = this.searchQuery
      if (searchQuery) {
        foods = foods.filter(function (row) {
          return Object.keys(row).some(function (key) {
            return String(row[key]).toLowerCase().indexOf(searchQuery) > -1
          })
        })
      }
      return foods;
    },

    isButtonDisabled: function () {
      return this.toBuyFoods.length == 0 ? true : false
    },

    toBuyFoods: function() {
      var foods = this.foods.filter(function(el) {
        return el.to_buy
      }, this);
      return foods
    }
  },

  methods: {
    clickCheck: function(amount) {
      const upperAmount = amount.slice( 0, 1 ).toUpperCase() + amount.slice( 1 )
      eval(`this.select${upperAmount} = !this.select${upperAmount}`) 
    },
    askUrl: function() {
      var toBuyFoodsName = []
      for(var i = 0; i < this.toBuyFoods.length; i++) {
        toBuyFoodsName.push(this.toBuyFoods[i].name);
      };
      return "http://slackbutton.herokuapp.com/post/new?url=帰りに" + toBuyFoodsName.join('と') + "を買ってきて";
    },

    postSlack: function() {
      if (this.isButtonDisabled == false) {
        window.open(this.askUrl(), 'Slackで共有する', 'height=400, width=600');
      return false;
      }
    },
    deleteSearchQuery: function () {
      this.searchQuery = ""
    }
  }
}
</script>