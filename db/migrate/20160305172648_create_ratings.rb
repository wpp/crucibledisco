class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :games_played
      t.integer :mode
      t.integer :elo
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
