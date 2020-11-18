# Linkplay HTTP-API Guide
Date of documentation: 15.05.2016  
Date of translation: 09.05.2020

This documentation is a translation based on [iEAST API Guide](https://www.dropbox.com/s/yogm7yu4iw4v754/20160516-manuel-api-sonoe-ieast.pdf?dl=0). 

This documentation describes the API of boards which are produced by a company called [Linkplay](https://linkplay.com). Their boards are so called white label solutions, which means that hundrets of brands are using it in its own products. There are many [well known brands](https://linkplay.com) which uses Linkplay as the core. In theory most of them should be controllable with the API described below.

## Basics
A request format to a Linkplay device is like this:
```
http://10.10.10.254/httpapi.asp?command=$COMMAND
```

All requests are transmitted via HTTP `GET` method. The device response is in `JSON` format. Some values in both requests and responses are converted from ASCII to its hexadecimal representation. These values are marked with `(hex)`.

## Overview of API Commands
### Get Device Status Informations
Returns basic device configuration settings like WiFi IP address, ethernet IP address, firmware version, device language etc.

* HTTP-Method: `GET`
* Response format: `JSON`
* Command: `getStatus`

```
http://10.10.10.254/httpapi.asp?command=getStatus
```

<details>
<summary><i>HTTP-Response: (Click to expand)</i></summary>

```JSON
{
  "language": "en_us",
  "ssid": "SoundSystem_2BE9",
  "hideSSID": "1",
  "SSIDStrategy": "2",
  "firmware": "4.2.8020",
  "build": "release",
  "project": "RP0011_WB60",
  "priv_prj": "RP0011_WB60",
  "Release": "20200220",
  "branch": "stable\/wiimu-4.2",
  "group": "0",
  "expired": "0",
  "internet": "1",
  "uuid": "FF31F09ED58AC1176944064B",
  "MAC": "00:22:6C:00:2B:E9",
  "STA_MAC": "00:22:6C:00:2B:EB",
  "CountryCode": "CN",
  "CountryRegion": "1",
  "date": "2020:05:08",
  "time": "22:40:44",
  "tz": "1.000000",
  "dst_enable": "1",
  "netstat": "2",
  "essid": "57696E6B656C6761737365",
  "apcli0": "WIFI_IP_ADDRESS",
  "eth2": "0.0.0.0",
  "hardware": "A31",
  "VersionUpdate": "0",
  "NewVer": "0",
  "mcu_ver": "22",
  "mcu_ver_new": "0",
  "dsp_ver_new": "0",
  "ra0": "10.10.10.254",
  "temp_uuid": "21A8B78608119C0F",
  "cap1": "0x305200",
  "capability": "0x28490a00",
  "languages": "0x6",
  "dsp_ver": "0",
  "streams_all": "0x7ffffbfe",
  "streams": "0x7ffffbfe",
  "region": "unknown",
  "external": "0x0",
  "preset_key": "10",
  "plm_support": "0x6",
  "spotify_active": "0",
  "lbc_support": "0",
  "WifiChannel": "11",
  "RSSI": "-63",
  "battery": "0",
  "battery_percent": "0",
  "securemode": "0",
  "ali_pid": "RAKOIT_MA1",
  "ali_uuid": "",
  "iot_ver": "1.0.0",
  "upnp_version": "1005",
  "upnp_uuid": "uuid:FF31F09E-D58A-C117-6944-064BFF31F09E",
  "uart_pass_port": "8899",
  "communication_port": "8819",
  "web_firmware_update_hide": "0",
  "web_login_result": "-1",
  "ignore_talkstart": "0",
  "silenceOTATime": "",
  "ignore_silenceOTATime": "1",
  "new_tunein_preset_and_alarm": "1",
  "iheartradio_new": "1",
  "security": "https\/2.0",
  "security_version": "2.0",
  "privacy_mode": "0",
  "user1": "319:524",
  "user2": "1888:2097",
  "DeviceName": "Boombox",
  "GroupName": "Boombox"
}
```
</details>

<details>
<summary><i>Key description: (Click to expand)</i></summary>

| Key | Description |
|:--|:--|
| `language` | Device's system language |
| `ssid` | WiFi SSID of the device in configuration mode |
| `hideSSID` | Boolean value of whether the system SSID is hidden or not.<br>`0`: visible<br>`1`: hidden.<br>(_Officially not documented!_) |
| `SSIDStrategy` | _Officially not documented!_ |
| `firmware` | Installed firmware version |
| `build` | Firmware build flavor |
| `project` | Project name |
| `priv_prj` | _Officially not documented!_ |
| `Release` | Date of firmware |
| `branch` | _Officially not documented!_ |
| `group` | Name of the group<br>(not sure what that means) |
| `expired` | Boolean value of whether the firmware has expired or not.<br>`0`: valid<br>`1`: expired. |
| `internet` | Boolean value of wheter the device has access to the internet or not.<br>`0`: not connected<br>`1`: connected. |
| `uuid` | UDID of the device. The first 8 bytes of the project ID, followed by the unique device identifier |
| `MAC` | Device MAC address |
| `STA_MAC` | _Officially not documented!_ |
| `CountryCode` | I assume it's the manufacturer country code.<br>_Officially not documented!_ |
| `CountryRegion` | _Officially not documented!_ |
| `date` | Current date on device |
| `time` | Current time on device |
| `tz` | Could be _"Timezone"_. No idea what the value means<br>_Officially not documented!_ |
| `dst_enable` | _Officially not documented!_ |
| `netstat` | WIFI connection state<br>`0`: not connected<br>`1`: transient state<br>`2`: connected |
| `essid` | SSID of your local WiFi network the device is currently connected to. To support special characters in its name this value is encoded. `(hex)` |
| `apcli0` | WiFi IP address |
| `eth2` | Ethernet IP address |
| `hardware` | Hardware version |
| `VersionUpdate` | Boolean value of whether there is a new firmware version available or not.<br>`0`: no new firmware<br>`1`: new firmware available |
| `NewVer` | Version number of the new firmware (if available). If there is no new firmware available this value is set to `0`. |
| `mcu_ver` | Current MCU version number (if available). If there is no MCU this value is set to `0`.  |
| `mcu_ver_new` | New MCU version number. If there is no MCU this value is set to `0`. |
| `dsp_ver_new` | New DSP version number. If there is no DSP this value is set to `0`. |
| `ra0` | _Officially not documented!_ |
| `temp_uuid` | Temporary UUID. Its value will change after reboot. |
| `cap1` | _Officially not documented!_ |
| `capability` | _Officially not documented!_ |
| `languages` | _Officially not documented!_ |
| `dsp_ver` | _Officially not documented!_ |
| `streams_all` | Bitmask of audio streams to be displayed in the user interface |
| `streams` | Bitmask of all available audio streams<br>Bit:<br>`00` MFI Airplay<br>`01` Airplay<br>`02` DLNA<br>`03` Qplay<br>`10` TTPod<br>`11` DubanFM<br>`14` QuingTing<br>`15` Ximalaya<br>`16` TuneIn<br>`17` iHeartRadio<br>`18` Tidal<br>`21` Pandora<br>`22` Spotify |
| `region` | _Officially not documented!_ |
| `external` | Board has light control |
| `preset_key` | WiFi [Pre-Shared Key](https://en.wikipedia.org/wiki/Pre-shared_key) number |
| `plm_support` | Bitmask<br>`00` LineIn (AUX)<br>`01` Bluetooth<br>`02` Optical<br><br>_Since I have a value of `6` here (see response above), it seems that some bits are not documented yet. However, the board whose response above I copied from, has BT and AUX. This means that the value of `6` doesn't make any sense with the documented bits._ |
| `spotify_active` | Boolean value of whether the device is currently playing via Spotify Connect or not.<br>`0`: Spotify Connect not active<br>`1`: Spotify Connect active |
| `lbc_support` | _Officially not documented!_ |
| `WifiChannel` | Currently used WiFi channel |
| `RSSI` | WiFi [Received Signal Strength Indicator](https://en.wikipedia.org/wiki/Received_signal_strength_indication) |
| `battery` | Boolean value of whether the device has a battery or not.<br>`0`: No battery present<br>`1`: Battery present |
| `battery_percent` | State of charge for the battery in percent.<br>Value can range from `0` to `100`. |
| `securemode` | Boolean value of whether the API communication uses HTTP or HTTPS.<br>`0`: HTTP<br>`1`: HTTPS |
| `ali_pid` | _Officially not documented!_ |
| `ali_uuid` | _Officially not documented!_ |
| `iot_ver` | IoT version?<br>_Officially not documented!_ |
| `upnp_version` | _Officially not documented!_ |
| `upnp_uuid` | _Officially not documented!_ |
| `uart_pass_port` | _Officially not documented!_ |
| `communication_port` | _Officially not documented!_ |
| `web_firmware_update_hide` | Boolean value of whether the firmware update feature is hidden in Web-Frontend or not<br>`0`: Not hidden<br>`1`: Hidden |
| `web_login_result` | _Officially not documented!_ |
| `ignore_talkstart` | _Officially not documented!_ |
| `silenceOTATime` | _Officially not documented!_ |
| `ignore_silenceOTATime` | _Officially not documented!_ |
| `new_tunein_preset_and_alarm` | _Officially not documented!_ |
| `iheartradio_new` | _Officially not documented!_ |
| `security` | _Officially not documented!_ |
| `security_version` | _Officially not documented!_ |
| `privacy_mode` | _Officially not documented!_ |
| `user1` | _Officially not documented!_ |
| `user2` | _Officially not documented!_ |
| `DeviceName` | Current name of the device.<br>This name is changeable by using the REST command [SlaveSetDeviceName](#SlaveSetDeviceName) |
| `GroupName` | Name of the multiroom group the device is attached to. |

</details>

### WIFI KONFIGURATION