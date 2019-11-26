import java.util.*;

public class Collection{
	// data property
	private ArrayList<Alternative> alternatives; // alternatives inside a collection
	private String name ;
	private String viewId;
	private String refId;

	// view properies
	public float x;
	public float y;
	public float colWidth;
	public float colHeight;
	public View parallelView;
	public View thumbNailView;
	public View collectionView;


	// parse the data that has been sent from server
	public Collection(JSONObject newCollection, JSONArray alternativesData, JSONArray layoutData ,JSONArray keySets ,JSONObject valueBands){
		alternatives = new ArrayList<Alternative>();

		name = newCollection.getString("collectionName");
		viewId = newCollection.getString("viewId");
		refId = newCollection.getString("refId");
		
		findAlternativesWithAltId(alternativesData , newCollection.getJSONArray("altsid"));
		findLayoutWithCollectionId(layoutData , viewId);

		parallelView = new ParallelCordinate(this , keySets , valueBands);
		thumbNailView = new Thumbnail(this);
		collectionView = parallelView;
	}

	// creates a new collection from scratch
	public Collection(String id, ArrayList<Alternative> alternatives, String name,  float x, float y, float colWidth, float colHeight, JSONArray keySets, JSONObject valueBands){
		this.alternatives = alternatives;
		this.name = name;
		this.viewId = id;
		this.refId = id;
		this.x = x;
		this.y = y;
		this.colWidth = colWidth;
		this.colHeight = colHeight;

		parallelView = new ParallelCordinate(this , keySets , valueBands);
		thumbNailView = new Thumbnail(this);
		collectionView = parallelView;
	}

	/* gets ids of the alternatives in the collection and finds them in JSONArray of all the alternatives*/
	public void findAlternativesWithAltId(JSONArray alternativesData , JSONArray altsId){

		// adding alttsId to a list so we can find alternatives based on their ids 
		List<String> altsIdList = new ArrayList<String>();
		for (int i = 0; i < altsId.size(); ++i) {			
			altsIdList.add(altsId.getString(i));	
		}

		for (int i = 0; i < alternativesData.size(); ++i) {
			JSONObject newAlt = alternativesData.getJSONObject(i);
			int indexOfAlt = altsIdList.indexOf(newAlt.getString("viewId"));

			if (indexOfAlt >= 0) {				
				Alternative alt = new Alternative(newAlt);
				alternatives.add(alt);
			}
		}
	}

	// finds layout of the collection from the layout data that came from server
	public void findLayoutWithCollectionId(JSONArray layoutData , String collectionID){
		
		for (int i = 0; i < layoutData.size(); ++i) {
			JSONObject layoutObject = layoutData.getJSONObject(i);
			String newLayoutId = layoutObject.getString("i");
			if (newLayoutId.equals(collectionID)) {
				x = layoutObject.getInt("x") * 150;
				y = layoutObject.getInt("y") * 70;
				colWidth = layoutObject.getInt("w") * 170; 
				colHeight = layoutObject.getInt("h") * 53; 
				break;
			}
		}
	}

	//turns the data of the collection toString (to print it) 
	public String toString() {
		String result = "{\"name\":\""+name+"\",\"viewId\":\""+viewId+"\",\"refId\":\""+refId+"\",alts:[";
		for (int i = 0; i < alternatives.size(); ++i) {
			result += alternatives.get(i).toString() + ",";
		}
		result += "]}";

		return result;
	}

	public void draw(){
		// draw the collection background
		fill(225);
		rect(x, y, colWidth, colHeight, 7);

		// draw the collection name
		fill(0);
		textSize(15);
		float nameWidth = textWidth(name);
		text(name, x + colWidth/2 - nameWidth/2 , y + 20);

		// drawing View of the collection
		collectionView.draw();

		// draw a switch for toggling between PC view and Thumb view 
		drawSwitch();

	}

	public void drawSwitch() {

		if (collectionView.getType().equals("Thumb")) {
			fill(150);
		}else{
			fill(200);
		}

		rect(this.getX(), this.getY(), 50, 20);

		fill(0);
		textSize(10);
		float thumbTextWidth = textWidth("Thumb");
		text("Thumb", this.getX() - thumbTextWidth/2 + 25 , this.getY() + 15);

		if (collectionView.getType().equals("PC")) {
			fill(150);
		}else{
			fill(200);
		}
		rect(this.getX() + 50, this.getY(), 50, 20);

		fill(0);
		textSize(10);
		float pcTextWidth = textWidth("PC");
		text("PC", this.getX() + 50 - pcTextWidth/2 + 25 , this.getY() + 15);
	}

	//checks if switch has been clicked 
	public void checkForSwitch(){
		if (mouseX > scale*(this.getX()+left) && mouseY > scale*(this.getY()+top) && mouseX < scale*(this.getX()+50+left) && mouseY < scale*(this.getY()+top+20)) {
			// Thumbnail Clicked
			collectionView = thumbNailView;
		}else if (mouseX > scale*(this.getX()+50+left) && mouseY > scale*(this.getY()+top) && mouseX < scale*(this.getX()+100+left) && mouseY < scale*(this.getY()+top+20)) {
			// PC Clicked
			collectionView = parallelView;
		}
	}
	/* interactions */
	public void clicked(){
		checkForSwitch();
		collectionView.clicked();
	}

	public boolean dragged(){
		if (collectionView.dragged()) {
			return true;
		}
		else if (mouseX > scale*(this.getX()+left) && mouseY > scale*(this.getY()+top) && mouseX < scale*(this.getX()+this.getWidth()+left) && mouseY < scale*(this.getY()+top+this.getHeight())) {
			this.setX(this.getX() + ((mouseX - pmouseX)/scale));
			this.setY(this.getY() + ((mouseY - pmouseY)/scale));
			return true; 
		}

		return false;
	}

	public void pressed(){	
		 collectionView.pressed();
	}

	public void released(){	
		 collectionView.released();
	}

	public void wheel(){
		collectionView.wheel();
	}

	public void brushChange(ArrayList<String> newRefIds){
		parallelView.brushChange(newRefIds);
		thumbNailView.brushChange(newRefIds);
		if (collectionView != null) {
			collectionView.brushChange(newRefIds);
		}
	}

	public void keyPressed() {
		if (collectionView != null) {
			collectionView.keyPressed();
		}
	}
	/* get and sets */
	public void setX(float newX) {
		x = newX;

		parallelView.setX(newX);
		parallelView.update();

		thumbNailView.setX(newX);
		thumbNailView.update();

		collectionView.setX(newX);
		collectionView.update();		
	}

	public void setY(float newY) {
		y = newY;

		parallelView.setY(newY);
		parallelView.update();

		thumbNailView.setY(newY);
		thumbNailView.update();

		collectionView.setY(newY);
		collectionView.update();

	}

	public float getX() {
		return x;
	}

	public float getY() {
		return y;
	}

	public float getWidth() {
		return colWidth;
	}

	public float getHeight() {
		return colHeight;
	}

	public ArrayList<Alternative> getAlternatives(){
		return alternatives;
	}

}