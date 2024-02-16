class ChangeTeamNamesToIdsInFixtures < ActiveRecord::Migration[7.0]
  def up
    # Remove the old columns
    remove_column :fixtures, :home_team
    remove_column :fixtures, :away_team

    # Add new columns with the correct type
    add_column :fixtures, :home_team_id, :integer
    add_column :fixtures, :away_team_id, :integer
  end

  def down
    # Remove the new columns
    remove_column :fixtures, :home_team_id
    remove_column :fixtures, :away_team_id

    # Add back the original columns
    add_column :fixtures, :home_team, :string
    add_column :fixtures, :away_team, :string
  end
end
