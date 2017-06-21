#include "../headers/Network.h"

Network::Network(String ssid, String password) {
  WiFi.begin(ssid, password);
}

std::vector<Network::NetworkInformation> Network::scanNetwork() {
	std::vector<Network::NetworkInformation> networks;

	byte numberOfNetworks = WiFi.scanNetworks();
	for (auto currentNetwork = 0; currentNetwork < numberOfNetworks; currentNetwork++)
		networks.push_back({
            WiFi.SSID(currentNetwork),
            WiFi.RSSI(currentNetwork),
            WiFi.encryptionType(currentNetwork)
        });

	return networks;
}

bool Network::checkStatus() const {
  return WiFi.status() == WL_CONNECTED;
}

String Network::getSSID() const {
    return WiFi.SSID();
}

long Network::getRSSI() const {
    return WiFi.RSSI();
}

String Network::getEncryptionType() const {
    switch (WiFi.encryptionType()) {
      case ENC_TYPE_WEP:
        return "WEP";
        break;
      case ENC_TYPE_TKIP:
        return "WPA";
        break;
      case ENC_TYPE_CCMP:
        return "WPA2";
        break;
      case ENC_TYPE_NONE:
        return "None";
        break;
      case ENC_TYPE_AUTO:
        return "Auto";
        break;
    }
}
