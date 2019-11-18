public class Dimension{
	// view properies
	private float posX;
	private float posY;
	private float dimHeight;
	private ArrayList<Brush> brushes;
	private Brush currentBrush;

    // data property
	private String name; 
	private float min;
	private float max;

	public Dimension(String name, float dimHeight, float posX, float posY , float max, float min) {
		this.name = name;
		this.dimHeight = dimHeight;
		this.posX = posX;
		this.posY = posY;
		this.max = max;
		this.min = min;

		brushes = new ArrayList<Brush>();
		currentBrush = null;
	}

	public void draw(){
		// draw name
		pushMatrix();
			fill(0);
			textSize(10);
			float nameWidth = textWidth(name);
			translate(posX, posY);
			rotate(radians(-45));
			text(name, 0,0);			
		popMatrix();

		// draw line
		line(posX, posY, posX, posY+dimHeight);

		//draw brushes
		for (int i = 0; i < brushes.size(); ++i) {
			brushes.get(i).draw();
		}

		//draw current brush
		if(currentBrush != null){
			currentBrush.draw();
		}
	}

	/* interactions */
	public boolean dragged(){
		if(currentBrush != null){
			float t = mouseY - pmouseY + currentBrush.getEnd();
			if(t < posY){
				t = posY;
			}
			else if(t > posY + dimHeight){
				t = posY + dimHeight;
			}
			currentBrush.updateEnd(t);
			return true;
		}
		else{
			if(abs(mouseX - posX) < 5 && mouseY > posY && mouseY < posY + dimHeight){
				boolean result=false;
				for (int i = 0; i < brushes.size(); ++i) {
					if(brushes.get(i).dragged()){
						result = true;
						break;
					}
				}	
				if(!result){
					currentBrush = new Brush(posX, mouseY);
				}
				return true;
			}		
		}
		return false;
	}

	public void released(){
		if(currentBrush != null){
			brushes.add(currentBrush);
			currentBrush = null;	
		}
	}

	/* set and gets */
	public float getX(){
		return posX;
	}

	public float getY(){
		return posY;
	}

	public float getHeight(){
		return dimHeight;
	}

	public float getMax(){
		return max;
	}

	public float getMin(){
		return min;
	}

	public String getName(){
		return name;
	}

	public ArrayList<Brush> getBrushes(){
		return brushes;
	}

	public Brush getCurrentBrush(){
		return currentBrush;
	}

}