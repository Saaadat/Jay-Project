#define relay 7
#define sensor 8
char incomingByte = 'x';

//1 is open 0 is closed

int opened = 0;
int closed = 1;



void setup() {
  Serial.begin(115200); // opens serial port, sets data rate to 9600 bps
  Serial.print("wait for request");
  pinMode(relay, OUTPUT);
  digitalWrite(relay, LOW);
  pinMode(sensor, INPUT);
}

void loop() {
  int counter = 0;
  if (Serial.available() > 0) {
     incomingByte = Serial.read(); // read the incoming byte:

     if(incomingByte == 'A'){
      
        while(digitalRead(sensor) == 0){
         
          }

       if(digitalRead(sensor) == 1){

       digitalWrite(relay, HIGH);
       delay(1000);
       digitalWrite(relay, LOW);
       delay(1000);
      }

     }

  }
}
   
