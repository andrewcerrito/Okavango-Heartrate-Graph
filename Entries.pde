class Entries {
  
  String person;
  float heartrate;
  String datetime;
  Date date;
  
  PVector pos = new PVector();
  PVector tpos = new PVector();
  
  void update() {
    pos.lerp(tpos,0.1);
}

void render() {
  pushMatrix();
    translate(pos.x, pos.y);
    //noStroke();
    //rect(0, 0, 1, 1);
    stroke(255);
    point(0,0);
    popMatrix();
}
}

