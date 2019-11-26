public class Thumbnail extends View{
	private ArrayList<AlternativeImage> images ;
	private float imageSize = 160;
	private ArrayList<Integer> selectedAlternatives;
	private Collection collection;

	public Thumbnail(Collection collection ) {
		super(collection,"Thumb");

		this.collection = collection;
		images = new ArrayList<AlternativeImage>();
		selectedAlternatives = new ArrayList<Integer>();

		createImages(collection.getAlternatives());
	}

	public void createImages(ArrayList<Alternative> alternaives){
		int column = 0;
		int row = 0;
		for (int i = 0; i < alternaives.size(); ++i) {
			if ( 50 + (20+imageSize)*(column+1) > this.getWidth() ) {
				row ++;
				column = 0;
			}
			images.add(new AlternativeImage(alternaives.get(i) , 25 + this.getX() + (20+imageSize)*column, 50 + this.getY()+(20+imageSize)*row,imageSize,imageSize));			
			column ++;
		}
	}

	@Override
	public void draw() {
		for (int i = 0; i < images.size(); ++i) {
			AlternativeImage newImage = images.get(i);
			if (newImage.getY() >= 50 + this.getY() && newImage.getY()+newImage.getHeight() <= 50 + this.getY()+this.getHeight()) {
				newImage.draw();
			}else if (newImage.getY() < 50 + this.getY()+this.getHeight() && newImage.getY()+newImage.getHeight() > 50 + this.getY()+this.getHeight()){
				newImage.drawPartially(floor(50 + this.getY()+this.getHeight() - newImage.getY()));
			}else if (newImage.getY() < 50 + this.getY() && newImage.getY()+newImage.getHeight() > 50 + this.getY()){				
				newImage.drawPartially(floor(50 + this.getY() - newImage.getY() - newImage.getHeight()));
			}
		}
	}

	@Override
	public void update(){
		ArrayList<Alternative> alternaives = collection.getAlternatives();

		int column = 0;
		int row = 0;
		for (int i = 0; i < alternaives.size(); ++i) {
			if ( 50 + (20+imageSize)*(column+1) > this.getWidth() ) {
				row ++;
				column = 0;
			}
			images.get(i).update(25 + this.getX() + (20+imageSize)*column, 50 + this.getY() + (20+imageSize)*row);
			column ++;
		}
	}

	public void update(float newY){
		ArrayList<Alternative> alternaives = collection.getAlternatives();		
		for (int i = 0; i < alternaives.size(); ++i) {
			images.get(i).update(images.get(i).getX(), images.get(i).getY()+newY);
		}
	}

	/*interactions*/
	@Override
	public void brushChange(ArrayList<String> newRefIds) {
		selectedAlternatives = new ArrayList<Integer>();
		for (int i = 0; i < collection.getAlternatives().size(); ++i) {
			Alternative tmpAlt = collection.getAlternatives().get(i);
			for (int j = 0; j < newRefIds.size(); ++j) {
				if(tmpAlt.getRefId().equals(newRefIds.get(j))){
					selectedAlternatives.add(i);
				}
			}
		}
	}

	@Override
	public void clicked() {
		for (int i = 0; i < images.size(); ++i) {
			images.get(i).clicked();
		}
	}

	@Override
	public void wheel(){
		if (wheelDir > 0) {
			update(-1);			
		}else{
			update(1);			
		}
	}
}