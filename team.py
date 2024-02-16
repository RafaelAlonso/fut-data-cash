def search_team(query):
    '''Look for a given team. If multiple options are returned,
    have the user choose between them. Return one team (or None)'''

    url = BASE_URI + '/search'
    headers = {'X-Auth-Token': 'YOUR_API_KEY'}  # Replace with your API key
    teams = requests.get(url, headers=headers, params={'query': query}).json()

    if len(teams) == 1:
        team = teams[0]
        return team

    if len(teams) > 1:
        for i, team in enumerate(teams):
            print(f"{i+1}. {team['name']}")
        team_index = int(input("Multiple matches found, which team did you mean?\n> "))
        team = teams[team_index - 1]
        return team

    return None

def main():
    '''Ask user for a team and display team information'''
    query = input("Team?\n> ")
    team = search_team(query)

    if not team:
        print(f"Sorry, the API doesn't know about {query}...")
    else:
        print(f"Here's the information for {team['name']}:")

        # Display team information
        print(f"Name: {team['name']}")
        print(f"Country: {team['area']['name']}")  # Assuming 'area' contains the country information
        print(f"State: {team['area']['state']}")  # Assuming 'area' contains the state information
        print(f"Year of Foundation: {team['founded']}")  # Assuming 'founded' contains the year of foundation

if __name__ == '__main__':
    try:
        while True:
            main()
    except KeyboardInterrupt:
        print('\nGoodbye!')
        sys.exit(0)



# Get the logo of a team --> call: https://media.api-sports.io/football/teams/{team_id}.png
# Teams ids --> https://dashboard.api-football.com/soccer/ids/teams


import requests

def get_data(endpoint, league, season, api_key):
    url = f'https://v3.football.api-sports.io/{endpoint}?league={league}&season={season}'
    headers = {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key': api_key
    }

    response = requests.get(url, headers=headers)
    return response.text

# Usage
league = 39  # You can change this value
season = 2021  # You can change this value
api_key = 'XxXxXxXxXxXxXxXxXxXxXxXx'  # Replace with your actual API key

print(get_data('players', league, season, api_key))
