class Item {
  int id;
  PVector pos;
  String name;
  String desc;
  String type;
  int func;
  int size = 15;
  
  // defaulting PVector to (-1,-1) when just setting Item for the player
  Item(int id) {
   this.id = id;
   pos = new PVector(-1, -1);
   if (id == 0) {
     name = "Hands";
     desc = "You were born with them";
     type = "Melee";
     func = 0;
   } else if (id == 1) {
     name = "Rock";
     desc = "Can be found everywhere";
     type = "Ranged";
     func = 0;
   } 
  }
  
  // Contstructor for items to be placed in the overworld
  Item(int id, int x, int y) {
    this.id = id;
    pos = new PVector(x, y);
    if (id == 2) {
     name = "Rusty Sword";
     desc = "A rusty sword, go figure (+1 STR)";
     type = "Melee";
     func = 1;
   } else if (id == 3) {
     name = "Slingshot";
     desc = "Shoots rocks (+1 DEX)";
     type = "Ranged";
     func = 1;
   } else if (id == 4) {
     name = "Health Potion";
     desc = "Heals for 10 health points";
     type = "Potion";
     func = 10;
   } else if (id == 5) {
     name = "Large Health Potion";
     desc = "Heals for 20 health points";
     type = "Potion";
     func = 20;
   } else if (id == 6) {
     name = "Treasure";
     desc = "Shiny";
     type = "Treasure";
     func = 0;
   } else if (id == 7) {
     name = "Steel Sword";
     desc = "A well forged sword (+3 STR)";
     type = "Melee";
     func = 3;
   } else if (id == 8) {
     name = "Bow";
     desc = "A regular bow (+2 DEX)";
     type = "Ranged";
     func = 2;
   } else if (id == 9) {
     name = "Zweihander";
     desc = "A very tall sword (+8 STR)";
     type = "Melee";
     func = 8;
   } else if (id == 10) {
     name = "Gun";
     desc = "Who left this here? (+7 DEX)";
     type = "Ranged";
     func = 7;
   }
  }
  
  // draw the items as a chest image
  void draw() {
    if (pos.x != -1 && pos.y != -1) {
      image(chest, pos.x, pos.y, size, size);
    }
  }
  
  
}
