public class Link implements Comparator<Brush>{
	// view properies
	private ArrayList<Brush> brushes;


	public Link(Brush firstBrush) {
		brushes = new ArrayList<Brush>();
		brushes.add(firstBrush);
	}

	public void draw(){
		if (brushes.size() > 1) {
			for (int i = 0; i < brushes.size(); i++) {
				if (i+1<brushes.size()) {
					Brush firstB = brushes.get(i);
					Brush secondB = brushes.get(i+1);

					float firstTop = firstB.getStart();
					float firstEnd = firstB.getEnd(); 
					float firstX = firstB.getX();
					if (firstTop > firstEnd) {
						firstTop = firstB.getEnd();
						firstEnd = firstB.getStart();
					}

					float secondTop = secondB.getStart();
					float secondEnd = secondB.getEnd(); 
					float secondX = secondB.getX();
					if (secondTop > secondEnd) {
						secondTop = secondB.getEnd();
						secondEnd = secondB.getStart();
					}

					fill(255,0,0,100);
					quad(firstX, firstTop, secondX, secondTop, secondX, secondEnd, firstX, firstEnd);
				}
			}			
		}else if(brushes.size() == 1){
			Brush firstB = brushes.get(0);
			float firstTop = firstB.getStart();
			float firstEnd = firstB.getEnd(); 
			float firstX = firstB.getX();

			if (firstTop > firstEnd) {
				firstTop = firstB.getEnd();
				firstEnd = firstB.getStart();
			}

			fill(255,0,0,100);
			rect(firstX - 2.5, firstTop, 5 , abs(firstEnd - firstTop));
		}
	}

	@Override
	public int compare(Brush a, Brush b) 
    { 
        return floor(a.getX() - b.getX()); 
    }

	/*sorts the brushes based on their position*/
	public void sort(){
		Collections.sort(brushes, this);
	}

	/* get and sets */

	/* sorts all the brushes after adding a new brush*/
	public void add(Brush newBrush){
		brushes.add(newBrush);
		sort();
	}

	public ArrayList<Brush> getBrushes() {
		return brushes;
	}
}