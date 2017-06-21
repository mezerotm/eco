#ifndef NETWORK
#define NETWORK

#include <SPI.h>
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
    bool checkStatus() const;
    String getSSID() const;
    long getRSSI() const;
    String getEncryptionType() const;
};

#endif
