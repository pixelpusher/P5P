/**
 * lineforline.
 */

// defaults
var defaults =  {
	
	// sketch
	randomness:{'value':0.3,'min':0,'max':1},
	
	// lines
	lines_segments:{'rmin':5,'rmax':20,'min':2,'max':30},
	lines_nb:{'rmin':100,'rmax':450,'min':60,'max':900}
	
};

// lib
Motion motion;
Colors colors;

// parameterize
int nbSegments;
int nbLines;
float rx;
float ry;
float dx;


// fields
PVector[][] lines;
Color bg,c;
PVector tp;



/*
 * Processing setup.
 */
void setup() {
	
	// stage
	size(DeviceSettings.view_width,DeviceSettings.view_height);
	smooth();
	noLoop();
	
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
	draw();
}

/*
 * Processing settings.
 */
void settings() {
	
  	// extend defaults
	if (window.UserDefaults) {
		jQuery.extend(defaults, window.UserDefaults);
	}
	
}

/*
 * Processing reset.
 */
void reset() {
	
	// lines
	nbSegments = (int)random(defaults.lines_segments.rmin,defaults.lines_segments.rmax);
	nbLines = (int)random(defaults.lines_nb.rmin,defaults.lines_nb.rmax);
	lines = new PVector[nbSegments][nbLines];
	
	// randomness
	rx = defaults.randomness.value * 3;
	ry = defaults.randomness.value * 3;
	dx = defaults.randomness.value * (width/4);
	
	// segment
	float by = random(0,height/8);
	float ey = random(height*7/8,height);
	
	float bx = random(0,width/8);
	float ex = random(width*7/8,width);
	
	// increment
	float iy = (ey-by) / nbSegments;
	float ix = (ex-bx) / nbLines;
	
	// initial points
	float px = bx;
	float py = by;
	float ca = random(30,120);
	for (int l = 0; l < nbLines; l++) {
		
		// save
		lines[0][l] = new PVector(px,py,ca);
		
		// next position
		px = px + ix+random(-rx,rx);;
		py = py + random(-ry,ry);
		ca = random(ca-1,ca+1);
	}
	
	// segments
	for (int s = 1; s < nbSegments; s++) {
		float ox = random(-dx,dx);
		ca = random(30,120);
		for (int l = 0; l < nbLines; l++) {
			ca = random(ca-1,ca+1);
			px = lines[s-1][l].x + ox+random(-rx,rx);
			py = lines[s-1][l].y+iy+random(-ry,ry);
			lines[s][l] = new PVector(px,py,ca);
		}
	}
	
	// transform
	ptransform = new PVector(random(width/4,width/2),random(height/4,height/2),random(0,PI));

    // color
    bg = colors.background();
    c = colors.dcolor(defaults.color);
	
	// sketch
	noFill();
	strokeWeight(random(0.5,1.5));
	
}



/*
 * Processing draw.
 */
void draw() { 
	

	// background
	background(bg);
	
	// output
	pushMatrix();
    translate(ptransform.x, ptransform.y);
	rotate(ptransform.z);
	for (int s = 0; s < nbSegments-1; s++) {
		for (int l = 0; l < nbLines; l++) {
			stroke(c,lines[s][l].z);
			line(lines[s][l].x-ptransform.x,lines[s][l].y-ptransform.y,lines[s+1][l].x-ptransform.x,lines[s+1][l].y-ptransform.y);

		}
	}
	popMatrix();
	
}



