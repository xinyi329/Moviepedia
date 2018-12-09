import java.io.IOException;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class DataProfileMapper
	extends Mapper<LongWritable, Text, Text, Text> {

	@Override
	public void map(LongWritable key, Text value, Context context)
	   throws IOException, InterruptedException {
	
	 	String line = value.toString();
        //StringBuffer sbuff = new StringBuffer();
        line = line.toLowerCase();
        double eng_cnt = 0;
        char c;
        //String[] line_split = line.split("\\s+");
        for (int i = 0; i < line.length(); i++)
        {
            c = line.charAt(i);
            if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z') {
                eng_cnt++;
            }  
        }
        double eng_per;
        if (line.length() != 0)
        {
        	eng_per = eng_cnt/(double)line.length();
        	context.write(new Text("eng_percent"), new Text(Double.toString(eng_per)));
        	context.write(new Text("length"), new Text(Integer.toString(line.length())));
        }       
	 }
} 

