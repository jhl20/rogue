class Room {
  PVector pos;
  int Width;
  int Height;
  
  // Constructor for rooms in the dungeon
  Room(int x, int y, int Width, int Height) {
   pos = new PVector(x, y);
   this.Width = Width;
   this.Height = Height;
  }
  
  // getters
  public PVector getPos() {return pos;}
  public void setPos(int x, int y) {pos = new PVector(x, y);}
  public int getWidth() {return Width;}
  public int getHeight() {return Height;}
  
  // place rooms into the dungeon tiles
  public void place(int[][] tiles) {
    // Fill the room with floor tiles
    for (int xPOS = (int)pos.x; xPOS < (int)pos.x + Width; xPOS++) {
      for (int yPOS = (int)pos.y; yPOS < (int)pos.y + Height; yPOS++) {
        tiles[xPOS][yPOS] = 1;
      }
    }
  }
    
}
