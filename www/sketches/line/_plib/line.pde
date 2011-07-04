/*
 * Colors.
 */
public class Colors {
    
    /*
     * Fields.
     */
    public color bgcolor;
    public color[] colors;
    
    /**
     * Creates a new instance.
     */
    public Colors() {
        
        // bgcolor
        bgcolor = color(255,252,240);
        
        // default colors
        colors = new color[5];
        colors[0] = color(181,163,131); // Shikan-cha 
        colors[1] = color(187,192,0);// Kimidori
        colors[2] = color(105,153,174); // Sabiasagi
        colors[3] = color(225,0,178); // Botan-iro
        colors[4] = color(229,0,30); // Shinkou 
        
    }
    
    /**
     * Background.
     */
    public color background() {
        return bgcolor;
    }
    

    /**
    * Color or random.
    */
    public color dcolor(d) {
        color c = colors[(int)random(colors.length)];
        if (d && d.rgb) {
            c = color(d.r*255,d.g*255,d.b*255);
        }
        return c;
    }
}
