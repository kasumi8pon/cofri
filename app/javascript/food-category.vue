<template>
  <div>
    <div class="column is-7-desktop is-7-tablet is-4-mobile name list__body__column">
      <a :href="editPath" class="name">
        {{ foodCategory.name }}
      </a>
    </div>
    <div class="column is-5-desktop is-5-tablet is-8-mobile position list__body__column">
      <div class="columns is-mobile is-variable is-0-mobile">
        <div class="column">
          <div class="button is-danger is-rounded is-small" @click="changePosition('top')">
            <span class="icon is-large">
              <i class="fas fa-angle-double-up"></i>
            </span>
          </div>
        </div>
        <div class="column">
          <div class="button is-danger is-rounded is-small" @click="changePosition('higher')">
            <span class="icon is-large">
              <i class="fas fa-angle-up"></i>
            </span>
          </div>
        </div>
        <div class="column">
          <div class="button is-danger is-rounded is-small" @click="changePosition('lower')">
            <span class="icon is-large">
              <i class="fas fa-angle-down"></i>
            </span>
          </div>
        </div>
        <div class="column">
          <div class="button is-danger is-rounded is-small" @click="changePosition('bottom')">
            <span class="icon is-large">
              <i class="fas fa-angle-double-down"></i>
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
  export default {
  props: ["foodCategory"],

  computed: {
    editPath: function() {
      return 'food_categories/'+this.foodCategory.id+'/edit';
    }
  },

  methods: {
    changePosition: function(move) {
      this.$emit('changePosition', {id: this.foodCategory.id, move: move})
    }
  }
}
</script>