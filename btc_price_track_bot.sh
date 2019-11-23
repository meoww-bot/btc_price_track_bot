#!/bin/bash
TOKEN="BOT TOKEN HERE"
CHAT_ID="CHANNEL OR GROUP ID"
sad_emoji="😞"
happy_emoji="😄"
LOW_PRICE=7050
HIGH_PRICE=9000
res=$(curl -s https://blockchain.info/ticker)
usd_price=$(echo $res |  jq -r '.USD["15m"]')
cny_price=$(echo $res |  jq -r '.CNY["15m"]')
TEXT="1 BTC = \$$usd_price = ¥$cny_price"
if (( $(echo "$usd_price < $LOW_PRICE" |bc -l) )); then
    TEXT=$TEXT$sad_emoji
fi

if (( $(echo "$usd_price > $HIGH_PRICE" |bc -l) )); then
    TEXT=$TEXT$happy_emoji
fi
curl "https://api.telegram.org/bot$TOKEN/sendMessage?chat_id=$CHAT_ID&disable_web_page_preview=1&text=$TEXT"
