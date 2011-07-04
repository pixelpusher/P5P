/**
* Test. One Two. Test.
*/


// local defaults
var defaults =  {
};

/*
* Processing setup.
*/
void setup() {
P5P.ios.log("setup");
  
	// stage
	size(DeviceSettings.view_width,DeviceSettings.view_height);
	frameRate(12);
	smooth();
	
	// font
	PFont font = loadFont("Helvetica");
	textFont(font, 12);
	
	// settings
	settings();
}

/*
* Processing refresh.
*/
void refresh() {
P5P.ios.log("refresh");

	// settings
	settings();

}

/*
* Processing update.
*/
void settings() {
P5P.ios.log("settings");

	// extend defaults
	if (window.UserDefaults) {
		jQuery.extend(defaults, window.UserDefaults);
	}
}

/*
 * Processing draw.
 */
void draw() {

	// background
	background(255);
    noStroke();
	fill(0); 
	
	// offset
	int offset = 70;
	
	// live
	text("Live",20,offset);
	text("defaults.test_live_x.value: "+defaults.test_live_x.value ,20, offset+=15);
	text("defaults.test_live_y.value: "+defaults.test_live_y.value ,20, offset+=15);
    if (defaults.test_color.rgb) {
        text("defaults.test_color.r: "+defaults.test_color.r*255 ,20, offset+=15);
        text("defaults.test_color.g: "+defaults.test_color.g*255 ,20, offset+=15);
        text("defaults.test_color.b: "+defaults.test_color.b*255 ,20, offset+=15);
    }
	
	// inputs
	text("Inputs",20,offset+=30);
	text("defaults.test_switch: "+defaults.test_switch ,20, offset+=15);
	text("defaults.test_slider: "+defaults.test_slider ,20, offset+=15);
	if (defaults.test_slider != null) {
		text("defaults.test_slider.value: "+defaults.test_slider.value ,20, offset+=15);
	}
	text("defaults.test_range: "+defaults.test_range ,20, offset+=15);
	if (defaults.test_range != null) {
		text("defaults.test_range.rmin: "+defaults.test_range.rmin ,20, offset+=15);
		text("defaults.test_range.rmax: "+defaults.test_range.rmax ,20, offset+=15);
	}
	text("defaults.test_picker: "+defaults.test_picker ,20, offset+=15);
    
    
    // values
    color c = color(0);
    if (defaults.test_color.rgb) {
        c = color(defaults.test_color.r*255,defaults.test_color.g*255,defaults.test_color.b*255);
    }
    fill(c);
	ellipse(width*defaults.test_live_x.value,height*defaults.test_live_y.value,10,10);

  
}

