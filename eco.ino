//Network Global Variables
#include <WiFi101.h>

String request = "/arduino";

String ssid = "2.4GHZ:2001:0DB8:AC10";
String password = "f3aYrwWyeF8bkF9";

String host = "192.168.1.80";
int port = 80;

WiFiClient client;

//Flow Meter Global Variables
const byte FLOW_SENSOR_PIN = 6;

/*
Sensor Frequency (Hz) = 7.5 * Q (Liters/min)
Liters = Q * time elapsed (seconds) / 60 (seconds/minute)
Liters = (Frequency (Pulses/second) / 7.5) * time elapsed (seconds) / 60
Liters = Pulses / (7.5 * 60)
*/

uint16_t pulses = 0;
uint8_t lastflowpinstate;
uint32_t lastflowratetimer = 0;
float flowrate;

void setup() {
	do{
		Serial.begin(9600);
	}
	while (!Serial);

	pinMode(FLOW_SENSOR_PIN, INPUT);
	lastflowpinstate = digitalRead(FLOW_SENSOR_PIN);
	attachInterrupt(6, flowLoop, HIGH);

	Serial.println("Attempting to connect to: " + ssid);
	WiFi.begin(ssid, password);
	if (WiFi.status() == WL_CONNECTED){
		Serial.println("Succesfully connected to wifi");
		Serial.println("Attempting to connect to: " + host);
		client.connect(host.c_str(), port);
		if (client.connected()){
			Serial.println("Succesfully connected to server");

			client.println("GET " + request);
			client.println("Accept: text/plain");
			client.println("User-Agent: MKR1000");
			client.println("Connection: close");
			client.println();

			Serial.println("Request sent");
		}
		else{
			Serial.println("Could not connect to server");
		}
	}
	else{
		Serial.println("Could not connect to wifi");
	}
}

void loop() {
	if (WiFi.status() == WL_CONNECTED){
		String line = "";
		if (client.connected()){
			line = client.readStringUntil('\n');
			if (line == "\r"){
				Serial.println("headers received");
				return;
			}
		}
		line = client.readStringUntil('\n');
		Serial.println(line);
	}
}

void flowLoop() {
	uint8_t x = digitalRead(FLOW_SENSOR_PIN);

	if (x == lastflowpinstate) {
		lastflowratetimer++;
		return;
	}

	if (x == HIGH) pulses++;

	lastflowpinstate = x;
	flowrate = 1000.0;
	flowrate /= lastflowratetimer;  // in hertz
	lastflowratetimer = 0;

	float liters = pulses;
	liters /= 7.5;
	liters /= 60.0;

	Serial.print("Freq: "); Serial.println(flowrate);
	Serial.print("Pulses: "); Serial.println(pulses, DEC);
	Serial.print(liters); Serial.println(" Liters");
}
