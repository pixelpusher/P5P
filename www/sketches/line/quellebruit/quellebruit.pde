/**
* quelle bruit.
*/

// local defaults
var	defaults =  {
	
	// sketch
	interaction:"auto",
	color:{'rgb':false},
	mode:"mode_1",
	agents:{'rmin':300,'rmax':600,'min':100,'max':1200},
	collisions:{'rmin':3,'rmax':9,'min':0,'max':18},
		
	// noise 
	noise_scale:{'value':150,'min':50,'max':300},
	noise_factor:{'value':50,'min':1,'max':100},
	noise_octaves:{'value':6,'min':2,'max':32},
	noise_falloff:{'value':0.4,'min':0.1,'max':0.8},
	noise_zinc:{'value':0.2,'min':0,'max':3}
		
};

// lib
Motion motion;
Colors colors;


// parameterize
boolean mode2;
boolean ia_touch;
int nb;
float nscale,nfactor,nz,nzinc;
int mcollision;
int bindex;


// fields
float sa,sw;
ArrayList agents;
color c,bg;


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

}

/*
* Processing settings.
*/
void settings() {

  	// extend defaults
	if (window.UserDefaults) {
		jQuery.extend(defaults, window.UserDefaults);
	}
	
	// touch
	ia_touch = false;
	if (defaults.interaction == "touch") {
		ia_touch = true;
	}
	
	// mode
	mode2 = false;
	if (defaults.mode == "mode_2") {
		mode2 = true;
	}
	
	// noise factors
	nscale = defaults.noise_scale.value; 
	nfactor = defaults.noise_factor.value;
	nz = 0.1;
	nzinc = defaults.noise_zinc.value; 
	
	// noise detail
	int octaves = (int) defaults.noise_octaves.value; // default: 4
	float falloff = defaults.noise_falloff.value; // default: 0.5
	noiseDetail(octaves, falloff);
    
    // live color
    if (defaults.color.rgb) {
        c = colors.dcolor(defaults.color);
    }

}

/*
* Processing reset.
*/
void reset() {

	// fill
	sa = random(30,90);
	sw = random(0.3,1.5);

	
	// agents
	nb = 0;
	agents = new ArrayList(); 
	if (! ia_touch) {
		nb = (int) random(defaults.agents.rmin,defaults.agents.rmax);
		for (int i = 0; i < nb; i++) {
			agents.add(new Agent(random(width),random(height)));
		}
	}
	mcollision = (int)random(defaults.collisions.rmin,defaults.collisions.rmax);
    
    // index
    bindex = (int)random(8,64);	
	
	// noise
	int nseed = (int) random(1000000);
	noiseSeed(nseed);
    
    // color
    c = colors.dcolor(defaults.color);
    bg = colors.background();
  
	// sketch
	background(bg);
	noFill();
	strokeWeight(sw);

  
}

/*
* Generates agents.
*/
void generateAgents(PVector p, float sw, float sh, int n) {
	for (int i = 0; i <= n; i++) {
		agents.add(new Agent(p.x+random(-sw,sw),p.y+random(-sh,sh)));
		nb++;
	}
}


/*
 * Processing draw.
 */
void draw() {  
  
	// offset
	float ox = 0;
	float oy = 0;
	float oinc = 3;
  
	// zinc
	nz += nzinc * 0.01;
  
    // randomize position
    ox = sin(frameRate)*oinc;
    oy = cos(frameRate)*oinc;

	  // agents  
	  for (int i = 0; i < agents.size()-1; i++) {
	  
		// agent
		Agent agent = agents.get(i);
		if (! agent.dead) {
		  agent.cycle++;
		  
		  // check
		  float border = 1;
		  if (agent.p.x < border || agent.p.x > width-border) {
			if (agent.collision < mcollision) {
			  agent.dx = -1 * agent.dx;
			  agent.collision++;
			}
			else {
			  agent.dead = true;
			}
		  }
		  if (agent.p.y < border || agent.p.y > height-border) {
			if (agent.collision < mcollision) {
			  agent.dy = -1 * agent.dy;
			  agent.collision++;
			}
			else {
			  agent.dead = true;
			}
		  }
		  
		  // angle
		  float angle = noise(agent.p.x/nscale,agent.p.y/nscale,nz) * nfactor;

		  
		  // update position
		  agent.p.x += cos(angle) * agent.step * agent.dx + ox;
		  agent.p.y += sin(angle) * agent.step * agent.dy + oy;
		  
		  // draw
		  float saf = 1.0;
		  if (agent.cycle < 30) {
			saf = agent.cycle / 30.0;
		  }
		  stroke(c,sa*saf);
		  line(agent.pp.x,agent.pp.y,agent.p.x,agent.p.y);
		  
		  // mode 2
		  if (mode2 && i%bindex == bindex-1) {
			Agent pagent = agents.get(nb-i-2);
			Agent c1agent = agents.get(nb-i-1);
			Agent c2agent = agents.get(nb-i);
			strokeWeight(sw/2.0);
			bezier(agent.pp.x,agent.pp.y,c1agent.pp.x,c1agent.pp.y,c2agent.pp.x,c2agent.pp.y,pagent.p.x,pagent.p.y);
		  }
		  
		  // retain
		  agent.pp.set(agent.p);
		}
	  }
	  
}

/*
* Processing event mouse pressed.
*/
void mousePressed() {
	generateAgents(new PVector(mouseX,mouseY),width/16.0,height/16.0,(int)random(1,30));
}

/*
* Processing event mouse dragged.
*/
void mouseDragged() {
  generateAgents(new PVector(mouseX,mouseY),width/16.0,height/16.0,(int)random(1,10));
}




/**
* Agent Class.
*/
public class Agent {

  /*
  * Fields
  */
  public PVector p,pp;
  public float step;
  public int cycle;
  float dx;
  float dy;
  int collision;
  boolean dead;

  
  /**
  * Creates a new instance.
  */
  public Agent(float x, float y) {
    this.p = new PVector(x,y);
    this.pp = new PVector(x,y);
    this.step = random(3,6);
    this.cycle = 1;
    this.dx = 1;
    this.dy = 1;
    this.collision = 0;
    this.dead = false;
  }

}




