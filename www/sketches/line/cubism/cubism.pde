/**
 * cubism.
 */

// defaults
var defaults =  {
	
	// sketch
	color:{'rgb':false},
	partitions:{'rmin':4,'rmax':12,'min':3,'max':18},
	randomness:{'value':0.3, 'min':0,'max':1}

};

// lib
Motion motion;
Colors colors;


// fields
int cycle;
int seg;
int nbl;
PVector[][] points;
int cnx,cny;
float cwidth,cheight;
color bg;
color c;
float offset;




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
	
	// loop
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

	// null cycle
	cycle = 0;
	
	// seg
	seg = (int) random(defaults.partitions.rmin,defaults.partitions.rmax);
	nbl = (int) random(2,seg*0.6);
	
	// init
	cwidth = width / seg;
	cheight = cwidth / 4.0;
	
	cnx = seg + 1;
	cny = (int) (height / cheight) + 1;
	
	// randomness
	float r = defaults.randomness.value * width/100.0;

	// points
	points = new PVector[cny][cnx];
	float px = (cwidth/2.0);
	float py = random(-r,r);
	float pxo = 0;
	
	// first batch
	for (int ix = 0; ix < cnx; ix++) {

		// points
		points[0][ix] = new PVector(px,py); 
		px += cwidth+random(-r,r);
		py = random(-r,r);
	
	}
	
	// followers
	for (int iy = 1; iy < cny; iy++) {

		// based on previous
		py += cheight+random(-r,r);
		px = points[iy-1][0].x;
		pxo = - cwidth/2;
		if (iy % 2 == 0) pxo = cwidth/2;
		// points
		for (int ix = 0; ix < cnx; ix++) {
		
			// point
			points[iy][ix] = new PVector(px+pxo,py); 
			px += cwidth+random(-r,r);
			
		}
		
	}
	
	// minmax
	float miny = height;
	float maxy = 0;
	for (int sy = 1; sy < cny; sy++) {
		for (int sx = 1; sx < cnx; sx++) {
			miny = min(miny,points[sy][sx].y);
			maxy = max(maxy,points[sy][sx].y);
		}
	}
	offset = (height-(maxy-miny))/6.0;

	
	// sketch
	bg = colors.background();
    c = colors.dcolor(defaults.color);
	
	noFill();
	stroke(c);
	strokeWeight(1);
	strokeCap(ROUND);

}


/*
 * Processing draw.
 */
void draw() {  
	cycle++;
	
	// background
	background(bg);
	
	// translate
	pushMatrix();
	translate(0,offset);
	
	// shapes
	for (int sy = 6; sy < cny-6; sy+=4) {
		for (int sx = 1; sx < cnx-2; sx+=1) {
			
			// left
			PVector pl1 = points[sy][sx];
			PVector pl2 = points[sy+1][sx];
			PVector pl3 = points[sy-1][sx];
			
			// lines
			for (int l = 1; l < nbl && sx > 1 && l < cycle; l++) {
				float d = l/(float)nbl;
				float x1 = lerp(pl2.x,pl1.x,d);
				float y1 = lerp(pl2.y,pl1.y,d);
				float x2 = lerp(pl2.x,pl3.x,d);
				float y2 = lerp(pl2.y,pl3.y,d);
				line(x1,y1,x2,y2);
			}
			
			
			// right
			PVector pr1 = points[sy][sx];
			PVector pr2 = points[sy+1][sx+1];
			PVector pr3 = points[sy-1][sx+1];
			
			
			// lines
			for (int l = 1; l < nbl && sx < cnx-3 && l < cycle; l++) {
				float d = l/(float)nbl;
				float x1 = lerp(pr3.x,pr2.x,d);
				float y1 = lerp(pr3.y,pr2.y,d);
				float x2 = lerp(pr3.x,pr1.x,d);
				float y2 = lerp(pr3.y,pr1.y,d);
				line(x1,y1,x2,y2);
			}
			
		}
	}
	
	// shapes
	for (int sy = 4; sy < cny-4; sy+=4) {
		for (int sx = 1; sx < cnx-2; sx+=1) {
			
			// top left
			PVector ptl1 = points[sy][sx];
			PVector ptl2 = points[sy-1][sx];
			PVector ptl3 = points[sy-2][sx];
			
			
			// top right
			PVector ptr1 = points[sy][sx];
			PVector ptr2 = points[sy-2][sx];
			PVector ptr3 = points[sy-1][sx+1];
			
			// shape
			strokeWeight(2);
			beginShape();
			vertex(ptl1.x,ptl1.y);
			vertex(ptl2.x,ptl2.y);
			vertex(ptl3.x,ptl3.y);
			vertex(ptr3.x,ptr3.y);
			endShape(CLOSE);
			
			// lines
			strokeWeight(1);
			for (int l = 1; l < nbl && l < cycle; l++) {
				float d = l/(float)nbl;
				float x1 = lerp(ptl2.x,ptl3.x,d);
				float y1 = lerp(ptl2.y,ptl3.y,d);
				float x2 = lerp(ptr1.x,ptr3.x,d);
				float y2 = lerp(ptr1.y,ptr3.y,d);
				line(x1,y1,x2,y2);
			}
			
			
			// right
			PVector pr1 = points[sy][sx];
			PVector pr2 = points[sy-1][sx+1];
			PVector pr3 = points[sy+1][sx+1];
			
			
			// bottom right
			PVector pbr1 = points[sy][sx];
			PVector pbr2 = points[sy+1][sx+1];
			PVector pbr3 = points[sy+2][sx];
			
			// shape
			strokeWeight(2);
			beginShape();
			vertex(pr1.x,pr1.y);
			vertex(pr2.x,pr2.y);
			vertex(pr3.x,pr3.y);
			vertex(pbr3.x,pbr3.y);
			endShape(CLOSE);
			
			// lines
			strokeWeight(1);
			for (int l = 1; l < nbl && l < cycle; l++) {
				float d = l/(float)nbl;
				float x1 = lerp(pr2.x,pr3.x,d);
				float y1 = lerp(pr2.y,pr3.y,d);
				float x2 = lerp(pbr1.x,pbr3.x,d);
				float y2 = lerp(pbr1.y,pbr3.y,d);
				line(x1,y1,x2,y2);
			}
			
			
			// bottom left
			PVector pbl1 = points[sy][sx];
			PVector pbl2 = points[sy+2][sx];
			PVector pbl3 = points[sy+1][sx];
			
			
			// left
			PVector pl1 = points[sy][sx];
			PVector pl2 = points[sy+1][sx];
			PVector pl3 = points[sy-1][sx];
			
			// shape
			strokeWeight(2);
			beginShape();
			vertex(pbl1.x,pbl1.y);
			vertex(pbl2.x,pbl2.y);
			vertex(pbl3.x,pbl3.y);
			vertex(pl3.x,pl3.y);
			endShape(CLOSE);
			
			// lines
			strokeWeight(1);
			for (int l = 1; l < nbl && l < cycle; l++) {
				float d = l/(float)nbl;
				float x1 = lerp(pbl1.x,pbl2.x,d);
				float y1 = lerp(pbl1.y,pbl2.y,d);
				float x2 = lerp(pl3.x,pbl3.x,d);
				float y2 = lerp(pl3.y,pbl3.y,d);
				line(x1,y1,x2,y2);
			}
			
		}
	}
	
	// poppin
	popMatrix();
	
	// break it
	if (cycle >= nbl) {
		noLoop();
	}
	
	
}


