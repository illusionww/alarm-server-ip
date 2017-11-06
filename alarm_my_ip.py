import json

import ipgetter
import requests

with open('config.json') as f:
    config = json.load(f)

ip = ipgetter.myip()
requests.post('https://alarmerbot.ru/', data={
    'key': config['api_key'],
    'message': '{}\'s IP is: {}'.format(config['server_name'], ip)
})
