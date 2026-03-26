# Network

## UniFi

[ui](unifi.ui.com)

## IP Allocation

We use both static IP and DHCP at home.

- Static: 192.168.0.1 - 192.168.0.99
- DHCP: 192.168.0.100 - 192.168.0.255

Some kinds of devices are configured in specific static ranges.

- Switches: 192.168.0.10 - 192.168.0.19
- Access Points: 192.168.0.20 - 192.168.0.29
- Servers Wout: 192.168.0.50 - 192.168.0.60

### Known Devices

|IP|Hostname|MAC Address|Type|Description|
|--|--|--|--|--|
|192.168.0.1|USG|b4:fb:e4:e5:9d:d6|Network|Gateway|
|192.168.0.2|UniFi CloudKey|b4:fb:e4:ce:48:21|Network|UniFi controller|
|192.168.0.15|switch bureel|f4:92:bf:90:7f:e9|Network|Office switch|
|192.168.0.16|switch garage|68:d7:9a:31:db:3f|Network|Garage switch|
|192.168.0.17|switch werkhuis|d8:b3:70:11:76:b0|Network|Workshop switch|
|192.168.0.18|switch zolder|e4:38:83:38:60:11|Network|Attic switch|
|192.168.0.20|zolder|78:8a:20:d0:0f:63|Access Point|Access point zolder|
|192.168.0.21|bureel|78:8a:20:d0:88:2c|Access Point|Access point bureel|
|192.168.0.22|gelijkvloers|fc:ec:da:f3:c1:3b|Access Point|Access point garage|
|192.168.0.23|outdoor|f4:e2:c6:10:b6:87|Access Point|Access point terras|
|192.168.0.50|DNS-Wout|bc:24:11:31:d4:dc|Server|DNS server Wout|
|192.168.0.51|prod-vm|bc:24:11:d4:4a:9c|Server|Production server (prod.vdbhome.ovh)|
|192.168.0.52|public|bc:24:11:76:cc:3d|Server|Public server (public.vdbhome.ovh)|
|192.168.0.53|node1-wout|bc:24:11:22:65:08|Server|HA Docker server (ha.vdbhome.ovh)|
|192.168.0.81|Sonoff trap zolder|bc:dd:c2:0f:38:f9|IoT|Trapverlichting zolder|
|192.168.0.108|Device-5b64|36:55:fe:35:5b:64|Client|Laptop Wout|
|192.168.0.109|Device-c36c|4c:11:bf:20:c3:6c|IoT|Video intercom|
|192.168.0.110|Device-d470|4c:11:bf:20:d4:70|IoT|Video intercom|
|192.168.0.112|Shelly Pro 2|2c:bc:bb:9f:d0:08|IoT|Licht tuin + bol|
|192.168.0.132|Tab-S9-van-Wout|36:b2:81:06:13:fc|Client|Tablet Wout|
|192.168.0.138|wlan0|18:de:50:3f:d7:11|Unknown|WiFi client|
|192.168.0.151|Device-9600|d0:c9:07:9f:96:00|Unknown|Unidentified IoT device|
|192.168.0.165|Device-cf2d|d4:ad:fc:23:cf:2d|Unknown|Unidentified IoT device|
|192.168.0.173|ESP_074A5D|c8:2b:96:07:4a:5d|Unknown|ESP microcontroller|
|192.168.0.180|BoseHome|00:0c:8a:7a:60:ce|Media|Bose speaker|
|192.168.0.182|SPECTRE-Kristel|c8:58:c0:87:c6:39|Client|Laptop Kristel|
|192.168.0.183|OnePlus-12R|b2:fd:a6:d6:ff:58|Client|Phone Lander|
|192.168.0.185|ZENGGE_33_DDCBA5|2c:f4:32:dd:cb:a5|IoT|Smart light bureau Wout|
|192.168.0.186|hue smart hub|ec:b5:fa:18:7c:5a|IoT|Philips Hue hub (terras lights)|
|192.168.0.193|SDongleA-TA2270161499|6c:e8:74:ee:df:40|IoT|Solar panels dongle|
|192.168.0.194|Device-16f7|38:86:f7:0f:16:51|IoT|Google Nest Hub slaapkamer|
|192.168.0.197|VDB-NAS|00:11:32:1a:2d:fd|Server|NAS storage|
|192.168.0.198|Easee-EH64GQRE|4c:eb:d6:5c:4f:cc|IoT|EV charger|
|192.168.0.200|Device-279a|00:17:c8:9d:27:5a|Client|Printer|
|192.168.0.201|HW-p1meter-100710|5c:2f:af:10:07:10|IoT|Power meter|
|192.168.0.205|PC-WOUT|4c:ed:fb:78:5c:3f|Client|Desktop Wout|
|192.168.0.208|mibox licht bar|70:89:76:10:dd:e3|IoT|Smart light bar|
|192.168.0.210|Server Wout|bc:e9:2f:87:15:5e|Server|VM server Wout|
|192.168.0.212|desktop_Lander|a8:5e:45:e1:56:a2|Client|Desktop Lander|
|192.168.0.213|TV Living|84:c8:a0:7a:fb:f8|Media|Smart TV|
|192.168.0.221|Device-e452|dc:e5:5b:42:e4:52|IoT|Google Nest Hub Bar|
|192.168.0.227|shellypro4pm-c8f09e8391f8|c8:f0:9e:83:91:f8|IoT|Shelly smart relay|
|192.168.0.233|tado|ec:e5:12:14:d5:02|IoT|Thermostat|
|192.168.0.234|ESP_C22B8D|c4:4f:33:c2:2b:8d|IoT|Sonoff kamer Lander|
|192.168.0.235|ESP_768A30|84:0d:8e:76:8a:30|IoT|Sonoff kamer Wout|
|192.168.0.239|TV Wout|08:c3:b3:48:95:ca|Media|Smart TV|
|192.168.0.241|yeelink-light-lamp4_mibtAFEC|04:cf:8c:26:af:ec|IoT|Smart lamp|
|192.168.0.244|Nothing-phone-1|2c:be:eb:21:18:0d|Client|Phone Wout|
|192.168.0.245|wlan0|a8:80:55:bb:87:96|Unknown|WiFi client|
|192.168.0.253|iRobot-BD9A3A82FB834236A2EBC605|50:14:79:45:93:03|IoT|Robot vacuum|
