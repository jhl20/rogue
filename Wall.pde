class Wall {
 PVector pos;
 PVector endPos;
 
 // Wall constructor
 Wall(int x, int y, int x2, int y2) {
  pos = new PVector(x, y); 
  endPos = new PVector(x2, y2);   
 }
 
 // method for collision detection with player
 void coll() {
   // collision detection with walls.
   //when you hit the bottom of the wall
   if (player.getPos().y - player.size/2 < endPos.y && player.getPos().y + player.size/2 > pos.y && player.getPos().x - player.size/2 < endPos.x && player.getPos().x + player.size/2 > pos.x && moveUp == true){
     player.getPos().y = endPos.y + player.size/2;
   }
   //when you hit the top of the wall
   else if (player.getPos().y - player.size/2 < endPos.y && player.getPos().y + player.size/2 > pos.y && player.getPos().x - player.size/2 < endPos.x && player.getPos().x + player.size/2 > pos.x && moveDown == true){
     player.getPos().y = pos.y - player.size/2;
   }
   //when you hit the right of the wall
   else if (player.getPos().y - player.size/2 < endPos.y && player.getPos().y + player.size/2 > pos.y && player.getPos().x - player.size/2 < endPos.x && player.getPos().x + player.size/2 > pos.x && moveLeft == true){
     player.getPos().x = endPos.x + player.size/2;
   }
   //when you hit the left side of the wall
   else if (player.getPos().y - player.size/2 < endPos.y && player.getPos().y + player.size/2 > pos.y && player.getPos().x - player.size/2 < endPos.x && player.getPos().x + player.size/2 > pos.x && moveRight == true){
     player.getPos().x = pos.x - player.size/2;
   }
   //bound check for player
   if (player.getPos().x < 0) {
     player.getPos().x = 0 + player.size/2;
   }
   if (player.getPos().x + player.size/2 > displayWidth) {
     player.getPos().x = displayWidth - player.size/2;
   }
   if (player.getPos().y < 0) {
     player.getPos().y = 0 + player.size/2;
   }
   if (player.getPos().x + player.size/2 > displayWidth) {
     player.getPos().y = displayHeight - player.size/2;
   }
 }
 
 // method for collision detection with mobs
 void mobColl() {
   int i = 0;
   for (Mob mob: mobs) {
   //bound check to ensure mobs don't leave their spawn rooms
   if (mob.getPos().x - mob.size/2 < dungeon.getRooms().get(i+1).getPos().y * blockWidth) {
     mob.getPos().x = dungeon.getRooms().get(i+1).getPos().y * blockWidth + mob.size/2;
     mob.velocity = new PVector(0, 0);
     mob.dir = (int) random(0, 8);
   }
   if (mob.getPos().x + mob.size/2 > (dungeon.getRooms().get(i+1).getPos().y + dungeon.getRooms().get(i+1).getHeight()) * blockWidth) {
     mob.getPos().x = (dungeon.getRooms().get(i+1).getPos().y + dungeon.getRooms().get(i+1).getHeight()) * blockWidth - mob.size/2;
     mob.velocity = new PVector(0, 0);
     mob.dir = (int) random(0, 8);
   }
   if (mob.getPos().y - mob.size/2 < dungeon.getRooms().get(i+1).getPos().x * blockHeight) {
     mob.getPos().y = dungeon.getRooms().get(i+1).getPos().x * blockHeight + mob.size/2;
     mob.velocity = new PVector(0, 0);
     mob.dir = (int) random(0, 8);
   }
   if (mob.getPos().y + mob.size/2 > (dungeon.getRooms().get(i+1).getPos().x + dungeon.getRooms().get(i+1).getWidth()) * blockHeight) {
     mob.getPos().y = (dungeon.getRooms().get(i+1).getPos().x + dungeon.getRooms().get(i+1).getWidth()) * blockHeight - mob.size/2;
     mob.velocity = new PVector(0, 0);
     mob.dir = (int) random(0, 8);
   }
   i++;
   }
 }
 
 
 
}
