#!/bin/bash
TOKEN="BOT TOKEN HERE"
CHAT_ID="CHANNEL OR GROUP ID"
sad_emoji="😞"
happy_emoji="😄"
LOW_PRICE=7050 # if usd price lower than $LOW_PRICE, a sad emoji would append to text
HIGH_PRICE=9000 # if usd price greater than $HIGH_PRICE, a happy emoji would append to text

res=$(curl -s https://blockchain.info/ticker)
usd_price=$(echo $res |  jq -r '.USD["15m"]')
cny_price=$(echo $res |  jq -r '.CNY["15m"]')

coincola_price=$(curl -s 'https://www.coincola.com/api/v2/contentslist/list' --compressed -H 'Content-Type: application/x-www-form-urlencoded'  --data 'limit=1&offset=0&sort_order=GENERAL&country_code=CN&crypto_currency=BTC&currency=&type=SELL&payment_provider=' |jq -r '.data["advertisements"][0]["price"]')
huobi_price=$(curl -s "https://otc-api.eiijo.cn/v1/data/trade-market?coinId=1&currency=1&tradeType=sell&currPage=1&payMethod=0&country=37&blockType=general&online=1&range=0&amount=" | jq -r '.data[0]["price"]')

#TEXT="BTC Price Monitor \nblockchain: \$$usd_price = ¥$cny_price \ncoincola:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t ¥$coincola_price \nhuobi:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t ¥$huobi_price"

coincola_premium=$(echo "scale=4;$coincola_price/$cny_price*100-100" | bc)
huobi_premium=$(echo "scale=4;$huobi_price/$cny_price*100-100"| bc)

TEXT="1 BTC = \$$usd_price = ¥$cny_price \n= ¥$coincola_price(coincola,$coincola_premium%) \n= ¥$huobi_price(huobi,$huobi_premium%)"


if (( $(echo "$usd_price < $LOW_PRICE" |bc -l) )); then
    TEXT=$TEXT$sad_emoji
fi

if (( $(echo "$usd_price > $HIGH_PRICE" |bc -l) )); then
    TEXT=$TEXT$happy_emoji
fi

echo -e $TEXT | curl -G --data-urlencode text@- "https://api.telegram.org/bot$TOKEN/sendMessage?chat_id=$CHAT_ID"
#curl "https://api.telegram.org/bot$TOKEN/sendMessage?chat_id=$CHAT_ID&disable_web_page_preview=1&text=$TEXT"
