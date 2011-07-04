/**
 * inrecursion.
 */


// defaults
var defaults =  {

	// sketch
	live:true,
	partitions:{'rmin':2,'rmax':4,'min':2,'max':6},
	flip:false,
		
	// lines
	lines_minlength:{'value':0.1,'min':0,'max':1},
	lines_randomdeath:{'value':0.5,'min':0,'max':1}
};

// lib
Motion motion;
Colors colors;

// parameterize
float minlength;

// fields
ArrayList lines;
boolean update;
float w,h;
float sh,sw;
int wnb,hnb;
color bg,c;

/*
 * Processing setup.
 */
void setup() {
	
	// stage
	size(DeviceSettings.view_width,DeviceSettings.view_height);
	frameRate(6);
	smooth();

	
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
	
	// lines
	lines = new ArrayList();
	
	// partitions
	int partitions = (int) random(defaults.partitions.rmin,defaults.partitions.rmax);
	
	// size & nb
	minlength = width*( ((float)defaults.lines_minlength.value+0.1)/10.0);
	float d = (int)random(1,4)*(int)partitions;
	sw = width/d;
	sh = height/d;
	wnb = (int) (width/sw);
	hnb = (int) (height/sh);
	
	// init
	w = width/wnb;
	h = height/hnb;
	float fh = ((int)random(partitions-1)+1)/partitions;
	float hlen1 = fh*w;
	float hlen2 = w-hlen1; 
	float fv = ((int)random(partitions-1)+1)/partitions;
	float vlen1 = fv*h;
	float vlen2 = h-vlen1;
	
	Line l1 = new Line();
	l1.dir = 0;
	l1.p1 = new PVector(0,vlen1);
	l1.p2 = new PVector(hlen1,vlen1);
	l1.len1 = vlen1;
	l1.len2 = vlen2;
	lines.add(l1);
	
	Line l2 = new Line();
	l2.dir = 0;
	l2.p1 = new PVector(hlen1,vlen1);
	l2.p2 = new PVector(w,vlen1);
	l2.len1 = vlen1;
	l2.len2 = vlen2;
	lines.add(l2);
	
	Line l3 = new Line();
	l3.dir = 1;
	l3.p1 = new PVector(hlen1,0);
	l3.p2 = new PVector(hlen1,vlen1);
	l3.len1 = hlen1;
	l3.len2 = hlen2;
	lines.add(l3);
	
	Line l4 = new Line();
	l4.dir = 1;
	l4.p1 = new PVector(hlen1,vlen1);
	l4.p2 = new PVector(hlen1,h);
	l4.len1 = hlen1;
	l4.len2 = hlen2;
	lines.add(l4);
	
	
	// update
	update = true;
    
    // colors
    bg = colors.background();
    c = colors.dcolor(defaults.color);
	
	// sketch
	background(bg);
	noFill();
	stroke(c);
	strokeWeight(1);
	
	
	// static
	if (! defaults.live) {
		while (update) {
			updateLines();
		}
	}
}


/*
 * Updates the lines.
 */
void updateLines() {
	
	// flag
	update = false;
	
	// lines
	ArrayList newlines = new ArrayList();
	float f = ((int)random(1,12))*(1.0/12.0);
	int c = 0;
	for (int i = 0; i < lines.size(); i++) {
		// retain
		Line l = (Line) lines.get(i);
		
		
		// divide
		float d = l.p1.dist(l.p2);
		if (l.divide && d > minlength) {
			update = true;
			
			// divided
			float len1 = f*d;
			float len2 = d-len1;       
			
			// lines
			Line l1 = new Line();
			l1.dir = (l.dir + 1) % 2;
			l1.len1 = len1;
			l1.len2 = len2;
			Line l2 = new Line();
			l2.dir = (l.dir + 1) % 2;
			l2.len1 = len1;
			l2.len2 = len2;
			
			
			// horizontal
			if (l.dir == 0) {
				l1.p1 = new PVector(l.p1.x+len1,l.p1.y-l.len1);
				l1.p2 = new PVector(l.p1.x+len1,l.p1.y);
				
				l2.p1 = new PVector(l.p1.x+len1,l.p1.y);
				l2.p2 = new PVector(l.p1.x+len1,l.p1.y+l.len2);
			}
			// vertical
			if (l.dir == 1) {
				l1.p1 = new PVector(l.p1.x-l.len1,l.p1.y+len1);
				l1.p2 = new PVector(l.p1.x,l.p1.y+len1);
				
				l2.p1 = new PVector(l.p1.x,l.p1.y+len1);
				l2.p2 = new PVector(l.p1.x+l.len2,l.p1.y+len1);
			}
			
			// add em lines
			if (random(1) > defaults.lines_randomdeath.value) {
				newlines.add(l1);
				newlines.add(l2);
			}
			
			
			// f
			if (c++%2==0) {
				f = 1-f;
			}
			
		}
		l.divide = false;
	}
	
	// add
	for (int n = 0; n < newlines.size(); n++) {
		lines.add(newlines.get(n));
	}
	
	
}


/*
 * Processing draw.
 */
void draw() { 
	
	// live update
	if (defaults.live && update) {
		updateLines();
	}
	
	// display
	for (int hy = 0; hy < hnb; hy++) {
		
		for (int hx = 0; hx < wnb; hx++) {
			pushMatrix();
			
			// points
			float x = hx*sw;
			float y = hy*sh;
			
			// transform
			translate(x,y);
			if (defaults.flip) {
				translate(sw*0.625,-(sh*0.125));
				rotate(PI/4.0);
			}

			
			for (int p = 0; p < 4; p++) {
				pushMatrix();
				
				// transform
				switch(p) {
						// top left
					case 0:
						break;
						// top right
					case 1:
						translate(w,0);
						scale(-1, 1);
						break;
						// bottom left
					case 2:
						translate(0,h);
						scale(1, -1);
						break;
						// bottom right
					case 3:
						translate(w,h);
						scale(-1, -1);
						break;
				}
				
				// lines
				for (int j = 0; j < lines.size(); j++) {
					Line l = (Line) lines.get(j);
					line(l.p1.x,l.p1.y,l.p2.x,l.p2.y);
				}
				
				// pop it
				popMatrix();
			}
			popMatrix();
		}
	}
	
	// this is the end
	if (! update) {
		noLoop();
	}
	
	
}



/*
 * Line class.
 */
public class Line {
	
	/*
	 * Fields.
	 */
	public PVector p1,p2;
	public int dir;
	float len1,len2;
	boolean divide;
	
	/*
	 * Creates a new instance.
	 */
	public Line() {
		this.p1 = new PVector(0,0);
		this.p2 = new PVector(0,0);
		this.dir = 0;
		this.len1 = 0;
		this.len2 = 0;
		this.divide = true;
	}
}
