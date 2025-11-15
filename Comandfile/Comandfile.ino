#include <Servo.h>

const int trigPin = 10;
const int echoPin = 11;

const int led1 = 7;
const int led2 = 6;
const int led3 = 5;

const int buzzer1 = 8;
const int buzzer2 = 4;

long duration;
int distance;

Servo myServo;

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);

  pinMode(buzzer1, OUTPUT);
  pinMode(buzzer2, OUTPUT);

  Serial.begin(9600);
  myServo.attach(12);
}

void loop() {

  for (int i = 15; i <= 165; i++) {
    myServo.write(i);
    delay(30);
    distance = calculateDistance();

    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");

    alert(distance);
  }

  for (int i = 165; i > 15; i--) {
    myServo.write(i);
    delay(30);
    distance = calculateDistance();

    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");

    alert(distance);
  }
}

// int calculateDistance() {
//   digitalWrite(trigPin, LOW);
//   delayMicroseconds(2);
//   digitalWrite(trigPin, HIGH);
//   delayMicroseconds(10);
//   digitalWrite(trigPin, LOW);

//   duration = pulseIn(echoPin, HIGH);
//   distance = duration * 0.034 / 2;

//   return distance;
// }
// int calculateDistance() {
//   long sum = 0;
//   int samples = 3;

//   for (int i = 0; i < samples; i++) {
//     digitalWrite(trigPin, LOW);
//     delayMicroseconds(2);
//     digitalWrite(trigPin, HIGH);
//     delayMicroseconds(10);
//     digitalWrite(trigPin, LOW);

//     long dur = pulseIn(echoPin, HIGH, 20000); // 20ms timeout

//     int dist = dur * 0.034 / 2;

//     // ignore weird values
//     if (dist > 2 && dist < 400) {
//       sum += dist;
//     } else {
//       i--;  // repeat this sample
//     }

//     delay(5);
//   }

//   return sum / samples;   // return average distance
// }

int calculateDistance() {
  long sum = 0;
  int samples = 3;  // number of readings to average

  for (int i = 0; i < samples; i++) {
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);

    long durationSample = pulseIn(echoPin, HIGH);
    int distanceSample = durationSample * 0.034 / 2;

    sum += distanceSample;
    delay(5);  // small pause between samples
  }

  return sum / samples;  // average distance
}

void alert(int d) {

  if (d > 0 && d < 20) {

    // blink 3 LEDs together
    digitalWrite(led1, HIGH);
    digitalWrite(led2, HIGH);
    digitalWrite(led3, HIGH);

    digitalWrite(buzzer1, HIGH);
    digitalWrite(buzzer2, HIGH);

    delay(100);

    digitalWrite(led1, LOW);
    digitalWrite(led2, LOW);
    digitalWrite(led3, LOW);

    delay(100);
  }

  else {
    digitalWrite(led1, LOW);
    digitalWrite(led2, LOW);
    digitalWrite(led3, LOW);

    digitalWrite(buzzer1, LOW);
    digitalWrite(buzzer2, LOW);
  }
}
