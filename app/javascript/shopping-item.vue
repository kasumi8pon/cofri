<template>
  <div>
    <div class="column is-2-desktop is-2-tablet is-2-mobile check list__column">
      <span class="icon checkbox" @click="clickButton">
        <font-awesome-icon :icon="checkboxIcon" />
      </span>
    </div>
    <div class="column is-4-desktop is-4-tablet is-6-mobile name list__column">
      <p :class="{bought: !food.to_buy}">{{ food.name }}</p>
    </div>
    <div class="column is-3-desktop is-3-tablet is-hidden-mobile category ist__column">
      <p>{{ food.food_category.name }}</p>
    </div>
    <div class="column is-3-desktop is-3-tablet is-4-mobile buy list__column">
      <button class="button is-small" :class="{'is-danger': food.to_buy}" @click="clickButton">
        {{ buyButtonLabel }}
      </button>
    </div>
  </div>
</template>
<script>
  export default {
  props: ["food"],
  data () {
    return {

    }
  },

  created: function () {
    
  },

  computed: {
    buyButtonLabel: function() {
      return this.food.to_buy ? "買った！" : "取り消す"
    },
    checkboxIcon: function() {
      return this.food.to_buy ? ['far', 'square'] : 'check-square'
    }
  },

  methods: {
    token: function() {
        const meta = document.querySelector('meta[name="csrf-token"]')
        return meta ? meta.getAttribute('content') : ''
      },
    clickButton: function() {
      this.food.to_buy ? this.buy() : this.undo()
    },
    buy: function () {
      fetch(`api/foods/${this.food.id}`, {
        method: 'PUT',
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token()
        },
        credentials: 'same-origin',
        redirect: 'manual',
        body: JSON.stringify({
          "to_buy": !this.food.to_buy,
          amount: 2
        })
      })
        .then(response => {
          this.food.to_buy = !this.food.to_buy
        })
        .catch(error => {
          console.warn('Failed to parsing', error)
        })
    },
    undo: function() {
      fetch(`api/foods/${this.food.id}`, {
        method: 'PUT',
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token()
        },
        credentials: 'same-origin',
        redirect: 'manual',
        body: JSON.stringify({
          "to_buy": !this.food.to_buy,
          amount: this.food.amount
        })
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