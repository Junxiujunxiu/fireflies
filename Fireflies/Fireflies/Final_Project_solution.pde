/*
Author: [Junxiu Wu]
Student ID: [22164260]
Date: [20/05/2023]
Description: 
/**
 * Fireflies in the jungle simulation
 * 
 * This program simulates fireflies flying around in a jungle,
 * There is a pair of animated animal eyes that follow the movement of the fireflies, which simulated the animal hidden in the jungle starring the fireflies.
 * The fireflies will follow the  mouse cursor, making the program interactive.
 * users can input the number of fireflies they want to see on the canvas screen.
 * The program also have background image and customized mouse cursor.
 * The fireflies' positions, velocities, and colors are all random.
 * The fireflies bounce off the screen if i press the mouse.
 * The program imports the Minim library for sound.
 * 
 
/** Sources for assets and programming inspirations:
 
I am a big fan of Miyazaki Hayao, a famous manga artist and film director, 
and I have watched all of his animated films. I also enjoy listening to the music from these films. 
While listening to the music, I drew inspiration from the animated background of a music playlist on YouTube. 
The bubbles on the screen resembled fireflies, and I was also inspired by 
the eyes of Totoro (the large chinchilla lying on the ground). I have attached the reference link below.

Reference link for the project concept: https://www.youtube.com/watch?v=oYQut39Uyww

Reference link for the Eye class design inspiration: https://tangerinedev.com/play/portrait-gallery

*/

import javax.swing.JOptionPane;
import ddf.minim.*;

// Prompt the user to enter the number of fireflies for the simulation.
String input = JOptionPane.showInputDialog(null,
    "What is the number? (150 is recommended)", "Enter the number of fireflies",
    JOptionPane.QUESTION_MESSAGE);

int numFireflies = Integer.parseInt(input);

// Variable for background image
PImage backgroundImage;

// Variables for fireflies positions, velocities, and colors
float[] x;
float[] y;
float[] z;
float[] vx;
float[] vy;
float[] vz;
color[] fireflyColors;
float radius = 3;

// Variables for Maximum and minimum velocity of the fireflies
float maxVel;
float minVel;

// Variable for mouse cursor image
PImage customCursor;

// Variables for eyes from Eyes class
Eye leftEye, rightEye;

void setup() {
  size(1830, 1016, P3D);
  smooth();

  // instance objects for the fireflies properties.
  x = new float[numFireflies];
  y = new float[numFireflies];
  z = new float[numFireflies];
  vx = new float[numFireflies];
  vy = new float[numFireflies];
  vz = new float[numFireflies];
  fireflyColors = new color[numFireflies];

  // assign values to the maximum and minimum velocity properties.
  maxVel = 20;
  minVel = 5;

  // Eye(float x, float y, float radius, color eye_Outer_Color, color eye_Inner_Color, float irisRadius, float maxIrisOffset, float smoothingFactor, float pupilRadius)
  // instantiate instance objects based on the Eyes class constructor.
  leftEye = new Eye(width/3, height/2, 40, color(255), color(0), 40, 12, 1, 30);
  rightEye = new Eye(2*width/3, height/2, 40, color(255), color(0), 40, 12, 1, 30);

  lights();// Enables lighting effects.
  noStroke();

  // upload image for background and mouse cursor
  backgroundImage = loadImage("forest_image.jpg");
  customCursor = loadImage("rose_image.png");

  // implement the sound with minim library.
  Minim minim;
  minim = new Minim(this);
  AudioPlayer player;
  player = minim.loadFile("Firefly_sound.mp3");
  player.loop();

  // Initialize fireflies
  for (int i = 0; i < numFireflies; i++) {
    // Random position in a sphere
    PVector position = PVector.random3D();
    position.mult(40);
    x[i] = position.x;
    y[i] = position.y;
    z[i] = position.z;

    // initialize Random velocity
    PVector velocity = PVector.random3D();
    velocity.mult(random(minVel, maxVel + 1));
    vx[i] = velocity.x;
    vy[i] = velocity.y;
    vz[i] = velocity.z;

    // Random color between 100 and 255 to avoid darker shade.
    fireflyColors[i] = color(random(100, 256), random(100, 256), random(100, 256));
  }
}

