require 'uri'
require 'net/http'
require 'openssl'

module FootballApi
  class Client
    BASE_URL = "https://v3.football.api-sports.io/".freeze

    def api_request(path, params = {})
      url = URI(BASE_URL + path)
      url.query = URI.encode_www_form(params)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-host"] = 'v3.football.api-sports.io'
      request["x-rapidapi-key"] = ENV['FOOTBALL_API_KEY']

      response = http.request(request)
      if response.code == '200'
        JSON.parse(response.body)
      else
        { error: 'Unable to complete request', status_code: response.code }
      end
    end

    def fetch_teams
      response = api_request('/teams', { country: 'Brazil' })
    end

    def fetch_head_to_head(home_team, away_team, n_matches = 5)
      params = {
        h2h: "#{home_team.external_id}-#{away_team.external_id}",
        last: n_matches
      }
      response = api_request('/fixtures/headtohead', params)
      response['response']
    end

    def fetch_team_fixture_stats(team, fixture)
      params = {
        team: team.external_id,
        fixture: fixture.fixture_id
      }
      response = api_request('/fixtures/statistics', params)
      response['response']
    end
  end
end
