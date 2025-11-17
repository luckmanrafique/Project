import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;

Serial myPort;

String angle = "";
String distance = "";
String data = "";
String noObject;

float pixsDistance;

int iAngle, iDistance;
int index1 = 0;

void setup() {
  size(1200, 700);
  smooth();
  
  myPort = new Serial(this, "COM3", 9600);
  myPort.bufferUntil('.');
}

void draw() {
  // motion blur background
  noStroke();
  fill(0, 4);
  rect(0, 0, width, height-height*0.065);

  fill(98, 245, 31);
  drawRadar();
  drawLine();
  drawObject();
  drawText();
}

void serialEvent(Serial p) {

  try {
    data = p.readStringUntil('.');
    
    if (data == null) return;                   // ignore null data
    data = trim(data);
    if (data.length() < 3) return;             // ignore too-short data
    
    data = data.substring(0, data.length()-1); // remove '.'

    index1 = data.indexOf(",");
    if (index1 == -1) return;                  // corrupted packet

    angle = data.substring(0, index1);
    distance = data.substring(index1 + 1);

    iAngle = int(angle);
    iDistance = int(distance);

  } catch (Exception e) {
    println("Serial read error: " + e);
  }
}

void drawRadar() {
  pushMatrix();
  translate(width/2, height - height*0.074);

  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);

  arc(0,0,(width-width*0.0625),(width-width*0.0625), PI, TWO_PI);
  arc(0,0,(width-width*0.27),(width-width*0.27), PI, TWO_PI);
  arc(0,0,(width-width*0.479),(width-width*0.479), PI, TWO_PI);
  arc(0,0,(width-width*0.687),(width-width*0.687), PI, TWO_PI);

  line(-width/2,0,width/2,0);
  line(0,0,(-width/2)*cos(radians(30)), (-width/2)*sin(radians(30)));
  line(0,0,(-width/2)*cos(radians(60)), (-width/2)*sin(radians(60)));
  line(0,0,(-width/2)*cos(radians(90)), (-width/2)*sin(radians(90)));
  line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
  line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));

  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width/2, height - height*0.074);

  strokeWeight(9);
  stroke(255, 10, 10);

  if (iDistance < 40) {
    pixsDistance = iDistance * ((height-height*0.1666) * 0.025);
    line(pixsDistance*cos(radians(iAngle)),
         -pixsDistance*sin(radians(iAngle)),
         (width-width*0.505)*cos(radians(iAngle)),
         -(width-width*0.505)*sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  translate(width/2, height - height*0.074);

  strokeWeight(9);
  stroke(30,250,60);

  line(0,0,(height-height*0.12)*cos(radians(iAngle)),
            -(height-height*0.12)*sin(radians(iAngle)));
  popMatrix();
}

void drawText() {
  pushMatrix();

  fill(0);
  noStroke();
  rect(0, height-height*0.0648, width, height);

  fill(98,245,31);
  textSize(40);

  text("Angle: " + iAngle + "°", width - width*0.48, height - height*0.0277);
  text("Distance:", width - width*0.26, height - height*0.0277);

  if (iDistance < 40) {
    text("        " + iDistance + " cm", width - width*0.225, height - height*0.0277);
  } else {
    text("Out of Range", width - width*0.225, height - height*0.0277);
  }

  popMatrix();
}
