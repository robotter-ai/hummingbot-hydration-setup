#!/bin/bash
set -e

function init() {
	clear

	echo "Initializing HDX setup..."
	
	echo
	echo "Removing old containers and folder configurations"
	docker rm -f $(docker ps -aq) || true
	sudo rm -rf hdx || true

	# echo
	# echo "Pulling latest docker images"
	# docker pull funttastic/hydration_client
	# docker pull funttastic/hydration_gateway

	# Define a temporary directory for cloning
	echo
	TEMP_DIR=$(mktemp -d)
	echo "Cloning repository into a temporary folder: $TEMP_DIR"
	git clone --branch feat/hydration --single-branch https://github.com/robotter-ai/hummingbot.git "$TEMP_DIR/hummingbot"

	# Check if the hdx folder already exists in the current directory
	if [ ! -d "hdx" ]; then
		echo
		echo "Creating hdx folder structure..."

		mkdir -p hdx/common/certs

		# Create directories for hdx-client
		mkdir -p hdx/client/conf
		mkdir -p hdx/client/conf/connectors
		mkdir -p hdx/client/conf/strategies
		mkdir -p hdx/client/conf/controllers
		mkdir -p hdx/client/conf/scripts
		mkdir -p hdx/client/logs
		mkdir -p hdx/client/data
		mkdir -p hdx/client/scripts
		mkdir -p hdx/client/controllers

		# Create directories for hdx-gateway
		mkdir -p hdx/gateway/conf
		mkdir -p hdx/gateway/logs

		echo
		echo "Copying configuration folders from the cloned repository..."
		# Copy folders from the cloned repo to hdx/client
		cp -r "$TEMP_DIR/hummingbot/conf" hdx/client/
		cp -r "$TEMP_DIR/hummingbot/scripts" hdx/client/
		cp -r "$TEMP_DIR/hummingbot/controllers" hdx/client/

		chmod -R 777 hdx

		echo "Folder structure and files copied."
	else
		echo "Folder 'hdx' already exists. Skipping repository copy."
	fi

	# Clean up the temporary directory
	rm -rf "$TEMP_DIR"
}

function create_hdx_client() {
	echo
	echo "Starting hdx-client container..."
	docker compose up -d hdx-client
}

function create_hdx_gateway() {
	echo
	echo "Starting hdx-gateway container..."
	echo
	echo "If you have already generated your GATEWAY_PASSPHRASE using the 'gateway generate-certs' command inside of the Hummingbot Client, enter it below:"
	read -s -p "Enter your gateway passphrase: " gateway_passphrase
	echo
	GATEWAY_PASSPHRASE="$gateway_passphrase" docker-compose up -d hdx-gateway
	docker logs -f hdx-gateway
}

# Main logic to handle script arguments
case "$1" in
	hdx-client)
		init
		create_hdx_client
		;;
	hdx-gateway)
		create_hdx_gateway
		;;
	*)
		echo "Usage: $0 {hdx-client|hdx-gateway}"
		exit 1
		;;
esac

set +e
