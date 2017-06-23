#include "Network.h"

void printEncryptionType(int thisType) {
  switch (thisType) {
    case ENC_TYPE_WEP:
      Serial.println("WEP");
      break;
    case ENC_TYPE_TKIP:
      Serial.println("WPA");
      break;
    case ENC_TYPE_CCMP:
      Serial.println("WPA2");
      break;
    case ENC_TYPE_NONE:
      Serial.println("None");
      break;
    case ENC_TYPE_AUTO:
      Serial.println("Auto");
      break;
  }
}

void scanNetworksToSerial() {
    Serial.begin(9600);
    while (!Serial);

    Serial.println("Scanning available networks...");
  	std::vector<Network::NetworkInformation> networks = Network::scanNetwork();
  	for(auto network : networks){
  	    Serial.print("SSID: " + network.SSID);
  	    Serial.print("\tSignal: ");
        Serial.print(network.RSSI);
        Serial.print(" dBm\tEncryption: ");
        printEncryptionType(network.encryptionType);
        Serial.flush();
  	}
}
