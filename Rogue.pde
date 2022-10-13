import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Iterator;

// Images for backgrounds and chest
PImage dungeonBG;
PImage statBG;
PImage slime;
PImage zombie;
PImage crab;
PImage vampire;
PImage chest;
PImage door;
PImage escape;

// Size of blocks
int blockWidth, blockHeight;
// Size of map
int mapSize;
// Player
Player player;
// Store map
int[][] newMap;
// For the dungeon creation
Dungeon dungeon;
//int[][] tiles;
// Walls for some collision detection;
Wall[] walls;
// Items in each level
List<Item> items;

// Exit
Exit exit;

// For removing items when player picks them up
List<Item> toRemove;
boolean removing;

// List of mobs
List<Mob> mobs;
Mob fightingMob;

// booleans to control state of game
boolean moveLeft, moveRight, moveUp, moveDown;
boolean moving;
boolean battle;
boolean overworld;
boolean stats;
boolean encounterMessage;
boolean playerTurn;
boolean mobTurnA;
boolean mobTurnB;
boolean mobTurnR;
boolean battleWon;
boolean gameOver;
boolean equip;
boolean win;
int currEquip;
int diceRoll;
int time;
int wait;
int wait2;
int mobCount;
int dmg;
int level;
int colorCycle;
int mobsKilled;

//int targetX, targetY ;
PVector targetVel;

