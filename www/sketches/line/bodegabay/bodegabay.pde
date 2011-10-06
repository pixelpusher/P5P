/**
 * bodegabay.
 */

// defaults
var defaults =  {
		
    // sketch
    interaction:"touch",
	color:{'rgb':false},
    module:"module_vertex",
    
    // boids
    boids_nb:{'rmin':4,'rmax':8,'min':4,'max':24},
    debug:false
		
};

// lib
Motion motion;
Colors colors;


// fields
color bg,c;
float maxalpha;
float df;
ArrayList swarm;
int total;
PVector mover,destination;
boolean module_vertex;
boolean module_bezier;
boolean module_draw;
boolean module_debug;
boolean ia_touch;

// draw
ArrayList memory;
int lag;




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

    // live color
    if (defaults.color.rgb) {
        c = colors.dcolor(defaults.color);
    }
	
}

/*
 * Processing reset.
 */
void reset() {
    
    // varia
    total = (int) random(defaults.boids_nb.rmin,defaults.boids_nb.rmax);
    
    // module
    module_bezier = false;
    module_vertex = false;
    module_draw = false;
    module_debug = false;
    if (defaults.module == "module_bezier") {
        module_bezier = true;
        total *= 2;
    }
    else if (defaults.module == "module_vertex") {
        module_vertex = true;
    }
    else if (defaults.module == "module_draw") {
        module_draw = true;
    }
    else {
        module_debug = true;
    }
    
    
    // draw
	memory = new ArrayList();
	lag = (int)random(128);
    

    // swarming
    swarm = new ArrayList();
    int r = random(0.5,1)*height;
    P5P.ios.log("width = " + width + " height = " + height + " r = " + r);
    float b = width/4;
    for (int i = 0; i < total; i++) {
        swarm.add(new Birdie(b+random(width-2*b),b+random(height-2*b),r));
    }
    
    // mover
    mover = new PVector(random(width/4,width-width/4),random(height/4,height-height/4));
    destination = new PVector(random(width/8,width-width/8),random(height/8,height-height/8));
    
    
    // color
    bg = colors.background();
    c = colors.dcolor(defaults.color);
    
    // sketch
    stroke(color(c,100));
    maxalpha = random(180,210);
    df = width/50;
    noFill();
    background(bg);

}


/*
 * Processing draw.
 */
void draw() {  
    
    // mover
    if (! ia_touch && ! module_draw) {
        
        // update
        destination.x += random(-6,6);
        destination.y += random(-6,6);
        destination.x = max(0,destination.x);
        destination.y = max(0,destination.y);
        destination.x = min(width,destination.x);
        destination.y = min(height,destination.y);
        mover.x += (destination.x-mover.x) * 0.01;
        mover.y += (destination.y-mover.y) * 0.01;
        
        
        // rumble in the jungle
        if (mover.dist(destination) < 15) {
            destination = new PVector(random(width/8,width-width/8),random(height/8,height-height/8));
        }
    }
   
    
    // bezier
    if (module_bezier) {
        
        // update
        for (int i = 0; i < total; i+=2) {
            
            // birdie
            Birdie birdie1 = (Birdie) swarm.get(i);
            Birdie birdie2 = (Birdie) swarm.get((i+1)%total);
            Birdie control1 = (Birdie) swarm.get((i+2)%total);
            Birdie control2 = (Birdie) swarm.get((i+3)%total);
            
            
            // flock
            birdie1.flock(swarm,mover);
            birdie1.update();
            birdie2.flock(swarm,mover);
            birdie2.update();
            
            
            // birdie nam nam
            float d = PVector.dist(birdie1.loc, birdie2.loc);
            float a = pow(1/(d/df), 2);
            stroke(c,a*255);
            bezier(birdie1.loc.x,birdie1.loc.y,control1.loc.x,control1.loc.y,control2.loc.x,control2.loc.y,birdie2.loc.x,birdie2.loc.y);
            line(birdie1.loc.x,birdie1.loc.y,birdie1.ploc.x,birdie1.ploc.y);
        }
        
        
    }
    
    // vertex
    else if (module_vertex) {
        
        
        // update
        int pnb = total;
        for (int i = 0; i < total; i+=pnb) {
            
            // circle
            PVector points = new PVector[pnb];
            for (int j = 0; j < pnb; j++) {
                Birdie birdie = (Birdie) swarm.get(i+j);
                birdie.flock(swarm,mover);
                birdie.update();
                points[j] = new PVector(birdie.loc.x,birdie.loc.y);
            }
            
            // stroke
            float d = PVector.dist(points[0], points[pnb-1]);
            float a = pow(d/height, 1.5);
            stroke(c,a*maxalpha);
            
            
            beginShape();
            curveVertex(points[pnb-1].x,points[pnb-1].y);
            for (int j = 0; j < pnb; j++) {
                curveVertex(points[j].x,points[j].y);
            }
            curveVertex(points[0].x,points[0].y);
            curveVertex(points[1].x,points[1].y);
            endShape();
            
        }
        
        
    }
    
    // draw
    else if (module_draw && mousePressed) {
            
            // distance
            float d = dist(mover.x,mover.y, mouseX,mouseY);
            
            // threshold
            float step = 3.0;
            if (d > step) {
                
                // anchor and controls
                PVector m = memory.get(0);
                PVector c1 = memory.get(lag%memory.size());
                PVector c2 = memory.get((lag*2)%memory.size());
                
                // output
                pushMatrix();
                float a = pow(d/(width*0.25), 4);
                stroke(c,a*255);
                bezier(mover.x,mover.y,c1.x,c1.y,c2.x,c2.y,m.x,m.y);
                popMatrix();
                
                // move
                mover.x += (mouseX-mover.x) * step * 0.01;
                mover.y += (mouseY-mover.y) * step * 0.01;
                
                // memory
                memory.add(new PVector(mover.x,mover.y));
                if (memory.size() > 128) {
                    memory.remove(0);
                };

            }
    }
    
    // debug
    if (defaults.debug) {
        fill(255,0,0);
        ellipse(mover.x,mover.y,5,5);
        fill(0,255,0);
        ellipse(destination.x,destination.y,5,5);
        fill(0,0,255);
        for (int i = 0; i < total; i++) {
            Birdie birdie = (Birdie) swarm.get(i);
            ellipse(birdie.loc.x,birdie.loc.y,3,3);
        }
        
        noFill();
    }
    

		
}



