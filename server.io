#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <rBase64.h>

const char* ssid     = "PROLiNK_PRN3003L_857EC";
const char* password = "prolink12345";
IPAddress ip(10, 1, 39, 118);
IPAddress gateway_ip ( 10,  1,   39,   254);
IPAddress subnet_mask(255, 255, 255, 0);
ESP8266WebServer server(80);

void WIFI_Connect()
{
  WiFi.disconnect();
  WiFi.config(ip, gateway_ip, subnet_mask);
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  int wifi_ctr = 0;
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi connected");
}

void setup() {
  Serial.begin(115200);
  delay(10);

  WIFI_Connect();

  // Start the server
  server.on("/trigger", triggerSerial);
  server.begin();
  Serial.println("Server started");

  // Print the IP address
  Serial.print("Use this IP : ");
  IPAddress ip = WiFi.localIP();
  Serial.println(ip);
}
void loop() {
  if (WiFi.status() != WL_CONNECTED)
    {
      delay(500);
      WIFI_Connect();
    } 
  server.handleClient();    //Handling of incoming requests
}

void triggerSerial() {
  MD5Builder md5;
  md5.begin();
  md5.add("TouchlessIsTheGoal");
  md5.calculate();
if(md5.toString() == rbase64.decode(server.header("Authorization"))){
  Serial.write('A');
  server.send(200);
}else{
  server.send(401);  
}

}
