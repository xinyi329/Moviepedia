import org.apache.hadoop.util.Tool;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.jobcontrol.Job;
import org.apache.hadoop.mapred.jobcontrol.JobControl;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.util.ToolRunner;
import org.apache.hadoop.streaming.StreamJob;
import java.io.IOException; 

// https://stackoverflow.com/questions/12872590/hadoop-streaming-chaining-jobs

public class IMDb {

	public static void main(String[] args) throws Exception {
		JobControl job = new JobControl("IMDb");

		JobConf job1Conf = StreamJob.createJob(new String[] {
			//"-file", "/user/xl2700/class9/map1.py",
			//"-file", "/user/xl2700/class9/reduce1.py",
			//"-files", "/user/xl2700/class9/reduce1.py,/user/xl2700/class9/map1.py",
			"-mapper", "python map1.py",
			"-reducer", "python reduce1.py",
			"-input", "/user/xl2700/class9/movie_budget_2018.json,/user/xl2700/class9/fetch_imdb_url_2018.json",
			"-output", "/user/xl2700/class9/c-output1",
			"-numReduceTasks", "1",
		});
		Job job1 = new Job(job1Conf);
		job.addJob(job1);

		JobConf job2Conf = StreamJob.createJob(new String[] {
			//"-file", "/user/xl2700/class9/map2.py",
			//"-file", "/user/xl2700/class9/reduce2.py",
			//"-files", "/user/xl2700/class9/map2.py,/user/xl2700/class9/reduce2.py",
			"-mapper", "python map2.py",
			"-reducer", "python reduce2.py",
			"-input", "/user/xl2700/class9/imdb_output_2018.json,/user/xl2700/class9/c-output1",
			"-output", "/user/xl2700/class9/c-output2",
			"-numReduceTasks", "1",
		});
		Job job2 = new Job(job2Conf);
		job2.addDependingJob(job1);
		job.addJob(job2);

		JobConf job3Conf = StreamJob.createJob(new String[] {
			//"-file", "/user/xl2700/class9/map3.py",
			//"-file", "/user/xl2700/class9/reduce3.py",
			//"-files", "/user/xl2700/class9/map3.py,/user/xl2700/class9/reduce3.py",
			"-mapper", "python map3.py",
			"-reducer", "python reduce3.py",
			"-input", "/user/xl2700/class9/imdb_output_2017.json,/user/xl2700/class9/c-output2",
			"-output", "/user/xl2700/class9/c-output3",
			"-numReduceTasks", "1",
		});
		Job job3 = new Job(job3Conf);
		job3.addDependingJob(job2);
		job.addJob(job3);

		JobConf job4Conf = StreamJob.createJob(new String[] {
			//"-file", "/user/xl2700/class9/map4.py",
			"-mapper", "python map4.py",
			"-reducer", "NONE",
			"-input", "/user/xl2700/class9/c-output3",
			"-output", "/user/xl2700/class9/c-output4",
		});
		Job job4 = new Job(job4Conf);
		job4.addDependingJob(job3);
		job.addJob(job4);

		Thread runJob = new Thread(job);
		runJob.start();

		while(true) {
			if(job.allFinished()) {
				System.out.println(job.getSuccessfulJobList());
				job.stop();
				break;  
            }
            if(job.getFailedJobList().size() > 0){
            	System.out.println(job.getFailedJobList());
            	job.stop();
            	break;
            }
        }

	}

}
