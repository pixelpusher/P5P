/**
 * strangeattractor.
 */

// defaults
var defaults =  {
	
    // sketch
	color:{'rgb':false},
    layer:true,
    
    // nodes
    nodes_layout:"layout_grid",
    nodes_nbx:{'rmin':10,'rmax':40,'min':2,'max':60},
    nodes_nby:{'rmin':10,'rmax':40,'min':2,'max':60},
    
    // attractor
    attractor_radius:{'value':150,'min':50,'max':300},
    attractor_strength:{'value':6,'min':-12,'max':12},
    attractor_lock_x:false,
    attractor_lock_y:false
};

// lib
Motion motion;
Colors colors;


// fields
color c,bg;
int nbx;
int nby;
float r;
float conr;
float gwidth;
float gheight;
Node[][] nodes;
Attractor attractor;
boolean layout_grid;
boolean layout_circular;
boolean mode_layer;
float sac,fac;


// vars
int ip;


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
    
    // radius
    r = defaults.attractor_radius.value;
    
    // attractor
    attractor = new Attractor(-width,-height,defaults.attractor_radius.value,defaults.attractor_strength.value);
    attractor.setLock(defaults.attractor_lock_x,defaults.attractor_lock_y);
    
    
    // layer
    sac = 1.8;
    fac = 0.5;
    mode_layer = false;
    if (defaults.layer) {
        mode_layer = true;
        sac = random(9,27);
        fac = random(3,9);
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
    
    // vars
    nbx = (int) random(defaults.nodes_nbx.rmin,defaults.nodes_nbx.rmax);
    nby = (int) random(defaults.nodes_nby.rmin,defaults.nodes_nby.rmax);
    ip = (int)random(12);
    
    // grid
    gwidth = random(width*0.125,width*0.875);
    gheight = random(height*0.125,height*0.875);
      
    
    // nodes
    nodes = new Node[nbx][nby];
    
    // layout
    layout_grid = false;
    layout_circular = false;
    
    // grid
    if (defaults.nodes_layout == "layout_grid") {
        layout_grid = true;
        
        // cells
        for (int y = 0; y < nby; y++) {
            for (int x = 0; x < nbx; x++) {
                
                // position
                float px = x*(gwidth/(nbx-1))+(width-gwidth)/2;
                float py = y*(gheight/(nby-1))+(height-gheight)/2;
                
                // node
                nodes[x][y] = new Node(px, py);
            }
        }
    }
    
    // circular
    if (defaults.nodes_layout == "layout_circular") {
        layout_circular = true;
        
        // origin
        PVector origin = new PVector(width/2,height/2);
        
        // angle
        float a = 360.0/nbx; 

        
        // radius
        float cr = random(width/64,width/32);
        float cri = random(((width/4.0)-cr)/nby,((width/2.0)-cr)/nby);
        
        // on circle
        for (int y = 0; y < nby; y++) {
            for (int x = 0; x < nbx; x++) {
            
                // point
                PVector p = pointOnCircle(origin,cr,x*a);

                // node
                nodes[x][y] = new Node(p.x,p.y);
            }
            cr += (cri*random(0.75,1));
        }
        
    }
    
    // color
    bg = colors.background();
    c = colors.dcolor(defaults.color);
    
    // sketch
    background(bg);
    noFill();
    
	
}

/*
 * Calculates a point on a circle.
 * x = cx + r * cos(a)
 * y = cy + r * sin(a)
 */
public PVector pointOnCircle(PVector origin, float radius, float angleInDegrees) {
    // convert from degrees to radians via multiplication by PI/180        
    float x = (float)(radius * cos(angleInDegrees * PI / 180.0)) + origin.x;
    float y = (float)(radius * sin(angleInDegrees * PI / 180.0)) + origin.y;
    
    // return
    return new PVector(x, y);
}



/*
 * Processing draw.
 */
