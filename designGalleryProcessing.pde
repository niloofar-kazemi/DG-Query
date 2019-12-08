ArrayList<Collection> collections;
ArrayList<String> selectedAlternativesRefId;
float top = 0;
float left = 0;
float scale = 1;
float closeEnough = 10;
float wheelDir = 0;

void setup() {
  // size(1440  , 900);
  fullScreen();
  frameRate(60);
  collections = new ArrayList<Collection>();
  selectedAlternativesRefId = new ArrayList<String>();
  // in Action file
  fetchCollections();
}

void draw() { 
	background(64);
	scale(scale);
	translate(left , top);
	if(collections != null){
		for (int i = 0; i < collections.size(); ++i) {
			Collection col = collections.get(i);
			col.draw();
		}
	}
}

void keyPressed(){
	if (key == '+') {// press + to zoom in
		scale += 0.2;
	}else if (key == '-'){// press - to zoom out
		scale -= 0.2;
	}

	if(collections != null){
		for (int i = collections.size()-1; i >= 0 ; --i) {
			Collection col = collections.get(i);
			col.keyPressed();
		}
	}
}

/* whenever theres a click event they will be send to all the instaces of collections*/
void mouseClicked() {
	if(collections != null){
		for (int i = collections.size()-1; i >= 0 ; --i) {
			Collection col = collections.get(i);
			col.clicked();
		}
	}
}

/* whenever theres a drag event they will be send to all the instaces of collections*/
void mouseDragged() {

	boolean result = false;

	if(collections != null){
		for (int i = collections.size()-1; i >= 0 ; --i) {
			Collection col = collections.get(i);			
			if (col.dragged()) {
				result = true;
				break;
			}
		}
	}

	if (!result) {
		top += (mouseY - pmouseY)/scale;
		left += (mouseX - pmouseX)/scale;
	}
}

void mousePressed() {
	if(collections != null){
		for (int i = collections.size()-1; i >= 0 ; --i) {
			Collection col = collections.get(i);
			col.pressed();
		}
	}
}

void mouseReleased() {
	if(collections != null){
		for (int i = collections.size()-1; i >= 0 ; --i) {
			Collection col = collections.get(i);
			col.released();
		}
	}
}

void mouseWheel(MouseEvent event) {
	float e = event.getCount();
	if(e > 0){
		wheelDir = e;
	}else if(e < 0){
		wheelDir = e;
	}

  	if(collections != null){
		for (int i = collections.size()-1; i >= 0 ; --i) {
			Collection col = collections.get(i);
			col.wheel();
		}
	}
}


/*if the brushes will change in any collection this function will be called*/ 
BrushChangeListener brushListener = new BrushChangeListener(){
	@Override
	public void onChange(ArrayList<String> newRefIds){
		selectedAlternativesRefId = newRefIds;
		if(collections != null){
			for (int i = 0; i < collections.size(); ++i) {
				Collection col = collections.get(i);
				col.brushChange(newRefIds);
			}
		}
	}
};

/*if an alternative was selected this function will be called*/
AlternativeSelectionListener selectionListener = new AlternativeSelectionListener(){
	@Override
	public void onClicked(Alternative alt){
		ArrayList<Alternative> resultAlts = new ArrayList<Alternative>();
		for (int i = 0; i < collections.size(); ++i) {
			ArrayList<Alternative> colAlts = collections.get(i).getAlternatives();
			for (int j = 0; j < colAlts.size(); ++j) {
				Alternative newAlt = colAlts.get(j);
				float distance = newAlt.getDistance(alt);				
				if (distance <= closeEnough && !newAlt.getRefId().equals(alt.getRefId())) {
					resultAlts.add(newAlt);
				}
			}
		}

		// creates a new collection with the alternatives found from search (in Action File)
		createCollectionForAlternative(resultAlts , alt.getRefId());
	}
};








