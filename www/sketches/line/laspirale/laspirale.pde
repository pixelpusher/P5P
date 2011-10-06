/**
 * laspirale.
 */

// defaults
var defaults =  {
	
	// sketch
	color:{'rgb':false},
	mode:"mode_1",
	touch:"frequency",
	
	// frequency
	frequency_random:true,
	frequency_x:{'value':1,'min':1,'max':20},
	frequency_y:{'value':2,'min':1,'max':30},
	frequency_phase_x:{'value':0,'min':0,'max':180},
	frequency_phase_y:{'value':0,'min':0,'max':180},
	
	// modulation
	modulation_random:false,
	modulation_x:{'value':0,'min':0,'max':20},
	modulation_y:{'value':0,'min':0,'max':30}
	
};

// lib
Motion motion;
Colors colors;

// parameters
float fx, fy, mfx, mfy;
float phix, phiy;
int total;
PVector[] lpoints;
color bg,c;
int span;
float r;
float factor;
int b;
boolean mode_1, mode_2;
float sinfo,txinfo,tyinfo;
boolean drawing;

/*
 * Processing setup.
 */
void setup() {
	
	// stage
	size(DeviceSettings.view_width,DeviceSettings.view_height);
	smooth();
	frameRate(24);
	
	// font
	PFont font = loadFont("Helvetica");
	textFont(font, 15);
	
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
	
	// settings 
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
    
	// live color
    if (defaults.color.rgb) {
        c = colors.dcolor(defaults.color);
    }
}

/*
 * Processing reset.
 */
void reset() {
	
	// mode
	mode_1 = true;
	mode_2 = false;
	if (defaults.mode == "mode_2") {
		mode_1 = false;
		mode_2 = true;
	}
	
	// frequency
	if (defaults.frequency_random) {
		fx = (int) random(defaults.frequency_x.min,defaults.frequency_x.max);
		fy = (int) random(defaults.frequency_y.min,defaults.frequency_y.max);
		phix = (int) random(defaults.frequency_phase_x.min,defaults.frequency_phase_x.max);
		phiy = (int) random(defaults.frequency_phase_y.min,defaults.frequency_phase_y.max);
	}
	else {
		fx = (int) defaults.frequency_x.value;
		fy = (int) defaults.frequency_y.value;
		phix = (int) defaults.frequency_phase_x.value;
		phiy = (int) defaults.frequency_phase_y.value;
	}
	
	// modulation
	if (defaults.modulation_random) {
		mfx = (int) random(defaults.modulation_x.min,defaults.modulation_x.max);
		mfy = 0; // don't mess up everything
	}
	else {
		mfx = (int) defaults.modulation_x.value;
		mfy = (int) defaults.modulation_y.value;
	}
    
	
	
	// lpoints
	current = 0;
	total = (int) random(300,900);
	if (mode_2) {
		total = (int) random(90,120);
	}
	span = random(total*0.3,total*0.9);
	r = random(width/4,width/2);
	b = (int)random(60);
	factor = width*(random(0.25,0.375));
	lpoints = new PVector[total];
	for (int p = 0; p <= total; p++) {
		
		// point
		PVector l = lissajous(p);
		lpoints[p] = new LPoint(l.x,l.y,l.z);
	}
    
    // color
    bg = colors.background();
    c = colors.dcolor(defaults.color);
	
	// sketch
	noFill();
	
	// position
	sinfo = width/4.0;
	if (deviceIPhone()) {
		sinfo = width/2.0;
	}
    
	txinfo = (width/2.0)-sinfo/2.0+20;
	tyinfo = (height/2.0)-45;
    
    // state
    drawing = true;
	
}



/*
 * Update frequency.
 */
void updateFrequency() {
	
	// what's the frequency kenny?
	if (defaults.touch == "modulation") {
		mfx = ((int) ((mouseX/width)*defaults.modulation_x.max))+1;
		mfy = ((int) ((mouseY/height)*defaults.modulation_y.max))+1;
	}
	else if (defaults.touch == "phase") {
		phix = (int) ((mouseX/width)*defaults.frequency_phase_x.max);
		phiy = (int) ((mouseY/height)*defaults.frequency_phase_y.max);
	}
	else {
		fx = ((int) ((mouseX/width)*defaults.frequency_x.max))+1;
		fy = ((int) ((mouseY/height)*defaults.frequency_y.max))+1;
	}
	
}


/*
 * Update Lissajous.
 */
void updateLissajous() {
	
	// lpoints
	for (int p = 0; p <= total; p++) {
		
		// move point
		lpoints[p].move2(lissajous(p));
		
	}
	
}

/*
 * Calculates a lissajous point.
 */
