// Pinball 

// CSCI 5611

// Drew Osmundson 

// osmun049


int currentBalls = 1;

int ballId = 0;


void setup(){

  surface.setTitle("Pinball Drew Osmundson");

  size(700, 975);

  textSize(50);

}

//==========

// Main loop

//==============

void draw(){

  float dt = 1.0/frameRate;

  background(30,30,20,40);

  stroke(255); // Set stroke color to white

  gameInputs();

  strokeWeight(8);

  spinFlipper();

  for(int i = 0; i < walls.length; i++){

    walls[i].scetch();

  }

  for(int i = 0; i < flippers.length; i++){

    flippers[i].updateSubsteps(dt);

    flippers[i].scetch();

  }

  for (int i = 0; i < balls.length; i++) {

    balls[i].updateSubsteps(dt);

    balls[i].scetch();

    balls[i].edgeCollision();

  }

  stroke(255);

  fill(255, 190, 20);

  for (int i = 0; i < obstacles.length; i++) {

    obstacles[i].update();

    obstacles[i].scetch();

  }

  text("Score " + ballId, 20, 950);
  textSize(20);
  text("Hold and release 'w' to start", 390, 935);
  text("Press 'a' or 'd' to use flippers", 390, 955);

  textSize(50);
  if (currentBalls == 0){

    fill(255, 190, 20);

    text("Game Over", 200, 500);

    text("Score " + ballId, 200, 600);
    
    text("'R' to Restart", 200, 700); 
    
   
  }

}


//=============

//other game fucntions
//===============
void restartGame(){
  // Reset counters
  currentBalls = 1;
  ballId = 0;

  // Reset ball
  balls = new Ball[]{ new Ball(new Vec2(670, 800), new Vec2(0,0), 14, 0) };

}
void spawnBalls(){

    ballId++;

    currentBalls++;

    Ball newBall = new Ball(new Vec2(random(20, 120), random(270, 370)), new Vec2(0, 0), 15, ballId);

    Ball[] newBalls = new Ball[balls.length + 1];  // Add the new ball to the array

    for (int i = 0; i < balls.length; i++) {

      newBalls[i] = balls[i];

    }

    newBalls[balls.length] = newBall;

    balls = newBalls; // Update the balls array with the new ball;

}


void gameInputs() {

  if (newBallCreation) {

    spawnBalls();

  }

  if (rightPressed) right_flipper.angular_velocity = 9; // Change the angular velocity when 'a' is pressed

  else right_flipper.angular_velocity = -9;

  

  if (leftPressed) left_flipper.angular_velocity = -9; // Change the angular velocity when 'd' is pressed

  else left_flipper.angular_velocity = 9; // Stop the line if no input is given


  if (upPressed) {

    right_launch_flipper.angular_velocity = -1; // Change the angular velocity when 'd' is pressed

    left_launch_flipper.angular_velocity = 1; // Change the angular velocity when 'd' is pressed

  }

  else{

    right_launch_flipper.angular_velocity = 15; // Stop the line if no input is given

    left_launch_flipper.angular_velocity = -15; // Stop the line if no input is given

  }

  if(restartKeyPressed) {
    restartGame();
  }

}

void spinFlipper(){

  if(center1.angle == -3.14) center1.angular_velocity = 2;

  if(center1.angle == 3.14) center1.angular_velocity = -2;

  if(center2.angle == -6.28) center2.angular_velocity = 4;

  if(center2.angle == 0) center2.angular_velocity = -4;

}

boolean leftPressed, rightPressed, upPressed, downPressed, newBallCreation, restartKeyPressed;

void keyPressed(){

  if (key == 'a') leftPressed = true;

  if (key == 'd') rightPressed = true;

  if (key == 'w') upPressed = true; 

  if (key == 'b') newBallCreation = true;
  
  if (key == 'r') restartKeyPressed = true;

}

void keyReleased(){

  if (key == 'a') leftPressed = false;

  if (key == 'd') rightPressed = false;

  if (key == 'w') upPressed = false; 

  if (key == 'b') newBallCreation = false;

  if (key == 'r') restartKeyPressed = false;
}



//==========================

// Wall Object and fucntions

//===========================

class Wall { 

  Vec2 base;

  Vec2 tip;

  Wall(Vec2 base, Vec2 tip) { 

    this.base = base;

    this.tip = tip;

  }

  void scetch(){

    line(base.x, base.y, tip.x, tip.y);

  }

}



//==========================

// Obstacle Object and fucntions

//=========================

class Obstacle{

  Vec2 pos;

  float radius;

  int id;

  boolean collision = false;

  Obstacle(Vec2 pos, float radius, int id) {

    this.pos = pos;

    this.radius = radius;

    this.id = id;

  }

  void scetch(){

    ellipse(pos.x, pos.y, radius*2, radius*2);

  }

