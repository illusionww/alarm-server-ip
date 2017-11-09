#!/usr/bin/env bash
current_dir="$(dirname $0)"

echo "$(cat README.md)"
echo

echo "Checking requirements..."
pip3 install -r ./requirements.txt
echo

file=config.json
if [ -f "$file" ]; then
    read -p "Config already exists. Want to replace it with new one (Y/n)? " yn_replace_config
else
    echo "Config does not exist"
    yn_replace_config = "Y"
fi

if [ "$yn_replace_config" == "Y" ]; then
    echo "Please answer some questions to generate config"
    while true; do
        echo "Your server name (for message only):"
        read server_name
        echo "Your Alarmer API key (https://alarmerbot.ru/):"
        read api_key
        read -p "    server_name = $server_name
    api_key = $api_key
Are your information right (Y/n)? " yn_config_right
        if [ "$yn_config_right" == "Y" ]; then
            break;
        fi
    done
    echo "Ok, now generate config json..."
    echo "{\"server_name\": \"$server_name\", \"api_key\": \"$api_key\"}" > config.json
fi

read -p "Are you want to add script to cron (Y/n)? " yn_add_to_cron
if [ "$yn_add_to_cron" == "Y" ]; then
    while true; do
        echo "Please write cron like this
* * * * *
- - - - -
| | | | |
| | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
| | | ------- Month (1 - 12)
| | --------- Day of month (1 - 31)
| ----------- Hour (0 - 23)
------------- Minute (0 - 59)"
        read cron_string
        read -p "Line
$cron_string python3 $current_dir/alarm_my_ip.py
will be added to crontab. Continue (Y/n)? " yn_cronstring_right
        if [ "$yn_cronstring_right" == "Y" ]; then
            crontab -l > mycron
            echo "$cron_string $current_dir/run.sh"  >> mycron
            crontab mycron
            rm mycron
            break;
        fi
    done
fi
echo "Done!"