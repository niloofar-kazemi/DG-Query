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