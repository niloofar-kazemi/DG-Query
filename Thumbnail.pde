public class Thumbnail extends View{
	private ArrayList<PImage> images ;
	private float imageSize = 160;

	public Thumbnail(Collection collection ) {
		super(collection,"Thumb");

		images = new ArrayList<PImage>();
		createImages(collection.getAlternatives());
	}

	public void createImages(ArrayList<Alternative> alternaives){
		for (int i = 0; i < alternaives.size(); ++i) {
			PImage newImage = loadImage(alternaives.get(i).getImageURL());
			images.add(newImage);
		}
	}

	@Override
	public void draw() {
		for (int i = 0; i < images.size(); ++i) {
			image(images.get(i), 25 + this.getX() + (20+imageSize)*i, 70 + this.getY(), imageSize, imageSize);
		}
	}
}