/*
* Processing event mouse pressed.
*/
void mousePressed() {

    // store position
    if (ia_touch || module_draw) {
        mover.x = mouseX;
        mover.y = mouseY;
    }
    
    // clear memory
    if (module_draw) {
        memory = new ArrayList();
        memory.add(new PVector(mover.x,mover.y));
    }
}

/*
* Processing event mouse moved.
*/
void mouseDragged() {

    // store position
    if (ia_touch && ! module_draw) {
        mover.x = mouseX;
        mover.y = mouseY;
    }

}



/**
 * Birdie (based on Boid).
 * @author Daniel Shiffman
 * @url http://processing.org/learning/topics/flocking.html
 */
public class Birdie  {
    
    /*
     * Fields.
     */
    PVector loc;
    PVector ploc;
    PVector vel;
    PVector acc;
    float radius;
    float maxforce;   
    float maxspeed;  
    ArrayList memory;
    int lag;
    
    
    /**
     * Creates a new instance.
     */
    public Birdie(float x, float y, float r) {
        
        // fields
        acc = new PVector(0,0);
        vel = new PVector(0,0);
        loc = new PVector(x,y);
        ploc = new PVector(loc.x,loc.y);
        
        // vars
        radius = r;
        maxspeed = 6;
        maxforce = 0.05;
        
        // sweet memories
        lag = (int)random(128);
        memory = new ArrayList();
    }
    
    
    
    /**
     * Updates the location.
     */
    void update() {
        
        // prev
        ploc = new PVector(loc.x,loc.y);
        
        // velocity
        vel.add(acc);
        
        // limit speed
        vel.limit(maxspeed);
        loc.add(vel);
        
        
        // reset
        acc.mult(0);
    }
    
    /**
     * Memorizes the position.
     */
    void memorize(int s) {
        
        // memorize
        memory.add(new PVector(loc.x,loc.y));
        if (memory.size() > s) {
            memory.remove(0);
        };
    }
    
    /**
     * Flocking birds.
     */
    void flock(ArrayList birds, PVector m) {
        
        // distance
        float dx = m.x - loc.x;
        float dy = m.y - loc.y;
        float d = sqrt(sq(dx) + sq(dy));
        
        // acceleration based on three rules
        PVector sep = separate(birds);   // Separation
        PVector ali = align(birds);      // Alignment
        PVector rest = restrict(birds);   // Restriction
        
        // cohesion
        PVector coh;
        if (ia_touch) {
            coh = (d < radius && mousePressed) ? steer(new PVector(m.x,m.y),false) : cohesion(birds);
        }
        else {
            coh = (d < radius) ? steer(new PVector(m.x,m.y),false) : cohesion(birds);
        }
        
        
        // weight these forces
        sep.mult(1.0);
        ali.mult(1.0);
        coh.mult(1.2);
        rest.mult(1.0);
        
        // add the force vectors to acceleration
        acc.add(sep);
        acc.add(ali);
        acc.add(coh);
        acc.add(rest);
    }
    
    
    
    
    
