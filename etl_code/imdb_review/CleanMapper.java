import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import java.util.*;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.Scanner; 
import java.net.URI;

public class CleanMapper extends Mapper<LongWritable, Text, Text, Text>{
        @Override
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException{
                URI[] localPaths = context.getCacheFiles();
                List<String> stop = new ArrayList<String>();
                BufferedReader fis = new BufferedReader(new FileReader(new File(localPaths[0].getPath()).getName()));
                String pattern;
                while ((pattern = fis.readLine()) != null) {
                        stop.add(pattern);
                }
                String input = value.toString();
                int score = input.indexOf(",");
                int url  = input.lastIndexOf(",");
                int review = input.substring(score+1,input.length()).indexOf(",");
                int spoiler = input.substring(0,url).lastIndexOf(",");
                String reviewS = input.substring(score+1+review+1, spoiler).toLowerCase().replaceAll("[^A-Za-z ]", "");
                String movieIDS = input.substring(0,score);
                String spoilerS = input.substring(spoiler+1,url);
                String urlS = input.substring(url+1,input.length());
                String scoreS = input.substring(score+1,score+1+review);
                if (scoreS.length() != 0) {
                        List<String> ans = new ArrayList<String>();
                        String[] tokens = reviewS.split("\\s+");
                        for (String token : tokens){
                        if (!stop.contains(token)) ans.add(token);
                        }
                        for (String emit:ans){
                                String newKey  = movieIDS+"\t"+emit;
                                String newValue = scoreS;
                                context.write(new Text(newKey),new Text(scoreS));
                        }
                }

        }
}
