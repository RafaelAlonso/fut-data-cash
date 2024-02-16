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
  end
end
