import requests
import ipgetter

ip = ipgetter.myip()
requests.post('https://alarmerbot.ru/', data={
    'key': '892d3f-68a710-b8344a',
    'message': 'Buhanka\'s IP is: {}'.format(ip)
})