final class Player {
  float ORIENTATION_INCREMENT = PI/32 ;
  float SAT_RADIUS = 0.1f ;
  int size = 15;

  // Static Data
  PVector pos;
  float orientation ;
  int maxHP;
  int currentHP;
  int lvl;
  int expMax;
  int exp;
  int STR;
  int DEX;
  float SPD;
  Item currMelee;
  Item currRange;
  public List<Item> INV;
  
  // Kinematic Data For Movement
  public PVector velocity = new PVector(0, 0) ;
  
  // Player constructor
  Player(int x, int y) {
   pos = new PVector(x, y);
   orientation = 0;
   // Max and current health
   maxHP = 20;
   currentHP = 20;
   // Level
   lvl = 1;
   // 5 experience to level up
   expMax = 5;
   exp = 0;
   // stats
   // change back to STR = 2
   STR = 2;
   DEX = 1;
   // change back to SPD = 3
   SPD = 3;
   INV = new ArrayList<Item>();
   INV.add(new Item(0));
   INV.add(new Item(1));
   currMelee = new Item(0);
   currRange = new Item(1);
  }
  
  // getter
  public PVector getPos() { return pos;}  
  
  // player draw method
  void draw() {
    //draw player
    fill(0, 0, 255);
    ellipse(pos.x, pos.y, size, size);
    // Show orientation
    int newxe = (int)(pos.x + 5 * cos(orientation)) ;
    int newye = (int)(pos.y + 5 * sin(orientation)) ;
    fill(0);
    ellipse(newxe, newye, 5, 5) ;  
  }
  
  // update position and orientation
  void integrate(PVector targetVel) {
    float distance = targetVel.mag() ;
    
    // If close enough, done.
    if (distance < SAT_RADIUS) return ;
    
    velocity = targetVel ;
    
    pos.add(velocity) ;
    // Stop moving at the edge of screen
    if ((pos.x < 0) || (pos.x > width)) velocity.x = 0 ;
    if ((pos.y < 0) || (pos.y > height)) velocity.y = 0;
        
    // move a bit towards velocity:
    // turn vel into orientation
    float targetOrientation = atan2(velocity.y, velocity.x) ;
    
    // Will take a frame extra at the PI boundary
    if (abs(targetOrientation - orientation) <= ORIENTATION_INCREMENT) {
      orientation = targetOrientation ;
      return ;
    }

    // if it's less than me, then how much if up to PI less, decrease otherwise increase
    if (targetOrientation < orientation) {
      if (orientation - targetOrientation < PI) orientation -= ORIENTATION_INCREMENT ;
      else orientation += ORIENTATION_INCREMENT ;
    }
    else {
     if (targetOrientation - orientation < PI) orientation += ORIENTATION_INCREMENT ;
     else orientation -= ORIENTATION_INCREMENT ; 
    }
    
    // Keep in bounds
    if (orientation > PI) orientation -= 2*PI ;
    else if (orientation < -PI) orientation += 2*PI ;    
  }
  
  // exp gain from killing mobs, also used for levelling and stat increases
  void getEXP(Mob mob) {
   exp += mob.expYield;
   if (exp >= expMax) {
    exp -= expMax;
    lvl += 1;
    expMax += 1;
    maxHP += 5;
    currentHP += 5;
    STR += 2;
    DEX += 2;
    SPD += 0.5;
   }
  }
  
  // method for changing equipped item or using potions, encounts for using potion at full health
  // to not waste them
  void useEquipment(Item item){
    if (item.type == "Melee") {
      STR -= currMelee.func;
      currMelee = item;
      STR += currMelee.func;
    } else if (item.type == "Ranged") {
      DEX -= currRange.func;
      currRange = item;
      DEX += currRange.func;
    } else if (item.type == "Potion") {
      if (currentHP == maxHP) {
        
      } else if (currentHP != maxHP) {
        currentHP += item.func;
        INV.remove(item);
        if (currentHP > maxHP) {
          currentHP = maxHP;
        }
      }
    }
  }
  
  // counting the number of treasures
  int getTotalTreasure() {
    int count = 0;
    for (Item item: INV) {
      if (item.type == "Treasure") {
        count++;
      }
    }
    return count;
  }
  
}
