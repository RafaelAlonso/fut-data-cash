class Fixture < ApplicationRecord
  # Validations for presence
  validates :fixture_id, :home_team_id, :away_team_id, :date_time, presence: true

  # Validation for fixture_id uniqueness
  validates :fixture_id, uniqueness: true

  # Assuming date_time is stored as a DateTime object in the database
  validates :date_time, presence: true

  # Custom validations
  validate :home_team_cannot_be_same_as_away_team

  private

  def home_team_id_cannot_be_same_as_away_team_id
    errors.add(:home_team, "cannot be the same id as the away id") if home_team_id == away_team_id
  end
end
