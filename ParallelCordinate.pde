public class ParallelCordinate extends View{
	private Collection collection;
	private ArrayList<Dimension> dimensions;
	private ArrayList<ArrayList<JSONObject>> paths; 	
	private JSONArray keySets;
	private JSONObject valueBands;
	private ArrayList<Integer> selectedAlternatives;

	public ParallelCordinate(Collection collection ,JSONArray keySets ,JSONObject valueBands) {
		super(collection,"PC");

		dimensions = new ArrayList<Dimension>();
		paths = new ArrayList<ArrayList<JSONObject>>();
		selectedAlternatives = new ArrayList<Integer>();

		this.keySets = keySets;
		this.valueBands = valueBands;
		this.collection = collection;

		createDimensions();
		createPaths(collection.getAlternatives());
	}

	public void createDimensions(){
		for (int i = 0; i < keySets.size(); ++i) {
			// get min and max value for each dimenstion from value band data that came from server			
			float minValue = valueBands.getJSONObject(keySets.getString(i)).getFloat("min");
			float maxValue = valueBands.getJSONObject(keySets.getString(i)).getFloat("max");

			//make dimension for the parameter
			Dimension newDimension = new Dimension(keySets.getString(i), this.getHeight(), 25 + this.getX() + i*(this.getWidth()/keySets.size()), 70 + this.getY() , maxValue, minValue);

			dimensions.add(newDimension);
		}
	}

	public void createPaths(ArrayList<Alternative> alternaives ){
		for (int j = 0; j < alternaives.size(); ++j) {
			ArrayList<JSONObject> path = new ArrayList<JSONObject>();
			boolean isAltSelected = true;
			int brushesCount = 0;
			for (int i = 0; i < dimensions.size(); ++i) {
				Alternative currentAlt = alternaives.get(j);
				Dimension currentDim = dimensions.get(i);

				JSONObject newNode = new JSONObject();
				float valueLength = abs(currentDim.getMax() - currentDim.getMin());

				float yPosition = 70 + this.getY() + this.getHeight()*(abs(currentAlt.getValueForParam(currentDim.getName())-currentDim.getMax())/valueLength);				

				newNode.setFloat("x" , currentDim.getX());
				newNode.setFloat("y" , yPosition);				


				boolean isNodeSelected = false;
				ArrayList<Brush> brushes = currentDim.getBrushes();
				for (int m = 0; m < brushes.size(); ++m) {
					Brush currBrush = brushes.get(m);
					if ((newNode.getFloat("y") >= currBrush.getStart() && newNode.getFloat("y") <= currBrush.getEnd()) || (newNode.getFloat("y") <= currBrush.getStart() && newNode.getFloat("y") >= currBrush.getEnd())) {
						isNodeSelected = true;
						break;
					}
				}

				Brush currentBrush = currentDim.getCurrentBrush();
				if (currentBrush != null) {
					if ((newNode.getFloat("y") >= currentBrush.getStart() && newNode.getFloat("y") <= currentBrush.getEnd()) || (newNode.getFloat("y") <= currentBrush.getStart() && newNode.getFloat("y") >= currentBrush.getEnd())) {
						isNodeSelected = true;
					}
					brushesCount ++;
				}

				if (brushes.size() == 0 && currentBrush == null) {
					isNodeSelected = true;
				}
				if(!isNodeSelected){
					isAltSelected = false;
				}
				brushesCount += brushes.size();

				path.add(newNode);
			}

			if (brushesCount==0) {
				isAltSelected = false;
			}
			if (isAltSelected) {
				selectedAlternatives.add(j);
			}
			paths.add(path);
		}
	}

	@Override
	public void update(){
		dimensions = new ArrayList<Dimension>();
		paths = new ArrayList<ArrayList<JSONObject>>();
		selectedAlternatives = new ArrayList<Integer>();

		createDimensions();
		createPaths(collection.getAlternatives());
	}

	@Override
	public void draw() {

		// drawing the dimension lines 
		for (int i = 0; i < dimensions.size(); ++i) {
			dimensions.get(i).draw();
		}

		// drawing the paths 		
		for (int i = 0; i < paths.size(); ++i) {
			ArrayList<JSONObject> currPath = paths.get(i);

			noFill();
			if (selectedAlternatives.indexOf(i) >= 0) {
				stroke(25,127,200);
			}else{
				stroke(64);
			}

			beginShape();
			smooth();
			for (int j = 0; j < currPath.size(); ++j) {
				JSONObject currPathData = currPath.get(j);				
				vertex(currPathData.getFloat("x"), currPathData.getFloat("y"));
			}
			endShape();

			stroke(64);
			// noStroke();
		}
	}

	/* interactions */
	@Override
	public void pressed(){

	}

	@Override
	public void released(){	
		for (int i = 0; i < dimensions.size(); ++i) {
			dimensions.get(i).released();
		} 
	}

	@Override
	public boolean dragged(){
		boolean result = false;
		for (int i = 0; i < dimensions.size(); ++i) {
			if(dimensions.get(i).dragged()){
				result = true;
				// update();
				paths = new ArrayList<ArrayList<JSONObject>>();
				selectedAlternatives = new ArrayList<Integer>();
				createPaths(collection.getAlternatives());

				break;
			}
		}
		return result;
	}

}