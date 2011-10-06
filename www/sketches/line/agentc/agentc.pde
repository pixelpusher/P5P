/**
 * agent c.
 */

// defaults
var defaults =  {
		
	// sketch
	interaction:"touch",
	color:{'rgb':false},
	movement_speed:{'value':0.5,'min':0.1,'max':1.0},
	movement_randomness:{'value':0.5, 'min':0,'max':3},
		
	// shape
	shape_points:{'rmin':4,'rmax':128,'min':4,'max':128},
	shape_radius:{'rmin':'0.1','rmax':'0.9','min':0.1,'max':1.0},
	shape_distort_x_probability:{'value':0.3,'min':0,'max':1},
	shape_distort_y_probability:{'value':0.3,'min':0,'max':1}
		
};

// lib
Motion motion;
Colors colors;


// parameterize
float radius = 60;
int pnb = 32;
int circles;
int lag;

// fields
PVector[][] points;
PVector cp,mp,tp;
float mx,my;
float sa,sw,ct;
boolean ia_touch,ia_motion;
color bg,c;


/*
 * Processing setup.
 */
void setup() {
	
	// stage
	size(DeviceSettings.view_width,DeviceSettings.view_height);
	smooth();
	frameRate(24);
	
	// lib
	motion = new Motion();
	colors = new Colors();
	
	// settings & reset
	settings();
	reset();
	
}

/*
* Processing refresh.
*/
void refresh() {

	// settings & reset
	settings();
	reset();
}

/*
 * Processing settings.
 */
void settings() {
	
  	// extend defaults
	if (window.UserDefaults) {
		jQuery.extend(defaults, window.UserDefaults);
	}
    
    // interaction
    ia_touch = false;
    ia_motion = false;
    if (defaults.interaction == "touch") {
        ia_touch = true;
    }
    else if (defaults.interaction == "motion") {
        ia_motion = true;
    }
    
    // live color
    if (defaults.color.rgb) {
        c = colors.dcolor(defaults.color);
    }
	
}

/*
 * Processing reset.
 */
void reset() {

	
	// size
	float s = min(width,height)/2.0;
	
	// circles
	circles = 1;
	
	// points
	pnb = ((int)random(defaults.shape_points.rmin,defaults.shape_points.rmax));
	lag = (int)random(pnb);
	cp = new PVector(width/2.0,height/2.0);
	mp = new PVector(random(width),random(height));
	tp = new PVector(width/2.0,height/2.0);
	radius = random(defaults.shape_radius.rmin*s/2.0,defaults.shape_radius.rmax*s/2.0);
	
	float angle = radians(360/(float)pnb);
	points = new PVector[circles][pnb];
	for (int i = 0; i < circles; i++) {
		float fx = 1.0;
		float fy = 1.0;
		if (random(1) < defaults.shape_distort_x_probability.value) {
			fx = random(0.25);
		}
		else if (random(1) < defaults.shape_distort_y_probability.value) {
			fy = random(0.25);
		}
		for (int j = 0; j < pnb; j++) {
			float x = cos(angle*j) * radius * fx;
			float y = sin(angle*j) * radius * fy;
			points[i][j] = new PVector(x,y);
		}
	}

	
	// color
	sa = random(180,255);
	sw = random(0.1,0.5);
	ct = -0.5 + random(-3,3); // 0.5 = round
	
    bg = colors.background();
    c = colors.dcolor(defaults.color);
    
    // sketch
	background(bg);
	noFill();
	strokeWeight(sw);
	curveTightness(ct);
	
}


/*
 * Processing draw.
 */
void draw() {  
    
	
	// interaction touch
	if (ia_touch) {
		mp.x = tp.x;
		mp.y = tp.y;
	}
	
	// interaction acceleration
	else if (ia_motion) {
		
		// acceleration
		motion.acceleration();
		
		// slow down
		if (motion.isMotionX()) {
			mp.x += motion.motionX();
		}
		if (motion.isMotionY()) {
			mp.y += motion.motionY();
		}
		
		// constrain
		motion.constrain(mp);
	}
	else {
		// movement
	    mp.x = mp.x + mx;
	    mp.y = mp.y + my;
		
	    // reset
	    if (cp.dist(mp) < radius) {
			mp = new PVector(random(width),random(height));
			float rm = random(2,6);
			mx = random(-rm,rm);
			my = random(-rm,rm);
	    }
	}
	
	// slow down
	if (mp.x < radius || mp.x > width-radius) {
		mx -= mx/10.0;
	}
	if (mp.y < radius || mp.y > height-radius) {
		my -= my/10.0;
	}
	
	// move
	cp.x += (mp.x-cp.x) * defaults.movement_speed.value * 0.05;
	cp.y += (mp.y-cp.y) * defaults.movement_speed.value * 0.05;
	
	
	
	// randomize 
	for (int i = 0; i < circles; i++) {
		for (int j = 0; j < pnb; j++) {
			points[i][j].x += random(-defaults.movement_randomness.value,defaults.movement_randomness.value);
			points[i][j].y += random(-defaults.movement_randomness.value,defaults.movement_randomness.value);
		}
	}
	
	
	
	// draw that thing
    stroke(c,sa);
	for (int i = 0; i < circles; i++) {
        beginShape();
        curveVertex(points[i][pnb-1].x+cp.x,points[i][pnb-1].y+cp.y);
        for (int j = 0; j < pnb; j++) {
            curveVertex(points[i][j].x+cp.x,points[i][j].y+cp.y);
        }
        curveVertex(points[i][0].x+cp.x,points[i][0].y+cp.y);
        curveVertex(points[i][1].x+cp.x,points[i][1].y+cp.y);
        endShape();
    }

	
	
}



/*
 * Processing event mouse pressed.
 */
void mousePressed() {
    
    // don't touch this
    if (ia_touch) {
		tp.x = mouseX;
		tp.y = mouseY;
	}

}

/*
 * Processing event mouse moved.
 */
void mouseDragged() {
    
    // what a drag
    if (ia_touch) {
		tp.x = mouseX;
		tp.y = mouseY;
	}

}