PVector lissajous(int p) {

	// angle
	float angle = map(p,0,total,0,TWO_PI);
	
	// point
	float x = sin(angle*fx+radians(phix)) * cos(angle*mfx) * factor + width/2.0;
	float y = sin(angle*fy+radians(phiy)) * cos(angle*mfy) * factor + height/2.0;
	
	// return
	return new PVector(x,y,0);
}

/*
 * Displays an info overlay.
 */
void displayInfo() {
    

        // rect
        fill(0,90);
        noStroke();
        rect((width/2.0)-sinfo/2.0,(height/2.0)-sinfo/2.0,sinfo,sinfo);
        fill(255);
        text("Frequency X " + fx,txinfo,tyinfo);
        text("Frequency Y " + fy,txinfo,tyinfo+20);
        text("Phase X " + phix,txinfo,tyinfo+40);
        text("Phase Y " + phiy,txinfo,tyinfo+60);
        text("Modulation X " + mfx,txinfo,tyinfo+80);
        text("Modulation Y " + mfy,txinfo,tyinfo+100);
        noFill();

    
}

/*
 * Processing draw.
 */
void draw() {  
    
    
    // draw it
    if (drawing) {
        
        // update
        for (int i=0; i<=total; i++){
            // update
            lpoints[i].update();
        }
        
        
        // background
        background(bg);
        stroke(c);
        
        // mode 1
        if (mode_1) {
            
            // figure
            strokeWeight(1);
            beginShape();
            for (int i=0; i<=total; i++){
                
                // line
                float d = PVector.dist(lpoints[i].pos, new PVector(width/2.0,height/2.0));
                float a = pow(1/(d/r+1), 3);
                stroke(c,a*255);
                vertex(lpoints[i].pos.x, lpoints[i].pos.y);
            }
            endShape();
            
            
            // lines
            for (int i = 0; i < span; i++) {
                int i1 = (int)( i %total);
                int i2 = (int)((i1+span)%total);
                int c1 = (int) ((i1+b)%total);
                int c2 = (int) ((i2+b)%total);
                float d = PVector.dist(lpoints[i1].pos, lpoints[i2].pos);
                float a = pow(1/(d/r+1), 3);
                stroke(c,a*255);
                strokeWeight((i/span)*2);
                bezier(lpoints[i1].pos.x, lpoints[i1].pos.y,lpoints[c1].pos.x, lpoints[c1].pos.y, lpoints[i2].pos.x, lpoints[i2].pos.y, lpoints[c2].pos.x, lpoints[c2].pos.y);
            }
            
        }
        
        // mode 2
        else if (mode_2) {
            
            // some more lines
            for (int i1 = 0; i1 <= total; i1++) {
                for (int i2 = 0; i2 < i1; i2++) {
                    
                    // distance
                    float d = PVector.dist(lpoints[i1].pos, lpoints[i2].pos);
                    float a = pow(1/(d/r+1), 4);
                    if (d <= r) {
                        stroke(c,(a*255));
                        line(lpoints[i1].pos.x, lpoints[i1].pos.y,lpoints[i2].pos.x, lpoints[i2].pos.y);
                    }
                }
            }
        }
    }
    else {
        // info
        displayInfo();
    }

	
	
}

/*
 * Processing event mouse clicked.
 */
void mousePressed() {
    drawing = false;
	updateFrequency();
}

/*
 * Processing event mouse dragged.
 */
void mouseDragged() {
    drawing = false;
	updateFrequency();
}

/*
 * Processing event mouse released.
 */
void mouseReleased() {
    
	// regenerate
	updateLissajous();
    
    // draw
    drawing = true;
}





/**
 * Lissajous Point.
 */
public class LPoint {
	
	/**
	 * Public fields.
	 */
	public PVector pos;
	public PVector mpos;
	
	/*
	 * Private fields.
	 */
	private boolean moved;
	
	/**
	 * Creates a new instance.
	 */
	public LPoint(float x, float y, float z) {
		this.pos = new PVector(x,y,z);
		this.mpos = new PVector(x,y,z);
	}
	
	
	/**
	 * Updates the point.
	 */
	public void update() {
		this.move();
	}
	
	
	/**
	 * Move to point.
	 */
	public void move2(PVector m) {
		this.mpos.x = m.x;
		this.mpos.y = m.y;
		this.mpos.z = m.z;
		this.moved = true;
	}
	
	private void move() {
		float dx = this.mpos.x - this.pos.x;
		float dy = this.mpos.y - this.pos.y;
		float dz = this.mpos.z - this.pos.z;
		this.pos.x += dx/2;
		this.pos.y += dy/2;
		this.pos.z += dz/2;
	}
}


