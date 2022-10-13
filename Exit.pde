class Exit {
  PVector pos;
  int size = 15; 
  
  // Constructor
  Exit(int x, int y) {
   pos = new PVector(x, y); 
  }
  
  // draw the exit as a door image
  void draw() {
    image(door, pos.x, pos.y, size, size);
  }
  
}
