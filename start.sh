#!/bin/bash
set -e

# Universal startup script for both Home Assistant addon and plain Docker deployment
#
# Detection logic:
# - If /data/options.json exists -> Home Assistant addon mode
# - Otherwise -> Plain Docker mode (reads from environment variables)

CONFIG_PATH="/data/options.json"


# Function to extract JSON values using jq
get_config_value() {
    local key=$1
    jq -r --arg k "$key" '.[$k] // empty' "$CONFIG_PATH" 2>/dev/null || echo ""
}

# Detect deployment mode and set environment variables accordingly
if [ -f "$CONFIG_PATH" ]; then
    # Home Assistant addon mode
    echo "Starting in Home Assistant addon mode..."

    BOT_TOKEN=$(get_config_value "BOT_TOKEN")
    export BOT_TOKEN
    MQTT_URL=$(get_config_value "MQTT_URL")
    export MQTT_URL
    MQTT_PORT=$(get_config_value "MQTT_PORT")
    export MQTT_PORT
    MQTT_USERNAME=$(get_config_value "MQTT_USERNAME")
    export MQTT_USERNAME
    MQTT_PASSWORD=$(get_config_value "MQTT_PASSWORD")
    export MQTT_PASSWORD
    TOPIC_DISCOVERY=$(get_config_value "TOPIC_DISCOVERY")
    export TOPIC_DISCOVERY
    TOPIC_BOT=$(get_config_value "TOPIC_BOT")
    export TOPIC_BOT
    GUILD_ID=$(get_config_value "GUILD_ID")
    export GUILD_ID
    YOUR_ID=$(get_config_value "YOUR_ID")
    export YOUR_ID
    BOT_ID=$(get_config_value "BOT_ID")
    export BOT_ID
    MQTT_CLIENT_ID=$(get_config_value "MQTT_CLIENT_ID")
    export MQTT_CLIENT_ID
    BOT_ACTIVITY=$(get_config_value "BOT_ACTIVITY")
    export BOT_ACTIVITY
    BOT_NICKNAME=$(get_config_value "BOT_NICKNAME")
    export BOT_NICKNAME
else
    # Plain Docker mode - environment variables already set by docker run -e flags
    echo "Starting in plain Docker mode..."

    # Validate that required environment variables are set
    required_vars=(BOT_TOKEN MQTT_URL MQTT_USERNAME MQTT_PASSWORD GUILD_ID YOUR_ID BOT_ID TOPIC_BOT)
    missing_vars=()

    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            missing_vars+=("$var")
        fi
    done

    if [ ${#missing_vars[@]} -gt 0 ]; then
        echo "ERROR: The following required environment variables are not set:"
        printf '  - %s\n' "${missing_vars[@]}"
        echo ""
        echo "Required environment variables:"
        echo "  - BOT_TOKEN"
        echo "  - MQTT_URL"
        echo "  - MQTT_USERNAME"
        echo "  - MQTT_PASSWORD"
        echo "  - GUILD_ID"
        echo "  - YOUR_ID"
        echo "  - BOT_ID"
        echo "  - TOPIC_BOT"
        echo ""
        echo "Optional environment variables (with defaults):"
        echo "  - MQTT_PORT (default: 1883)"
        echo "  - TOPIC_DISCOVERY (default: homeassistant)"
        echo "  - MQTT_CLIENT_ID (default: discordbot_docker_1)"
        echo "  - BOT_ACTIVITY (default: 🏠 Watching the house)"
        echo "  - BOT_NICKNAME (default: Caduceus)"
        exit 1
    fi

    # Set defaults for optional variables if not provided
    export MQTT_PORT="${MQTT_PORT:-1883}"
    export TOPIC_DISCOVERY="${TOPIC_DISCOVERY:-homeassistant}"
    export MQTT_CLIENT_ID="${MQTT_CLIENT_ID:-discordbot_docker_1}"
    export BOT_ACTIVITY="${BOT_ACTIVITY:-🏠 Watching the house}"
    export BOT_NICKNAME="${BOT_NICKNAME:-Caduceus}"
fi

# Start the application
echo "Starting Discord bot application..."
exec bun run /app/dist/index.js
