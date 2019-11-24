# btc_price_track_bot

A simple shell script for telegram bot to get lastest btc price, then sent it to telegram channel.

## setup

Replace bot token and the id of the chat where you want to send the price message, chat can be group or channel or user.

```sh
TOKEN="BOT TOKEN HERE"
CHAT_ID="CHANNEL OR GROUP ID"
```
You can also use channel username in this kind of format `@channelusername`.But I suggest using id cause id is not changable.

>Tip: How to get channel id?  
>Send a message on behalf of the channel, forward it to [@userinfobot](https://t.me/userinfobot), then the bot will show you the channel id.

## configure crontab

Use system crontab to determine the interval of message sending.

For exmaple, on Debian,edit the crontab file:  
```
vim /etc/crontab
```
content:
```
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user	command
*/1 *  *   *   *   root  bash /path/to/btc_price_track_bot.sh
```
`*/1 *  *   *   * ` means the interval is 1min.