void setup() {
 // fullscreen
 fullScreen();
 // loading pngs
 dungeonBG = loadImage("dungeon.png");
 statBG = loadImage("stats.png");
 slime = loadImage("slime.png");
 zombie = loadImage("zombie.png");
 crab = loadImage("crab.png");
 vampire = loadImage("vampire.png");
 chest = loadImage("chest.png");
 door = loadImage("door.png");
 escape = loadImage("escape.png");
 // random seed 0 for testing
 //randomSeed(0);
 // How deep in the dungeon, 0 = starting floor
 level=0;
 // initialising on restart
 restart();
 }
 
 void restart() {
   
   // record how many mobs the player killed
   if (level == 0) {
     mobsKilled = 0;
   }
   
   colorMode(RGB, 255, 255, 255);
   mapSize = 32;
   moveLeft = false;
   moveRight = false;
   moveUp = false;
   moveDown = false;
   moving = false;
   battle = false;
   overworld = true;
   stats = false;
   encounterMessage = false;
   playerTurn = false;
   mobTurnA = false;
   mobTurnB = false;
   mobTurnR = false;
   battleWon = false;
   gameOver = false;
   removing = false;
   equip = false;
   win = false;
   currEquip = 0;
   diceRoll = 0;
   time = millis();
   // 3 seconds wait
   wait = 3000;
   // 2 seconds wait
   wait2 = 2000;
   mobCount = 0;
   dmg = 0;
    
   // build dungeon
   dungeon = new Dungeon();
   // creaing the map
   newMap = dungeon.buildMap(mapSize, mapSize);
   
   // initialising width and height
   blockWidth = displayWidth/newMap[0].length;
   blockHeight = displayHeight/newMap.length;
 
   // initialise array to be the size of all walls
   int i = 0;
   for (int row = 0; row < newMap.length; row++) {
     for (int col = 0; col < newMap[0].length; col++) {
       if (newMap[row][col]==0) {
         i++;
        }
      }
   }
   walls = new Wall[i]; 
   
   // iterate and add each wall to the array
   i = 0;
   for (int row = 0; row < newMap.length; row++) {
     for (int col = 0; col < newMap[0].length; col++) {
       if (newMap[row][col]==0) {
         walls[i] = new Wall(col*blockWidth, row*blockHeight, col*blockWidth+blockWidth, row*blockHeight+blockHeight);
         i++;
        }
      }
   }
   
   // create new player if level = 0, if level > 1 just update position
   if (level == 0) {
   // player spawned on a random tile in a room 
   player = new Player((int)random(dungeon.getRooms().get(0).getPos().y + 1, dungeon.getRooms().get(0).getPos().y + dungeon.getRooms().get(0).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(0).getPos().x + 1, dungeon.getRooms().get(0).getPos().x + dungeon.getRooms().get(0).getWidth() - 1) * blockHeight);         
   } else if (level > 0) {
     player.pos.x = (int)random(dungeon.getRooms().get(0).getPos().y + 1, dungeon.getRooms().get(0).getPos().y + dungeon.getRooms().get(0).getHeight() - 1) * blockWidth;
     player.pos.y = (int)random(dungeon.getRooms().get(0).getPos().x + 1, dungeon.getRooms().get(0).getPos().x + dungeon.getRooms().get(0).getWidth() - 1) * blockHeight;
   }
   
   // player not moving
   targetVel = new PVector(0, 0);
 
   // initialise arraylist for items
   items = new ArrayList<Item>();
   toRemove = new ArrayList<Item>();
   
   if (level == 0) {
   // 3 Initial items spawned for the player, 2 weapons and 1 potion, only spawned in first level
   items.add(new Item(2, (int)random(dungeon.getRooms().get(0).getPos().y + 1, dungeon.getRooms().get(0).getPos().y + dungeon.getRooms().get(0).getHeight() - 1) * blockWidth, 
                         (int)random(dungeon.getRooms().get(0).getPos().x + 1, dungeon.getRooms().get(0).getPos().x + dungeon.getRooms().get(0).getWidth() - 1) * blockHeight));
   items.add(new Item(3, (int)random(dungeon.getRooms().get(0).getPos().y + 1, dungeon.getRooms().get(0).getPos().y + dungeon.getRooms().get(0).getHeight() - 1) * blockWidth, 
                         (int)random(dungeon.getRooms().get(0).getPos().x + 1, dungeon.getRooms().get(0).getPos().x + dungeon.getRooms().get(0).getWidth() - 1) * blockHeight));
   items.add(new Item(4, (int)random(dungeon.getRooms().get(0).getPos().y + 1, dungeon.getRooms().get(0).getPos().y + dungeon.getRooms().get(0).getHeight() - 1) * blockWidth, 
                         (int)random(dungeon.getRooms().get(0).getPos().x + 1, dungeon.getRooms().get(0).getPos().x + dungeon.getRooms().get(0).getWidth() - 1) * blockHeight));
   }
   
   // add a single treasure in every level, looks the same as every other item
   // treasure can't spawn in the player room
   int treasureTemp = (int) random(1, dungeon.getRooms().size());
   items.add(new Item(6, (int)random(dungeon.getRooms().get(treasureTemp).getPos().y + 1, dungeon.getRooms().get(treasureTemp).getPos().y + dungeon.getRooms().get(treasureTemp).getHeight() - 1) * blockWidth, 
                         (int)random(dungeon.getRooms().get(treasureTemp).getPos().x + 1, dungeon.getRooms().get(treasureTemp).getPos().x + dungeon.getRooms().get(treasureTemp).getWidth() - 1) * blockHeight));
   
   // each room have a 30% chance of spawning a potion and a 5% chance of spawning a large potion
   for(i = 1; i < dungeon.getRooms().size(); i++) {
     if ((int) random(0,10) < 3) {
       items.add(new Item(4, (int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                             (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight));
     }
     if ((int) random(0, 20) < 1) {
       items.add(new Item(5, (int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                             (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight));
     }
   }
   // in the third level, there is a 50% chance for either the 'steel sword' or the 'bow' to be spawned.
   if (level == 2) {
     if ((int)random(0,2) == 1) {
       int itemTemp = (int) random(1, dungeon.getRooms().size());
       if ((int)random(0,2) == 1) {
         items.add(new Item(7, (int)random(dungeon.getRooms().get(itemTemp).getPos().y + 1, dungeon.getRooms().get(itemTemp).getPos().y + dungeon.getRooms().get(itemTemp).getHeight() - 1) * blockWidth, 
                               (int)random(dungeon.getRooms().get(itemTemp).getPos().x + 1, dungeon.getRooms().get(itemTemp).getPos().x + dungeon.getRooms().get(itemTemp).getWidth() - 1) * blockHeight));
       } else {
         items.add(new Item(8, (int)random(dungeon.getRooms().get(itemTemp).getPos().y + 1, dungeon.getRooms().get(itemTemp).getPos().y + dungeon.getRooms().get(itemTemp).getHeight() - 1) * blockWidth, 
                               (int)random(dungeon.getRooms().get(itemTemp).getPos().x + 1, dungeon.getRooms().get(itemTemp).getPos().x + dungeon.getRooms().get(itemTemp).getWidth() - 1) * blockHeight));
       }
     }
   }
   // in the fifth level, there is a 25% chance for a 'Zweihander' to spawn and a 25% chance for a 'gun' to spawn
   if (level == 4) {
     if ((int)random(0,100) < 25) {
       int itemTemp = (int) random(1, dungeon.getRooms().size());
       items.add(new Item(9, (int)random(dungeon.getRooms().get(itemTemp).getPos().y + 1, dungeon.getRooms().get(itemTemp).getPos().y + dungeon.getRooms().get(itemTemp).getHeight() - 1) * blockWidth, 
                             (int)random(dungeon.getRooms().get(itemTemp).getPos().x + 1, dungeon.getRooms().get(itemTemp).getPos().x + dungeon.getRooms().get(itemTemp).getWidth() - 1) * blockHeight));
     }
     if ((int)random(0,100) < 25) {
       int itemTemp = (int) random(1, dungeon.getRooms().size());
       items.add(new Item(10, (int)random(dungeon.getRooms().get(itemTemp).getPos().y + 1, dungeon.getRooms().get(itemTemp).getPos().y + dungeon.getRooms().get(itemTemp).getHeight() - 1) * blockWidth, 
                             (int)random(dungeon.getRooms().get(itemTemp).getPos().x + 1, dungeon.getRooms().get(itemTemp).getPos().x + dungeon.getRooms().get(itemTemp).getWidth() - 1) * blockHeight));
     }
   }
   
   
   
   
   // creating an exit in a random room which is not the one the player is placed in
   int exitTemp = (int) random(1, dungeon.getRooms().size());
   exit = new Exit((int)random(dungeon.getRooms().get(exitTemp).getPos().y + 1, dungeon.getRooms().get(exitTemp).getPos().y + dungeon.getRooms().get(exitTemp).getHeight() - 1) * blockWidth,
                   (int)random(dungeon.getRooms().get(exitTemp).getPos().x + 1, dungeon.getRooms().get(exitTemp).getPos().x + dungeon.getRooms().get(exitTemp).getWidth() - 1) * blockHeight);
   
   
   // initialise arraylist for mobs
   mobs = new ArrayList<Mob>();
   
   // curated psudo-random generation for mobs in each level
   // initial level: 75% slime, 20% zombie, 5% vampire spawn chance
   if (level == 0) {
   for(i = 1; i < dungeon.getRooms().size(); i++) {
     int spawnChance = (int) random(0,100);
     if (spawnChance < 75) {
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 0));
       } else if (spawnChance >= 75 && spawnChance < 95){
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 1));
       } else {
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 3));
       }
     }
   }
   // second level : 50% slime, 40% zombie, 7% crab, 3% vampire 
   if (level == 1) {
   for(i = 1; i < dungeon.getRooms().size(); i++) {
     int spawnChance = (int) random(0,100);
     if (spawnChance < 50) {
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 0));
       } else if (spawnChance >= 50 && spawnChance < 90){
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 1));
       } else if (spawnChance >= 90 && spawnChance < 97){
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 2));
       } else {
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 3));
       }
     }
   }
   // third level : 20% slime, 60% zombie, 15% crab, 5% vampire 
   if (level == 2) {
   for(i = 1; i < dungeon.getRooms().size(); i++) {
     int spawnChance = (int) random(0,100);
     if (spawnChance < 20) {
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 0));
       } else if (spawnChance >= 20 && spawnChance < 80){
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 1));
       } else if (spawnChance >= 80 && spawnChance < 95){
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 2));
       } else {
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 3));
       }
     }
   }
   // fourth level : 5% slime, 5% zombie, 70% crab, 20% vampire 
   if (level == 3) {
   for(i = 1; i < dungeon.getRooms().size(); i++) {
     int spawnChance = (int) random(0,100);
     if (spawnChance < 5) {
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 0));
       } else if (spawnChance >= 5 && spawnChance < 10){
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 1));
       } else if (spawnChance >= 10 && spawnChance < 80){
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 2));
       } else {
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 3));
       }
     }
   }
   // last level : 2% slime, 8% zombie, 10% crab, 80% vampire 
   if (level == 4) {
   for(i = 1; i < dungeon.getRooms().size(); i++) {
     int spawnChance = (int) random(0,100);
     if (spawnChance < 2) {
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 0));
       } else if (spawnChance >= 2 && spawnChance < 10){
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 1));
       } else if (spawnChance >= 10 && spawnChance < 20){
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 2));
       } else {
       mobs.add(new Mob((int)random(dungeon.getRooms().get(i).getPos().y + 1, dungeon.getRooms().get(i).getPos().y + dungeon.getRooms().get(i).getHeight() - 1) * blockWidth, 
                       (int)random(dungeon.getRooms().get(i).getPos().x + 1, dungeon.getRooms().get(i).getPos().x + dungeon.getRooms().get(i).getWidth() - 1) * blockHeight, 3));
       }
     }
   }
}  

