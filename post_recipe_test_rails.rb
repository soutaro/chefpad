# -*- coding: utf-8 -*-

class PostTestWithRails < FrankTest
  setup do
    # サーバのセットアップ: アカウントを作って、適当なレシピを登録しておく

    # Create account
    @account = Account.new
    @account.email = "test@example.com"
    @account.password = "topsecret"
    @account.password_confirmation = "topsecret"
    @account.save!
    
    # Add one recipe
    @account.recipes.create!(:title => "たこ焼き", :body => "タコを入れて焼く")
  end

  teardown do
    # アカウントとレシピを消す
    @account.recipes.destroy_all
    @account.destroy    
  end

  setup do
    # クライアントのセットアップ: ログインする
    frankly_map('view marked:"email"', "setText:", "test@example.com")
    frankly_map('view marked:"password"', "setText:", "topsecret")
    frankly_map('button marked:"Login"', "touch")

    sleep 1

    assert_equal 1, frankly_map('view:"UITableView"', "description").count
  end

  test "post new recipe" do
    # 現在のレシピの先頭を確かめる
    titles = frankly_map('view:"RecipeTableViewCell" marked:"recipe_at_0" label marked:"title"', "text")
    assert_equal ["たこ焼き"], titles
    
    bodies = frankly_map('view:"RecipeTableViewCell" marked:"recipe_at_0" label marked:"body"', "text")
    assert_equal ["タコを入れて焼く"], bodies

    # 新しいレシピを投稿する
    frankly_map('button marked:"New"', "touch")
    
    frankly_map('view:"UITextField"', "setText:", "みかん")
    frankly_map('view:"UITextView"', "setText:", "皿に盛る")
    frankly_map('button marked:"Done"', "touch")
    
    sleep 3
  
    # 新しく投稿したレシピが先頭に表示されていることを確かめる
    titles = frankly_map('view:"RecipeTableViewCell" marked:"recipe_at_0" label marked:"title"', "text")
    assert_equal ["みかん"], titles
    
    bodies = frankly_map('view:"RecipeTableViewCell" marked:"recipe_at_0" label marked:"body"', "text")
    assert_equal ["皿に盛る"], bodies

    # サーバにレシピが送信されてきていることを確認する
    latest_recipe = Recipe.last
    assert_equal "みかん", latest_recipe.title
    assert_equal "皿に盛る", latest_recipe.body
  end
end