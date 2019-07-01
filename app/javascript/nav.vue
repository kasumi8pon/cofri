<template>
  <nav class="navbar" role="navigation" aria-label="main navigation">
    <div class="navbar-brand">
      <a class="navbar-item" href="/">
        <h1 class="title">coFri</h1>
      </a>

      <a role="button" class="navbar-burger burger" aria-label="menu" aria-expanded="false" data-target="navbarBasicExample" @click="isOpen = !isOpen" v-bind:class="{'is-active': isOpen}">
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
      </a>
    </div>

    <div id="navbarBasicExample" class="navbar-menu" v-bind:class="{'is-active': isOpen}">
      <div class="navbar-start" v-if="currentUserId">
        <a href="/foods" class="navbar-item">
          冷蔵庫のなかみ
        </a>

        <a href="/shopping_list" class="navbar-item">
          買い物リスト
        </a>

        <a href="/food_categories" class="navbar-item">
          カテゴリー
        </a>
      </div>

      <div class="navbar-end">
        <div class="navbar-item">
          <div class="buttons" v-if="currentUserId">
            <a :href="editPath(currentUserId)" class="button is-primary">
              <strong>ユーザー情報</strong>
            </a>
            <a href="/logout" class="button is-light" rel="nofollow" data-method="delete">
              ログアウト
            </a>
          </div>
          <div class="buttons" v-else>
            <a href="/users/new" class="button is-danger">
              <strong>ユーザー登録</strong>
            </a>
            <a href="/login" class="button is-light">
              ログイン
            </a>
          </div>
        </div>
      </div>
    </div>
  </nav>
</template>
<script>
export default {
  props: ['currentUserId'],
  data () {
    return {
      isOpen: false
    }
  },
  methods: {
    editPath: function(id) {
      return '/users/'+id+'/edit';
    }
  }
}
</script>