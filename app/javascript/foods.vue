<template>
  <div>
    <label for="search">検索</label>
    <input id="search" v-model="searchQuery">
    <label v-for="label in amounts">
      <input type="radio" v-bind:value="label.value" v-model="selectedAmount">{{ label.label }}</input>
    </label>
    <table class="table">
      <thead class="thead">
        <tr>
          <th>{{ name }}</th>
          <th>{{ amount }}</th>
          <th>
            {{ foodCategory }}
            <select v-model="selectedCategory">
              <option v-for="category in categories" name="category" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="food in computedFoods" :key="food.id">
          <td>{{ food.name }}</td>
          <td>
            <ul v-for="(amount, index) in amountList">
              <li class="amount_button" :class="{'now': food.amount == index }" v-on:click="changeAmount(food.id, index)">
                {{ amount.label }}
              </li>
            </ul>
          <td>{{ food.food_category.name }}</td>
          <td><a :href="path('edit', food.id)">編集</a></td>
          <td><a :data-confirm="dataConfirm(food.name)" rel="nofollow" data-method="delete" :href="path('delete', food.id)">削除</a></td>
        </tr>
      </tbody>
    </table>
  </div>

</template>

<script>
import axios from 'axios';

const csrfToken = document.querySelector("meta[name=csrf-token]").content;
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;

export default {
  props: ['name', 'amount', 'foodCategory'],
  data () {
    return {
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
    }
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
}
</script>