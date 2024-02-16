class AddFieldsToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :state, :string
    add_column :teams, :logo_url, :string
    add_column :teams, :external_id, :integer
    add_column :teams, :code, :string
  end
end
