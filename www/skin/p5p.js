/**
* P5P JavaScript stuff.
* @author CNPP
*/
var P5P = {
    
    /*
    * Flags.
    */
    device:true,
    debug:false,
    track:false,
    
	
	/*
	* References.
	*/
	p5: null,
	ios: null,
	
	
	/**
	* Initialize on document ready.
	*/
	initOnDocumentReady: function() {	
		//console.log("initOnDocumentReady");
	
		// init ios
		P5P.ios = jQuery().ios({"device":P5P.device,"debug":P5P.debug});
		P5P.ios.log("iOS initialized.");
		
		// init local
		if (! P5P.device) {
		
			// init settings
			P5P.initLocalSettings();
			
			// init sketches
			P5P.initSketches();
			
			// init processing
			P5P.initProcessing();
            
            // init tracker
			P5P.initTracker();
			
			// modal
			P5P.initModal();
			
			// init links
			P5P.initLinks();

		}

	},
	
	/**
	* Initialize on device ready.
	*/
	initOnDeviceReady: function() {
		P5P.ios.log("initOnDeviceReady");
		
		// nothing to do here (sketch is preloaded in background)
	},
	
	/**
	* Initialize on page reload.
	*/
	initOnDeviceReload: function() {
		P5P.ios.log("initOnDeviceReload");
		
		// hide (in case not properly unloaded)
		jQuery("#sketch").hide();
		
		// init
		P5P.initProcessing();		
	},
	
	/**
	* Initialize on page refresh.
	*/
	initOnDeviceRefresh: function() {
		P5P.ios.log("initOnDeviceRefresh");
	
		// refresh
		if (P5P.p5) {
			P5P.p5.refresh();
		}
		// safety fallback
		else {
			// try reload
			P5P.initOnDeviceReload();
		}
	},
	
	/**
	* Initialize on page update.
	*/
	initOnDeviceUpdate: function() {
		P5P.ios.log("initOnDeviceUpdate");
	
		// update settings
		if (P5P.p5) {
			P5P.p5.settings();
		}
		// safety fallback
		else {
			// try reload
			P5P.initOnDeviceReload();
		}
	},
	
	/**
	* Resets on page unload.
	*/
	resetOnDeviceUnload: function() {
		P5P.ios.log("resetOnDeviceUnload");
		
		// reset p5
		P5P.resetProcessing();
		
		// reset ios
		P5P.ios.reset();
	},

	
	/**
	 * Initializes the DeviceSettings and PageSettings object.
	 */
	initLocalSettings: function() {	
	P5P.ios.log("initLocalSettings");
		
		// DeviceSettings
		DeviceSettings.type = "browser";
		DeviceSettings.platform = navigator.userAgent;
		DeviceSettings.version = jQuery.browser.version;
		DeviceSettings.view_width = jQuery("#p5").width();
		DeviceSettings.view_height = DeviceSettings.view_width*(8.0/6.0);
			
		// PageSettings
		PageSettings.title = "P5P";
		if ( (param_title = jQuery(document).getUrlParam("title")) != null) {
			PageSettings.title = unescape(param_title);
		}
		PageSettings.sketch = "_test/defaults/defaults.pde"
		if ((param_sketch = jQuery(document).getUrlParam("sketch")) != null) {
			PageSettings.sketch = param_sketch;
		}
		PageSettings.lib = "_test/_plib/test.pde"
		if ((param_lib = jQuery(document).getUrlParam("lib")) != null) {
			PageSettings.lib = param_lib;
		}
		

	},
	
	
	/**
	 * Initializes processing.
	 */
	initProcessing: function() {	
	P5P.ios.log("initProcessing");
	
		// processing
		jQuery(".processing").each(function(i,canvas) {
			
			// prepare canvas
			jQuery(canvas).css({"width":DeviceSettings.view_width,"height":DeviceSettings.view_height});
			jQuery(canvas).attr("width",DeviceSettings.view_width);
			jQuery(canvas).attr("height",DeviceSettings.view_height);
			
			
			// code
			var code = "";

			// load sketch
			P5P.ios.log("load sketch: " + PageSettings.sketch);
			jQuery.ajax({ url: PageSettings.sketch, async: false, context: document.body, success: function(data){
			
				// append sketch
				code += ";\n" + data;
				
				// load global library
				var p5plib = "_plib/p5p.pde";
				P5P.ios.log("load lib: " + p5plib);
				jQuery.ajax({ url:p5plib, async: false, context: document.body, success: function(data){
				
					// append lib
					code += ";\n" + data;
					
					// load collection library
					P5P.ios.log("load lib: " + PageSettings.lib);
					jQuery.ajax({ url:PageSettings.lib, async: false, context: document.body, success: function(data){
					
						// append lib
						code += ";\n" + data;
						
						// safety exit
						if (P5P.p5 != null) {
							P5P.ios.log("exit");
							P5P.p5.exit();
							P5P.p5 = null;
						}
					
						// show sketch
						jQuery("#sketch").show();
					
						// init
						P5P.p5 = new Processing(canvas,code);
                        //P5P.p5.use3DContext = true;
						P5P.ios.log("initialized.");

						
					}});
			
				}});
			
			}});
			

		});

	},
	
	/**
	* Resets processing.
	*/
	resetProcessing: function() {
		P5P.ios.log("resetProcessing");
		
		// bye bye
		if (P5P.p5) {
		
			// cleans up resources
			P5P.p5.exit(); 
			
			// reset p5
			P5P.p5 = null;
		
		}
		
		// unbind events
		jQuery("#sketch").unbind();
		
		// hide sketch
		jQuery("#sketch").hide();

	},
	
	/**
	* Initialize the links.
	*/
	initLinks: function(ctx) {	
		
		// email
		SEmail.initialize();
		
		// app store
		jQuery(".appstore").bind("click",function(){
			window.location = "http://itunes.apple.com/app/p5p-generative-sketches/id443413228?mt=8";
		});
		
	},
    
	/**
	* Initializes the sketches.
	*/
	initSketches: function() {
		P5P.ios.log("initSketches");
		
		// sketches
		jQuery(".sketches li").each(function(i,sketch) {
			
			// events
			jQuery(sketch).bind("mouseenter",function(){
				jQuery(this).addClass("hover");
				jQuery("img",this).animate({opacity: 0.85}, 180);
			});
			jQuery(sketch).bind("mouseleave",function(){
				jQuery(this).removeClass("hover");
				jQuery("img",this).animate({opacity: 1.0}, 300);
			});
		
			
			// sketch
			jQuery(sketch).bind("click",function(e){
			
				// event
				e.preventDefault();
				
				// link
				var link = jQuery("a",this);
			
				// vars
				var collection = jQuery(link).attr("rel");
				var sketch = jQuery(link).attr("href");
				var title = jQuery(link).html();
				var folder = sketch.substring(0,sketch.length-4);
				
				// params
				var params = "?sketch="+collection+"/"+folder+"/"+sketch+"&lib="+collection+"/_plib/"+collection+".pde&title="+title;
				
				// open sketch
				window.location = "sketches/p5p.html"+params;
				return false;
				
			});
			
		
		});
		
		// p5p
		if (jQuery("#page").hasClass("p5p")) {
			
			// title
			jQuery("#header h2").html(PageSettings.title);
            jQuery("title").html("P5P - " + PageSettings.title);
			
			
			// refresh
			jQuery("#refresh").bind("click",function(evt){
				evt.preventDefault();
				P5P.initOnDeviceRefresh();
			});
			
			// source
			jQuery("#source").attr("href",PageSettings.sketch);
			
			//  position
			if (P5P.ios.isPad() || P5P.ios.isMobile()) {
				var stop = DeviceSettings.view_height + 100 + 'px';
				jQuery("#source").css({"top":stop});
			}

			
		}
		
	},
	
	/**
	 * Initialize the modal.
	 */
	initModal: function(ctx){
		
		// modal
		jQuery("ul.screens li a",ctx).nyroModal({
			bgColor:'#F5F5F5',
			minHeight:'100',
			hideContent:function hideModal(elts, settings, callback) {
			  elts.wrapper.hide().animate({opacity: 0}, {complete: callback, duration: 80}); 
			},
			showBackground:function showBackground(elts, settings, callback) {
				
				//  position
				if (P5P.ios.isPad() || P5P.ios.isMobile()) {
					var st = jQuery(window).scrollTop();
					jQuery("#nyroModalFull").css({"top":st});
					jQuery("#nyroModalWrapper").css({"margin-top":20,"top":0});
				}
				
				// animate
				elts.bg.css({opacity:0}).fadeTo(300, 0.75, callback);
			}
		});
	},
	
    /**
     * Initialize the tracker.
     */
	initTracker: function(ctx) {	
        
        // flag
        if (P5P.track) {
        
            // tracker
            var trackerId = "UA-1005717-23";
            
            // app store
            jQuery(".appstore").bind("click",function() {
                
                // track
                try {
                    var pageTracker = _gat._getTracker(trackerId);
                    pageTracker._trackEvent('Tracker', 'App Store', '/tracker/app-store');
                }
                catch (e) {
                    // ignore
                }
                
                // follow link
                return true;
            });
            
            
            // cnpp 
            jQuery(".cnpp").bind("click",function() {
                
                // track
                try {	
                    var pageTracker = _gat._getTracker(trackerId);
                    pageTracker._trackEvent('Tracker', 'CNPP', '/tracker/cnpp');
                }
                catch (e) {
                    // ignore
                }
                
                // follow link
                return true;
            });
            
            // sketch
            jQuery(".sketches li").bind("click",function() {
                
                // link
                var link = jQuery("a",this);
                
                // vars
                var collection = jQuery(link).attr("rel");
                var title = unescape(jQuery(link).html());
                
                // track
                try {	
                    var pageTracker = _gat._getTracker(trackerId);
                    pageTracker._trackEvent('Sketch', collection, title);
                }
                catch (e) {
                    // ignore
                }
                
                // follow link
                return true;
                
                
            });
            
            
        }
		
	}
}

/*
* Initialize.
*/
jQuery(document).ready(function(){
	P5P.initOnDocumentReady();
});
document.addEventListener("device_ready",P5P.initOnDeviceReady,false);
document.addEventListener("device_reload",P5P.initOnDeviceReload,false);
document.addEventListener("device_refresh",P5P.initOnDeviceRefresh,false);
document.addEventListener("device_update",P5P.initOnDeviceUpdate,false);
document.addEventListener("device_unload",P5P.resetOnDeviceUnload,false);
