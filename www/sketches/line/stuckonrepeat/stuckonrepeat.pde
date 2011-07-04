/**
 * stuckonrepeat.
 */


// defaults
var defaults =  {
	
	// sketch
	partitions:{'rmin':6,'rmax':18,'min':1,'max':24},
	
	// lines
	lines_nb:{'rmin':3,'rmax':12,'min':1,'max':24},
	lines_length:{'rmin':0.25,'rmax':0.5,'min':0,'max':1},
	
	// directions
	direction_up:true,
	direction_upright:false,
	direction_right:true,
	direction_downright:false,
	direction_down:true,
	direction_downleft:false,
	direction_left:true,
	direction_upleft:false
};


// lib
Motion motion;
Colors colors;

// parameterize
int psize;
int msize;


// fields
float[][] pattern;
ArrayList dirs;
float pnw,pnh;
int lines, direction,cx,cy;
float offset;
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
 * Processing reset.
 */
void reset() {

	
	// pattern size
	float cf = ((int)random(defaults.partitions.rmin,defaults.partitions.rmax)) * 2;
	psize = (int)(width/(cf));
	
	// lines
	lines = (int) random(defaults.lines_nb.rmin,defaults.lines_nb.rmax);
	msize = ((int)(random(defaults.lines_length.rmin,defaults.lines_length.rmax) * psize))+1;
	
	// directions
	dirs = new ArrayList();
	if (defaults.direction_up) {
		dirs.add(0);
	}
	if (defaults.direction_upright) {
		dirs.add(1);
	}
	if (defaults.direction_right) {
		dirs.add(2);
	}
	if (defaults.direction_downright) {
		dirs.add(3);
	}
	if (defaults.direction_down) {
		dirs.add(4);
	}
	if (defaults.direction_downleft) {
		dirs.add(5);
	}
	if (defaults.direction_left) {
		dirs.add(6);
	}
	if (defaults.direction_upleft) {
		dirs.add(7);
	}
	
	// check
	if (dirs.length() <= 0) {
		dirs.add((int)random(8));
	}
	
	
	// init pattern
	pattern = new float[psize][psize];
	pnw = (int)(width/psize);
	pnh = (int)(height/psize);
	cx = (int) random(0,psize);
	cy = (int) random(0,psize);
	direction = dirs.get((int)random(dirs.size()));
	pattern[cx][cy] = 1;
	
	// offset
	offset = (width-(pnw*psize))/2.0;
    
    
    // color
    bg = colors.background();
    c = colors.dcolor(defaults.color);
	
	// sketch
    background(bg);
    noStroke();
    fill(c);

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
 * Updates the pattern.
 */
boolean updatePattern() {

	// direction
	if (frameCount % msize == 0) {
		direction = dirs.get((int)random(dirs.size()));
	} 
	switch (direction) {
			// up 
		case 0:
			cy -= 1;
			break;
			// up right
		case 1:
			cx += 1;
			cy -= 1;
			break;
			// right
		case 2:
			cx += 1;
			break;
			// down right
		case 3:
			cx += 1;
			cy += 1;
			break;
			// down 
		case 4:
			cy += 1;
			break;
			// down left
		case 5:
			cx -= 1;
			cy += 1;
			break;
			// left
		case 6:
			cx -= 1;
			break;
			// up left
		case 7:
			cx -= 1;
			cy -= 1;
			break;
	}
	
	// restrain
	if (cx < 0 || cy < 0 || cx >= psize || cy >= psize) {
		if (lines > 1) {
			cx = (int) random(0,psize);
			cy = (int) random(0,psize);
			lines--;
		}
		else {
			noLoop();
		}
		return false;
	}
	
	// set & return
	pattern[cx][cy] = 1;
	return true;
	
}

/*
 * Processing draw.
 */
void draw() {

	
	// update
	if (updatePattern()) {		
		
		// display
		float ox = 0;
		float oy = 0;
		for (int px = 0; px < pnw; px++) {
			for (int py = 0; py <= pnh; py++) {
				
				// value
				int vx = (int) ox == 0 ? cx : (psize-cx);
				int vy = (int) oy == 0 ? cy : (psize-cy);
				float v = pattern[cx][cy];
			
				// pixel
				int sx = (int)(px*psize+vx)+offset;
				int sy = (int)(py*psize+vy);
                rect(sx,sy,1,1);
				
				// increment y
				oy = (oy+1) % 2;
			}
			// increment x
			ox = (ox+1) % 2;
		}
		
	}
	
}