void draw() {
  // overworld gamplay
  if (overworld) {
  dungeonBG.resize(width, height);
  background(dungeonBG);
  fill(100);
  noStroke();
  
  // place a rectangle for all areas that player, mobs and items can spawn and move on
  for (int row = 0; row < newMap.length; row++) {
    for (int col = 0; col < newMap[0].length; col++) {
      if (newMap[row][col]==1) {
        rectMode(CORNER);
        rect(col * blockWidth, row * blockHeight, blockWidth, blockHeight) ;
      }
    }
  }
  
  stroke(0);
  
  // draw player and integrate
  player.draw();
  player.integrate(targetVel) ;
  
  // draw exit
  exit.draw();
  // exit collision
  if (player.pos.x+player.size/2 > exit.pos.x && player.pos.x-player.size/2 < exit.pos.x+exit.size && player.pos.y+player.size/2 > exit.pos.y && player.pos.y-player.size/2 < exit.pos.y+exit.size) {
    level++;
    restart();
  }
  
  // draw items and collision detection to add items to the player
  for(Item item: items){
   item.draw(); 
   if (player.pos.x+player.size/2 > item.pos.x && player.pos.x-player.size/2 < item.pos.x+item.size && player.pos.y+player.size/2 > item.pos.y && player.pos.y-player.size/2 < item.pos.y+item.size) {
     toRemove.add(item);
     removing = true;
   }
  }
  if (removing) {
    player.INV.addAll(toRemove);
    items.removeAll(toRemove);
    toRemove.clear();
  }
  
  // draw mobs and integrate movement after 3 seconds (grace period so when player runs, they can get away from mobs)
  for(Mob mob: mobs){
   mob.draw(); 
   if(millis() - time >= wait) {
   mob.integrate();
   }
  }
  
  // wall collision for player with walls and mobs with walls
  for (int i = 0; i < walls.length; i++){
    walls[i].coll(); //initialize wall collision
    walls[i].mobColl();
  }
  
  // "removing" mob after beating it, setting its position where the player can't reach
  if (battleWon) {
    mobs.set(mobCount, new Mob());
    battleWon = false;
  }
  
  // collision detection with mobs, wait 2 seconds in case players successfully run from battle
  for(Mob mob: mobs){
    if(millis() - time >= wait2) {
      if (mob.getPos().y - mob.size/2 < player.pos.y + player.size/2 && mob.getPos().y + mob.size/2 > player.pos.y - player.size/2 && mob.getPos().x - mob.size/2 < player.pos.x + player.size/2 && mob.getPos().x + mob.size/2 > player.pos.x - player.size/2) {
        // if collion with mob, stop movement and start battle with mob
        moveLeft = false;
        moveUp = false;
        moveDown = false;
        moveRight = false;
        targetVel.x = 0;
        targetVel.y = 0;
        moving = false;
        fightingMob = mob;
        mobCount = mobs.indexOf(mob);
        overworld = false;
        battle = true;
        encounterMessage = true;
      }
    }
  }
  
  // Instructions
  textSize(20);
  fill(255);
  text("Press S to bring up Status and Inventory and Arrow Keys to move", width/100, 99*height/100);
  text("Goal: Collect treasures, level up and escape floor 5", 65*width/100, 99*height/100);
  text("You are on floor " + (level+1), 45*width/100, 99*height/100);
  
  }
  
  // battle screen, main game state paused
  if (battle) {
    if (fightingMob.type == "Slime") {
      slime.resize(width, height);
      background(slime);
    }
    if (fightingMob.type == "Zombie") {
      zombie.resize(width, height);
      background(zombie);
    }
    if (fightingMob.type == "Giant Crab") {
      crab.resize(width, height);
      background(crab);
    }
    if (fightingMob.type == "Vampire") {
      vampire.resize(width, height);
      background(vampire);
    }
    textSize(40);
    if (battleWon) {
     fill(0,0,100); 
    } else {
     fill(255);
    }
    text("Player Level: " + player.lvl, width/10, 2*height/20);
    text("Player Experience: " + player.exp + "/" + player.expMax, width/10, 3*height/20);
    text("Player HP: " + player.currentHP + "/" + player.maxHP, width/10, 4*height/20);
    if (encounterMessage) {
      text("Encountered a " + fightingMob.type, width/10, 12*height/20);
      text("Press A to attack with " + player.currMelee.name, width/10, 13*height/20);
      text("Press B to attack with " + player.currRange.name,width/10, 14*height/20);
      text("Press R to run", width/10, 15*height/20);
    }
    if (playerTurn) {
      text(fightingMob.atkDesc(diceRoll) + " and you take " + dmg + " damage", width/10, 12*height/20);
      text("Press A to attack with " + player.currMelee.name, width/10, 13*height/20);
      text("Press B to attack with " + player.currRange.name,width/10, 14*height/20);
      text("Press R to run", width/10, 15*height/20);
    }
    if (mobTurnA) {
      text("You attacked with " + player.currMelee.name, width/10, 13*height/20);
      text("You did " + dmg + " damage", width/10, 14*height/20);
      text("Press ENTER to continue", width/10, 15*height/20);
    }
    if (mobTurnB) {
      text("You attacked with " + player.currRange.name, width/10, 13*height/20);
      if (dmg > player.DEX) {
      text("You crit and did " + dmg + " damage", width/10, 14*height/20);
      } else {
      text("You did " + dmg + " damage", width/10, 14*height/20);
      }
      text("Press ENTER to continue", width/10, 15*height/20);
    }
    if (mobTurnR) {
      text("You failed to flee", width/10, 13*height/20);
      text("Press ENTER to continue", width/10, 14*height/20);
    }
    if (battleWon) {
      // 100 brightness = white
      fill(0,0,100);
      text("You deal " + dmg + " damage", width/10, 13*height/20);
      // cycle color using framerate using HSB instead of RGB
      colorCycle = frameCount%360;
      fill(color(colorCycle, 100, 100));
      text("You killed the " + fightingMob.type, width/10, 14*height/20);
      text("You gained " + fightingMob.expYield + " experience", width/10, 15*height/20);
      fill(0,0,100);
      text("Press ENTER to continue", width/10, 16*height/20);
    }
    if (gameOver) {
      fill(255,0,0);
      text(fightingMob.atkDesc(diceRoll) + " and you take " + fightingMob.atk(diceRoll) + " damage", width/10, 12*height/20);
      text("You Died to the " + fightingMob.type, width/10, 13*height/20);
      text("Press ENTER to restart", width/10, 14*height/20);
      fill(255);
    }
  }
  
  // stat and inv screen, overworld paused
  if (stats) {
    statBG.resize(width, height);
    background(statBG); 
    textSize(30);
    fill(0);
    text("------------STATS------------", width/10, 4*height/40);
    text("Level: " + player.lvl, width/10, 5*height/40);
    text("Experience: " + player.exp + "/" + player.expMax, width/10, 6*height/40);
    text("HP: " + player.currentHP + "/" + player.maxHP, width/10, 7*height/40);
    text("Strength: " + player.STR, width/10, 8*height/40);
    text("Dexterity: " + player.DEX, width/10, 9*height/40);
    text("Speed: " + player.SPD, width/10, 10*height/40);
    text("----------EQUIPMENT----------", 4*width/10, 4*height/40);
    text("Melee: " + player.currMelee.name, 4*width/10, 5*height/40);
    text("Ranged: " + player.currRange.name, 4*width/10, 6*height/40);
    if (!equip) {
    text("Press E to select item to use/equip", 4*width/10, 11*height/40);
    }
    text("----------INVENTORY----------", width/10, 13*height/40);
    for(int i = 0; i < player.INV.size(); i++) {
      text(player.INV.get(i).name , width/10, (14+i)*height/40);
    }
  }
  if (equip) {
    text("Press E to use/equip " + player.INV.get(currEquip).name, 4*width/10, 11*height/40);
    text("Press > to select next item", 4*width/10, 12*height/40);
    text("Press < to select prev item", 4*width/10, 13*height/40);
    text("<-- Equip/Use?", 4*width/10, (14+currEquip)*height/40);
    text("------ITEM DESCRIPTION------", 7*width/10, 4*height/40);
    text(player.INV.get(currEquip).desc , 7*width/10, 6*height/40);
  }
  
  if (level == 5) {
    overworld = false;
    win = true;
  }
  
  if (win) {
    textSize(40);
    escape.resize(width, height);
    background(escape);
    colorMode(HSB,360,100,100);
    // cycle color using framerate using HSB instead of RGB
    colorCycle = frameCount%360;
    fill(color(colorCycle, 100, 100));
    text("You Escaped!", 3*width/10, 8*height/20);
    text("Score: " + (player.lvl+player.getTotalTreasure()), 3*width/10, 9*height/20);
    text("Number of mobs killed: " + mobsKilled, 3*width/10, 10*height/20);
    text("Press ENTER if you want to play again", 3*width/10, 11*height/20);
  }
}

