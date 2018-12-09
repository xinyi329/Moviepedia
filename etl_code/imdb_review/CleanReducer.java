import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class CleanReducer extends Reducer<Text, Text, Text, Text>{

        @Override

        public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException{
                int count = 0;
                int ratingSum = 0;
                for (Text value:values){
                        count ++;
                        ratingSum += Integer.parseInt(value.toString());
                }
                String newKey = key.toString()+'\t'+Integer.toString(count);
                String newValue = Integer.toString(ratingSum);
                context.write(new Text(newKey),new Text(newValue));
        }

}
