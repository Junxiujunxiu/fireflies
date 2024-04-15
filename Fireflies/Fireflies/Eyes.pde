/*
Author: [Junxiu Wu]
Student ID: [22164260]
Date: [20/05/2023]
Description: 
/**
 * The Eye class represents an wild animal eye with features like position, size, colors,
 * iris , and pupil. It also can update the eye's state based on external factors and to 
 * render the eye on the screen.
*/

class Eye {
  // initialize variables for eyes
  float x;
  float y;
  float radius;
  color eye_Outer_Color;
  color eye_Inner_Color;
  float irisRadius;
  float maxIrisOffset;
  float smoothedPupilX;
  float smoothedPupilY;
  float smoothingFactor;
  float pupilRadius;
  float irisOffsetX;
  float irisOffsetY;

  // constructor for the eye class
  Eye(float x, float y, float radius, color eye_Outer_Color,
      color eye_Inner_Color, float irisRadius, float maxIrisOffset,
      float smoothingFactor, float pupilRadius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.eye_Outer_Color = eye_Outer_Color;
    this.eye_Inner_Color = eye_Inner_Color;
    this.irisRadius = irisRadius;
    this.maxIrisOffset = maxIrisOffset;
    this.smoothingFactor = smoothingFactor;
    this.pupilRadius = pupilRadius;
    irisOffsetX = 0;
    irisOffsetY = 0;
    smoothedPupilX = 0;
    smoothedPupilY = 0;
  }

  /**
   * Updates the eye state based on the mouse position.
   * Calculates the offset for the iris based on the mouse position,
   * gradually adjusts the iris offset towards the target offset using a smoothing factor,
   * calculates the position of the pupil based on the iris offset,
   * and smooths the pupil position.
   * This function should be called to update the eye state before rendering.
   */
  void update() {
    // calculate the offset for the iris based on the mouse position
    float irisOffsetTargetX = map(mouseX, 0, width, -maxIrisOffset, maxIrisOffset);
    float irisOffsetTargetY = map(mouseY, 0, height, -maxIrisOffset, maxIrisOffset);
    irisOffsetX = lerp(irisOffsetX, irisOffsetTargetX, smoothingFactor);
    irisOffsetY = lerp(irisOffsetY, irisOffsetTargetY, smoothingFactor);

    // calculate the position of the pupil based on the iris offset
    float pupilX = x + irisOffsetX;
    float pupilY = y + irisOffsetY;

    // smooth the pupil position
    smoothedPupilX = lerp(smoothedPupilX, pupilX, smoothingFactor);
    smoothedPupilY = lerp(smoothedPupilY, pupilY, smoothingFactor);
  }

  /**
   * Draws an eye with a white outer part and a black inner part.
   * The eye is represented by two ellipses: one for the white part and
   * another for the black part.
   */
  void draw() {
    // draw the white part of the eye
    fill(eye_Outer_Color);
    ellipse(x, y, radius + 120, radius);

    // draw the black part of the eye
    fill(eye_Inner_Color);
    ellipse(smoothedPupilX, smoothedPupilY, pupilRadius, pupilRadius + 1);
  }
}
