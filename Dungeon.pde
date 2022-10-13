class Dungeon {
  int MAX_ROOM_WIDTH = 10;
  int MAX_ROOM_HEIGHT = 8;
  int MIN_ROOM_WIDTH = 5;
  int MIN_ROOM_HEIGHT = 4;
  // ratios to calculate total rooms to place in the dungeon
  float ROOM_RATIO = 0.8;
  // stores all rooms, not including corridors 
  List<Room> rooms;
  // tiles used to store the whole level
  int[][] tiles;

  // getter
  public List<Room> getRooms() {return rooms; }

  // used to build the map by placing rooms and tunnels in the level
  public int[][] buildMap(int Width, int Height) {
    int[][] tiles = new int[Width][Height];
    // clear the map
    for (int x = 0; x < Width; x++) {
      for (int y = 0; y < Height; y++) {
        tiles[x][y] = 0;
      }
    }
    // Build the rooms and tunnels
    rooms = placeRooms(tiles);
    placeTunnels(tiles, rooms);
    this.tiles = tiles;
    return tiles;
  }
  
  private List<Room> placeRooms(int[][] tiles) {
    int mapWidth = tiles.length;
    int mapHeight = tiles[0].length;
    int roomsInRow = mapWidth / MAX_ROOM_WIDTH;
    int roomsInCol = mapHeight / MAX_ROOM_HEIGHT;
    int maxRooms = roomsInRow * roomsInCol;
    // use an array of booleans to represent which rooms have been used
    boolean[] usedRooms = new boolean[maxRooms];
    // generate the number of total rooms based on the ratios
    int totalRooms = (int) (maxRooms * ROOM_RATIO);
    // generate the rooms
    List<Room> rooms = new ArrayList<Room>(totalRooms);
    Room room;
    int roomCell;
    int Width, Height, x, y;
    for (int i = 0; i < totalRooms; i++) {
      // keep generating a room cell until we find an unused one
      do {
        roomCell = (int) random(0, maxRooms - 1);
      } while (usedRooms[roomCell]);
      usedRooms[roomCell] = true;
      // generate room width and height of room
      Width = (int) random(MIN_ROOM_WIDTH, MAX_ROOM_WIDTH);
      Height = (int) random(MIN_ROOM_HEIGHT, MAX_ROOM_HEIGHT);
      // generate x and y position based on cell x and y for the room
      x = (roomCell % roomsInRow) * MAX_ROOM_WIDTH;
      // random offset after the x and y position of the rooms  
      // with the remaining space in the cell for more variation
      // and less symmetrical levels
      x += random(0, MAX_ROOM_WIDTH - Width);
      y = (roomCell / roomsInRow) * MAX_ROOM_HEIGHT;
      y += random(0, MAX_ROOM_HEIGHT - Height);
      room = new Room(x, y, Width, Height);
      room.place(tiles);
      rooms.add(room);
    }
    return rooms;
  }
  
  private void placeTunnels(int[][] tiles, List<Room> rooms) {
    int changeX, changeY, changeXSign, changeYSign;
    int currentX, currentY;
    boolean moveInX;
    int tunneler, tunnelLength;
    Room currRoom, goalRoom;
    // iterate through each room to build the tunnels between rooms
    Iterator<Room> iterator = rooms.iterator();
    currRoom = iterator.next();
    while (iterator.hasNext()) {
        goalRoom = iterator.next();
        // calculate the starting position and distance remaining
        // based on the center of the two rooms
        currentX = (int) currRoom.pos.x + (currRoom.Width / 2);
        currentY = (int) currRoom.pos.y + (currRoom.Height / 2);
        // X distance between center of rooms
        changeX = ((int)goalRoom.pos.x + (goalRoom.Width / 2)) - currentX;
        // Y distance between center of rooms
        changeY = ((int)goalRoom.pos.y + (goalRoom.Height / 2)) - currentY;
        // determine sign to tunnel in for both directions, either pos or neg
        // 0 is always a positive sign
        if (changeX == 0) {
          changeXSign = 1;
        } else {
          // checking the sign if there is distance between the two x centers
          changeXSign = (int)(changeX / abs(changeX));
        }
        if (changeY == 0) {
          changeYSign = 1;
        } else {
          // checking the sign if there is distance between the two y centers
          changeYSign = (int)(changeY / abs(changeY));
        }
        // iterate until we only have 1 direction left
        // and while the x and y of both room centers are different
        while (!(changeX == 0 && changeY == 0)) {
            // randomly choose a direction to move in
            // if value is 1, moveInX is true and so it moves in the x axis
            moveInX = (int) random(0, 1) == 1;
            // if we are at 0 of current side, switch direction
            // reached the x value of the center 
            if (moveInX && changeX == 0) {
              // move in Y axis
              moveInX = false;
            }
            if (!moveInX && changeY == 0) {
              moveInX = true;
            }
            // tunnel a random length, based on if moving in x axis or y axis
            tunnelLength = (int) random(1, (int)(abs(moveInX ? changeX : changeY)));
            // tunneling
            for (tunneler = 0; tunneler < tunnelLength; tunneler++) {
                if (moveInX) {
                  currentX += changeXSign * 1;
                } else {
                  currentY += changeYSign * 1;
                }
                // Placing the tunnel tile
                tiles[currentX][currentY] = 1;
            }
            // update changes
            if (moveInX) {
              changeX -= changeXSign * tunnelLength;
            } else {
              changeY -= changeYSign * tunnelLength;
            }
        }
        currRoom = goalRoom;
    }
  }
  
  
}
