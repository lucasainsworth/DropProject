class Note {
  float m_nx;
  float m_ny;
  int m_hue;
  float m_bright;
  int m_setTimer;

  //Constructor
  Note(float im_nx, float im_ny, int im_hue, float im_bright) {
    m_nx=im_nx;
    m_ny=im_ny;
    m_hue=im_hue;
    m_bright = im_bright;
  }

  //Methods }

  //draw key

  void display(boolean i_bcollision) {

    // don't know why, but thinking this will help keep all keys from flashing at once later...
    boolean bcollision= i_bcollision;
    // set a timer running always...    
    m_setTimer++;
    stroke(0);
    strokeWeight(1);
    strokeJoin(ROUND);

    //flash if collision == true, then fade
    if (bcollision == true) {
      m_setTimer = 0;
      m_bright = 100;
    } 

    if ((m_bright>50) && m_setTimer>5) {
      m_bright = m_bright-5;
    }


    //draw key using the fill information from above.
    fill (color(m_hue, 70, m_bright));
    rect(m_nx, m_ny, (2*unitWidth), height/75);
    noStroke();
  }
}

