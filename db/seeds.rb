client = FootballApi::Client.new

teams = client.fetch_teams
db_teams_ids = Team.all.pluck(:external_id)

teams['response'].each do |team_info|
  team = team_info['team']
  next if db_teams_ids.include? team['id']

  city, state = team_info.dig('venue', 'city')&.split(', ')

  puts "Creating #{team['name']}"
  Team.create!(
    external_id: team['id'],
    name: team['name'],
    code: team['code'],
    country: team['country'],
    state: state,
    city: city,
    founded: team['founded'],
    logo_url: team['logo']
  )
end
