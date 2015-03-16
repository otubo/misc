#!/usr/bin/python
# -*- coding: utf-8 -*-
import requests
import json
from requests.auth import HTTPBasicAuth

user = ""
api_key = ""
url = "" % user
pushover_token = ""
pushover_user_token = ""

my_info = requests.get(url, auth=HTTPBasicAuth(user, api_key)).content
my_balance = json.loads(my_info)["balances"]["BTC"]

current_price = requests.get('https://blockchain.info/ticker')
current_price_in_euro =  json.loads(current_price.content)["EUR"]["last"]

value_in_euro = "%.10f" % (float(my_balance) * float(current_price_in_euro))

message = "€" + str(value_in_euro)

pushover_url='https://api.pushover.net/1/messages.json'
data= {
    'token': pushover_token,
    'user': pushover_user_token,
    'message': message
}

requests.post(pushover_url, data=data)
