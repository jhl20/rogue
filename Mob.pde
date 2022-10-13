class Mob {
 float ORIENTATION_INCREMENT = PI/32 ;
 float SAT_RADIUS = 0.1f ;
 String type;
 PVector pos;
 float orientation ;
 int hp;
 int attack;
 int expYield;
 int size;
 float speed;
 // move in direction
 int dir;
 boolean move;
 
 // Kinematic Data
 public PVector velocity = new PVector(0, 0);
 
 //Mob(float x, float y) {
 // type = "Vampire";
 // pos = new PVector(x, y);
 // health = 10;
 // orientation = 0;
 // dir = (int) random(0, 4);
 // size = 15;
 // //size = 8;
 // speed = 2.5;
 //}
 
 // dummy mob to fill array
 Mob() {
   pos = new PVector(-1, -1);
   hp = 0;
   orientation = 0;
   // 8 so wont move
   dir = 8;
   move = false;
 }
 
 // Different mobs
 Mob(float x, float y, int type) {
   move = true;
   pos = new PVector(x, y);
   orientation = 0;
   dir = (int) random(0, 8);
   if (type == 0) {
     this.type = "Slime";
     hp = 5;
     attack = 1;
     expYield = 1;
     size = 8;
     speed = 4;
   } else if (type == 1) {
     this.type = "Zombie";
     hp = 10;
     attack = 3;
     expYield = 2;
     size = 15;
     speed = 1.5;
   } else if (type == 2) {
     this.type = "Giant Crab";
     hp = 30;
     attack = 10;
     expYield = 6;
     size = 30;
     speed = 0.5;
   } else if (type == 3) {
     this.type = "Vampire";
     hp = 50;
     attack = 5;
     expYield = 12; 
     size = 15;
     speed = 2.5;
   }
 }
 
 public PVector getPos() { return pos;}
  
  void draw() {
    // only draw mobs if they're moving
    if (move) {
    if (type == "Rock") {
     fill(90,77,65); 
    } else if (type == "Slime") {
     fill(101,255,0); 
    } else if (type == "Zombie") {
     fill(120,193,101); 
    } else if (type == "Giant Crab") {
     fill(205,127,132);
    } else if (type == "Vampire") {
     fill(255,0,0); 
    }
    
    ellipse(pos.x, pos.y, size, size);
    // Show orientation
    int newxe = (int)(pos.x + 5 * cos(orientation)) ;
    int newye = (int)(pos.y + 5 * sin(orientation)) ;
    fill(0);
    ellipse(newxe, newye, 5, 5) ; 
    }
  }
  
    // update position and orientation
  void integrate() {
    PVector Vel = new PVector(0, 0);
    // mobs can move horizontal, vertical and diagonal and change after hitting a wall.
    if (dir == 0) {
      Vel = new PVector(speed, 0);
    }
    if (dir == 1) {
      Vel = new PVector(-speed, 0);
    }
    if (dir == 2) {
      Vel = new PVector(0, speed);
    }
    if (dir == 3) {
      Vel = new PVector(0, -speed);
    }
    if (dir == 4) {
      Vel = new PVector(speed, speed);
    }
    if (dir == 5) {
      Vel = new PVector(-speed, speed);
    }
    if (dir == 6) {
      Vel = new PVector(speed, -speed);
    }
    if (dir == 7) {
      Vel = new PVector(-speed, -speed);
    }
    
   //chase player if they get too close, 5 times the mob size
   if (player.getPos().y - player.size/2 < pos.y + size*5 && player.getPos().y + player.size/2 > pos.y - size*5 && player.getPos().x - player.size/2 < pos.x + size*5 && player.getPos().x + player.size/2 > pos.x - size*5){
     Vel = new PVector(player.getPos().x - pos.x, player.getPos().y - pos.y);
   }
    
    
    
    float distance = Vel.mag() ;
    
    // If close enough, done.
    if (distance < SAT_RADIUS) return ;
    
    velocity = Vel ;
    if (distance > speed) {
      velocity.normalize() ;
      velocity.mult(speed) ;
    }
    
    pos.add(velocity) ;
     //Apply an impulse to bounce off the edge of the screen
    //if ((pos.x < 0) || (pos.x > width)) velocity.x = -velocity.x ;
    //if ((pos.y < 0) || (pos.y > height)) velocity.y = -velocity.y ;
        
    //move a bit towards velocity:
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
  
  // hard coded chance for mob attacks, rng is from 0 to 9 so 10% increments
  public int atk(int rng){
    if (type == "Slime") {
      if (rng < 5) {
       return 0;
      } else if (rng >= 5) {
       return attack;
      }
    } else if (type == "Zombie") {
      if (rng < 2) {
       return 0;
      } else if (rng >= 2) {
       return attack;
      }
    } else if (type == "Giant Crab") {
      if (player.DEX < 9) {
        if (rng < 3) {
         return 0;
        } else if (rng >= 3) {
         return attack;
        }
      } else return 0;
    } else if (type == "Vampire") {
      if (player.currentHP > 10) {
        if (rng < 1) {
          return 0;
        } else if (rng >= 1 && rng < 7) {
          return attack;
        } else if (rng >= 7) {
          return attack*2; 
        }
      } else if (player.currentHP <= 10) {
        if (rng < 2) {
          return 0;
        } else if (rng >= 2) {
          return attack*2; 
        }
      }
    } 
    return 0;
  }
  
  // mob attack descriptions to match their attacks
  public String atkDesc(int rng){
    if (type == "Slime") {
      if (rng < 5) {
       return "Slime did nothing";
      } else if (rng >= 5) {
       return "Slime attacks";
      }
    } else if (type == "Zombie") {
      if (rng < 2) {
       return "Zombie misses";
      } else if (rng >= 2) {
       return "Zombie bites you";
      }
    } else if (type == "Giant Crab") {
      if (player.DEX < 9) {
        if (rng < 3) {
         return "Giant Crab misses";
        } else if (rng >= 3) {
         return "Giant Crab hits hard";
        }
      } else return "You dodge the Giant Crabs claw";
    } else if (type == "Vampire") {
      if (player.currentHP > 10) {
        if (rng < 1) {
          return "Vampire misses";
        } else if (rng >= 1 && rng < 7) {
          return "Vampire hits you";
        } else if (rng >= 7) {
          return "Vampire drains you"; 
        }
      } else if (player.currentHP <= 10) {
        if (rng < 2) {
          return "Vampire aims for your neck and misses";
        } else if (rng >=2) {
          return "You got drained and die, horribly";
        }
      }
    }
    return "Nothing happened";
  }
  
}
