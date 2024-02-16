import requests


url = "https://media.api-sports.io/football/teams/"

response = requests.get(url).json()
city = response[0]
print(f"{city['name']}: ({city['lat']}, {city['lon']})")
