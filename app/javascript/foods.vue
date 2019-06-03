<template>
  <div>
    <div class="field">
      <label for="search" class="label">検索</label>
      <div class="control">
        <input id="search" v-model="searchQuery" class="input">
      </div>
    </div>
    <div class="field">
      <div class="control">
        <label v-for="label in amounts" class="radio">
          <input type="radio" v-bind:value="label.value" v-model="selectedAmount">{{ label.label }}</input>
        </label>
      </div>
    </div>
    <a v-on:click="postSlack" class="button" v-bind:disabled="isButtonDisabled">
      <span class="icon is-large has-text-primary">
        <i class="fab fa-slack"></i>
      </span>
      <span>Slackで買い物を頼む</span>
    </a>
    <table class="table is-striped is-fullwidth">
      <thead>
        <tr>
          <th><input type="checkbox" :checked="isAllSelected" v-on:click="selectAllFoods"></th>
          <th>{{ name }}</th>
          <th>{{ amount }}</th>
          <th>
            {{ foodCategory }}
            <br>
            <select v-model="selectedCategory" class="select">
              <option v-for="category in categories" name="category" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </th>
          <th></th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="food in computedFoods" :key="food.id">
          <td><input type="checkbox" v-model="food.checked" v-on:change="select"></td>
          <td>{{ food.name }}</td>
          <td class="amount">
            <div class="columns">
              <div v-for="(amount, index) in amountList" class="column">
                <div class="button is-rounded is-small amount" :class="{'is-primary': food.amount == index }" v-on:click="changeAmount(food.id, index)">
                  {{ amount.label }}
                </div>
              </div>
            </div>
          <td>{{food.food_category.name}}</td>
          <td class="edit"><a :href="path('edit', food.id)" class="button is-small">編集</a></td>
          <td class="destroy"><a :data-confirm="dataConfirm(food.name)" rel="nofollow" data-method="delete" :href="path('delete', food.id)" class="button is-small is-danger">削除</a></td>
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
        { id: -1, name: 'すべて'}
      ],
      selectedCategory: -1,
      amounts: [
        { value: -1, label: 'すべて' },
        { value: 0, label: 'empty' },
        { value: 1, label: 'short' },
        { value: 2, label: 'enough'}
      ],
      selectedAmount: -1,
      searchQuery: '',
      isAllSelected: false
    }
  },

  created: function () {
    axios.get('api/foods').then((response) => {
      for(var i = 0; i < response.data.foods.length; i++) {
        response.data.foods[i].checked = false
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
    },

    isButtonDisabled: function () {
      if (this.checkedFoods.length == 0) {
        return true;
      } else {
        return false;
      }
    },

    checkedFoods: function() {
      var foods = this.computedFoods.filter(function(el) {
        return el.checked
      }, this);
      return foods
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

    askUrl: function() {
      var checkedFoodsName = []
      for(var i = 0; i < this.checkedFoods.length; i++) {
        checkedFoodsName.push(this.checkedFoods[i].name);
      };
      return "http://slackbutton.herokuapp.com/post/new?url=帰りに" + checkedFoodsName.join('と') + "を買ってきて";
    },

    postSlack: function() {
      if (this.isButtonDisabled == false) {
        window.open(this.askUrl(), 'Slackで共有する', 'height=400, width=600');
      return false;
      }
    },

    selectAllFoods () {
      if (this.isAllSelected) {
        this.isAllSelected = false
        for(var i = 0; i < this.computedFoods.length; i++) {
        this.computedFoods[i].checked = false
        };
      } else {
        this.isAllSelected = true
        for(var i = 0; i < this.computedFoods.length; i++) {
        this.computedFoods[i].checked = true
        };
      }
    },

    select() {
      var checkedFoods = this.computedFoods.filter(function(el) {
        return el.checked
      }, this);
      if (checkedFoods.length !== this.computedFoods.length) {
        this.isAllSelected = false
      } else {
        this.isAllSelected = true
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