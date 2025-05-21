# Hummingbot + Hydration Quickstart
A repository with scripts to easily set up Hummingbot to do market-making with Hydration (HDX).

While this repository is fully functional, it serves as a product preview until the Hummingbot Foundation officially merges the code. In the meantime, the setup flow demonstrated here, using the Hummingbot Client and Gateway, remains compatible with the latest Hummingbot versions by updating the docker-compose.yml file accordingly.

## Instructions

### Prerequisites

- [Docker (or Docker Desktop)](https://www.docker.com/products/docker-desktop/)
- Unix-like system (Linux, MacOS) or WSL (for Windows)

### Create and configure the Hummingbot Client

```sh
git clone https://github.com/robotter-ai/hydration.git
cd hydration
./setup.sh hummingbot
docker attach hummingbot
```

After running the commands above, the Hummingbot Client screen should appear. Follow the instructions and configure a strong password for yourself.

When the main screen (after the login) appears, generate the SSL certificates for the Hummingbot Client to securely communicate with the Hummingbot Gateway. This can be done with the following command:

```sh
gateway generate-certs
```

Follow the instructions and define a strong password.

### Create and configure the Hummingbot Gateway

In another terminal window, but inside the same repository, do:

```sh
./setup.sh gateway
```

Inform the GATEWAY_PASSPHRASE previously defined when asked.
The HB Gateway logs should appear and start normally.
Also, from the HB Client, on the top right side, it should appear that the HB Gateway is now online.

### How to run strategies

Once the configuration above is done, you can run your preferred strategies.
Please refer to the Hummingbot documentation on how to use and configure them.
Note that Hydration is an AMM (Automated Market Maker) connector, so only the strategies compatible with them can be run.

https://hummingbot.org/docs/#ways-to-use-hummingbot

https://hummingbot.org/v1-strategies/

https://hummingbot.org/strategies/

Some interesting strategies and scripts to try are:
- scripts/amm_portfolio_manager.py (Our own strategy, fully customizable and full of features for you to build on top of it)
- amm_arb (Hummingbot v1 arbitrage strategy, so you can make arbitrages between different connectors)
- scripts/amm_price_example.py (Hummingbot script to check the price functionality from an AMM connector)
- scripts/amm_trade_example.py (Hummingbot script to place a trade using an AMM connector)
- scripts/amm_data_feed.py (Hummingbot script that fetchs data from an AMM connector)
- (Other strategies are in the making by the Hummingbot foundation, since the support for AMM connectors is quite new, there are a lot of good ones to come)
