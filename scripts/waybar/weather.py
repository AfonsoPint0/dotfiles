import json
import requests

def get_weather_icon(weather_id: int) -> str:
    match weather_id:
        case id if 200 <= id <= 232:
            return ""
        case id if 300 <= id <= 321:
            return ""
        case id if 500 <= id <= 504:
            return ""
        case 511:
            return ""
        case id if 520 <= id <= 531:
            return ""
        case id if 600 <= id <= 622:
            return ""
        case id if 700 <= id <= 781:
            return ""  
        case 800:
            return ""
        case 801:
            return ""
        case 802:
            return ""
        case 803:
            return ""
        case 804:
            return ""
        case _:
            return ""

API_KEY = '00a3eb5d0edd8a003aa73d68dc866be3'  # <- Replace this with your real API key
CITY = 'Lisbon'
URL = f'http://api.openweathermap.org/data/2.5/weather?q={CITY}&appid={API_KEY}&units=metric'

response = requests.get(URL)

if(response.status_code == 200):
    data = response.json()
   
    icon = get_weather_icon(data['weather'][0]['id'])

    

    result = { 
              "text" : f'{icon} {round(data['main']['temp'])} ºC', 
              "tooltip" : "aaa",
              "class" : "aaa"
              }

    result = {
        "text": f"{icon} {round(data['main']['temp'])} ºC",
        "tooltip": f"tool",
        "class": "time"
    }

    print(json.dumps(result))

else:
    print(response.status_code)
