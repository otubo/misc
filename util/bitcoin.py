#!/usr/bin/python
# -*- coding: utf-8 -*-

# this script gets the CEX balance and calculates the value in BRL
# using the latest value from mercadobitcoin and send a pushover
# notification to your device.

import cexapi # you can find cexapi here: https://github.com/matveyco/cex.io-api-python
import requests
import json

username = "CEX username"
api_key = "CEX api key"
api_secret = "CEX api secret"
pushover_token = "Pushover token"
pushover_user_token = "Pushover user token"

cex_account = cexapi.api(username, api_key, api_secret)
balance = cex_account.balance()["BTC"]["available"]

mercadobitcoin_get = requests.get("http://www.mercadobitcoin.com.br/api/ticker")
bitcoin_raw = mercadobitcoin_get.content
bitcoin = json.loads(bitcoin_raw)["ticker"]["last"]

valor_em_reais = "%.2f" % (float(bitcoin) * float(balance))

message = "Hello master, your balance is R$" + str(valor_em_reais)

pushover_url='https://api.pushover.net/1/messages.json'
data= {
    'token': pushover_token,
    'user': pushover_user_token,
    'message': message
}

requests.post(pushover_url, data=data)

exit
