#!/usr/bin/python
# -*- coding: utf-8 -*-

# this script gets the CEX balance and calculates the value in BRL
# using the latest value from mercadobitcoin and send a pushover
# notification to your device.

import cexapi # you can find cexapi here: https://github.com/matveyco/cex.io-api-python
import requests
import json

username = ""
api_key = ""
api_secret = ""
pushover_token = ""
pushover_user_token = ""

cex_account = cexapi.API(username, api_key, api_secret)
my_balance = cex_account.balance()["BTC"]["available"]

#mercadobitcoin_get = requests.get("http://www.mercadobitcoin.com.br/api/ticker")
#bitcoin_raw = mercadobitcoin_get.content
#bitcoin = json.loads(bitcoin_raw)["ticker"]["last"]
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

exit