    /**
     * Separation checks for nearby boids and steers away.
     */
    PVector separate (ArrayList birds) {
        
        // vars
        float desiredseparation = width/10;//20.0;
        PVector steer = new PVector(0,0,0);
        int count = 0;
        
        // check with every bird
        for (int i = 0 ; i < birds.size(); i++) {
            
            // other
            Bird other = (Bird) birds.get(i);
            float d = PVector.dist(loc,other.loc);
            
            // distance
            if ((d > 0) && (d < desiredseparation)) {
                
                // vector pointing away from neighbor
                PVector diff = PVector.sub(loc,other.loc);
                diff.normalize();
                diff.div(d);        // Weight by distance
                steer.add(diff);
                count++;            // Keep track of how many
            }
        }
        
        // average -- divide by how many
        if (count > 0) {
            steer.div((float)count);
        }
        
        // vector is greater than 0
        if (steer.mag() > 0) {
            
            // Implement Reynolds: Steering = Desired - Velocity
            steer.normalize();
            steer.mult(maxspeed);
            steer.sub(vel);
            steer.limit(maxforce);
        }
        return steer;
    }
    
    
    
    /**
     * Alignment for every nearby boid in the system.
     */
    PVector align (ArrayList boids) {
        
        // vars
        float neighbordist = width/12;//25.0;
        PVector steer = new PVector(0,0,0);
        int count = 0;
        for (int i = 0 ; i < boids.size(); i++) {
            Boid other = (Boid) boids.get(i);
            float d = PVector.dist(loc,other.loc);
            if ((d > 0) && (d < neighbordist)) {
                steer.add(other.vel);
                count++;
            }
        }
        if (count > 0) {
            steer.div((float)count);
        }
        
        // As long as the vector is greater than 0
        if (steer.mag() > 0) {
            // Implement Reynolds: Steering = Desired - Velocity
            steer.normalize();
            steer.mult(maxspeed);
            steer.sub(vel);
            steer.limit(maxforce);
        }
        return steer;
    }
    

    
    /**
     * Cohesion for the average location (i.e. center) of all nearby boids, calculate steering vector towards that location.
     */
    PVector cohesion (ArrayList birds) {
        
        // var
        float neighbordist = width/6;
        
        // accumulate all locations
        PVector sum = new PVector(0,0);   
        int count = 0;
        for (int i = 0 ; i < birds.size(); i++) {
            Bird other = (Bird) birds.get(i);
            float d = loc.dist(other.loc);
            if ((d > 0) && (d < neighbordist)) {
                
                // add location
                sum.add(other.loc); 
                count++;
            }
        }
        
        // steer towards the location
        if (count > 0) {
            sum.div((float)count);
            return steer(sum,true);  
        }
        return sum;
    }
    
    
    /**
     * Calculates a steering vector towards a target.
     */
    PVector steer(PVector target, boolean slowdown) {
        
        // steering vector
        PVector steer;  
        
        // desired
        PVector desired = new PVector(target.x-loc.x,target.y-loc.y);  
        
        // distance
        float d = desired.mag(); 
        if (d > 0) {
            
            // normalize
            desired.normalize();
            
            // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
            if ((slowdown) && (d < 100.0)) desired.mult(maxspeed*(d/100.0)); // This damping is somewhat arbitrary
            else desired.mult(maxspeed);
            
            // Steering = Desired minus Velocity
            steer = new PVector(desired.x-vel.x,desired.y-vel.y);
            steer.limit(maxforce);  // Limit to maximum steering force
        } 
        else {
            steer = new PVector(0,0);
        }
        return steer;
    }
    
    
    /**
     * Restrict movement.
     */
    PVector restrict(ArrayList birds) {
        
        // dist
        float dx = 0;
        float dy = 0;
        
        // bound
        float b = width*0.3;
        if (loc.x < b || loc.x > width-b) {
            dx = width/2.0 - loc.x;
        }
        if (loc.y < b || loc.y > height-b) {
            dy = height/2.0 - loc.y;
        }
        
        // desired
        PVector desired = new PVector(dy,dx); 
        desired.normalize();
        float d = desired.mag(); 
        
        // restriction
        if (d > 0) {
            desired.mult(maxspeed*(d/10.0));
            PVector restriction = new PVector(desired.x-vel.x,desired.y-vel.y);
            restriction.limit(maxforce); 
        }
        else {
            restriction = new PVector(0,0);
        }
        
        // return
        return restriction;
    }


    
    
    
}
