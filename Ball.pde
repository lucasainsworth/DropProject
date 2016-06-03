class Ball {
  float bx, by;
  float vy;
  float vx;
  float accel;


  //Constructor
  Ball (float ibx, float  iby, float  ivx, float ivy, float iaccel) {
    bx=ibx;
    by=iby;
    vy=ivy;
    vx=ivx;
    accel=iaccel;
  }
  //apply gravity and x movement
  void drop() {
    vy += accel;
    by += vy;
    bx += vx;
  }
  //Draw the circle at location defined by drop()
  void display() {
fill(0);
    ellipse (bx, by, height/55, height/55);
  }
  //when called, the ball is set to the hight of the top of the key and velocity is reversed.
  void bounce() {
    by = ((height-(height/20))-(height/110));
    vy = (-0.6 *vy);
  }
}


