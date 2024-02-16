class Team < ApplicationRecord
  has_many :home_fixtures, foreign_key: 'home_team_id', class_name: 'Fixture', dependent: :destroy
  has_many :away_fixtures, foreign_key: 'away_team_id', class_name: 'Fixture', dependent: :destroy
  has_many :players, dependent: :destroy
end
