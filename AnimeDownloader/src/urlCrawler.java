import java.io.*;
import java.net.*;
import javax.net.ssl.HttpsURLConnection;

import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

public class urlCrawler {

	private static final int BUFFER_SIZE = 4096;

	public urlCrawler() {
		File anime = new File(System.getProperty("user.dir") + File.separator + "Anime");
		anime.mkdirs();
	}

	public boolean writeToFile(String anime) throws IOException {
		File yourFile = new File("anime.txt");
		yourFile.createNewFile(); // if file already exists will do nothing
		try (BufferedReader br = new BufferedReader(new FileReader(yourFile))) {
			for (String line; (line = br.readLine()) != null;) {
				if (line.equals(anime)) {
					return true;
				}
			}
		}
		BufferedWriter bw = new BufferedWriter(new FileWriter(yourFile, true));
		bw.write(anime);
		bw.newLine();
		bw.close();
		return false;
	}

	/**
	 * Downloads a file from a URL
	 * 
	 * @param fileURL
	 *            HTTP URL of the file to be downloaded
	 * @param saveDir
	 *            path of the directory to save the file
	 * @throws IOException
	 */
	public void downloadFile(String fileURL) throws IOException {
		URL url = new URL(fileURL);
		HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
		httpConn.addRequestProperty("User-Agent",
				"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.101 Safari/537.36 OPR/25.0.1614.50");
		int responseCode = httpConn.getResponseCode();

		String key;
		for (int i = 1; (key = httpConn.getHeaderFieldKey(i)) != null; i++) {
			System.out.println(key + ":" + httpConn.getHeaderField(i));
		}

		// always check HTTP response code first
		if (responseCode == HttpURLConnection.HTTP_OK) {
			String fileName = "";
			String disposition = httpConn.getHeaderField("Content-Disposition");
			String contentType = httpConn.getContentType();
			int contentLength = httpConn.getContentLength();

			if (disposition != null) {
				// extracts file name from header field
				int index = disposition.indexOf("filename=");
				if (index > 0) {
					fileName = disposition.substring(index + 10, disposition.length() - 1);
				}
			} else {
				// extracts file name from URL
				// fileName = fileURL.substring(fileURL.lastIndexOf("/") + 1,
				// fileURL.length());
				fileName = "test.txt";
			}

			System.out.println("Content-Type = " + contentType);
			System.out.println("Content-Disposition = " + disposition);
			System.out.println("Content-Length = " + contentLength);
			System.out.println("fileName = " + fileName);

			// opens input stream from the HTTP connection
			InputStream inputStream = httpConn.getInputStream();
			String saveFilePath = System.getProperty("user.dir") + File.separator + "Anime" + File.separator + fileName;

			// opens an output stream to save into file
			FileOutputStream outputStream = new FileOutputStream(saveFilePath);

			int bytesRead = -1;
			byte[] buffer = new byte[BUFFER_SIZE];
			while ((bytesRead = inputStream.read(buffer)) != -1) {
				outputStream.write(buffer, 0, bytesRead);
			}

			outputStream.close();
			inputStream.close();

			System.out.println("File downloaded");
		} else {
			System.out.println("No file to download. Server replied HTTP code: " + responseCode);
		}
		httpConn.disconnect();
	}

	public void test() throws IOException {
		CloseableHttpClient httpclient = HttpClients.createDefault();
		HttpGet httpget = new HttpGet("https://9anime.to/search?keyword=gamers");
		CloseableHttpResponse response = httpclient.execute(httpget);
		try {
		    HttpEntity entity = response.getEntity();
		    if (entity != null) {
		        InputStream instream = entity.getContent();
		        BufferedReader bR = new BufferedReader(new InputStreamReader(instream));
		        try {
		            String line;
		            while((line = bR.readLine()) != null) {
		            	System.out.println(line);
		            }
		        } finally {
		            instream.close();
		        }
		    }
		} finally {
		    response.close();
		}

	}

}
