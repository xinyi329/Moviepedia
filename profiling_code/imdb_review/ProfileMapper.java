import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;


public class ProfileMapper extends Mapper<LongWritable, Text, Text, IntWritable>{
        @Override
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException{
                String input = value.toString();
                int score = input.indexOf(",");
                int url  = input.lastIndexOf(",");
                int review = input.substring(score+1,input.length()).indexOf(",");
                int spoiler = input.substring(0,url).lastIndexOf(",");
                String reviewS = input.substring(score+1+review+1, spoiler).toLowerCase();
                String movieIDS = input.substring(0,score);
                String spoilerS = input.substring(spoiler+1,url);
                String urlS = input.substring(url+1,input.length());
                String scoreS = input.substring(score+1,score+1+review);
                String scoreOutput = "score"+scoreS;
                String spoilerOutput  = "whether spolier" + spoilerS;
                context.write(new Text(scoreOutput), new IntWritable(1));
                context.write(new Text(spoilerOutput), new IntWritable(1));

        }
}
