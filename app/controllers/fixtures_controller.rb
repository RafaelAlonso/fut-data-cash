class FixturesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :head_to_head ]

  def head_to_head
    team_one_id = params[:fixture][:team_one_id]
    team_two_id = params[:fixture][:team_two_id]
    return redirect_back fallback_location: root_path, alert: 'Ambos os times devem ser selecionados' unless team_one_id.present? && team_two_id.present?

    @team_one = Team.find_by(id: team_one_id)
    @team_two = Team.find_by(id: team_two_id)
    return redirect_back fallback_location: root_path, alert: 'Time não encontrado em nossa base de dados' unless @team_one.present? && @team_two.present?

    @fixtures = build_fixtures
    @fixture_stats = build_fixture_stats
    @team_one_fixture_stats = FixtureStat.where(team: @team_one, id: @fixture_stats.map(&:id)).includes(:fixture)
    @team_two_fixture_stats = FixtureStat.where(team: @team_two, id: @fixture_stats.map(&:id)).includes(:fixture)
    render turbo_stream: turbo_stream.replace("head_to_head",
                                              partial: 'fixtures/head_to_head',
                                              locals: {
                                                team_one: @team_one,
                                                team_two: @team_two,
                                                fixture_stats: @fixture_stats,
                                                team_one_fixture_stats: @team_one_fixture_stats.sort_by { |fs| fs.fixture.date_time },
                                                team_two_fixture_stats: @team_two_fixture_stats.sort_by { |fs| fs.fixture.date_time }
                                              })
  end

  private

  def client
    client ||= ::FootballApi::Client.new
  end

  def build_fixtures
    existing_fixtures = Fixture.where(home_team: [@team_one, @team_two], away_team: [@team_one, @team_two])
    return existing_fixtures if existing_fixtures.count >= 10

    head_to_head = client.fetch_head_to_head(@team_one, @team_two, 10)
    head_to_head.map do |fixture|
      existing_fixture = Fixture.find_by(fixture_id: fixture.dig('fixture', 'id'))
      next existing_fixture if existing_fixture.present?

      home_team = [@team_one, @team_two].find { |team| team.external_id == fixture.dig('teams', 'home', 'id') }
      away_team = ([@team_one, @team_two] - [home_team]).first
      home_score = fixture.dig('goals', 'home')
      away_score = fixture.dig('goals', 'away')
      date_time = fixture.dig('fixture', 'date')
      season = fixture.dig('league', 'swason')
      turnover = check_fixture_turnover(fixture)
      Fixture.create!(
        fixture_id: fixture.dig('fixture', 'id'),
        status: fixture.dig('status', 'long'),
        home_team:,
        away_team:,
        date_time:,
        home_score:,
        away_score:,
        season:,
        turnover:
      )
    end
  end

  def build_fixture_stats
    fixture_stats = []
    @fixtures.each do |fixture|
      [@team_one, @team_two].each do |team|
        existing_stat = FixtureStat.find_by(team: team, fixture: fixture)
        fixture_stats << existing_stat and next if existing_stat.present?

        team_fixture_stats = client.fetch_team_fixture_stats(team, fixture)
        team_fixture_stats.each do |fixture_stat|
          home_or_away = fixture.home_team == team ? 'home' : 'away'
          goals_made = home_or_away == 'home' ? fixture.home_score : fixture.away_score
          goals_suffered = home_or_away == 'home' ? fixture.away_score : fixture.home_score
          fixture_status = 'draw' if goals_made == goals_suffered
          fixture_status ||= goals_made > goals_suffered ? 'win' : 'loss'
          fixture_stats << FixtureStat.create(
            fixture: fixture,
            team: team,
            home_or_away: home_or_away,
            status: fixture_status,
            goals_made: goals_made,
            goals_suffered: goals_suffered,
            shots_on_goal: get_stat_value(fixture_stat, 'Shots on Goal'),
            shots_off_goal: get_stat_value(fixture_stat, 'Shots off Goal'),
            shots_insidebox: get_stat_value(fixture_stat, 'Total Shots'),
            shots_outsidebox: get_stat_value(fixture_stat, 'Blocked Shots'),
            total_shots: get_stat_value(fixture_stat, 'Shots insidebox'),
            blocked_shots: get_stat_value(fixture_stat, 'Shots outsidebox'),
            fouls: get_stat_value(fixture_stat, 'Fouls'),
            corner_kicks: get_stat_value(fixture_stat, 'Corner Kicks'),
            offsides: get_stat_value(fixture_stat, 'Offsides'),
            ball_posession: get_stat_value(fixture_stat, 'Ball Possession')&.gsub('%', '')&.to_i,
            yellow_cards: get_stat_value(fixture_stat, 'Yellow Cards'),
            red_cards: get_stat_value(fixture_stat, 'Red Cards'),
            goalkeeper_saves: get_stat_value(fixture_stat, 'Goalkeeper Saves'),
            total_passes: get_stat_value(fixture_stat, 'Total passes'),
            passes_accurate: get_stat_value(fixture_stat, 'Passes accurate'),
            passes_percentage: get_stat_value(fixture_stat, 'Passes %'),
          )
        end
      end
    end
    fixture_stats
  end

  def check_fixture_turnover(fixture)
      halftime_home_score = fixture.dig('score', 'halftime', 'home')
      halftime_away_score = fixture.dig('score', 'halftime', 'away')
      return false if halftime_away_score == halftime_home_score # empate no primeiro tempo, não dá pra calcular virada com stats existentes
      halftime_winner = halftime_home_score > halftime_away_score ? 'home' : 'away'

      fulltime_home_score = fixture.dig('score', 'fulltime', 'home')
      fulltime_away_score = fixture.dig('score', 'fulltime', 'away')
      return false if fulltime_away_score == fulltime_home_score # empate no segundo tempo, não houve virada
      fulltime_winner = halftime_home_score > halftime_away_score ? 'home' : 'away'

      halftime_winner != fulltime_winner
  end

  def get_stat_value(fixture_stat, stat)
    fixture_stat['statistics'].find { |st| st['type'] == stat }.try(:[], 'value') || 0
  end
end
