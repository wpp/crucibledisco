class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :slack_id
      t.integer :gg_id, limit: 8
      t.string :gamertag
      t.integer :platform_id

      t.timestamps null: false
    end
  end
end
