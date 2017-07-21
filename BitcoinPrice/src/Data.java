import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import org.json.JSONException;
import org.json.JSONObject;

public class Data {
	
	private String[] currency = {
			"USD", "ISK", "HKD", "TWD", "CHF", "EUR", "DKK", "CLP", "CAD", "INR", "CNY", 
			"THB", "AUD", "SGD", "KRW", "JPY", "PLN", "GBP", "SEK", "NZD", "BRL", "RUB"
	};
	
	private String[] headers = {
		"Currency", "15m", "Last", "Buy", "Sell"	
	};

	public String[] getHeader()
	{
		return headers;
	}
	
	public String[][] getData() throws JSONException, Exception
	{
		JSONObject ticker = new JSONObject(readUrl("https://blockchain.info/ticker"));
		final String[][] data = new String[ticker.length()][5];
		for(int i = 0; i < ticker.length(); i++)
	    {
	    	data[i][0] = currency[i];
	    	data[i][1] = ticker.getJSONObject(currency[i]).get("15m").toString();
	    	data[i][2] = ticker.getJSONObject(currency[i]).get("last").toString();
	    	data[i][3] = ticker.getJSONObject(currency[i]).get("buy").toString();
	    	data[i][4] = ticker.getJSONObject(currency[i]).get("sell").toString();
	    }
		return data;
	}
	
	private static String readUrl(String urlString) throws Exception {
	    BufferedReader reader = null;
	    try {
	        URL url = new URL(urlString);
	        reader = new BufferedReader(new InputStreamReader(url.openStream()));
	        StringBuffer buffer = new StringBuffer();
	        int read;
	        char[] chars = new char[1024];
	        while ((read = reader.read(chars)) != -1)
	            buffer.append(chars, 0, read); 

	        return buffer.toString();
	    } finally {
	        if (reader != null)
	            reader.close();
	    }
	}
}
