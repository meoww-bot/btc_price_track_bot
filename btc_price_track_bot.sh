#!/bin/bash
TOKEN="BOT TOKEN HERE"
CHAT_ID="CHANNEL OR GROUP ID"
sad_emoji="😞"
happy_emoji="😄"

LOW_PRICE=7050 # if usd price lower than $LOW_PRICE, a sad emoji would append to text
HIGH_PRICE=9000 # if usd price greater than $HIGH_PRICE, a happy emoji would append to text

blockchain_ticker=$(curl -s https://blockchain.info/ticker)
blockchain_usd_price=$(echo $blockchain_ticker |  jq -r '.USD["15m"]')
blockchain_cny_price=$(echo $blockchain_ticker |  jq -r '.CNY["15m"]')
blockchain_usdt_price=$(echo "scale=4;$blockchain_cny_price / $blockchain_usd_price" |bc  -l)

#coincola_in_market_ticker=$(curl -s 'https://www.coincola.com/api/exchange/market/ticker/list' --data 'currency=USDT' | jq -r '.data["tickers"][0]["price"]')
#coincola_out_market_price=$(curl -s 'https://www.coincola.com/api/v2/contentslist/list' --compressed -H 'Content-Type: application/x-www-form-urlencoded'  --data 'limit=1&offset=0&sort_order=GENERAL&country_code=CN&crypto_currency=BTC&currency=&type=SELL&payment_provider=' |jq -r '.data["advertisements"][0]["price"]')
#coincola_premium_rate=$(echo "scale=4;$coincola_out_market_price/$blockchain_cny_price*100-100" | bc)
#coincola_per_usd_price=$(echo "scale=4;$coincola_out_market_price/$blockchain_usd_price" | bc)

#coincola_usdt_resp=$(curl -s 'https://www.coincola.com/api/v2/contentslist/list' --compressed -H 'Content-Type: application/x-www-form-urlencoded'  --data 'limit=1&offset=0&sort_order=GENERAL&country_code=CN&crypto_currency=USDT&currency=&type=SELL&payment_provider=' | jq -r '.')
#coincola_usdt_price=$(echo $coincola_usdt_resp | jq -r '.data["advertisements"][0]["price"]')
#coincola_usdt_min_amt=$(echo $coincola_usdt_resp | jq -r '.data["advertisements"][0]["min_amount"]')
#coincola_usdt_max_amt=$(echo $coincola_usdt_resp | jq -r '.data["advertisements"][0]["max_amount"]')

huobi_cny_price=$(curl -s "https://otc-api.eiijo.cn/v1/data/trade-market?coinId=1&currency=1&tradeType=sell&currPage=1&payMethod=0&country=37&blockType=general&online=1&range=0&amount=" | jq -r '.data[0]["price"]')
huobi_ticker=$(curl -s  "https://api.huobi.pro/market/detail/merged?symbol=btcusdt" | jq -r '.["tick"]')
huobi_ask_price=$(echo $huobi_ticker | jq -r '.["ask"][0]')
huobi_bid_price=$(echo $huobi_ticker | jq -r '.["bid"][0]')
huobi_close_price=$(echo $huobi_ticker | jq -r '.["close"]')

huobi_per_usd_price=$(echo "scale=4;$huobi_cny_price/$huobi_close_price" | bc)

# huobi_last_market_trade_resp=$(curl -s "https://api.huobi.pro/market/trade?symbol=btcusdt" | jq -r '.["tick"]["data"][0]')
# huobi_last_market_trade_price=$(echo $huobi_last_market_trade_resp| jq -r '.["price"]')
# huobi_last_market_trade_amount=$(echo $huobi_last_market_trade_resp| jq -r '.["amount"]')

huobi_premium_rate=$(echo "scale=4;$huobi_cny_price/$blockchain_cny_price*100-100"| bc)

#huobi_usdt_price_resp=$(curl -s "https://otc-api.eiijo.cn/v1/data/trade-market?coinId=2&currency=1&tradeType=sell&currPage=1&payMethod=0&country=37&blockType=general&online=1&range=0&amount=" | jq -r '.data[0]')
huobi_usdt_price_resp=$(curl -s 'https://otc-api-sz.eiijo.cn/v1/data/trade-market?coinId=2&currency=1&tradeType=sell&currPage=1&payMethod=2&country=37&blockType=general&online=1&range=0&amount=' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:69.0) Gecko/20100101 Firefox/69.0' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2' --compressed -H 'otc-language: zh-CN' -H 'token: rSMzy6u1st-BO0r3ahEkK6CfRxYnBDWic3Afm_q_n8MY-uOP2m0-gvjE57ad1qDF' -H 'uid: 0' -H 'trace_id: e1cf3fea-1f8f-4088-87f8-a227fb3486de' -H 'portal: web' -H 'X-Requested-With: XMLHttpRequest' -H 'fingerprint: undefined' -H 'Origin: https://c2c.huobi.io' -H 'Connection: keep-alive' -H 'Referer: https://c2c.huobi.io/zh-cn/trade/buy-usdt/' -H 'Cookie: acw_tc=784e2ca215840141665556541e5be54cc22beeeaaf225608f26a66d5e9132e' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'TE: Trailers'|jq -r '.data[0]')

huobi_usdt_price=$(echo $huobi_usdt_price_resp | jq -r '.["price"]')
huobi_usdt_min_amt=$(echo $huobi_usdt_price_resp | jq -r '.["minTradeLimit"]')
huobi_usdt_max_amt=$(echo $huobi_usdt_price_resp | jq -r '.["maxTradeLimit"]')



TEXT="=== BlockChain ===\n场内: <b>\$$blockchain_usd_price</b> , ¥$blockchain_cny_price"

#if (( $(echo "$blockchain_usd_price > $HIGH_PRICE" |bc -l) )); then
#    TEXT=$TEXT$happy_emoji
#fi

#if (( $(echo "$blockchain_usd_price < $LOW_PRICE" |bc -l) )); then
#    TEXT=$TEXT$sad_emoji
#fi

TEXT=$TEXT"\n折合 USD 单价: $blockchain_usdt_price"

#TEXT=$TEXT"\n\n=== CoinCola ==="
# \n相对bc溢价率: $coincola_premium_rate%
#TEXT=$TEXT"\n场内(币币): <b>\$$coincola_in_market_ticker</b>\n场外(法币): ¥$coincola_out_market_price\n折合USDT单价: $coincola_per_usd_price"
#TEXT=$TEXT"\n场外USDT: $coincola_usdt_price (¥$coincola_usdt_min_amt - ¥$coincola_usdt_max_amt)"
# \n相对blockchain溢价率: $huobi_premium_rate%
TEXT=$TEXT"\n\n=== Huobi ==="
TEXT=$TEXT"\n场内(币币): <b>\$$huobi_close_price</b>\n场外(法币): ¥$huobi_cny_price\n折合USDT单价: $huobi_per_usd_price"
TEXT=$TEXT"\n场外USDT: $huobi_usdt_price (¥$huobi_usdt_min_amt - ¥$huobi_usdt_max_amt)"

# alert
# if (( $(echo "$coincola_in_market_ticker < 6000" |bc -l) )); then
#     python /home/ubuntu/call.py
# fi


echo -e $TEXT | curl -G --data-urlencode text@- "https://api.telegram.org/bot$TOKEN/sendMessage?chat_id=$CHAT_ID&parse_mode=HTML"
#curl "https://api.telegram.org/bot$TOKEN/sendMessage?chat_id=$CHAT_ID&disable_web_page_preview=1&text=$TEXT"
