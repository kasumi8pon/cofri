import Vue from 'vue/dist/vue.esm.js'
import axios from 'axios';

const csrfToken = document.querySelector("meta[name=csrf-token]").content;
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;

new Vue ({
  el: '#app',
  data: {
    foods: [],
    amounts: [
      { value: -1, label: 'すべて' },
      { value: 0, label: 'empty' },
      { value: 1, label: 'short' },
      { value: 2, label: 'enough'}
    ],
    selectedAmount: -1
  },

  created: function () {
    axios.get('api/foods').then((response) => {
      for(var i = 0; i < response.data.foods.length; i++) {
        this.foods.push(response.data.foods[i]);
      };
    });
  },

  computed: {
    amountList: function() {
      return this.amounts.filter(amount => amount.value >= 0)
    },

    computedFoods: function() {
      return this.foods.filter(function(el) {
        return this.selectedAmount < 0 ? true: this.selectedAmount === el.amount
      }, this)
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
