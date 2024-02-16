class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :age
      t.string :position
      t.integer :goals_scored
      t.integer :assists
      t.integer :dribbles
      t.integer :tackles
      t.integer :red_card
      t.integer :yellow_card

      t.timestamps
    end
  end
end
