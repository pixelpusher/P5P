/*
* Static.
*/
boolean deviceIPad() {
	boolean ipad = false;
	if (DeviceSettings && DeviceSettings.type && DeviceSettings.type == "iPad") {
		ipad = true;
	}
	return ipad;
}
boolean deviceIPhone() {
	boolean iphone = false;
	if (DeviceSettings && DeviceSettings.type && DeviceSettings.type == "iPhone") {
		iphone = true;
	}
	return iphone;
}

/*
* Motion Tools.
*/
public class Motion {
  
	/*
	* Fields.
	*/
	public float threshhold;
	public float factor;
	
  
	/**
	* Creates a new instance.
	*/
	public Motion(float threshhold, float factor) {
		// fields
		this.threshhold = threshhold;
		this.factor = factor;
		this.a = new PVector(0,0);
	}
	public Motion() {
		this(0.01,10.0);
	}

	
	/**
	* Updates the acceleration.
	*/
	public void acceleration() {
		// call ios plugin
		P5P.ios.acceleration();
	}
	
	/**
	* Indicates horizontal movement.
	*/
	public boolean isMotionX() {
		boolean m = false;
		if (abs(DeviceAcceleration.x) > threshhold) {
			m = true;
		}
		return m;
	}
	
	/**
	* Indicates vertical movement.
	*/
	public boolean isMotionY() {
		boolean m = false;
		if (abs(DeviceAcceleration.y) > threshhold) {
			m = true;
		}
		return m;
	}
	
	/**
	* Returnes the x acceleration.
	*/
	float accelerationX() {
		return DeviceAcceleration.x;
	}
	
	/**
	* Returnes the y acceleration.
	*/
	float accelerationY() {
		// ios is upside down
		return - DeviceAcceleration.y;
	}
	
	/**
	* Calculates the x motion.
	*/
	float motionX() {
		return DeviceAcceleration.x*factor;
	}
	
	/**
	* Calculates the y motion.
	*/
	float motionY() {
		// ios is upside down
		return - DeviceAcceleration.y*factor;
	}
	
	
	/**
	* Constrains a point to the area.
	*/
	public void constrain(PVector p) {
		// constrain
		if (p.x < 0) {
			p.x = 0;
		}
		if (p.x > width) {
			p.x = width-1;
		}
		if (p.y < 0) {
			p.y = 0;
		}
		if (p.y > height) {
			p.y = height-1;
		}
	}

}
