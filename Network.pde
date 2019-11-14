import okhttp3.*;

public static class Network{
	private OkHttpClient client;
	private static Network instance = null ;

	public static Network getInstance() {
		if (instance != null) {
			return instance;
		}

		instance = new Network();
		return instance;
	}

	public Network(){
		client = new OkHttpClient();
	}

	public void sendRequest(String url , final NetworkCallback callback){
		Request request = new Request.Builder()
        .url(url)
        .build();

	    client.newCall(request).enqueue(new Callback() {
	      @Override 
	      public void onFailure(Call call, IOException e) {
	        e.printStackTrace();
	      }

	      @Override 
	      public void onResponse(Call call, Response response) throws IOException {
	      	ResponseBody responseBody = response.body();
	      	callback.onResult(responseBody.string());    
	      }
	    });
	}
}