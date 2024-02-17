class CreateFixtureStats < ActiveRecord::Migration[7.0]
  def change
    create_table :fixture_stats do |t|
      t.references :fixture, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :shots_on_goal
      t.integer :shots_off_goal
      t.integer :shots_insidebox
      t.integer :shots_outsidebox
      t.integer :total_shots
      t.integer :blocked_shots
      t.integer :fouls
      t.integer :corner_kicks
      t.integer :offsides
      t.integer :ball_posession
      t.integer :yellow_cards
      t.integer :red_cards
      t.integer :goalkeeper_saves
      t.integer :total_passes
      t.integer :passes_accurate
      t.integer :passes_percentage
      t.string :home_or_away
      t.integer :status
      t.integer :goals_made
      t.integer :goals_suffered

      t.timestamps
    end
  end
end
