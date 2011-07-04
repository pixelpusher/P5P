/**
* Test motion.
*/

// defaults
var defaults =  {
	motion:true
};

// vars
float speed;
PVector mover;
PVector dot;
Motion motion;

/*
* Processing setup.
*/
void setup() {
P5P.ios.log("setup");

  
	// stage
	size(DeviceSettings.view_width,DeviceSettings.view_height);
	frameRate(12);
	smooth();
	
	// sketch
	noStroke();
	
	// font
	PFont font = loadFont("Helvetica");
	textFont(font, 15);
	
	// connect the dots
	speed = 0.05;
	dot = new PVector(width/2.0,height/2.0);
	mover = new PVector(width/2.0,height/2.0);
	
	// motion
	motion = new Motion();
	
	// settings
	settings();
  
}

/*
* Processing refresh.
*/
void refresh() {
P5P.ios.log("refresh");

	// settings
	settings();

}

/*
* Processing update.
*/
void settings() {
	// extend defaults
	if (window.UserDefaults) {
		jQuery.extend(defaults, window.UserDefaults);
	}
}

/*
 * Processing draw.
 */
void draw() {

	// background
	background(255);
 

	// acceleration
	motion.acceleration();
	int offset = 40;
	fill(0);
	text("DeviceAcceleration",20, offset+40)
	text("DeviceAcceleration.available: " + DeviceAcceleration.available, 20, offset+60);
	text("DeviceAcceleration.x: " + DeviceAcceleration.x, 20, offset+80);
	text("DeviceAcceleration.y: " + DeviceAcceleration.y, 20, offset+100);
	text("DeviceAcceleration.z: " + DeviceAcceleration.z, 20, offset+120);
	
	// move
	if (defaults.motion) {
	
		// slow down
		if (motion.isMotionX()) {
			mover.x += motion.motionX();
		}
		if (motion.isMotionY()) {
			mover.y += motion.motionY();
		}
		
		// constrain
		motion.constrain(mover);
	}
	else {
		mover.x = mouseX;
		mover.y = mouseY;
	}
	
	// show mover
	fill(255,0,0);
	ellipse(mover.x,mover.y,5,5);
	
	
	// dot
	dot.x += (mover.x-dot.x) * speed;
	dot.y += (mover.y-dot.y) * speed;
	fill(0,255,0);
	ellipse(dot.x,dot.y,10,10);
	
  
}





