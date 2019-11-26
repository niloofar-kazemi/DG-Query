public static class Alternative{	
	private String viewId;
	private String refId;
	private JSONObject params;
	private JSONObject outputs;
	private String imageURL;	

	//view properies
	private float x;
	private float y;
	private float altWidth;
	private float altHeight;

	// parse the data that has been sent from server
	public Alternative(JSONObject newAlternatives){
		refId = newAlternatives.getString("refId");
		viewId = newAlternatives.getString("viewId");
		imageURL = newAlternatives.getString("image");
		params = newAlternatives.getJSONObject("params");
		outputs = newAlternatives.getJSONObject("outputs");
	}

	//turns the data of the Alternative toString (to print it) 
	public String toString() {		
		return "{\"imageURL\":\""+imageURL+"\",\"viewId\":\""+viewId+"\",\"refId\":\""+refId+"\",\"params\":"+params.toString()+",\"outputs\":"+outputs.toString()+"}";
	}

	public void draw(){

	}

	public float getDistance(Alternative alt){	
		float powerSum = 0;	
		Iterator keys = outputs.keys().iterator();
		while(keys.hasNext()) {
		    String key = (String)keys.next();
		    if (outputs.hasKey(key)) {
		    	powerSum += pow(outputs.getFloat(key) - alt.getValueForParam(key),2);		    	
		    }
		}
		return sqrt(powerSum);
	}

	/*get and sets*/
	public String getRefId(){
		return refId;
	}

	public float getValueForParam(String dimName) {
		float result = 0;
		if (params.hasKey(dimName)) {
			result = params.getFloat(dimName);
		}else if (outputs.hasKey(dimName)){
			result = outputs.getFloat(dimName);
		}

		return result;
	}

	public String getImageURL(){
		return "http://sr-02645.iat.sfu.ca:5050/" + imageURL;
	}
}