  void update(){

    if (collision){

      collision = false;

      fill(255,  10, 0);

      ellipse(pos.x, pos.y, radius*3, radius*3);

      for(int i = 0; i < id; i++){

        spawnBalls();

      }

    }

  }

}



//===========================

// Flipper Object and fucntions

//============================

class Flipper {

  Vec2 base;

  Vec2 tip;

  float angle;

  float min_angle;

  float max_angle;

  float line_length;

  float angular_velocity;

  // Constructor

  Flipper(Vec2 base, float min_angle, float max_angle, float angle, float line_length) {

    this.base = base;

    this.min_angle = min_angle;

    this.max_angle = max_angle;

    this.angle = angle;

    this.line_length = line_length;

    this.angular_velocity = 0.0;

    this.tip = getTip();

  }

  Vec2 getTip(){

    Vec2 tip = new Vec2(0,0);

    tip.x = base.x + line_length*cos(angle);

    tip.y = base.y + line_length*sin(angle);

    return tip;

  }

  void scetch(){

    line(base.x, base.y, tip.x, tip.y);

  }

  void update(float dt){

    angle += angular_velocity * dt; 

    tip = getTip();

    if(angle >= max_angle){

      angle = max_angle;

      angular_velocity = 0;

    } 

    if (angle <= min_angle){ 

      angle = min_angle;

      angular_velocity = 0;     

    }

  }

  void updateSubsteps(float dt){

  // Update line segment

  int subSteps = 10; 

  float subDt = dt / subSteps;

  for (int i = 0; i < subSteps; i++) {

      stroke(100 - (i * 10), 250 - (i * 10) , 250);

      scetch();

      update(subDt); 

  }

  stroke(255);

  }

}



//=======================

// Ball Object and fucntions

//=========================

class Ball {

  Vec2 pos;

  Vec2 vel;

  float radius;

  int id;

  // Constructor

  Ball(Vec2 pos, Vec2 vel, float radius, int id) {

    this.pos = pos;

    this.vel = vel;

    this.radius = radius;

    this.id = id;

  }


  void scetch(){

    ellipse(pos.x, pos.y, radius*2, radius*2);

  }


  void update(float dt){

    vel.add(gravity.times(dt));

    pos.add(vel.times(dt));

  }


  void updateSubsteps(float dt){

    int subSteps = 30; // Adjust this value as needed

    float subDt = dt / subSteps;

    for (int i = 0; i < subSteps; i++) {

      noStroke();

      fill(255,  10 + (i * 7), 0);

      scetch();

      update(subDt);

      for(int j = 0; j < flippers.length; j++){

        ballFlipperCollision(flippers[j]);

      }

      for(int j = 0; j < walls.length; j++){

        ballWallCollision(walls[j]);

      }

      for(int j = 0; j < balls.length; j++){

        ballBallCollision(balls[j]);

      }

      for(int j = 0; j < obstacles.length; j++){

        ballObstacleCollision(obstacles[j]);

      }

    }

    strokeWeight(2);

    stroke(255);

    fill(20);

  }



  void ballWallCollision(Wall wall) {

    float restitution = 0.4;

    // Find the closest point on the line segment

    Vec2 tip = wall.tip;

    Vec2 dir = tip.minus(wall.base);

    Vec2 dir_norm = dir.normalized();

    float proj = dot(pos.minus(wall.base), dir_norm);

    Vec2 closest;

    if (proj < 0) {

      closest = wall.base;

    } else if (proj > dir.length()) {

      closest = tip;

    } else {

      closest = wall.base.plus(dir_norm.times(proj));

    }

    // Check if the ball is close enough to the line segment

    dir = pos.minus(closest);

    float dist = dir.length();

    if (dist > radius) {

      return;

    }

    dir.mul(1.0/dist); // Normalize dir

    // Move the ball outside the line segment

    pos = closest.plus(dir.times(radius));

    // Calculate the new ball velocity

    float v_ball = dot(vel,dir);

    float m1 = 1;

    float m2 = 1000; // Give the flipper a big mass compared to the ball

    // Conservation of momentum

    float new_v = (m1 * v_ball - m2 * v_ball * restitution) / (m1 + m2);

    vel.add(dir.times(new_v - v_ball));

  }



  void edgeCollision(){  // If ball is out of bounds, reset it

    if (pos.y > height + radius){

      currentBalls--;

      for(int i = 0; i < balls.length; i++){ 

      if(id == balls[i].id){

        for(int j = i; j < balls.length -1; j++){

        balls[j] = balls[j+1]; 

          }

        }

      }

      Ball[] newBalls = new Ball[balls.length - 1];

      for (int i = 0; i < balls.length - 1 ; i++) {

        newBalls[i] = balls[i];

      }

      balls = newBalls; // Update the balls array without the lost ball

    }

  }


