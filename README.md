# Hummingbot + Hydration
A repository with scripts to easily setup Hummingbot to do market-making with Hydration (HDX).

Although this repository is fully funcitonal, this is a temporary solution until the code gets merged by the Hummingbot Foundation.
In any case, the flow to quickly start with the Hummingbot Client and Gateway presented here, can still be used with the latest versions of Hummingbot (changing the docker-compose.yml file).

## Instructions

### Create and configure the Hummingbot Client

```sh
git clone https://github.com/robotter-ai/hydration.git
cd hydration
./setup.sh hummingbot
docker attach hummingbot
```

After running the commands above the Hummingbot Client screen should appear, follow the instructions and configure a strong password for you.

When the main screen (after the login) appear, generate the SSL certificates for the Hummingbot Clien to securely communicate with the Hummingbot Gateway. This can be done with the following command there:

```sh
gateway generate-certs
```

Follow the instructions and define a strong password.

### Create and configure the Hummingbot Gateway

In another terminal window, but inside of same repository do:

```sh
./setup.sh gateway
```

Inform the GATEWAY_PASSPHRASE previously defined when asked.
The HB Gateway logs should appear and start normally.
Also, from the HB Client, on the top right side it should appear that the HB Gateway is now online.

### How to run strategies

Once the configuration above is done you can run your preferred strategies.
Please refer to the Hummingbot documentation on how to use and configure them.
Note that Hydration is a AMM (Automated Market Maker) connector, so only the strategies compatible with them can be run.

https://hummingbot.org/docs/#ways-to-use-hummingbot

https://hummingbot.org/v1-strategies/

https://hummingbot.org/strategies/
