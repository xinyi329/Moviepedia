import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.net.URI;
import java.util.HashSet;
import java.util.Set;
import java.io.IOException;
import java.util.regex.Pattern;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.util.StringUtils;

public class DataClean extends Configured implements Tool {

    public static void main(String[] args) throws Exception {
        int res = ToolRunner.run(new DataClean(), args);
        System.exit(res);
    }

    public int run(String[] args) throws Exception {
        Job job = Job.getInstance(getConf(), "dataclean");
        for (int i = 0; i < args.length; i += 1) {
            if ("-finds".equals(args[i])) {
                job.getConfiguration().setBoolean("dataclean.find.patterns", true);
                i += 1;
                job.addCacheFile(new Path(args[i]).toUri());
            }
        }
    job.setJarByClass(this.getClass());
    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
    job.setMapperClass(Map.class);
    job.setCombinerClass(Reduce.class);
    job.setReducerClass(Reduce.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(Text.class);
    job.setNumReduceTasks(1);
    return job.waitForCompletion(true) ? 0 : 1;
    }

    public static class Map extends Mapper<LongWritable, Text, Text, Text> {
    private Set<String> wordsToFind = new HashSet<String>();
    protected void setup(Mapper.Context context) throws IOException, InterruptedException {
        Configuration config = context.getConfiguration();
        if (config.getBoolean("dataclean.find.patterns", false)) {
            URI[] localPaths = context.getCacheFiles();
           parseFindFile(localPaths[0]);
        }
    }

    private void parseFindFile(URI patternsURI) {
       try {
          BufferedReader fis = new BufferedReader(new FileReader(new File(patternsURI.getPath()).getName()));
          String pattern;
          while ((pattern = fis.readLine()) != null) {
              wordsToFind.add(pattern);
          }
        } catch (IOException ioe) {
           System.err.println("Caught exception while parsing the cached file '"
                + patternsURI + "' : " + StringUtils.stringifyException(ioe));
        }
    } 

    public void map(LongWritable key, Text lineText, Context context)
        throws IOException, InterruptedException {
        String line = lineText.toString();
        //StringBuffer sbuff = new StringBuffer();
        line = line.toLowerCase();
        //String[] line_split = line.split("\\s+");
        /*for (String word : line_split)
        {
            if (!word.contains("@") && !word.matches(".*http:.*") && word.matches(".*[a-zA-Z0-9].*")) {
                sbuff.append(word);
                sbuff.append(" ");
            }  
        }*/
        String removed = line.replaceAll("@[0-9a-zA-Z]+" ," ");
        removed = removed.replaceAll("http(s)?:/*"," ");
        removed = removed.replaceAll("[^a-zA-Z0-9']", " ");
        for (String patterns : wordsToFind)
        {
            patterns = patterns.toLowerCase();
            String[] parts = patterns.split("\t");
            if (removed.contains(parts[2])) {
                context.write(new Text(parts[0]), new Text(removed));
            }
        }            
      }
  }

  public static class Reduce extends Reducer<Text, Text, Text, Text> {
      @Override
      public void reduce(Text word, Iterable<Text> values, Context context)
        throws IOException, InterruptedException {
          for (Text val : values) {
              context.write(word, new Text(val));
          }
      }
  }
}