// Draw function
void draw() {
  // Draw background and customized mouse cursor
  backgroundImage.resize(width, height);
  background(backgroundImage);
  image(customCursor, mouseX, mouseY);

  // Draw eyes
  leftEye.update();
  rightEye.update();
  leftEye.draw();
  rightEye.draw();

  // Hide the default mouse cursor
  noCursor();

  // Distance of the mouse cursor from the center of the sketch
  float mouseXPos = mouseX - width / 2;
  float mouseYPos = mouseY - height / 2;

  // Translate to center of screen with depth.
  translate(width / 2, height / 2, -200);

  // Draw fireflies
  for (int i = 0; i < numFireflies; i++) {
    // Calculate direction from firefly to mouse cursor
    float direction_x = mouseXPos - x[i];
    float direction_y = mouseYPos - y[i];
    float direction_z = -200 - z[i];

    // Calculate the distance between mouseXPos and fireflies in 3D space with Euclidean distance formula.
    float dist = sqrt(direction_x * direction_x + direction_y * direction_y + direction_z * direction_z);
    // Normalize direction vector to unit vector
    direction_x /= dist;
    direction_y /= dist;
    direction_z /= dist;

    // Scale direction vector by a constant force, with some random variation
    float baseForce = 5 * random(0.5, 1.6);
    float force = baseForce + random(-1, 1); // Add additional random value.
    float force_x = direction_x * force;
    float force_y = direction_y * force;
    float force_z = direction_z * force;

    // Apply force to velocity vector of firefly
    float damping = 0.9;
    vx[i] += force_x * (1 - damping);
    vy[i] += force_y * (1 - damping);
    vz[i] += force_z * (1 - damping);

    // Update position of firefly based on its new velocity vector
    x[i] += vx[i];
    y[i] += vy[i];
    z[i] += vz[i];

    // Draw fireflies
    pushMatrix();
    translate(x[i], y[i], z[i]);
    fill(fireflyColors[i]);
    sphere(radius);
    popMatrix();

    // Check if firefly is outside the screen
    if (x[i] < -width / 2 || x[i] > width / 2 || y[i] < -height / 2 || y[i] > height / 2 || z[i] < -width / 2 || z[i] > width / 2) {
      // Reset position and velocity
      PVector direction = PVector.random3D();
      x[i] = direction.x * random(100, 601);
      y[i] = direction.y * random(100, 601);
      z[i] = direction.z * random(100, 601);
      float v = random(minVel, maxVel + 1);
      direction = PVector.random3D();
      vx[i] = direction.x * v;
      vy[i] = direction.y * v;
      vz[i] = direction.z * v;
    }
  }
}

/**
 * Responds to a mouse button press event.
 * Calculates the position of the mouse cursor relative to the center of the screen.
 * Applies a repulsive force to the fireflies, causing them to bounce away from the mouse cursor.
 *
 * @param none
 * @return void
 */
void mousePressed() {
  // Get the position of the mouse cursor
  float mouseXPos = mouseX - width / 2;
  float mouseYPos = mouseY - height / 2;

  // Bounce fireflies away from mouse cursor
  for (int i = 0; i < numFireflies; i++) {
    // Calculate direction from fireflies to mouse cursor
    float direction_x = mouseXPos - x[i];
    float direction_y = mouseYPos - y[i];
    float direction_z = -200 - z[i];

    // Normalize direction vector to get a unit vector
    float dist = sqrt(direction_x * direction_x + direction_y * direction_y + direction_z * direction_z);
    direction_x /= dist;
    direction_y /= dist;
    direction_z /= dist;

    // Scale direction vector by a constant force to determine the force to be applied to the firefly
    float force = 40;
    float force_x = direction_x * force;
    float force_y = direction_y * force;
    float force_z = direction_z * force;

    // Apply force to velocity vector of firefly
    vx[i] += force_x;
    vy[i] += force_y;
    vz[i] += force_z;
  }
}
