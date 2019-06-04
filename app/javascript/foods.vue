<template>
  <div>
    <div class="columns">
      <div class="column">
        <div class="field has-addons">
          <div class="control">
            <label class="button is-primary is-static" for="search">検索</label>
          </div>
          <div class="control">
            <input id="search" v-model="searchQuery" class="input">
          </div>
        </div>
        <div class="field">
          <div class="control">
            <label class="radio" v-for="label in amounts">
              <input type="radio" v-bind:value="label.value" v-model="selectedAmount">
              {{ label.label }}
            </label>
          </div>
        </div>
        <div class="field">
          <div class="control">
            <label class="checkbox">
              <input type="checkbox" v-model="selectedToBuy">
              買うもののみ表示
            </label>
          </div>
        </div>
      </div>
      <div class="column">
        <a v-on:click="postSlack" class="button is-pulled-right" :class="{'is-static': isButtonDisabled }">
          <span class="icon is-large has-text-primary">
            <i class="fab fa-slack"></i>
          </span>
          <span>買い物を頼む</span>
        </a>
      </div>
    </div>
    <table class="table is-striped is-fullwidth">
      <thead>
        <tr>
          <th>買うもの<br>チェック</th>
          <th>{{ name }}</th>
          <th>{{ amount }}</th>
          <th>
            <label for="category">{{ foodCategory }}</label>
            <br>
            <select v-model="selectedCategory" class="select" id="category">
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
          <td class="to-buy">
            <div class="buttons has-addons">
              <span class="button is-small" :class="food.to_buy ? 'is-primary' : 'is-state is-light'" @click="changeToBuy(food.id)">ON</span>
              <span class="button is-small" :class="!food.to_buy ? 'is-primary' : 'is-state is-light'" @click="changeToBuy(food.id)">OFF</span>
            </div>
          </td>
          <td>{{ food.name }}</td>
          <td class="amount">
            <div class="columns">
              <div v-for="(amount, index) in amountList" class="column">
                <button class="button is-rounded is-small amount" :class="{'is-primary': food.amount == index }" v-on:click="changeAmount(food.id, index)">
                  {{ amount.label }}
                </button>
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

if (document.querySelector("meta[name=csrf-token]")) {
  const csrfToken = document.querySelector("meta[name=csrf-token]").content;
  axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
}

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
      selectedToBuy: 0,
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
      }, this).filter(function(el) {
        return this.selectedToBuy == 0 ? true : el.to_buy
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
      if (this.toBuyFoods.length == 0) {
        return true;
      } else {
        return false;
      }
    },

    toBuyFoods: function() {
      var foods = this.foods.filter(function(el) {
        return el.to_buy
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
    },

    checkAmount: function(amount, clicked) {
      return amount == clicked;
    },

    changeToBuy: function (id) {
      function findId(element) {
        return element.id == id;
      }
      var index = this.foods.findIndex(findId);

      axios.put('/api/foods/'+ id, { 
        to_buy: !this.foods[index].to_buy
      }).then(() => {
        this.foods[index].to_buy = !this.foods[index].to_buy;
      });
    }
  }
}
</script>