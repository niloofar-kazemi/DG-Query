public class AlternativeImage{
	private float x;
	private float y;
	private float altWidth;
	private float altHeight;
	private Alternative alt;
	private PImage image;

	public AlternativeImage(Alternative alt,float x, float y, float altWidth, float altHeight){
		this.x = x;
		this.y = y;
		this.altWidth = altWidth;
		this.altHeight = altHeight;
		this.alt = alt;
		this.image = loadImage(alt.getImageURL());
	}

	public void draw() {
		pushMatrix();
			noFill();
			if (selectedAlternativesRefId.indexOf(alt.getRefId()) >= 0) {
				strokeWeight(10);
				stroke(25,127,200);
			}else{
				stroke(64);
			}

			rect(this.getX(), this.getY(), altWidth, altHeight);
			image(image, this.getX(), this.getY(), altWidth, altHeight);
			strokeWeight(1);
		popMatrix();
	}

	public void drawPartially(int start){
		PImage partialImage = image;
		partialImage.loadPixels();		
		int[] imageAlpha = new int[partialImage.pixels.length];
		float newStart = (start*sqrt(partialImage.pixels.length))/altWidth;
		for (int i = 0; i < partialImage.pixels.length; ++i) {
			if (newStart < 0) {
				if (i > sqrt(partialImage.pixels.length) * abs(newStart)) {
					imageAlpha[i] = 255;
				}else{
					imageAlpha[i] = 0;
				}
			}else{
				if (i < sqrt(partialImage.pixels.length) * newStart) {
					imageAlpha[i] = 255;
				}else{
					imageAlpha[i] = 0;
				}				
			}
		}
		partialImage.mask(imageAlpha);
		pushMatrix();
			noFill();
			if (selectedAlternativesRefId.indexOf(alt.getRefId()) >= 0) {
				strokeWeight(10);
				stroke(25,127,200);
			}else{
				stroke(64);
			}

			rect(this.getX(), this.getY(), altWidth, start);
			image(partialImage, this.getX(), this.getY(), altWidth, altHeight);
			strokeWeight(1);
		popMatrix();
	}

	public void update(float x , float y) {
		this.x = x;
		this.y = y;
	}

	/*interactions*/
	public boolean clicked(){
		if (mouseX > scale*(this.getX()+left) && mouseX < scale*(this.getX()+altWidth+left) && mouseY > scale*(this.getY()+top) && mouseY < scale*(this.getY()+altHeight+top)) {
			selectionListener.onClicked(alt);
			return true;
		}

		return false;
	}

	/*set and get*/

	public float getX() {
		return x;
	}

	public float getY() {
		return y;
	}

	public float getWidth() {
		return altWidth;
	}

	public float getHeight() {
		return altHeight;
	}

}