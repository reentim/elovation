class Result < ActiveRecord::Base
  has_many :teams
  belongs_to :game

  validates :game, presence: true
  scope :most_recent_first, :order => "created_at desc"
  scope :for_game, lambda { |game| where(:game_id => game.id) }

  validate do |result|
    if result.winners.empty?
      result.errors.add(:teams, "must have a winner")
    end

    if result.players.size != players.uniq.size
      result.errors.add(:teams, "must have unique players")
    end

    if result.teams.size < result.game.min_number_of_teams
      result.errors.add(:teams, "must have at least #{result.game.min_number_of_teams} teams")
    end

    if result.game.max_number_of_teams && result.teams.size > result.game.max_number_of_teams
      result.errors.add(:teams, "must have at most #{result.game.max_number_of_teams} teams")
    end

    if result.teams.any?{|team| team.players.size < result.game.min_number_of_players_per_team}
      result.errors.add(:teams, "must have at least #{result.game.min_number_of_players_per_team} players per team")
    end

    if result.game.max_number_of_players_per_team && result.teams.any?{|team| team.players.size > result.game.max_number_of_players_per_team}
      result.errors.add(:teams, "must have at most #{result.game.max_number_of_players_per_team} players per team")
    end

    if !result.game.allow_ties && result.teams.map(&:rank).uniq.size != result.teams.size
      result.errors.add(:teams, "game does not allow ties")
    end

    if !result.game.record_scores && result.teams.map(&:score).any?
      result.errors.add(:game, "does not record scores")
    end

    if result.game.record_scores && result.teams.map(&:score).any?(&:nil?)
      result.errors.add(:game, "requires scores be recorded")
    end
  end

  def players
    teams.map(&:players).flatten
  end

  def winners
    teams.select{|team| team.rank == Team::FIRST_PLACE_RANK}.map(&:players).flatten
  end

  def losers
    teams.select{|team| team.rank != Team::FIRST_PLACE_RANK}.map(&:players).flatten
  end

  def score
    teams.sort { |a, b| a.rank <=> b.rank }.map(&:score)
  end

  def as_json(options = {})
    {
      :winner => winners.first.name,
      :loser => losers.first.name,
      :created_at => created_at.utc.to_s
    }
  end

  def most_recent?
    teams.all? do |team|
      team.players.all? do |player|
        player.results.where(:game_id => game.id).order("created_at DESC").first == self
      end
    end
  end
end
