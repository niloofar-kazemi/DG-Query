ArrayList<Collection> collections;
float top = 0;
float left = 0;
float scale = 1;

void setup() {
  size(1440 , 900);
  // fullScreen();
  frameRate(60);
  collections = new ArrayList<Collection>();
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
	if (key == '+') {
		scale += 0.2;
	}else if (key == '-'){
		scale -= 0.2;
	}
}

/* whenever theres a click event they will be send to all the instaces of collections*/
void mouseClicked() {
	if(collections != null){
		for (int i = 0; i < collections.size(); ++i) {
			Collection col = collections.get(i);
			col.clicked();
		}
	}
}

/* whenever theres a drag event they will be send to all the instaces of collections*/
void mouseDragged() {

	boolean result = false;

	if(collections != null){
		for (int i = 0; i < collections.size(); ++i) {
			Collection col = collections.get(i);			
			if (col.dragged()) {
				result = true;
				break;
			}
		}
	}

	if (!result) {
		top += mouseY - pmouseY;
		left += mouseX - pmouseX;		
	}
}

void mousePressed() {
	if(collections != null){
		for (int i = 0; i < collections.size(); ++i) {
			Collection col = collections.get(i);
			col.pressed();
		}
	}
}

void mouseReleased() {
	if(collections != null){
		for (int i = 0; i < collections.size(); ++i) {
			Collection col = collections.get(i);
			col.released();
		}
	}
}








