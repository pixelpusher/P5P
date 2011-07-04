/**
 * jQuery Plugin iOS.
 * @author CNPP		
 * @source Based on PhoneGap
 */
if (typeof(DeviceSettings) != 'object') {
	DeviceSettings = {
			type:null,
			platform:null,
			version:null,
			name:null,
			uuid:null,
			view_width:0,
			view_height:0	
	};
}
if (typeof(DeviceEvent) != 'object') {
	DeviceEvent = {
			available:false,
			type:null,
			data:null
	};
}
if (typeof(PageSettings) != 'object') {
	PageSettings = {
			title:"Title",
			sketch:"sketch.pde",
			lib:"lib.pde"
	};
}
if (typeof(DeviceAcceleration) != 'object') {
	DeviceAcceleration = {
			available:false,
			x:0,
			y:0,
			z:0	
	};
}
jQuery.fn.ios = function(op) {	

	// settings
	var settings =  {
		device:true,
		debug:false,
		interval_poll:50,
		interval_command:50
	};
	jQuery.extend(settings, op);
	
	// vars
	var ready = false;
	
	
	// observe device state
	if (settings.device) {
		var timer = setInterval(function() {
		
			// check for events
			if (DeviceEvent.available) {
		
				// type
				switch(DeviceEvent.type) {
					// device_ready
					case 'device_ready':
					ready = true; // state
					break;
					// default
					default:
					break;
				}
			
				// notify
				var e = document.createEvent('Events'); 
				e.initEvent(DeviceEvent.type);
				document.dispatchEvent(e);
				
				// reset
				DeviceEvent.available = false;
				DeviceEvent.type = null;
				DeviceEvent.data = null;
		}
		
		}, settings.interval_poll);
	}
	
	// standalone
	var mouseX = 0;
	var mouseY = 0;
	var dwidth = jQuery(document).width();
	var dheight = jQuery(document).height();
	if (! settings.device) {
		jQuery(window).bind("mousemove",function(evt){
			mouseX = evt.pageX;
			mouseY = evt.pageY;
		});
	}
	
	
	/**
	* Indicates if in device mode.
	*/
	this.isDevice = function() {
		return settings.device;
    };
	this.isPad = function() {
		return (
		        (navigator.platform.indexOf("iPad") != -1)
		    );
    };
	this.isMobile = function() {
		return (
		        (navigator.platform.indexOf("iPhone") != -1) ||
		        (navigator.platform.indexOf("iPod") != -1)
		    );
    };
	
	/**
	* Logs a message.
	*/
	this.log = function(msg) {
		
		// check
		if (! settings.debug) {
			return;
		}
		
		// device
		if (settings.device) {
			this.exec('log',msg);
		}
		else {
			console.log(msg);
		}
		
	
    };
	
	/**
	* Retrieves the device acceleration.
	*/
	this.acceleration = function(dir) {
	
		// data
		var data = dir || "xyz";
		
		// device
		if (settings.device) {
			this.exec('acceleration',data);
		}
		// simulate
		else {
			DeviceAcceleration.available = true;
			DeviceAcceleration.x = (dwidth/2.0-mouseX)/100.0;
			DeviceAcceleration.y = -(dheight/2.0-mouseY)/100.0;
		}
		
	
    };
	
	/**
	* Executes a command.
	*/
	var commands = new Array();
	var ctimer = null;
	var cready = true;
	this.exec = function(command,data) {
		
		// check
		if (!settings.device) {
			return;
		}
		
		// commands
		var url = "ios://" + command + "/" + data;
		commands.push(url);
		if (ctimer == null) {
			cready = true;
			ctimer = setInterval(run_command, settings.interval_command);
		}
		
	
    };
	
	/*
	* Runs a command.
	*/
	run_command = function() {
	
		// check
		if (!cready || !ready) {
			return;
		}
		
		// busy
		cready = false;
		
		// nothing to do today
		if (commands.length == 0) {
			
			// clear timer
			clearInterval(ctimer);
			ctimer = null;
			cready = true;
			
			// rest
			return;
		}

		// execute url
		var url = commands.shift();
		document.location = url;
		
		// and on it goes
		cready = true;

	};
	
	/**
	* Resets all pending commands.
	*/
	this.reset = function() {
		// clear timer
		clearInterval(ctimer);
		ctimer = null;
		
		// commands
		commands = new Array();
		
		// ready
		cready = true;
		
    };

	
	// chain
	return this;
	
};