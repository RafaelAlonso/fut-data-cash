class FixturesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :head_to_head ]

  def head_to_head
    team_one_id = params[:fixture][:team_one_id]
    team_two_id = params[:fixture][:team_two_id]
    return redirect_back fallback_location: root_path, alert: 'Ambos os times devem ser selecionados' unless team_one_id.present? && team_two_id.present?

    @team_one = Team.find_by(id: team_one_id)
    @team_two = Team.find_by(id: team_two_id)
    return redirect_back fallback_location: root_path, alert: 'Time não encontrado em nossa base de dados' unless @team_one.present? && @team_two.present?

    client = ::FootballApi::Client.new
    @head_to_head = client.fetch_head_to_head(@team_one, @team_two, 10)

    @metrics = process_head_to_head_info
    render turbo_stream: turbo_stream.replace("head_to_head",
                                              partial: 'fixtures/head_to_head',
                                              locals: { team_one: @team_one, team_two: @team_two, metrics: @metrics })
  end

  private

  def process_head_to_head_info
    team_one_fixtures = @head_to_head.select { |fixture| fixture.dig('teams', 'home', 'id') == @team_one.external_id } || []
    team_two_fixtures = @head_to_head.select { |fixture| fixture.dig('teams', 'home', 'id') == @team_two.external_id } || []
    team_one_goals_home = team_one_fixtures.sum { |fixture| fixture.dig('goals', 'home') }
    team_two_goals_home = team_two_fixtures.sum { |fixture| fixture.dig('goals', 'home') }
    team_one_goals_away = team_two_fixtures.sum { |fixture| fixture.dig('goals', 'away') }
    team_two_goals_away = team_one_fixtures.sum { |fixture| fixture.dig('goals', 'away') }
    team_one_victories_home = team_one_fixtures.count { |fixture| fixture.dig('teams', 'home', 'winner') } || 0
    team_two_victories_home = team_two_fixtures.count { |fixture| fixture.dig('teams', 'home', 'winner') } || 0
    team_one_victories_away = team_one_fixtures.count { |fixture| fixture.dig('teams', 'away', 'winner') } || 0
    team_two_victories_away = team_two_fixtures.count { |fixture| fixture.dig('teams', 'away', 'winner') } || 0
    team_one_draws_home = team_one_fixtures.count { |fixture| fixture.dig('teams', 'home', 'winner') == fixture.dig('teams', 'away', 'winner') } || 0
    team_two_draws_home = team_two_fixtures.count { |fixture| fixture.dig('teams', 'home', 'winner') == fixture.dig('teams', 'away', 'winner') } || 0
    team_one_turnovers_home = count_turnovers(team_one_fixtures, 'home')
    team_two_turnovers_home = count_turnovers(team_two_fixtures, 'home')
    team_one_turnovers_away = count_turnovers(team_one_fixtures, 'away')
    team_two_turnovers_away = count_turnovers(team_two_fixtures, 'away')

    {
      team_one_victories: team_one_victories_home + team_one_victories_away,
      team_one_victories_home: team_one_victories_home,
      team_one_victories_away: team_one_victories_away,
      team_one_draws_home: team_one_draws_home,
      team_one_goals: team_one_goals_home + team_one_goals_away,
      team_one_goals_home: team_one_goals_home,
      team_one_goals_away: team_one_goals_away,
      team_one_turnovers: team_one_turnovers_home + team_one_turnovers_away,
      team_one_turnovers_home: team_one_turnovers_home,
      team_one_turnovers_away: team_one_turnovers_away,
      team_two_victories: team_two_victories_home + team_two_victories_away,
      team_two_victories_home: team_two_victories_home,
      team_two_victories_away: team_two_victories_away,
      team_two_draws_home: team_two_draws_home,
      team_two_goals: team_two_goals_home + team_two_goals_away,
      team_two_goals_home: team_two_goals_home,
      team_two_goals_away: team_two_goals_away,
      team_two_turnovers: team_two_turnovers_home + team_two_turnovers_away,
      team_two_turnovers_home: team_two_turnovers_home,
      team_two_turnovers_away: team_two_turnovers_away,
    }
  end

  def count_turnovers(fixtures, home_or_away)
    fixtures.count do |fixture|
      halftime_home_score = fixture.dig('score', 'halftime', 'home')
      halftime_away_score = fixture.dig('score', 'halftime', 'away')
      next false if halftime_away_score == halftime_home_score # empate no primeiro tempo, não dá pra calcular virada com stats existentes
      halftime_winner = halftime_home_score > halftime_away_score ? 'home' : 'away'

      fulltime_home_score = fixture.dig('score', 'fulltime', 'home')
      fulltime_away_score = fixture.dig('score', 'fulltime', 'away')
      next false if fulltime_away_score == fulltime_home_score # empate no segundo tempo, não houve virada
      fulltime_winner = halftime_home_score > halftime_away_score ? 'home' : 'away'

      halftime_winner != fulltime_winner && fulltime_winner == home_or_away
    end
  end
end
