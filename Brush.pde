public class Brush{
	// view properies
	private float start;
	private float end;
	private float posX;
	private String dimName;

	public Brush(float posX, float start, String dimName) {
		this.posX = posX;
		this.start = start;
		this.end = start;
		this.dimName = dimName;
	}

	public void draw(){
		// draw line

		fill(255, 25);
		if(start < end){
			rect(posX - 2.5, start, 5 , abs(end - start));
		}
		else{
			rect(posX - 2.5, end, 5 , abs(end - start));
		}
	}

	/* interactions */
	public boolean dragged(){
		if(abs(mouseX - scale*(posX+left)) < 5 && ( 
			(mouseY > scale*(top+start) && mouseY < scale*(end+top)) || 
			(mouseY > scale*(top+end) && mouseY < scale*(start+top)) 
		)){
			start += mouseY - pmouseY;
			end += mouseY - pmouseY;
			return true;
		}
		return false;
	}

	public boolean clicked() {
		if(abs(mouseX - scale*(posX+left)) < 5 && ( 
			(mouseY > scale*(top+start) && mouseY < scale*(end+top)) || 
			(mouseY > scale*(top+end) && mouseY < scale*(start+top)) 
		)){			
			return true;
		}
		return false;
	}

	/* get and sets */
	public float getStart(){
		return start;
	}

	public void updateStart(){

	}

	public float getEnd(){
		return end;
	}

	public void updateEnd(float newEnd){
		end = newEnd;
	}

	public float getX(){
		return posX;
	}

	public String getDimName(){
		return dimName;
	}

}