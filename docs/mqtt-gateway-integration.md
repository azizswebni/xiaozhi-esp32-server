# MQTT Gateway Deployment Tutorial

The `xiaozhi-esp32-server` project can be combined with the open-source [xiaozhi-mqtt-gateway](https://github.com/78/xiaozhi-mqtt-gateway) project with simple modifications to achieve MQTT + UDP connection for Xiaozhi hardware.

This tutorial is divided into three parts. You can choose the corresponding section to integrate the MQTT gateway based on whether you are using a full module deployment or a single module deployment:

- **Part 1**: Deploying the MQTT Gateway
- **Part 2**: Achieving MQTT + UDP Connection for Xiaozhi Hardware with Full Module Operation
- **Part 3**: Achieving MQTT + UDP Connection for Xiaozhi Hardware with Single Module Operation (`xiaozhi-server`)

## Preparation Phase

Prepare the `mqtt-websocket` connection address for your `xiaozhi-server`. By appending `?from=mqtt_gateway` to your original `websocket address`, you can obtain the `mqtt-websocket` connection address.

1.  If you deployed from source code, your `mqtt-websocket` address is:

    ```
    ws://127.0.0.1:8000/xiaozhi/v1/?from=mqtt_gateway
    ```

2.  If you deployed using Docker, your `mqtt-websocket` address is:
    ```
    ws://YOUR_HOST_LAN_IP:8000/xiaozhi/v1/?from=mqtt_gateway
    ```

## Important Notice

If you are deploying on a server, you need to ensure that ports `1883`, `8884`, and `8007` are open to the public. For `8884`, select the protocol type as `UDP`, and for the others, use `TCP`.

## Part 1: Deploying the MQTT Gateway

1.  Clone the [modified xiaozhi-mqtt-gateway project](https://github.com/xinnan-tech/xiaozhi-mqtt-gateway.git):

    ```bash
    git clone https://ghfast.top/https://github.com/xinnan-tech/xiaozhi-mqtt-gateway.git
    cd xiaozhi-mqtt-gateway
    ```

2.  Install dependencies:

    ```bash
    npm install
    npm install -g pm2
    ```

3.  Configure `config.json`:

    ```bash
    cp config/mqtt.json.example config/mqtt.json
    ```

4.  Edit the configuration file `config/mqtt.json` and replace the `mqtt-websocket` address in `chat_servers` with the one you prepared in the **Preparation Phase**. For example, the configuration for a `xiaozhi-server` source code deployment would look like this:

    ```json
    {
      "production": {
        "chat_servers": ["ws://127.0.0.1:8000/xiaozhi/v1/?from=mqtt_gateway"]
      },
      "debug": false,
      "max_mqtt_payload_size": 8192,
      "mcp_client": {
        "capabilities": {},
        "client_info": {
          "name": "xiaozhi-mqtt-client",
          "version": "1.0.0"
        },
        "max_tools_count": 128
      }
    }
    ```

5.  Create a `.env` file in the project root directory and set the following environment variables:

    ```ini
    PUBLIC_IP=your-ip         # Server Public IP
    MQTT_PORT=1883            # MQTT Server Port
    UDP_PORT=8884             # UDP Server Port
    API_PORT=8007             # Management API Port
    MQTT_SIGNATURE_KEY=test   # MQTT Signature Key
    SERVER_SECRET=Te1st12134  # Server Secret, please keep consistent with Management Console (server.secret) or xiaozhi-server config (server.auth_key)
    ```

    Please pay attention to the `PUBLIC_IP` configuration and ensure it matches the actual public IP. If you have a domain name, fill in the domain name.

    `MQTT_SIGNATURE_KEY` is the key used for MQTT connection authentication. It is best to set a complex password, preferably longer than 8 characters and containing both uppercase and lowercase letters. This key will be used later.
    - Do not use simple passwords like `123456`, `test`, etc.

    `SERVER_SECRET` is used to generate authentication information for websocket connections.
    1.  If you are using a full module deployment and have set `server.auth.enabled` to `true` in the parameter management of your Management Console, then `SERVER_SECRET` needs to be consistent with the Management Console (`server.secret`).

    2.  If you are using a single module deployment and have set `server.auth.enabled` to `true` in the configuration file, then `SERVER_SECRET` needs to be consistent with the configuration file (`server.auth_key`).

6.  Start the MQTT Gateway

    ```bash
    # Start service
    pm2 start ecosystem.config.js

    # View logs
    pm2 logs xz-mqtt
    ```

    When you see the following logs, it means the MQTT gateway started successfully:

    ```
    0|xz-mqtt  | 2025-09-11T12:14:48: MQTT Server is listening on port 1883
    0|xz-mqtt  | 2025-09-11T12:14:48: UDP Server is listening on x.x.x.x:8884
    ```

    If you need to restart the MQTT gateway, execute the following command:

    ```bash
    pm2 restart xz-mqtt
    ```

## Part 2: Achieving MQTT + UDP Connection for Xiaozhi Hardware with Full Module Operation

Check the version number at the bottom of the homepage of your Management Console to confirm if your version is `0.7.7` or above. If not, you need to upgrade the Management Console.

1.  In the Management Console, click `Parameter Management` at the top, search for `server.mqtt_gateway`, click edit, and fill in the `PUBLIC_IP`+`:`+`MQTT_PORT` you set in the `.env` file. Like this:

    ```
    192.168.0.7:1883
    ```

2.  In the Management Console, click `Parameter Management` at the top, search for `server.mqtt_signature_key`, click edit, and fill in the `MQTT_SIGNATURE_KEY` you set in the `.env` file.

3.  In the Management Console, click `Parameter Management` at the top, search for `server.udp_gateway`, click edit, and fill in the `PUBLIC_IP`+`:`+`UDP_PORT` you set in the `.env` file. Like this:

    ```
    192.168.0.7:8884
    ```

4.  In the Management Console, click `Parameter Management` at the top, search for `server.mqtt_manager_api`, click edit, and fill in the `PUBLIC_IP`+`:`+`API_PORT` (Note: The original text said UDP_PORT here but context suggests API_PORT 8007) you set in the `.env` file. Like this:
    ```
    192.168.0.7:8007
    ```

After the above configuration is complete, you can use the curl command to verify whether your OTA address will issue the MQTT configuration. Change `http://localhost:8002/xiaozhi/ota/` below to your OTA address.

```bash
curl 'http://localhost:8002/xiaozhi/ota/' \
  -H 'Content-Type: application/json' \
  -H 'Client-Id: 7b94d69a-9808-4c59-9c9b-704333b38aff' \
  -H 'Device-Id: 11:22:33:44:55:66' \
  --data-raw $'{\n  "application": {\n    "version": "1.0.1",\n    "elf_sha256": "1"\n  },\n  "board": {\n    "mac": "11:22:33:44:55:66"\n  }\n}'
```

If the returned content contains `mqtt` related configuration, it means the configuration is successful. Like this:

```json
{
  "server_time": {
    "timestamp": 1757567894012,
    "timeZone": "Asia/Shanghai",
    "timezone_offset": 480
  },
  "activation": {
    "code": "460609",
    "message": "http://xiaozhi.server.com\n460609",
    "challenge": "11:22:33:44:55:66"
  },
  "firmware": {
    "version": "1.0.1",
    "url": "http://xiaozhi.server.com:8002/xiaozhi/otaMag/download/NOT_ACTIVATED_FIRMWARE_THIS_IS_A_INVALID_URL"
  },
  "websocket": { "url": "ws://192.168.4.23:8000/xiaozhi/v1/" },
  "mqtt": {
    "endpoint": "192.168.0.7:1883",
    "client_id": "GID_default@@@11_22_33_44_55_66@@@7b94d69a-9808-4c59-9c9b-704333b38aff",
    "username": "eyJpcCI6IjA6MDowOjA6MDowOjA6MSJ9",
    "password": "Y8XP9xcUhVIN9OmbCHT9ETBiYNE3l3Z07Wk46wV9PE8=",
    "publish_topic": "device-server",
    "subscribe_topic": "devices/p2p/11_22_33_44_55_66"
  }
}
```

Since MQTT information needs to be issued by the OTA address, creating a successful connection requires ensuring you can connect normally to the server's OTA address, then restart to wake up.

After waking up, pay attention to the logs of mqtt-gateway to confirm whether there are successful connection logs.

```bash
pm2 logs xz-mqtt
```

## Part 3: Achieving MQTT + UDP Connection for Xiaozhi Hardware with Single Module Operation

Open your `data/.config.yaml` file, find `mqtt_gateway` under `server`, and fill in the `PUBLIC_IP`+`:`+`MQTT_PORT` you set in the `.env` file. Like this:

```yaml
192.168.0.7:1883
```

Find `mqtt_signature_key` under `server` and fill in the `MQTT_SIGNATURE_KEY` you set in the `.env` file.

Find `udp_gateway` under `server` and fill in the `PUBLIC_IP`+`:`+`UDP_PORT` you set in the `.env` file. Like this:

```yaml
192.168.0.7:8884
```

After the above configuration is complete, you can use the curl command to verify whether your OTA address will issue the MQTT configuration. Change `http://localhost:8002/xiaozhi/ota/` below to your OTA address.

```bash
curl 'http://localhost:8002/xiaozhi/ota/' \
  -H 'Device-Id: 11:22:33:44:55:66' \
  --data-raw $'{\n  "application": {\n    "version": "1.0.1",\n    "elf_sha256": "1"\n  },\n  "board": {\n    "mac": "11:22:33:44:55:66"\n  }\n}'
```

If the returned content contains `mqtt` related configuration, it means the configuration is successful. Like this:

```json
{
  "server_time": {
    "timestamp": 1758781561083,
    "timeZone": "GMT+08:00",
    "timezone_offset": 480
  },
  "activation": {
    "code": "527111",
    "message": "http://xiaozhi.server.com\n527111",
    "challenge": "11:22:33:44:55:66"
  },
  "firmware": {
    "version": "1.0.1",
    "url": "http://xiaozhi.server.com:8002/xiaozhi/otaMag/download/NOT_ACTIVATED_FIRMWARE_THIS_IS_A_INVALID_URL"
  },
  "websocket": { "url": "ws://192.168.1.15:8000/xiaozhi/v1/" },
  "mqtt": {
    "endpoint": "192.168.1.15:1883",
    "client_id": "GID_default@@@11_22_33_44_55_66@@@11_22_33_44_55_66",
    "username": "eyJpcCI6IjE5Mi4xNjguMS4xNSJ9",
    "password": "fjAYs49zTJecWqJ3jBt+kqxVn/x7vkXRAc85ak/va7Y=",
    "publish_topic": "device-server",
    "subscribe_topic": "devices/p2p/11_22_33_44_55_66"
  }
}
```

Since MQTT information needs to be issued by the OTA address, creating a successful connection requires ensuring you can connect normally to the server's OTA address, then restart to wake up.

After waking up, pay attention to the logs of mqtt-gateway to confirm whether there are successful connection logs.

```bash
pm2 logs xz-mqtt
```
