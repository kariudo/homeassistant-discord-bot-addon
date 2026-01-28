# Home Assistant Discord Bot Addon

## Overview
This addon integrates a Discord bot with Home Assistant, enabling MQTT-based communication and automatic device/entity setup.

## Features
- Discord bot integration
- MQTT communication
- Automatic Home Assistant device/entity discovery
- Customizable bot activity and nickname

## Configuration
All configuration is done via the Home Assistant addon UI. The following options are available:

| Option            | Type   | Description                          |
|-------------------|--------|--------------------------------------|
| BOT_TOKEN         | str    | Discord bot token (required)          |
| MQTT_URL          | str    | MQTT broker URL                      |
| MQTT_PORT         | int    | MQTT broker port                     |
| MQTT_USERNAME     | str    | MQTT broker username                 |
| MQTT_PASSWORD     | str    | MQTT broker password                 |
| TOPIC_DISCOVERY   | str    | MQTT discovery topic prefix           |
| TOPIC_BOT         | str    | MQTT bot topic prefix                |
| GUILD_ID          | str    | Discord guild (server) ID            |
| YOUR_ID           | str    | Your Discord user ID                 |
| BOT_ID            | str    | Discord bot application ID           |
| MQTT_CLIENT_ID    | str    | MQTT client identifier               |
| BOT_ACTIVITY      | str    | Bot activity status message          |
| BOT_NICKNAME      | str    | Bot nickname in Discord              |

## Usage
1. Install the addon via Home Assistant Supervisor.
2. Configure the required options in the addon UI.
3. Start the addon. The bot will connect to Discord and MQTT, and begin publishing discovery messages.

## Troubleshooting
- Ensure all required options are set.
- Check Home Assistant and addon logs for errors.
- Verify MQTT broker connectivity and credentials.

## Links
- [GitHub Repository](https://github.com/kariudo/homeassistant-discord-bot-addon)
- [Home Assistant Addon Docs](https://developers.home-assistant.io/docs/add-ons/configuration/)
