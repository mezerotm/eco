#ifndef NETWORK
#define NETWORK

#include <WiFi101.h>
#include <ArduinoSTL.h>

class Network final {
  public:
    Network(String ssid, String password);

    struct NetworkInformation {
      String SSID;
      long RSSI;
      int encryptionType;
    };

    static std::vector<NetworkInformation> scanNetwork();
    static bool checkStatus();
	static String getSSID();
	static long getRSSI();
	static String getEncryptionType();
};

#endif
