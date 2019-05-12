<template>
  <input type="button" value="URLをコピーする" v-on:click="copyUrl">

</template>
<script>
export default {
  methods: {
    copyUrl: function() {
      const url = document.getElementById("invitation_url");
      url.select();
      document.execCommand("Copy");
      alert("招待URLをコピーしました");
    }
  }
}
</script>