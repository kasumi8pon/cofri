import Vue from 'vue/dist/vue.esm.js'
import axios from 'axios';

const csrfToken = document.querySelector("meta[name=csrf-token]").content;
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;

new Vue ({
  el: '#app',
  data: {
    foods: [],
    categories: [
      { id: -1, name: 'カテゴリー'}
    ],
    selectedCategory: -1,
    amounts: [
      { value: -1, label: 'すべて' },
      { value: 0, label: 'empty' },
      { value: 1, label: 'short' },
      { value: 2, label: 'enough'}
    ],
    selectedAmount: -1,
    searchQuery: ''
  },

  created: function () {
    axios.get('api/foods').then((response) => {
      for(var i = 0; i < response.data.foods.length; i++) {
        this.foods.push(response.data.foods[i]);
      };
    });
    axios.get('api/food_categories').then((response) => {
      for(var i = 0; i < response.data.food_categories.length; i++) {
        this.categories.push(response.data.food_categories[i]);
      };
    });
  },

  computed: {
    amountList: function() {
      return this.amounts.filter(amount => amount.value >= 0)
    },

    computedFoods: function() {
      var searchQuery = this.searchQuery
      var foods = this.foods.filter(function(el) {
        return this.selectedAmount < 0 ? true: this.selectedAmount === el.amount
      }, this).filter(function(el) {
        return this.selectedCategory < 0 ? true: this.selectedCategory === el.food_category.id
      }, this)
      if (searchQuery) {
        foods = foods.filter(function (row) {
          return Object.keys(row).some(function (key) {
            return String(row[key]).toLowerCase().indexOf(searchQuery) > -1
          })
        })
      }
      return foods;
    }
  },

  methods: {
    path: function(method, id) {
      switch(method) {
        case 'show':
          return 'foods/'+id;
        case 'delete':
          return 'foods/'+id;
        case 'edit':
          return 'foods/'+id+'/edit';
      }
    },

    dataConfirm: function(name) {
      return name+'を削除しますか。よろしいですか？';
    },

    checkAmount: function(amount, clicked) {
      return amount == clicked;
    },

    changeAmount: function (id, amount) {
      function findId(element) {
        return element.id == id;
      }
      var index = this.foods.findIndex(findId);

      if (this.foods[index].amount == amount) {
        return;
      };

      axios.put('/api/foods/'+ id, { 
        amount: amount
      }).then(() => {
        this.foods[index].amount = amount;
      });
    }
  }
})