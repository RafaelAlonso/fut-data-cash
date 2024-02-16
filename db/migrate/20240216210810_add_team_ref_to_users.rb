class AddTeamRefToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :team, null: false, foreign_key: true
  end
end
