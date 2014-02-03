class AddScoreToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :score, :int
  end
end
