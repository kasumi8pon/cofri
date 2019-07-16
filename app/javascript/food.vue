<template>
  <div>
    <div class="column is-4-desktop is-4-tablet is-12-mobile name food-list__column">
      <a :href="editPath">{{ food.name }}</a>
      <span class="is-hidden-tablet">({{ food.food_category.name }})</span>
    </div>
    <div class="column is-2-desktop is-2-tablet is-hidden-mobile category food-list__column">
      <p>{{ food.food_category.name }}</p>
    </div>
    <div class="column is-4-desktop is-4-tablet amount food-list__column">
      <div class="buttons has-addons">
        <span v-for="(amount, index) in amountList" :key="amount.value" class="button is-small amount-button" :class="{'is-primary': food.amount == index }" v-on:click="changeAmount(index)">
          {{ amount.label }}
        </span>
      </div>
    </div>
    <div class="column to-buy is-2-desktop is-2-tablet is-narrow food-list__column">
      <span class="button is-small to-buy" :class="{'is-danger': !food.to_buy}" @click="changeToBuy">
        <font-awesome-icon :icon="toBuyIcon" />
        {{ toBuyLabel }}
      </span>
    </div>
  </div>
</template>
<script>
  export default {
  props: ["food"],
  data () {
    return {
      amounts: [
        { value: -1, label: 'すべて' },
        { value: 0, label: 'empty' },
        { value: 1, label: 'short' },
        { value: 2, label: 'enough'}
      ]
    }
  },

  created: function () {
    
  },

  computed: {
    toBuyLabel: function() {
      return this.food.to_buy ? "買う物から削除" : "買う物に追加"
    },
    toBuyIcon: function() {
      return this.food.to_buy ? 'minus' : 'plus'
    },

    amountList: function() {
      return this.amounts.filter(amount => amount.value >= 0)
    },

    toBuyFoods: function() {
      var foods = this.foods.filter(function(el) {
        return el.to_buy
      }, this);
      return foods
    },

    editPath: function() {
      return 'foods/'+this.food.id+'/edit';
    }
  },

  methods: {
    token: function() {
        const meta = document.querySelector('meta[name="csrf-token"]')
        return meta ? meta.getAttribute('content') : ''
      },

    changeAmount: function (amount) {
      if (this.food.amount == amount) {
        return;
      };
      fetch(`api/foods/${this.food.id}`, {
        method: 'PUT',
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token()
        },
        credentials: 'same-origin',
        redirect: 'manual',
        body: JSON.stringify({"amount": amount})
      })
        .then(response => {
          this.food.amount = amount
        })
        .catch(error => {
          console.warn('Failed to parsing', error)
        })
    },

    changeToBuy: function () {
      fetch(`api/foods/${this.food.id}`, {
        method: 'PUT',
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token()
        },
        credentials: 'same-origin',
        redirect: 'manual',
        body: JSON.stringify({"to_buy": !this.food.to_buy})
      })
        .then(response => {
          this.food.to_buy = !this.food.to_buy
        })
        .catch(error => {
          console.warn('Failed to parsing', error)
        })
    }
  }
}
</script>