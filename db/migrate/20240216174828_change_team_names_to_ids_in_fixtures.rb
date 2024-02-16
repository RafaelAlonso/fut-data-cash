class ChangeTeamNamesToIdsInFixtures < ActiveRecord::Migration[7.0]
  def up
    # Remove the old columns
    remove_column :fixtures, :home_team
    remove_column :fixtures, :away_team
    remove_column :fixtures, :competition_id

    # Add new columns with the correct type
    add_reference :fixtures, :home_team, null: false, foreign_key: { to_table: :teams }
    add_reference :fixtures, :away_team, null: false, foreign_key: { to_table: :teams }
  end

  def down
    # Remove the new columns
    remove_reference :fixtures, :home_team
    remove_reference :fixtures, :away_team

    # Add back the original columns
    add_column :fixtures, :home_team, :string
    add_column :fixtures, :away_team, :string
    add_column :fixtures, :competition_id
  end
end
