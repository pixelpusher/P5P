/**
* Test. One Two. Test.
*/


// local defaults
var	defaults =  {
	test_value:"test_value (local)",
	test_local:"test_local value",
	test_live_x:"0.5",
	test_live_y:"0.5"
};

/*
* Processing setup.
*/
void setup() {
P5P.ios.log("setup");
  
	// stage
	size(DeviceSettings.view_width,DeviceSettings.view_height);
	noLoop();
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
	
	// draw
	draw();

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
P5P.ios.log("draw");

	// background
	background(255);
	fill(0); 
	
	// offset
	int offset = 70;
	
	// DeviceSettings
	text("DeviceSettings",20,offset);
	text("DeviceSettings.type: " + DeviceSettings.type,20, offset+=15);
	text("DeviceSettings.platform: " + DeviceSettings.platform,20, offset+=15);
	text("DeviceSettings.version: " + DeviceSettings.version,20, offset+=15);
	text("DeviceSettings.name: " + DeviceSettings.name,20, offset+=15);
	text("DeviceSettings.uuid: " + DeviceSettings.uuid,20, offset+=15);	
	text("DeviceSettings.view_width: " + DeviceSettings.view_width,20, offset+=15);
	text("DeviceSettings.view_height: " + DeviceSettings.view_height,20, offset+=15);
	
	// PageSettings
	text("PageSettings",20,offset+=30);
	text("PageSettings.title: " + PageSettings.title,20, offset+=15);
	text("PageSettings.lib: " + PageSettings.lib,20, offset+=15);
	text("PageSettings.sketch: " + PageSettings.sketch,20, offset+=15);

	
	// defaults
	text("Defaults",20,offset+=30);
	text("defaults.test_value: "+defaults.test_value ,20, offset+=15);
	text("defaults.test_local: "+defaults.test_local ,20, offset+=15);
	text("defaults.test_device: "+defaults.test_device ,20, offset+=15);

  
}