void keyPressed() {
  if (key == CODED) {
      // kinematic player movement
      switch (keyCode) {
        case LEFT:
          if (!moving && overworld) {
            moveLeft = true; 
            targetVel.x = -player.SPD;
            moving = true;
            break;
          }
        case RIGHT:
          if (!moving && overworld) {
            moveRight = true;
            targetVel.x = player.SPD;
            moving = true;
            break;
          }
        case UP:
          if (!moving && overworld) {
            moveUp = true;
            targetVel.y = -player.SPD;
            moving = true;
            break;
          }
        case DOWN:
          if (!moving && overworld) {
            moveDown = true;
            targetVel.y = player.SPD;
            moving = true;
            break;
          }
      }
    }
  }

void keyReleased() {
  if (key == CODED) {
    // kinematic player movement
    switch (keyCode) {
      case LEFT:
        if (moveLeft && overworld) {
          moveLeft = false;
          targetVel.x = 0;
          moving = false;
          break;
        } else break;
      case RIGHT:
        if (moveRight && overworld) {
          moveRight = false;
          targetVel.x = 0;
          moving = false;
          break;
        } else break;
      case UP:
        if (moveUp && overworld) {
          moveUp = false;
          targetVel.y = 0;
          moving = false;
          break;
        } else break;
      case DOWN:
        if (moveDown && overworld) {
          moveDown = false;
          targetVel.y = 0;
          moving = false;
          break;
        } else break;  
    }
  }
  // key to bring up stats and inventory
  if (key == 's') {
    if (overworld && !stats) {
      overworld = false;
      stats = true;
    } else if (!overworld && stats) {
      stats = false;
      overworld = true;
      equip = false;
    }
  }
  // key for equiping/using items
  if (key == 'e') {
    if (!equip && stats) {
      equip = true;
      currEquip = 0;
    } else if (equip && stats) {
      player.useEquipment(player.INV.get(currEquip));
      equip = false;
    }
  }
  // key press for > for item selection
  if (key == '.') {
    if (equip) {
      currEquip++;
      if (currEquip == player.INV.size()){
        currEquip = player.INV.size()-1;
      }
    }
  }
  // key press for < for item selection
  if (key == ',') {
    if (equip) {
      currEquip--;
      if (currEquip<0) {
        currEquip = 0;
      }
    }
  }
  // Used to progress the game depending on state or restart the game when player dies
  if (keyCode == ENTER) {
    if (mobTurnA || mobTurnB || mobTurnR) {
      diceRoll = (int) random(0, 10);
      dmg = fightingMob.atk(diceRoll);
      player.currentHP -= dmg;
      if (player.currentHP <= 0) {
        mobTurnA = false;
        mobTurnB = false;
        mobTurnR = false;
        gameOver = true;
      } else {
        mobTurnA = false;
        mobTurnB = false;
        mobTurnR = false;
        playerTurn = true;
      }
    } else if (battleWon) {
      fightingMob = new Mob();
      time = millis();
      battle = false;
      overworld = true;
      mobsKilled++;
      colorMode(RGB, 255, 255, 255);
    } else if (gameOver) {
      level = 0;
      restart();
    } else if (win) {
      level = 0;
      restart();
    }
  }
  // in battle, used to attack using melee weapon
  if (key == 'a') {
    if (encounterMessage) {
      dmg = player.STR;
      fightingMob.hp -= dmg;
      if (fightingMob.hp <= 0) {
        player.getEXP(fightingMob);
        encounterMessage = false;
        battleWon = true;
        colorMode(HSB,360,100,100);
      } else {
        encounterMessage = false;
        mobTurnA = true;
      }
    } else if (playerTurn) {
      dmg = player.STR;
      fightingMob.hp -= dmg;
      if (fightingMob.hp <= 0) {
        player.getEXP(fightingMob);
        playerTurn = false;
        battleWon = true;
        colorMode(HSB,360,100,100);
      } else {
        playerTurn = false;
        mobTurnA = true;
      }
    }
  }
  // in battle, use to attack using ranged weapon
  if (key == 'b') {
    if (encounterMessage) {
      if ((int) random(0, 10) < 3) {
        dmg = (int) (player.DEX*1.5);
        fightingMob.hp -= dmg;
      } else {
        dmg = player.DEX;
        fightingMob.hp -= dmg;
      }
      if (fightingMob.hp <= 0) {
        player.getEXP(fightingMob);
        encounterMessage = false;
        battleWon = true;
        colorMode(HSB,360,100,100);
      } else {
        encounterMessage = false;
        mobTurnB = true;
      }
    } else if (playerTurn) {
      if ((int) random(0, 10) < 3) {
        dmg = (int) (player.DEX*1.5);
        fightingMob.hp -= dmg;
      } else {
        dmg = player.DEX;
        fightingMob.hp -= dmg;
      }
      if (fightingMob.hp <= 0) {
        player.getEXP(fightingMob);
        playerTurn = false;
        battleWon = true;
        colorMode(HSB,360,100,100);
      } else {
        playerTurn = false;
        mobTurnB = true;
      }
    }
  } 
  // in battle, use to attempt to run away, 50% chance
  if (key == 'r') {
    if (encounterMessage) {
      if ((int) random(0, 2) == 0) {
        encounterMessage = false;
        battle = false;
        overworld = true;
        time = millis();
      } else {
        encounterMessage = false;
        mobTurnR = true;
      }
    } else if (playerTurn) {
      if ((int) random(0, 2) == 0) {
        playerTurn = false;
        battle = false;
        overworld = true;
        time = millis();
      } else {
        playerTurn = false;
        mobTurnR = true;
      }
    }
  }
}
