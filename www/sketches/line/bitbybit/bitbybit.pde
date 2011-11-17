/**
 * bitbybit.
 */

// defaults
var defaults =  {
	
	// sketch
	interaction:"auto",
	color:{'rgb':false},
	randomdeath:{'value':0.3,'min':0,'max':1},
	
	// lines
	lines_nb:{'rmin':150,'rmax':450,'min':1,'max':600},
	lines_length:{'rmin':0.1,'rmax':0.5,'min':0,'max':1},
	
	// directions
	direction_up:false,
	direction_upright:true,
	direction_right:false,
	direction_downright:true,
	direction_down:false,
	direction_downleft:true,
	direction_left:false,
	direction_upleft:true
	
};

// lib
Motion motion;
Colors colors;

// parameterize
int maxBits;
ArrayList dirs;

// fields
ArrayList trees;
ArrayList dead;
color c,bg;



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
	
}

/*
 * Processing reset.
 */
void reset() {
	
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
		dirs.add((int)random(4));
		dirs.add((int)random(4,8));
	}
	
	// bits
	maxBits = (int) ( (random(defaults.lines_length.rmin,defaults.lines_length.rmax)+0.05)*width/4.0);
	
	// trees
	trees = new ArrayList();
	dead = new ArrayList();
	if (defaults.interaction == "auto") {
		int t = (int)random(defaults.lines_nb.rmin,defaults.lines_nb.rmax);
		for (int i = 0; i < t; i++) {
			trees.add(new Tree());
		}
	}
    
    // color
    bg = colors.background();
    c  = colors.dcolor(defaults.color);
	
	// sketch
	background(bg);
	fill(c);
    noStroke();
	
}

/*
* Plants a tree.
*/
void plantTree(float x, float y) {
	if (defaults.interaction == "touch") {
		trees.add(new Tree(x,y));
	}
}


/*
 * Processing draw.
 */
void draw() { 
	
    // pixie
    loadPixels();
    
	// trees
	for (int t = 0; t < trees.size(); t++) {
		
		// tree
		Tree tree = (Tree) trees.get(t);
		
		// branch
		boolean grow = true;
		tree.branch.update();
		
		// restraint: size
		if (tree.branch.n >= maxBits) {
			grow = false;
		}
		// restraint: stage
		else if (tree.branch.cx < 0 || tree.branch.cx >= width || tree.branch.cy < 0 || tree.branch.cy >= height) {
			grow = false;
		}
		// restraint: collision
        else if (pixels[tree.branch.cy*width+tree.branch.cx] == c) {
			grow = false;
		}
		
		
		// grow
		if (grow) {
			
			// add bit
			tree.branch.saveBit();
            rect(tree.branch.cx,tree.branch.cy,1,1);
            
		}
		// branch
		else {

			// current branch
			if (tree.branch.n > 0) {
				PVector bit = tree.branch.eraseBit((int)random(0,tree.branch.n));
				tree.branches.add(tree.branch);
				tree.branch = new Branch(bit.x,bit.y,(int) dirs.get((int)random(dirs.size())));
			}
			// stack
			else if (tree.branches.size() > 0 && random(15) > defaults.randomdeath.value) {
				tree.branch = (Branch) tree.branches.remove(tree.branches.size()-1);
			}
			// this is the end my friend
			else {
				dead.add(t);
			}

		}
	}
	
	// dead trees
	if (dead.size() > 0) {
		for (int d = 0; d < dead.size(); d++) {
			int t = (int) dead.get(d);
			trees.remove(t);
		}
		dead = new ArrayList();
	}
	
}

/*
 * Processing event mouse clicked.
 */
void mouseClicked() {
	plantTree(mouseX,mouseY);
}
/*
 * Processing event mouse dragged.
 */
void mouseDragged() {
	float d = width/100.0
	plantTree(mouseX+random(-d,d),mouseY+random(-d,d));
}

/**
 * Tree.
 */
public class Tree {
	
	// Fields
	ArrayList branches;
	Branch branch;
	
	/**
	 * Creates a new instance.
	 */
	public Tree(int x, int y) {
		this.branches = new ArrayList();
		this.branch = new Branch(x,y,(int) dirs.get((int)random(dirs.size())));
	}
	public Tree() {
		this((int)random(0,width),(int)random(0,height));
	}
}

/**
 * Branch.
 */
public class Branch {
	
    /*
	 * Fields.
	 */
    private int x,y,d;
    public int cx,cy,n;
    private ArrayList bits;
	
    /**
	 * Creates a new instance.
	 */
    public Branch(int x, int y, int d) {
		this.x = this.cx = x;
		this.y = this.cy = y;
		this.d = d;
		this.n = 0;
		this.bits = new ArrayList();
    }
    
    /**
	 * Updates the branch.
	 */
    public void update() {
		
		// current position
		switch(this.d) {
			case(0): // up
				this.cy -= 1;
				break;
			case(1): // up right
				this.cx += 1;
				this.cy -= 1;
				break;
			case(2): // right
				this.cx += 1;
				break;
			case(3): // down right
				this.cx += 1;
				this.cy += 1;
				break;
			case(4): // down
				this.cy += 1;
				break;
			case(5): // down left
				this.cx -= 1;
				this.cy += 1;
				break;
			case(6): // left
				this.cx -= 1;
				break;
			case(7): // up left
				this.cx -= 1;
				this.cy -= 1;
				break;
		}
		
		
		
		
    }
    
    /**
	 * Saves a bit.
	 */
    public void saveBit() {
		
		// increment
		n++;
		
		// add
		this.bits.add(new PVector(this.cx,this.cy));
    }
    
    /**
	 * Gets a bit.
	 */
    public PVector getBit(int i) {
		return (PVector) this.bits.get(i);
    }
    
    /**
	 * Erases a bit.
	 */
    public PVector eraseBit(int i) {
		this.n--;
		return (PVector) this.bits.remove(i);
    }
}

