class CreateApiSessions < ActiveRecord::Migration
  def change
    create_table :api_sessions do |t|
      t.string :token
      t.references :account
      
      t.timestamps
    end
  end
end
