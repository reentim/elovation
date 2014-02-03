class AddRecordScoresFlagToGames < ActiveRecord::Migration
  def change
    add_column :games, :record_scores, :boolean, null: false, default: false
  end
end