void draw() { 
    
    // background
    if (! mode_layer) {
        background(bg);
    }
	
    
    // iterate is the new black
    for (int y = 0; y < nby; y++) {
        for (int x = 0; x < nbx; x++) {
            
            // attract
            if (mousePressed) {
                attractor.attract(nodes[x][y]);
                
            }
            
            // update
            nodes[x][y].update();
            
        }
    }
    

        
        // a bit tired of all these lines
        for (int y = 0; y < nby; y++) {
            for (int x = 0; x < nbx; x++) {
                
                // node
                float nx = nodes[x][y].x;
                float ny = nodes[x][y].y;
                
                
                // horizontal
                if (x < nbx-1) {
                    
                    // point
                    float n1x = nodes[x+1][y].x;
                    float n1y = nodes[x+1][y].y;
                    
                    // stroke
                    strangeStroke(mag(n1x-nx,n1y-ny));
                    
                    // line
                    line(nx,ny,n1x,n1y);
                    
                }
                
                
                // vertical
                if (y < nby-1) {
                    
                    // point
                    float n2x = nodes[x][y+1].x;
                    float n2y = nodes[x][y+1].y;
                    
                    // stroke
                    strangeStroke(mag(n2x-nx,n2y-ny));
                    
                    // line
                    line(nx,ny,n2x,n2y);
                }
                
                // interpolate
                if (x < nbx-1 && y < nby-1) {
                    
                    float n1x = nodes[x+1][y].x;
                    float n1y = nodes[x+1][y].y;
                    
                    float n2x = nodes[x][y+1].x;
                    float n2y = nodes[x][y+1].y;
                    
                    float n3x = nodes[x+1][y+1].x;
                    float n3y = nodes[x+1][y+1].y;
                    
                    // and on it goes
                    for (int ix = 1; ix < ip; ix++) {
                        
                        // such a distance
                        float d = ix/(float)ip;
                        float x1 = lerp(nx,n1x,d);
                        float y1 = lerp(ny,n1y,d);
                        float x2 = lerp(n2x,n3x,d);
                        float y2 = lerp(n2y,n3y,d);
                        
                        // stroke
                        strangeStroke(mag(x2-x1,y2-y1));
                        
                        // line
                        line(x1,y1,x2,y2);
                    }
                    for (int iy = 1; iy < ip; iy++) {
                        
                        // in the distance
                        float d = iy/(float)ip;
                        float x1 = lerp(nx,n2x,d);
                        float y1 = lerp(ny,n2y,d);
                        float x2 = lerp(n1x,n3x,d);
                        float y2 = lerp(n1y,n3y,d);
                        
                        // stroke it again
                        strangeStroke(mag(x2-x1,y2-y1));
                        
                        // that's it
                        line(x1,y1,x2,y2);
                    }
                    
                }
                
                // interpolate circular
                if (layout_circular && (x == nbx-1 || y == nby-1)) {
                    float n1x = nodes[(x+1)%nbx][y].x;
                    float n1y = nodes[(x+1)%nbx][y].y;
                    
                    float n2x = nodes[x][(y+1)%nby].x;
                    float n2y = nodes[x][(y+1)%nby].y;
                    
                    float n3x = nodes[(x+1)%nbx][(y+1)%nby].x;
                    float n3y = nodes[(x+1)%nbx][(y+1)%nby].y;
                    
                    // and on it goes
                    for (int ix = 0; ix < ip; ix++) {
                        
                        // such a distance
                        float d = ix/(float)ip;
                        float x1 = lerp(nx,n1x,d);
                        float y1 = lerp(ny,n1y,d);
                        float x2 = lerp(n2x,n3x,d);
                        float y2 = lerp(n2y,n3y,d);
                        
                        // stroke
                        strangeStroke(mag(x2-x1,y2-y1));
                        
                        // line
                        line(x1,y1,x2,y2);
                    }
                    for (int iy = 0; iy < ip; iy++) {
                        
                        // in the distance
                        float d = iy/(float)ip;
                        float x1 = lerp(nx,n2x,d);
                        float y1 = lerp(ny,n2y,d);
                        float x2 = lerp(n1x,n3x,d);
                        float y2 = lerp(n1y,n3y,d);
                        
                        // stroke it again
                        strangeStroke(mag(x2-x1,y2-y1));
                        
                        // that's it
                        line(x1,y1,x2,y2);
                    }
                }
            }
        }
    
    
}

/*
 * A Strange Stroke.
 */
void strangeStroke(d) {
    float a = pow(1/(d/r+1), sac);
    stroke(c,a*255);
}
void strangeFill(d) {
    float a = pow(1/(d/r+1), fac);
    fill(c,a*255);
}


/*
 * Processing event mouse pressed.
 */
void mousePressed() {
    
	// store position
	attractor.x = mouseX;
	attractor.y = mouseY;
    
}

/*
 * Processing event mouse moved.
 */
void mouseDragged() {
    
	// store position
	attractor.x = mouseX;
	attractor.y = mouseY;
    
}


/**
 * Attractor.
 */
public class Attractor {
    
    /*
     * Fields.
     */
    float x,y;
    float r;
    float ramp;
    float strength;
    boolean lock_x,lock_y;
    
    /**
     * Creates a new instance.
     */
    public Attractor(float x, float y, float r, float s) {
        
        // fields
        this.x = x;
        this.y = y;
        
        // defaults
        this.r = r;
        this.ramp = 1.8;
        this.strength = s;
        
        // lock
        this.lock_x = false;
        this.lock_y = false;
    }
    
    /**
     * Sets the lock.
     */
    void setLock(boolean lx, boolean ly) {
        this.lock_x = lx;
        this.lock_y = ly;
    }
    
    /**
     * This is so attracting.
     */
    void attract(Node node) {
        
        // distance
        float dx = x - node.x;
        float dy = y - node.y;
        float d = mag(dx,dy);
        
        // check
        if (d > 0 && d < r) {
            
            // force
            //float s = d/r;
            float s = pow(d/r,1/ramp);
            
            //float f = (1 / pow(s,0.5*ramp)-1)/(r*0.5);
            float f = s * 9 * strength * (1/(s+1) + ((s-3)/4)) / d;
            
            // node velocity
            node.velocity.x += lock_x ? 0 : dx * f;
            node.velocity.y += lock_y ? 0 : dy * f;
        }
    }
}



/**
 * Node.
 */
public class Node  {
    
    /*
     * Fields.
     */
    float x,y;
    float damping;
    PVector velocity;
    float speed;
    
    /**
     * Creates a new instance.
     */
    public Node(float x, float y) {
        
        // fields
        this.x = x;
        this.y = y;
        
        // defaults
        this.damping = 0.1;
        this.velocity = new PVector(0,0);
        this.speed = 2.1;
    }
    
    /**
     * Updates the node.
     */
    void update() {
        
        // position
        x += velocity.x*speed;
        y += velocity.y*speed;
        
        // damp
        velocity.x *= (1-damping);
        velocity.y *= (1-damping);

    }
    
}



