package twitter;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;


public class ReadTweet {
	public static void tweetsearch(String value) throws IOException, TwitterException{
		File file = new File("/Users/liyiming/Desktop/project_data.txt");
		if (!file.exists()) {
			file.createNewFile();
		}
		FileWriter filew = new FileWriter(file, true);
		BufferedWriter bufferw = new BufferedWriter(filew);
		PrintWriter out = new PrintWriter(bufferw);
		Twitter twitter = new TwitterFactory().getInstance();
		Query query = new Query();
		query.setCount(20);
		query.setQuery(value);
		QueryResult result;
		result = twitter.search(query);               
        for (Status status : result.getTweets()) {
            out.println(status.getText());
        }
        //System.out.println(value);
        out.println("");
        out.println("the searching word is " + value);
		out.close(); 
	}
	public static void main(String[] args) throws IOException, TwitterException, InterruptedException {
        FileReader filer = new FileReader("/Users/liyiming/Desktop/movie_info");
        BufferedReader bufferr = new BufferedReader(filer);
        String searchstr;
        Map<String, String> titles = new HashMap<String, String>();
       
        while ((searchstr = bufferr.readLine()) != null)
        {
        	String[] item = searchstr.split("\t");
        	titles.put(item[0], item[2]);
        	//System.out.println(item[0]+item[1]);
        }
        Iterator<Map.Entry<String,String>> entries = titles.entrySet().iterator();
        //while (entries.hasNext())
        int i = 0;
        
        while (entries.hasNext())
    	{
        	Map.Entry<String,String> entry = entries.next();
    		String value = entry.getValue();
    		//System.out.println(value);
    		tweetsearch(value);
        	i++;
        	if (i == 160)
        	{
        		Thread.sleep(950000);
        		i = 0;
        	}
        }
  		bufferr.close();
        System.exit(0);
    }
}