  //code given from canvas

  void ballFlipperCollision(Flipper flipper) {

    float restitution = 0.5;

    // Find the closest point on the line segment

    Vec2 tip = flipper.getTip();

    Vec2 dir = tip.minus(flipper.base);

    Vec2 dir_norm = dir.normalized();

    float proj = dot(pos.minus(flipper.base), dir_norm);

    Vec2 closest;

    if (proj < 0) {

      closest = flipper.base;

    } else if (proj > dir.length()) {

      closest = tip;

    } else {

      closest = flipper.base.plus(dir_norm.times(proj));

    }

    // Check if the ball is close enough to the line segment

    dir = pos.minus(closest);

    float dist = dir.length();

    if (dist > radius) {

      return;

    }

    dir.mul(1.0/dist); // Normalize dir

    // Move the ball outside the line segment

    pos = closest.plus(dir.times(radius + 1));

    // Velocity of the flipper at the point of contact

    Vec2 radius = closest.minus(flipper.base);

    Vec2 surfaceVel = new Vec2(0,0);

    if (radius.length() > 0) {

      surfaceVel = (new Vec2(-radius.y, radius.x)).normalized().times(flipper.angular_velocity * radius.length());

    }

    // Calculate the new ball velocity

    float v_ball = dot(vel,dir);

    float v_flip = dot(surfaceVel,dir);

    float m1 = 1;

    float m2 = 10000; // Give the flipper a big mass compared to the ball 

    // Conservation of momentum

    float new_v = (m1 * v_ball + m2 * v_flip - m2 * (v_ball - v_flip) * restitution) / (m1 + m2);

    vel.add(dir.times(new_v - v_ball));

  }




  //code from billiards exercise

  void ballBallCollision(Ball collidingBall){

    if (collidingBall.id == id) return; // return if the balls are the same

    float restitution = 0.4;

    Vec2 delta = pos.minus(collidingBall.pos);

    float dist = delta.length();

    if (dist < radius + collidingBall.radius){

      // Move balls out of collision

      float overlap = 0.5f * (dist - radius - collidingBall.radius);

      pos.subtract(delta.normalized().times(overlap));

      collidingBall.pos.add(delta.normalized().times(overlap));

      // Collision

      Vec2 dir = delta.normalized();

      float v1 = dot(vel, dir);

      float v2 = dot(collidingBall.vel, dir);

      float m1 = 1;

      float m2 = 1;

      // Pseudo-code for collision response

      float new_v1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * restitution) / (m1 + m2);

      float new_v2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * restitution) / (m1 + m2);

      vel.add(dir.times(new_v1 - v1));

      collidingBall.vel.add(dir.times(new_v2 - v2));

    }

  }


  //code from billiards exercise

  void ballObstacleCollision(Obstacle obstacle){

    float restitution = 0.4;

    Vec2 delta = pos.minus(obstacle.pos);

    float dist = delta.length();

    if (dist < radius + obstacle.radius){

      // Move balls out of collision

      float overlap = 0.5f * (dist - radius - obstacle.radius);

      pos.subtract(delta.normalized().times(overlap));

      // Collision

      Vec2 dir = delta.normalized();

      float v1 = dot(vel, dir);

      float v2 = 0;

      float m1 = 1;

      float m2 = 10000;

      // Pseudo-code for collision response

      float new_v1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * restitution) / (m1 + m2);

      vel.add(dir.times(new_v1 - v1));

      obstacle.collision = true; 

    }

  }

}



//=======================

// walls, flippers, balls, and obstacles objects

//=========================

Vec2 gravity = new Vec2(0,400);


Flipper right_flipper = new Flipper(new Vec2(480, 850), -3.65, -2.65 , -3.65, 125);

Flipper left_flipper = new Flipper(new Vec2(160, 850), -0.5, 0.5, 0.5, 125);


Flipper right_launch_flipper = new Flipper(new Vec2(700, 850), -3.14, -2.44, -2.44, 70);

Flipper left_launch_flipper = new Flipper(new Vec2(640, 850), -0.7, 0, -0.7, 70);


Flipper center1 = new Flipper(new Vec2(320, 320), -3.14, 3.14, 3.14, 140);

Flipper center2 = new Flipper(new Vec2(320, 320), -6.28, 0, 0, 140);


Wall floorRight = new Wall(new Vec2(640, 750), new Vec2(480, 850));

Wall floorLeft = new Wall(new Vec2(0, 750), new Vec2(160, 850));


Wall lanchWall = new Wall(new Vec2(640, 300), new Vec2(640, 975));

Wall lanchWall1 = new Wall(new Vec2(640, 0), new Vec2(640, 200));

Wall launchBump = new Wall(new Vec2(640, 200), new Vec2(700, 250));

