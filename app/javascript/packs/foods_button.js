import Vue from 'vue/dist/vue.esm.js'
import axios from 'axios';

const csrfToken = document.querySelector("meta[name=csrf-token]").content;
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;

new Vue ({
  el: '#app',

  data: {
    Active0: false,
    Active1: false,
    Active2: false,
  },

  mounted:function () {
    let now_amount = this.$refs.first.innerText;
    switch(now_amount){
      case "empty":
        this.Active0 = true;
        break;
      case "short":
        this.Active1 = true;
        break;
      case "enough":
        this.Active2 = true;
        break;
    }
  },
  
  methods: {
    changeAmount:function (id, amount) {
      let self = this
      let clicked = amount
      axios.put('/api/foods/'+ id, { 
        amount: amount
      }).then(changeClass());

      function changeClass() {
        self.Active0 = false;
        self.Active1 = false;
        self.Active2 = false;
        switch(clicked){
          case "empty":
            self.Active0 = true;
            break;
          case "short":
            self.Active1 = true;
            break;
          case "enough":
            self.Active2 = true;
            break;
        }
      }
    }
  }
})
