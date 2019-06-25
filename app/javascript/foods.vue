<template>
  <div class="food">
    <div class="columns">
      <div class="column is-three-quarters">
        <div class="field has-addons">
          <div class="control">
            <label class="button is-primary is-static" for="search">検索</label>
          </div>
          <div class="control">
            <input id="search" v-model="searchQuery" class="input">
          </div>
        </div>

        <div class="field is-grouped">
          <div class="control">
            <label class="checkbox">
              <input type="checkbox" v-model="onlyToBuy">
              買うもののみ
            </label>
          </div>
          <div class="control">
            <label class="checkbox">
              <input type="checkbox" v-model="onlyNotEmpty">
              残量があるもののみ
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
    <br>
    <br>
    <div class="columns is-vcentered is-mobile is-multiline food-list__head">
      <div class="column food-list__column is-2-desktop is-2-tablet is--mobile to-buy">
        <p class="has-text-centered">買うもの<br>チェック</p>
      </div>
      <div class="column food-list__column is-2-desktop is-3-tablet is-8-mobile name">
        <p class="has-text-centered">{{ name }}</p>
      </div>
      <div class="column food-list__column category is-2-desktop is-2-tablet is-hidden-mobile">
        <p class="has-text-centered">
          {{ foodCategory }}<br>
          <select v-model="selectedCategory" class="select" id="category">
            <option v-for="category in categories" name="category" :value="category.id" :key=category.id>
              {{ category.name }}
            </option>
          </select>
        </p>
      </div>
      <div class="column food-list__column is-4-desktop is-5-tablet is-hidden-mobile is-12-mobile amount">
      </div>
      <div class="column food-list__column is-2-desktop actions is-hidden-touch">
      </div>
    </div>
    <div class="food-list__body">
      <div class="columns is-vcentered is-mobile is-multiline food-list__body__item" v-for="food in computedFoods" :key="food.id">
        <div class="column is-2-desktop is-2-tablet is-4-mobile to-buy food-list__column">
          <div class="buttons has-addons is-centered">
            <span class="button is-small" :class="food.to_buy ? 'is-primary' : 'is-state is-light'" @click="changeToBuy(food.id)">ON</span>
            <span class="button is-small" :class="!food.to_buy ? 'is-primary' : 'is-state is-light'" @click="changeToBuy(food.id)">OFF</span>
          </div>
        </div>
        <div class="column is-2-desktop is-3-tablet is-8-mobile name food-list__column">
          <p><a :href="path('edit', food.id)">{{ food.name }}</a></p>
        </div>
        <div class="column is-2-desktop is-2-tablet is-hidden-mobile category food-list__column">{{ food.food_category.name }}</div>
        <div class="column is-4-desktop is-5-tablet is-full-mobile amount food-list__column">
          <div class="columns is-mobile is-variable is-1-mobile is-3-tablet is-3-desktop">
            <div v-for="(amount, index) in amountList" class="column has-text-centered" :key="amount.value">
              <button class="button is-rounded is-small amount-button" :class="{'is-primary': food.amount == index }" v-on:click="changeAmount(food.id, index)">
                {{ amount.label }}
              </button>
            </div>
          </div>
        </div>
        <div class="column actions is-2-desktop is-hidden-touch food-list__column">
          <div class="buttons is-centered">
            <a :href="path('edit', food.id)" class="button is-small">編集</a>
            <a :data-confirm="dataConfirm(food.name)" rel="nofollow" data-method="delete" :href="path('delete', food.id)" class="button is-small is-danger">削除</a>
          </div>
        </div>
      </div>
    </div>
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
      onlyToBuy: 0,
      onlyNotEmpty: 0,
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
        return this.selectedCategory < 0 ? true: this.selectedCategory === el.food_category.id
      }, this).filter(function(el) {
        return this.onlyToBuy == 0 ? true : el.to_buy
      }, this).filter(function(el) {
        return this.onlyNotEmpty == 0 ? true : el.amount != 0
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
        if (amount == 2) {
          this.foods[index].to_buy = false
        }
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