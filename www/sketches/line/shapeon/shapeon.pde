/**
 * shapeon.
 * @url http://processing.org/learning/basics/bezierellipse.html
 * @url http://processing.org/discourse/yabb2/YaBB.pl?num=1272553052/2
 */


// defaults
var defaults =  {

	// sketch
	color:{'rgb':false},
	partitions:{'rmin':1,'rmax':6,'min':1,'max':6},

	// shape
	shape_points:{'rmin':4,'rmax':12,'min':3,'max':18},
	shape_radius:{'rmin':0.5,'rmax':1.5,'min':0.1,'max':2},
	shape_randomdeath:{'rmin':0,'rmax':0.3,'min':0,'max':0.75}
};


// lib
Motion motion;
Colors colors;

// fields
int cycle;
float[] px,py,cx1,cy1,cx2,cy2;
float s,d,radius,cradius;
int points;
int wnb,hnb;
int randomdeath;
color bg,c;


/*
 * Processing setup.
 */
void setup() {
	
	// stage
	size(DeviceSettings.view_width,DeviceSettings.view_height);
	smooth();
	frameRate(6);
	
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
	
	// loop it
	loop();
	
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
	cycle = 0;
	
	// width
	float cf = ((int)random(defaults.partitions.rmin,defaults.partitions.rmax)) * 3;
	s = width/(cf*2);
	
	// radius
	radius = random(defaults.shape_radius.rmin,defaults.shape_radius.rmax)*s;
	cradius = radius;
	
	// points
	points = (int) random(defaults.shape_points.rmin,defaults.shape_points.rmax);
	
	// random deaths are the saddest
	randomdeath = (int) ((1 - random(defaults.shape_randomdeath.rmin,defaults.shape_randomdeath.rmax)) * points);
	
	
	// nb
	wnb = (int) (width/s);
	hnb = (int) (height/s);
	
	// shape
	px = new float[points];
	py = new float[points];
	cx1 = new float[points];
	cy1 = new float[points];
	cx2 = new float[points];
	cy2 = new float[points];
	
	float angle = 360.0/points;
	float controlAngle1 = angle/3.0;
	float controlAngle2 = controlAngle1*2.0;
	float rx = random(s/6);
	float ry = random(s/6);
	for ( int i=0; i<points; i++){
		
		// point
		px[i] = cos(radians(angle))*radius;
		py[i] = sin(radians(angle))*radius;
		
		// random
		float dx = 1;
		float dy = -1;
		
		// control 1
		cx1[i] = cos(radians(angle+controlAngle1))* 
		cradius/cos(radians(controlAngle1));
		cy1[i] = sin(radians(angle+controlAngle1))* 
		cradius/cos(radians(controlAngle1));
		
		cx1[i] += -dx*rx;
		cy1[i] += -dy*ry;
		
		// control 2
		cx2[i] = cos(radians(angle+controlAngle2))* 
		cradius/cos(radians(controlAngle1));
		cy2[i] = sin(radians(angle+controlAngle2))* 
		cradius/cos(radians(controlAngle1));
		
		cx2[i] += dx*rx;
		cy2[i] += dy*ry;
		
		//increment angle so trig functions keep chugging along
		angle+=360.0/points;
	}
    
    // colors
    bg = colors.background();
    c = colors.dcolor(defaults.color);
	
	// sketch
	background(bg);
	noFill();
    stroke(c);
	strokeWeight(0);
	strokeCap(ROUND);
	
}


/*
 * Processing draw.
 */
void draw() {  
	cycle++;
    
	
	// push it
	pushMatrix();
	translate(s/2,s/2);
    ellipse(0,0,0.0001,0.0001); // strange fix for ios5 bug...
	
	// shape
	float ox = 0;
	float oy = 0;
	
	// shapeon
	for (int hy = 0; hy < hnb; hy++) {
		
		for (int hx = 0; hx < wnb; hx++) {
			pushMatrix();
			
			// points
			float x = hx*s;
			float y = hy*s;
			
			// transorm
			translate(x,y);
			
			// top left
			if (hy % 2 == 0 && hx % 2 == 0) {
				translate(d,d);
			}
			
			// top right
			if (hy % 2 == 0 && hx % 2 == 1) {
				translate(-d,d);
				scale(-1, 1);
			}
			
			// bottom left
			if (hy % 2 == 1 && hx % 2 == 0) {
				translate(d,-d);
				scale(1, -1);
			}
			
			// bottom right
			if (hy % 2 == 1 && hx % 2 == 1) {
				translate(-d,-d);
				scale(-1, -1);
			}


			// shape
			beginShape();
			vertex(px[0], py[0]); 
			for (int p=1; p<=points && p < cycle && p <= randomdeath; p++){
				if (p == points) {
					bezierVertex(cx1[p-1], cy1[p-1], cx2[p-1], cy2[p-1],  px[0], py[0]);
					continue;
				}
				bezierVertex(cx1[p-1], cy1[p-1], cx2[p-1], cy2[p-1],  px[p], py[p]);
				
			}
			endShape(CLOSE);

			
			// and pop it goes
			popMatrix();
		}
	}
	
	// are you pop ular
	popMatrix();
	
	// stop that
	if (cycle > points || cycle > randomdeath) {
		noLoop();
	}
	
	
}




