public class ParallelCordinate extends View{
	private ArrayList<JSONObject> dimentions ;
	private ArrayList<ArrayList<JSONObject>> paths; 	
	private JSONArray keySets;
	private JSONObject valueBands;

	public ParallelCordinate(Collection collection ,JSONArray keySets ,JSONObject valueBands) {
		super(collection,"PC");

		dimentions = new ArrayList<JSONObject>();
		paths = new ArrayList<ArrayList<JSONObject>>();
		this.keySets = keySets;
		this.valueBands = valueBands;

		createDimentions();
		createPaths(collection.getAlternatives());
	}

	public void createDimentions(){
		for (int i = 0; i < keySets.size(); ++i) {
			JSONObject newDimention = new JSONObject();
			newDimention.setString("name" , keySets.getString(i));
			newDimention.setFloat("position" , 25 + this.getX() + i*(this.getWidth()/keySets.size()));

			// get min and max value for each dimenstion from value band data that came from server			
			float minValue = valueBands.getJSONObject(keySets.getString(i)).getFloat("min");
			float maxValue = valueBands.getJSONObject(keySets.getString(i)).getFloat("max");

			newDimention.setFloat("min",minValue);
			newDimention.setFloat("max",maxValue);

			dimentions.add(newDimention);
		}
	}

	public void createPaths(ArrayList<Alternative> alternaives ){
		for (int j = 0; j < alternaives.size(); ++j) {
			ArrayList<JSONObject> path = new ArrayList<JSONObject>();
			for (int i = 0; i < dimentions.size(); ++i) {
				Alternative currentAlt = alternaives.get(j);
				JSONObject currentDim = dimentions.get(i);

				JSONObject newNode = new JSONObject();
				float valueLength = abs(currentDim.getFloat("max") - currentDim.getFloat("min"));

				float yPosition = 70 + this.getY() + this.getHeight()*(abs(currentAlt.getValueForParam(currentDim.getString("name"))-currentDim.getFloat("max"))/valueLength);				

				newNode.setFloat("x" , currentDim.getFloat("position"));
				newNode.setFloat("y" , yPosition);				

				path.add(newNode);
			}

			paths.add(path);
		}
	}

	@Override
	public void update(Collection collection){
		dimentions = new ArrayList<JSONObject>();
		paths = new ArrayList<ArrayList<JSONObject>>();

		createDimentions();
		createPaths(collection.getAlternatives());
	}

	@Override
	public void draw() {

		// drawing the dimention lines 
		for (int i = 0; i < dimentions.size(); ++i) {
			JSONObject currentDim = dimentions.get(i);

			// dimention name
			pushMatrix();
				fill(0);
				textSize(10);
				float nameWidth = textWidth(currentDim.getString("name"));
				translate(currentDim.getFloat("position") , 70 + this.getY());
				rotate(radians(-45));
				text(currentDim.getString("name"), 0,0);			
			popMatrix();

			// lines
			line(currentDim.getFloat("position"), 70 + this.getY(), currentDim.getFloat("position"), 70 + this.getY()+this.getHeight());
		}

		// drawing the paths 
		for (int i = 0; i < paths.size(); ++i) {
			ArrayList<JSONObject> currPath = paths.get(i);

			noFill();
			beginShape();
			for (int j = 0; j < currPath.size(); ++j) {
				JSONObject currPathData = currPath.get(j);				
				vertex(currPathData.getFloat("x"), currPathData.getFloat("y"));
			}			
			endShape();
		}
	}
}