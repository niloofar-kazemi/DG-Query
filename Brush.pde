public class Brush{
	// view properies
	private float start;
	private float end;
	private float posX;


	public Brush(float posX, float start) {
		this.posX = posX;
		this.start = start;
		this.end = start;
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

}