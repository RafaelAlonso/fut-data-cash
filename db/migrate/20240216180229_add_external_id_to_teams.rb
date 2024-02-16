class AddExternalIdToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :external_id, :integer
  end
end
