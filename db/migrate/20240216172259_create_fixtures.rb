class CreateFixtures < ActiveRecord::Migration[7.0]
  def change
    create_table :fixtures do |t|
      t.integer :fixture_id
      t.string :status
      t.datetime :date_time
      t.string :home_team
      t.string :away_team
      t.integer :home_score, null: false, default: 0
      t.integer :away_score, null: false, default: 0
      t.integer :competition_id
      t.integer :season

      t.timestamps
    end
  end
end
