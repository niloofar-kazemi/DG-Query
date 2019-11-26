public class View{	

	// view properties
	private String type = "PC"; // Enum{PC,Thumb}
	private boolean enable = true;
	private float viewWidth; 
	private float viewHeight;
	private float viewX; 
	private float viewY; 

	public View(Collection collection , String type){
		viewWidth = collection.getWidth();
		viewHeight = collection.getHeight();
		viewX = collection.getX();
		viewY = collection.getY();
		this.type = type;
	}

	public void draw(){

	}

	public void update() {
		
	}

	/* interaction */

	public void pressed(){	
	}

	public void released(){	
	}

	public void clicked(){
	}

	public void keyPressed() {
	}

	public boolean dragged(){
		return false;
	}

	public void wheel() {
	}

	public void brushChange(ArrayList<String> newRefIds) {
	}

	/* get and sets */
	public void setX(float newX) {
		viewX = newX;
	}

	public void setY(float newY) {
		viewY = newY;
	}

	public float getWidth() {
		return viewWidth - 50;
	}

	public float getHeight() {
		return viewHeight - 100;
	}

	public float getX() {
		return viewX;
	}

	public float getY() {
		return viewY;
	}

	public String getType(){
		return type;
	}

}