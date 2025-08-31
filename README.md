The Features of my Pinball project include:

Basic pinball dynamics: There is a ball that bounces and interacts with its environment (throughout the video)

Multiple balls interacting: The pinballs will bounce off each other. (0:31 of the second video)

Circular obstacles: There are stationary circular obstacles that the pinballs will bounce off of.  (0:18 )

Line segment obstacles: There are many line obstacles for the ball to interact with and bounce off of.  (0:03)

Particle system: I've created 3 effects. The first one is a trail of fire behind the pinball that increases in length the faster the ball is moving, and the second is a lightsaber like effect for the flippers. Both of these effects are accomplished by making use of sub stepping when updating the position of the flippers and the ball. The last effect is the stationary circle obstacles glow red when hit to indicate an increase of score; however, this is brief, and the 30fps recording may not record all of them. (throughout the video and circle at 0:23)

Launcher to shoot the balls: I made use of the same flipper code to incorporate a launcher to start the game. (0:02)

Reactive obstacles: When the circular obstacles are hit, they spawn a certain number of balls depending on which is hit.  The two side circles each spawn one new ball, and the middle small circle spawns 3 new pinballs (0:23)

The scoreboard: Score is kept by the total number of balls spawned throughout the game and displayed on the bottom left. (throughout the video)

Interactive flippers: When 'a' is pressed, the right bumper fires, when 'd' is pressed, the left one goes. Other buttons are 'w' to charge the launcher and release to fire, and 'b' to spawn new balls without needing to hit an obstacle. (0:08)

Game over when there are no more balls on screen: The game is over, and the total number of balls spawned throughout the game is displayed as a score. (0:38)

Flipper obstacles: In the middle of the screen, there are two rotating flippers that cannot be controlled and act as moving obstacles. (throughout the video)

Challenges faced
Some obstacles I had to overcome when working on this project was getting the animations to feel natural while not breaking the game. For instance, I wanted to use a smaller ball but I found that without drastically increasing the number of substeps, the flippers would be traveling too fast for the ball to detect a collision, and I did not want to make the flippers any slower.

Another major challenge I had was the ball functionality. The game was almost complete when I realized I had to completely change much of the code to keep performance optimal on my old laptop.  Walls and flippers were the same object, and there was no ball class, so growing the project was getting more difficult, and the game was starting to get slow. I refactored what I had to create a more object-oriented design, and interactions the ball has with its surroundings became methods in a Ball class that updated their state values. The Ball objects are then stored in an array to be looped through at each frame rate. The game can now handle a few hundred pinballs.