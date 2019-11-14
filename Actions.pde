String fetchedCollections ;
String fetchedAlternatives ;

/* starts by getting data for collections from designGallery server at "http://sr-02645.iat.sfu.ca:5050/collections"*/
void fetchCollections(){
	NetworkCallback callback = new NetworkCallback(){
	  	@Override
	  	public void onResult(String collectionResponse){
	  		fetchedCollections = collectionResponse;
	  		fetchAlternatives(); // fetching alternatives after collections
	  	}
	};
	Network.getInstance().sendRequest("http://sr-02645.iat.sfu.ca:5050/collections", callback);
}

/* gets all the alternatives after getting collections */
void fetchAlternatives(){
	NetworkCallback callback = new NetworkCallback(){
	  	@Override
	  	public void onResult(String alternativeresponse){
	  		/*  Parsing all the data into collections and alternative instances*/
	  		fetchedAlternatives = alternativeresponse;
			fetchLayouts();
	  	}
	};
	Network.getInstance().sendRequest("http://sr-02645.iat.sfu.ca:5050/alternatives", callback);
}

/* gets all the layouts for collections after getting alternatives */
void fetchLayouts(){
	NetworkCallback callback = new NetworkCallback(){
	  	@Override
	  	public void onResult(String layoutResponse){
	  		/*  Parsing all the data into collections and alternative instances*/

	  		JSONArray colData = parseJSONArray(fetchedCollections);

			JSONObject altResponse = parseJSONObject(fetchedAlternatives);
			JSONArray altData = altResponse.getJSONArray("alternatives");
			JSONArray keySets = altResponse.getJSONArray("keySets");
			JSONObject valueBands = altResponse.getJSONObject("valueBands");


			JSONArray layoutData = parseJSONArray(layoutResponse);
			JSONArray layouts = layoutData.getJSONObject(0).getJSONArray("layout");
			
			for (int i = 0; i < colData.size(); ++i) {
				JSONObject newCollectionData = colData.getJSONObject(i);
				Collection newCollection = new Collection(newCollectionData,altData,layouts,keySets,valueBands);
				collections.add(newCollection);				
			}
			
	  	}
	};
	Network.getInstance().sendRequest("http://sr-02645.iat.sfu.ca:5050/layout", callback);
}