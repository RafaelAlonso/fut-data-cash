class FixtureStat < ApplicationRecord
  belongs_to :fixture
  belongs_to :team

  enum status: {
    win: 0,
    draw: 1,
    loss: 2,
  }

  FixtureStat.includes(:fixture).all.each do |fs|
    home_or_away = fs.fixture.home_team == fs.team ? 'home' : 'away'
    goals_made = home_or_away == 'home' ? fs.fixture.home_score : fs.fixture.away_score
    goals_suffered = home_or_away == 'home' ? fs.fixture.away_score : fs.fixture.home_score
    fixture_status = 'draw' if goals_made == goals_suffered
    fixture_status ||= goals_made > goals_suffered ? 'win' : 'loss'
    fs.update(status: fixture_status)
  end
end
