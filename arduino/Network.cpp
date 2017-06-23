#include "Network.h"

Network::Network(String ssid, String password) {
  WiFi.begin(ssid, password);
}

std::vector<Network::NetworkInformation> Network::scanNetwork() {
	std::vector<NetworkInformation> networks;

	byte numberOfNetworks = WiFi.scanNetworks();
	for (auto currentNetwork = 0; currentNetwork < numberOfNetworks; currentNetwork++)
		networks.push_back({
            WiFi.SSID(currentNetwork),
            WiFi.RSSI(currentNetwork),
            WiFi.encryptionType(currentNetwork)
        });

	return networks;
}

bool Network::checkStatus() {
  return WiFi.status() == WL_CONNECTED;
}

String Network::getSSID() {
    return WiFi.SSID();
}

long Network::getRSSI() {
    return WiFi.RSSI();
}

String Network::getEncryptionType() {
    switch (WiFi.encryptionType()) {
      case ENC_TYPE_WEP:
        return "WEP";
      case ENC_TYPE_TKIP:
        return "WPA";
      case ENC_TYPE_CCMP:
        return "WPA2";
      case ENC_TYPE_NONE:
        return "None";
      case ENC_TYPE_AUTO:
        return "Auto";
	  default:
		  return "None";
    }
}
