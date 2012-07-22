class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.references :account
      
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
