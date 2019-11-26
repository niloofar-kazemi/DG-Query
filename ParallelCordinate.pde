public class ParallelCordinate extends View{
	private Collection collection;

	private ArrayList<Dimension> dimensions;
	private ArrayList<ArrayList<JSONObject>> paths; 	
	private JSONArray keySets;
	private JSONObject valueBands;
	private ArrayList<Integer> selectedAlternatives;
	private ArrayList<Link> links;
	private Link currentLink ;
	private boolean isLinking= false;

	public ParallelCordinate(Collection collection ,JSONArray keySets ,JSONObject valueBands) {
		super(collection,"PC");

		dimensions = new ArrayList<Dimension>();
		paths = new ArrayList<ArrayList<JSONObject>>();
		selectedAlternatives = new ArrayList<Integer>();
		links = new ArrayList<Link>();
		currentLink = null;

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

	/* creates a new path for each alternative and checks all the brushes to see if the new path is in the brushe range */
	public void createPaths(ArrayList<Alternative> alternaives){
		ArrayList<String> selectedRefIds = new ArrayList<String>();

		//creating the path for each alternative
		for (int j = 0; j < alternaives.size(); ++j) {
			Alternative currentAlt = alternaives.get(j);

			ArrayList<JSONObject> path = new ArrayList<JSONObject>();
			boolean isAltSelected = true;
			int brushesCount = 0;

			// create a node for each dimention
			for (int i = 0; i < dimensions.size(); ++i) {
				Dimension currentDim = dimensions.get(i);

				JSONObject newNode = new JSONObject();
				float valueLength = abs(currentDim.getMax() - currentDim.getMin());

				// find the position of the node on the dimesntion based on the alternative value for that dimenstion
				float yPosition = 70 + this.getY() + this.getHeight()*(abs(currentAlt.getValueForParam(currentDim.getName())-currentDim.getMax())/valueLength);				

				newNode.setFloat("x" , currentDim.getX());
				newNode.setFloat("y" , yPosition);				


				// check if the node is in the range of the brushes that were create till now
				boolean isNodeSelected = false;
				ArrayList<Brush> brushes = currentDim.getBrushes();
				for (int m = 0; m < brushes.size(); ++m) {
					Brush currBrush = brushes.get(m);
					if ((newNode.getFloat("y") >= currBrush.getStart() && newNode.getFloat("y") <= currBrush.getEnd()) || (newNode.getFloat("y") <= currBrush.getStart() && newNode.getFloat("y") >= currBrush.getEnd())) {
						isNodeSelected = true;
						break;
					}
				}

				// check if the node is in the range of the current brush that is being created 
				Brush currentBrush = currentDim.getCurrentBrush();
				if (currentBrush != null) {
					if ((newNode.getFloat("y") >= currentBrush.getStart() && newNode.getFloat("y") <= currentBrush.getEnd()) || (newNode.getFloat("y") <= currentBrush.getStart() && newNode.getFloat("y") >= currentBrush.getEnd())) {
						isNodeSelected = true;
					}
					brushesCount ++;
				}				

				// if there's no brush we assume that the node is in the range 
				if (brushes.size() == 0 && currentBrush == null) {
					isNodeSelected = true;
				}

				// checks if there's a brush on the dimention and the node is in the range
				if(!isNodeSelected){
					isAltSelected = false;
				}

				//counting all the brushes to see if there's any brush on the pc or not
				brushesCount += brushes.size();

				path.add(newNode);
			}

			//check if the alternative is in the links ranges
			for (int m = 0; m < links.size(); ++m) {
				ArrayList<Brush> linkBrushes = links.get(m).getBrushes();
				int isInLink = 0;
				for (int n = 0; n < linkBrushes.size(); ++n) {
					Brush currBrush = linkBrushes.get(n);
					for (int i = 0; i < path.size(); ++i) {
						Dimension currentDim = dimensions.get(i);
						JSONObject newNode = path.get(i);
						if (currentDim.getName() == currBrush.getDimName()) {
							if ((newNode.getFloat("y") >= currBrush.getStart() && newNode.getFloat("y") <= currBrush.getEnd()) || (newNode.getFloat("y") <= currBrush.getStart() && newNode.getFloat("y") >= currBrush.getEnd())) {
								isInLink ++;
							}
						}
					}
				}				
				if (isInLink > 0 && isInLink < linkBrushes.size()) {
					isAltSelected = false;
					break;
				}
			}

			//check if the alternative is in the current link ranges
			if (currentLink != null) {				
				ArrayList<Brush> linkBrushes = currentLink.getBrushes();
				int isInLink = 0;
				for (int n = 0; n < linkBrushes.size(); ++n) {
					Brush currBrush = linkBrushes.get(n);
					for (int i = 0; i < path.size(); ++i) {
						Dimension currentDim = dimensions.get(i);
						JSONObject newNode = path.get(i);
						if (currentDim.getName() == currBrush.getDimName()) {
							if ((newNode.getFloat("y") >= currBrush.getStart() && newNode.getFloat("y") <= currBrush.getEnd()) || (newNode.getFloat("y") <= currBrush.getStart() && newNode.getFloat("y") >= currBrush.getEnd())) {
								isInLink ++;
							}
						}
					}
				}				
				if (isInLink > 0 && isInLink < linkBrushes.size()) {
					isAltSelected = false;					
				}
			}

			if (brushesCount==0) {
				isAltSelected = false;
			}
			if (isAltSelected) {				
				selectedRefIds.add(currentAlt.getRefId());
			}
			paths.add(path);
		}
		if (selectedRefIds.size()>0) {
			brushListener.onChange(selectedRefIds);
		}
	}

	@Override
	public void update(){
		dimensions = new ArrayList<Dimension>();
		paths = new ArrayList<ArrayList<JSONObject>>();
		selectedAlternatives = new ArrayList<Integer>();
		links = new ArrayList<Link>();
		currentLink = null;
		isLinking = true;

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

		for (int i = 0; i < links.size(); ++i) {
			links.get(i).draw();
		}
		if (currentLink != null) {
			currentLink.draw();
		}
	}

	/* interactions */
	@Override
	public void pressed(){}

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
				
				paths = new ArrayList<ArrayList<JSONObject>>();
				selectedAlternatives = new ArrayList<Integer>();
				createPaths(collection.getAlternatives());

				break;
			}
		}
		return result;
	}

	@Override
	public void clicked() {
		for (int i = 0; i < dimensions.size(); ++i) {
			Brush br = dimensions.get(i).clicked();
			if (br != null) {
				// if we are in linking mode
				if (isLinking) {
					//if there's already a current linking in process keep adding to that otherwise create a new Link
					if (currentLink != null) {
						currentLink.add(br);
					}else{						
						currentLink = new Link(br);
					}

					paths = new ArrayList<ArrayList<JSONObject>>();
					selectedAlternatives = new ArrayList<Integer>();
					createPaths(collection.getAlternatives());

				}
			}
		}
	}

	@Override
	public void keyPressed() {
		if (key == 'l') {			
			if (isLinking == true) {
				isLinking = false;
				if (currentLink != null) {
					links.add(currentLink);
					currentLink = null;					
				}
			}else{
				isLinking = true;
			}
		}
	}

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

}