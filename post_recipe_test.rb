# -*- coding: utf-8 -*-

class PostTest < FrankTest
  # 新しくレシピを投稿するテスト
  test "post new recipe" do
    # 現在のレシピの先頭を確かめる
    titles = frankly_map('view:"RecipeTableViewCell" marked:"recipe_at_0" label marked:"title"', "text")
    assert_equal ["Orange"], titles
    
    bodies = frankly_map('view:"RecipeTableViewCell" marked:"recipe_at_0" label marked:"body"', "text")
    assert_equal ["Put oranges on dish."], bodies

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
  end
end