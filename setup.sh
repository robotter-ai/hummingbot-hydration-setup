#!/bin/bash
set -e

function init() {
	clear

	echo "Initializing Hydration + Hummingbot setup..."

	echo
	echo "Pulling latest docker images"
	docker pull robotterlabs/hummingbot:latest
	docker pull robotterlabs/gateway:latest

	# Check if the volumes folder already exists in the current directory
	if [ ! -d "volumes" ]; then
		# Define a temporary directory for cloning
		echo
		HB_CLIENT_TEMP_DIR=$(mktemp -d)
		echo "Cloning Hummingbot Client repository into a temporary folder: $HB_CLIENT_TEMP_DIR"
		git clone --depth 1 --branch feat/hydration --single-branch https://github.com/robotter-ai/hummingbot.git "$HB_CLIENT_TEMP_DIR/hummingbot"

		HB_GATEWAY_TEMP_DIR=$(mktemp -d)
		echo "Cloning Gateway repository into a temporary folder: $HB_GATEWAY_TEMP_DIR"
		git clone --depth 1 --branch feat/hydration --single-branch https://github.com/robotter-ai/gateway.git "$HB_GATEWAY_TEMP_DIR/gateway"

		echo
		echo "Creating volumes folder structure..."

		mkdir -p volumes/common/certs

		# Create directories for hummingbot
		mkdir -p volumes/client/conf
		mkdir -p volumes/client/conf/connectors
		mkdir -p volumes/client/conf/strategies
		mkdir -p volumes/client/conf/controllers
		mkdir -p volumes/client/conf/scripts
		mkdir -p volumes/client/logs
		mkdir -p volumes/client/data
		mkdir -p volumes/client/scripts
		mkdir -p volumes/client/controllers

		# Create directories for gateway
		mkdir -p volumes/gateway/conf
		mkdir -p volumes/gateway/logs

		echo
		echo "Copying configuration folders from the cloned Hummingbot Client repository..."
		# Copy folders from the cloned repo to volumes/client
		cp -r "$HB_CLIENT_TEMP_DIR/hummingbot/conf" volumes/client/
		cp -r "$HB_CLIENT_TEMP_DIR/hummingbot/scripts" volumes/client/
		cp -r "$HB_CLIENT_TEMP_DIR/hummingbot/controllers" volumes/client/

		echo
		echo "Copying configuration folders from the cloned Gateway repository..."
		# Copy folders from the cloned repo to volumes/gateway
		cp -r "$HB_GATEWAY_TEMP_DIR/gateway/src/templates" volumes/gateway/conf

		chmod -R 777 volumes

		echo "Folder structure and files copied."
	else
		echo "Folder 'volumes' already exists. Skipping repository copy."
	fi

	# Clean up the temporary directory
	rm -rf "$HB_CLIENT_TEMP_DIR"
	rm -rf "$HB_GATEWAY_TEMP_DIR"
}

function create_hummingbot() {
	echo
	echo "Starting hummingbot container..."
	GATEWAY_PASSPHRASE="" docker compose up -d hummingbot
}

function create_gateway() {
	echo
	echo "Starting gateway container..."
	echo
	echo "If you have already generated your GATEWAY_PASSPHRASE using the 'gateway generate-certs' command inside of the Hummingbot Client, enter it below:"
	read -s -p "Enter your gateway passphrase: " gateway_passphrase
	echo
	GATEWAY_PASSPHRASE="$gateway_passphrase" docker compose up -d gateway
	docker logs -f gateway
}

# Main logic to handle script arguments
case "$1" in
	hummingbot)
		init
		create_hummingbot
		;;
	gateway)
		create_gateway
		;;
	*)
		echo "Usage: $0 {hummingbot|gateway}"
		exit 1
		;;
esac

set +e
