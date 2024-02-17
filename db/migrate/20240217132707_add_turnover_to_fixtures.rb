class AddTurnoverToFixtures < ActiveRecord::Migration[7.0]
  def change
    add_column :fixtures, :turnover, :boolean
  end
end
