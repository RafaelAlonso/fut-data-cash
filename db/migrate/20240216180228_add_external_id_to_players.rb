class AddExternalIdToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :external_id, :integer
  end
end
