/**
 * circled.
 */

// defaults
var defaults =  {

	// Sketch
	live:true,
	partitions:{'rmin':1,'rmax':6,'min':1,'max':8},
	
	// Circles
	circles_nb:{'rmin':1,'rmax':12,'min':1,'max':18},
	circles_lag:{'rmin':0,'rmax':8,'min':0,'max':8},
	circles_randomness:{'rmin':0,'rmax':1,'min':0,'max':1}
};

// lib
Motion motion;
Colors colors;


// fields
Circle[] circles;
float s;
float lag;
int wnb,hnb;
int cnb;
int rd;
int cycle;
color bg,c;
PVector t;


/*
 * Processing setup.
 */
void setup() {
	
	// stage
	size(DeviceSettings.view_width,DeviceSettings.view_height);
	smooth();
	frameRate(12);
	
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
	
	// draw
	loop();
	if (!defaults.live) {
		noLoop();
		draw();
	}
	
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
	
	// size & nb
	lag = 2 - (int)random(defaults.circles_lag.rmin,defaults.circles_lag.rmax) *0.125;
	int f = ((int)random(defaults.partitions.rmin,defaults.partitions.rmax))*2;
	s = width/f;
	wnb = (int) (width/s);
	hnb = (int) (height/s);
	float lagr = (random(defaults.circles_randomness.rmin,defaults.circles_randomness.rmax)*3);
	if (lagr == 0) {lagr = 1;}
	
	
	// circles
	float minv = width;
	float maxv = 0;
	cnb = (int)random(defaults.circles_nb.rmin,defaults.circles_nb.rmax);
    rd = (int) random(cnb*0.75,cnb);
    if (rd == 0) {rd = cnb;}
	circles = new Circle[cnb];
	for (int c = 0; c < cnb; c++) {
		float xy = (1+c)*(s/cnb);
		float r = 2* xy * lagr;
		circles[c] = new Circle(xy,xy,r);
		minv = min(minv,xy);
		maxv = max(maxv,xy);
	}
    
    // color
    bg = colors.background();
	c = colors.dcolor(defaults.color);
    
	// sketch
	noFill();
	stroke(c);
	strokeWeight(1);
	
	// static
	if (! defaults.live) {
		cycle = 1000000;
	}
	
	// offset
	float maxx = (wnb-1)*s*lag+2*s-minv;
	float maxy = (hnb-1)*s*lag+2*s-minv;
	float ox = (width-maxx-minv)/2.0;
	float oy = (height-maxy-minv)/2.0;
	t = new PVector(ox,oy);
}


/*
 * Processing draw.
 */
void draw() {  
	cycle++;
	
	// background
	background(bg);
	
	// push it
	pushMatrix();
	translate(t.x,t.y);
	
	
	// circles
	for (int hy = 0; hy < hnb; hy++) {
		for (int hx = 0; hx < wnb; hx++) {
		
			// push it push it
			pushMatrix();
			
			// points
			float x = hx*s*lag;
			float y = hy*s*lag;
			
			// transorm
			translate(x,y);
			
			// circles
			for (int c = 0; c < cnb && c < cycle && c < rd; c++) {
				Circle circle = circles[c];
				ellipse(circle.x,circle.y,circle.r,circle.r);
				ellipse(2*s-circle.x,circle.y,circle.r,circle.r);
				ellipse(circle.x,2*s-circle.y,circle.r,circle.r);
				ellipse(2*s-circle.x,2*s-circle.y,circle.r,circle.r);
			}
			
			// and pop it goes
			popMatrix();
		}
	}
	
	// still popping
	popMatrix();
	
	// stop, in the name of ...
	if (cycle > cnb) {
		noLoop();
	}
	
}


/*
* Circle.
*/
public class Circle {

  /*
  * Fields.
  */
  public float x,y,r;
  
  /*
  * Creates a new instance.
  */
  public Circle(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
  }
}

