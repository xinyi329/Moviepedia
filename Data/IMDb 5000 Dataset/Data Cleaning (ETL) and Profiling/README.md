There are 4 MapReduce jobs in total.
* `map1.py` and `reduce1.py`: Join `movie_budget_2018.json` and `fetch_imdb_url_2018.json`, and drop necessary fields. Output in JSON format.
* `map2.py` and `reduce2.py`: Join output from last job and `imdb_output_2018.json`, remove duplicates, and drop necessary fields. Output in JSON format.
* `map3.py` and `reduce3.py`: Join output from last job and `imdb_output_2017.json`, remove duplicates, and drop necessary fields. Output in JSON format.
* `map4.py`: Contain map phase only, profile the JSON data from last job to plain csv format with actor information deducted and storyline dropped.
Note that the output from MapReduce job 3 should be the meta data of the all necessary fields we may require. If the final output from MapReduce 4 turns out to be not enough during the following stage, we can modify the MapReduce job 4 to get what we want.

In `map3.py`, I refer to the parse functions to deal with durations, Facebook likes, aspect ratio (but was dropped later) provided by the author of the original dataset (https://github.com/sundeepblue/movie_rating_prediction).

We may run commands on Dumbo
```
hadoop jar /opt/cloudera/parcels/CDH-5.11.1-1.cdh5.11.1.p0.4/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapreduce.job.reduces=1 -files ./map1.py,./reduce1.py -mapper "python map1.py" -reducer "python reduce1.py" -input /user/xl2700/class9/movie_budget_2018.json,/user/xl2700/class9/fetch_imdb_url_2018.json -output /user/xl2700/class9/output1
```
```
hadoop jar /opt/cloudera/parcels/CDH-5.11.1-1.cdh5.11.1.p0.4/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapreduce.job.reduces=1 -files ./map2.py,./reduce2.py -mapper "python map2.py" -reducer "python reduce2.py" -input /user/xl2700/class9/imdb_output_2018.json,/user/xl2700/class9/output1 -output /user/xl2700/class9/output2
```
```
hadoop jar /opt/cloudera/parcels/CDH-5.11.1-1.cdh5.11.1.p0.4/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapreduce.job.reduces=1 -files ./map3.py,./reduce3.py -mapper "python map3.py" -reducer "python reduce3.py" -input /user/xl2700/class9/imdb_output_2017.json,/user/xl2700/class9/output2 -output /user/xl2700/class9/output3
```
```
hadoop jar /opt/cloudera/parcels/CDH-5.11.1-1.cdh5.11.1.p0.4/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapreduce.job.maps=1 -D mapreduce.job.reduces=0 -files ./map4.py -mapper "python map4.py" -input /user/xl2700/class9/output3 -output /user/xl2700/class9/output4
```
or use the Java driver
```
hadoop jar IMDb.jar IMDb -files ./map1.py,./map2.py,./map3.py,./map4.py,./reduce1.py,./reduce2.py,./reduce3.py
```
