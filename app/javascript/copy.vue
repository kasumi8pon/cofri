<template>
  <input type="button" value="コピーする" v-on:click="copyUrl" class="button">
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