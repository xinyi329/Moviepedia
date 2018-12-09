import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class DataProfileReducer
	extends Reducer<Text, Text, Text, Text> {
	@Override
	public void reduce(Text key, Iterable<Text> values, Context context)
	   throws IOException, InterruptedException {
	
          double maxFloat = Double.MIN_VALUE;
          double minFloat = Double.MAX_VALUE;
          double sum = 0;
          double cnt = 0;
          double avg = 0;
          for (Text val : values) {

              double a = Double.parseDouble(val.toString());
              minFloat = Math.min(minFloat, a);
              maxFloat = Math.max(maxFloat, a);
              sum = sum + a;
              cnt = cnt + 1;
          }
          avg = sum / cnt;

             context.write(key, new Text(Double.toString(minFloat)));
             context.write(key, new Text(Double.toString(avg)));
             context.write(key, new Text(Double.toString(maxFloat)));

  	}
}