Wall launchBump1 = new Wall(new Vec2(640, 200), new Vec2(570, 250));

Wall launchBump2 = new Wall(new Vec2(0, 200), new Vec2(70, 250));

Wall launchFloor = new Wall(new Vec2(640, 845), new Vec2(700, 845));


Wall centerWall1 = new Wall(new Vec2(220, 100), new Vec2(320, 50));

Wall centerWall2 = new Wall(new Vec2(420, 100), new Vec2(320, 50));


Wall middleCeiling = new Wall(new Vec2(0, 0), new Vec2(700, 0));

Wall middleRight = new Wall(new Vec2(500, 650), new Vec2(500, 400));

Wall middleLeft = new Wall(new Vec2(140, 650), new Vec2(140, 400));


Wall rightCeiling = new Wall(new Vec2(540, 0), new Vec2(640, 100));

Wall leftCeiling = new Wall(new Vec2(0, 100), new Vec2(100, 0));

Wall leftWall = new Wall(new Vec2(0, 0), new Vec2(0, 975));

Wall rightWall = new Wall(new Vec2(700, 0), new Vec2(700, 975));


Obstacle gold = new Obstacle(new Vec2(320, 250), 5, 3);

Obstacle bronze = new Obstacle(new Vec2(70, 150), 15, 1);

Obstacle bronze1 = new Obstacle(new Vec2(570, 150), 15, 1);


Ball ball = new Ball(new Vec2(670, 800), new Vec2(0,0), 14, 0);


Obstacle[] obstacles = {gold, bronze, bronze1};


Ball[] balls = {ball};


Flipper[] flippers = {right_flipper, left_flipper, 

  right_launch_flipper, left_launch_flipper,

  center1, center2};


Wall[] walls = {floorRight, floorLeft, lanchWall, rightCeiling, leftCeiling,

  leftWall, rightWall, centerWall1, centerWall2, middleLeft, middleCeiling,

  middleRight, launchBump, lanchWall1, launchBump1, launchBump2, launchFloor};



//---------------

//Vec 2 Library

//---------------


//Vector Library

//CSCI 5611 Vector 2 Library [Example]

// Stephen J. Guy <sjguy@umn.edu>


public class Vec2 {

  public float x, y;

  

  public Vec2(float x, float y){

    this.x = x;

    this.y = y;

  }

  

  public String toString(){

    return "(" + x+ "," + y +")";

  }

  

  public float length(){

    return sqrt(x*x+y*y);

  }

  

  public float lengthSqr(){

    return x*x+y*y;

  }

  

  public Vec2 plus(Vec2 rhs){

    return new Vec2(x+rhs.x, y+rhs.y);

  }

  

  public void add(Vec2 rhs){

    x += rhs.x;

    y += rhs.y;

  }

  

  public Vec2 minus(Vec2 rhs){

    return new Vec2(x-rhs.x, y-rhs.y);

  }

  

  public void subtract(Vec2 rhs){

    x -= rhs.x;

    y -= rhs.y;

  }

  

  public Vec2 times(float rhs){

    return new Vec2(x*rhs, y*rhs);

  }

  

  public void mul(float rhs){

    x *= rhs;

    y *= rhs;

  }

  

  public void clampToLength(float maxL){

    float magnitude = sqrt(x*x + y*y);

    if (magnitude > maxL){

      x *= maxL/magnitude;

      y *= maxL/magnitude;

    }

  }

  

  public void setToLength(float newL){

    float magnitude = sqrt(x*x + y*y);

    x *= newL/magnitude;

    y *= newL/magnitude;

  }

  

  public void normalize(){

    float magnitude = sqrt(x*x + y*y);

    x /= magnitude;

    y /= magnitude;

  }

  

  public Vec2 normalized(){

    float magnitude = sqrt(x*x + y*y);

    return new Vec2(x/magnitude, y/magnitude);

  }

  

  public float distanceTo(Vec2 rhs){

    float dx = rhs.x - x;

    float dy = rhs.y - y;

    return sqrt(dx*dx + dy*dy);

  }
 
}


Vec2 interpolate(Vec2 a, Vec2 b, float t){

  return a.plus((b.minus(a)).times(t));

}


float interpolate(float a, float b, float t){

  return a + ((b-a)*t);

}


float dot(Vec2 a, Vec2 b){

  return a.x*b.x + a.y*b.y;

}


//2D cross product is a funny concept

// ...its the 3D cross product but with z = 0

// ... (only the resulting z compontent is not zero so we just store is as a scalar)

float cross(Vec2 a, Vec2 b){

  return a.x*b.y - a.y*b.x;

}


Vec2 projAB(Vec2 a, Vec2 b){

  return b.times(a.x*b.x + a.y*b.y);

}


Vec2 perpendicular(Vec2 a){

  return new Vec2(-a.y,a.x);

}