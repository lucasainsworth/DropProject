
//Opens Open Sound Control library, allowing sending and recieving signals over the local network using IP addrss and port #.
import oscP5.*;
import netP5.*;
OscP5 oscP5;

float accelLaunchX = 0;
float accelLaunchY = 0;
float gx_accelerometer = 0.0;
float gy_accelerometer = 0.0;
//float z_accel = 0.0;

//array to hold Note (key) objects
int g_n = 5;
Note[] n = new Note[g_n];

//Array list for balls
ArrayList<Ball> group;

//vairables for calculating initial speed
float vect1x = 0;
float vect1y = 0;
float vect2x =0;
float vect2y = 0;

//unitWidth is used to divide up the screen for Note placement
float unitWidth;

//import sound library "minim"

import ddf.minim.*;
Minim minim;
AudioSample c4;
AudioSample e4;
AudioSample g4;
AudioSample c5;
AudioSample e5;

void setup() {
  colorMode(HSB, 360, 100, 100);
  size (1400, 900
 );
  smooth();
  noStroke();
  
  
  /* start oscP5, listening for incoming messages at port 8000 */
  oscP5 = new OscP5(this,8000);

  //Constructing the Note (key) objects
  unitWidth= (width/16);
  n = new Note[5];
  //xpos, ypos, hue (0-360 colorwheel), brightness (0-100)
  n[0] = new Note(unitWidth, (height-(height/20)), 237, 50);
  n[1] = new Note(4*unitWidth, (height-(height/20)), 179, 50);
  n[2] = new Note(7*unitWidth, (height-(height/20)), 130, 50);
  n[3] = new Note(10*unitWidth, (height-(height/20)), 70, 50);
  n[4] = new Note(13*unitWidth, (height-(height/20)), 3, 50);

  //Constructing the Ball list
  group = new ArrayList<Ball>();
  
  //import audio samples
  minim = new Minim(this);
  
  c4 = minim.loadSample("c4.mp3");
  e4 = minim.loadSample("e4.mp3");
  g4 = minim.loadSample("g4.mp3");
  c5 = minim.loadSample("c5.mp3");
  e5 = minim.loadSample("e5.mp3");

  
}


void draw() {
  //clear background every frame
  background(0, 0, 99);


  //display keys, the boolean triggers the color flash
  for (int i=0; i<(g_n); i++) {

    boolean bcollision=false;

    n[i].display(bcollision);
  }

  //draw balls
  for (int i = 0; i<group.size() ; i++) {

    Ball curBall = group.get(i);
    curBall.drop();
    curBall.display();
    
    //volume control based on ball y speed.  Maps speed from 0-10 (average speed) to the gain range of +6 (loud) to -6 (softer)
    // the sound is only played if the gain value is above -5, to avoid constant playing when a ball comes to rest on a key.
    float gain = map (curBall.vy, 0, 10, -26, 3);
println(curBall.vy);

    //check for collisions, key1
    if ((curBall.by >=((height-height/20)-(height/110)) && curBall.by <=(height-height/20)+(height/55)) &&(curBall.bx >=unitWidth) && (curBall.bx <= 3*unitWidth)) {
      curBall.bounce();
      n[0].display(true);
      c4.setGain(gain);
      if (gain>-25.5){ 
      c4.trigger();//play sound c4.wav
      }
    }
    //check for collisions, key2
    if ((curBall.by >=((height-height/20)-(height/110)) && curBall.by <=(height-height/20)+(height/55)) &&(curBall.bx >=4*unitWidth) && (curBall.bx <= 6*unitWidth)) {
      curBall.bounce();
      n[1].display(true);
      e4.setGain(gain);
      if (gain>-25.5){ 
      e4.trigger();
      }
    }   

    //check for collisions, key3
    if (curBall.by >=((height-height/20)-(height/110)) && curBall.by <=(height-height/20)+(height/55) && curBall.bx >=7*unitWidth && (curBall.bx <= 9*unitWidth)) {
      curBall.bounce();
      n[2].display(true);
      g4.setGain(gain);
      if (gain>-25.5){ 
      g4.trigger();
      }
    }   

    //check for collisions, key4
    if (curBall.by >=((height-height/20)-(height/110)) && curBall.by <=(height-height/20)+(height/55) &&(curBall.bx >=10*unitWidth) && (curBall.bx <= 12*unitWidth)) {
      curBall.bounce();
      n[3].display(true);
      c5.setGain(gain);
      if (gain>-25.5){ 
      c5.trigger();
      }
    }   

    //check for collisions, key5
    if ((curBall.by >=((height-height/20)-(height/110)) && curBall.by <=(height-height/20)+(height/55) &&curBall.bx >=13*unitWidth) && (curBall.bx <= 15*unitWidth)) {
      curBall.bounce();
      n[4].display(true);
      e5.setGain(gain);
      if (gain>-25.5){ 
      e5.trigger();
      }
    }

    //culling the group
    if (group.size()>18) {
      group.remove(1);
    }
  }
}

//this section calculates initial position and speed based on a mouse drag.
//and creates a new ball with the initial coords and speed.
void mousePressed() {
  //initial coords for vector calc.
  vect1x = mouseX;
  vect1y = mouseY;
}

void mouseReleased () {
  vect2x = mouseX;
  vect2y = mouseY;
  float vx = ((vect2x - vect1x)/50);
  float vy = ((vect2y - vect1y)/50); 
  group.add(new Ball(mouseX, mouseY, vx, vy, .05));
}
//this section
void oscEvent(OscMessage theOscMessage) {

   //Check for presence of acceleromiter message in OSC signal, called "accxyz," default in TouchOSC 
    if(theOscMessage.checkAddrPattern("/accxyz")== true){
     
      gx_accelerometer = theOscMessage.get(0).floatValue(); 
      gy_accelerometer = theOscMessage.get(1).floatValue();
      //gz_accelerometer = theOscMessage.get(2).floatValue();
  
}
    else {println("no accelerometer connection");
    }
    
    if (gx_accelerometer > 1.1){
constrain(gx_accelerometer, 1.1, 3);
 accelLaunchX = gx_accelerometer;
float xl = map(accelLaunchX, 1.1, 3, -1, -18);
 accelLaunchY = gy_accelerometer;
float yl = map(accelLaunchY, 2,-2, -1, -4.5);
 
 println(accelLaunchX);

group.add(new Ball(width, height/2 + (10*yl), xl, yl, 0.2));

    }
}



//end audio access..  The sound library requires closing all open sound objects to realease the memory.
void stop()
{
c4.close();
e4.close();
g4.close();
c5.close();
e5.close();
  minim.stop();

  super.stop();
}

