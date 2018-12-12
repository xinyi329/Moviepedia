#!/bin/sh

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select release_year, count(movie_id) as num_movies from movie where release_year is not null group by release_year order by release_year asc' > 1.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select release_year, avg(production_budget) as average_budget from movie where release_year is not null and production_budget <> 0 group by release_year order by release_year asc' > 2.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select release_year, avg(worldwide_gross) as average_gross from movie where release_year is not null and worldwide_gross <> 0 group by release_year order by release_year asc' > 3.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select movie_title, release_year, movie_id, worldwide_gross from movie where release_year = 1937 or release_year = 1939 or release_year = 1942 order by release_year asc' > 3a.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select * from correlation' > 4.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select distinct movie_id, movie_title, release_year, worldwide_gross from movie order by worldwide_gross desc limit 10' > 5.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select distinct movie_id, movie_title, release_year, imdb_score from movie order by imdb_score desc limit 10' > 6.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select distinct movie_id, movie_title, release_year, num_voted_users from movie order by num_voted_users desc limit 10' > 7.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select distinct movie_id, movie_title, release_year, num_critic_for_reviews from movie order by num_critic_for_reviews desc limit 10' > 8.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select mg.genre as genre, mg.movie_id as movie_id, mg.movie_title as movie_title, mg.release_year as release_year, mg.worldwide_gross as worldwide_gross from (select genre, movie_id, movie_title, release_year, worldwide_gross, row_number() over (partition by genre order by worldwide_gross desc) as rank from movie_genres order by genre, worldwide_gross desc) mg where mg.rank <= 1' > 9.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select mg.genre as genre, mg.movie_id as movie_id, mg.movie_title as movie_title, mg.release_year as release_year, mg.imdb_score as imdb_score from (select genre, movie_id, movie_title, release_year, imdb_score, row_number() over (partition by genre order by imdb_score desc) as rank from movie_genres order by genre, imdb_score desc) mg where mg.rank <= 1' > 10.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select mg.genre as genre, mg.movie_id as movie_id, mg.movie_title as movie_title, mg.release_year as release_year, mg.num_voted_users as num_voted_users from (select genre, movie_id, movie_title, release_year, num_voted_users, row_number() over (partition by genre order by num_voted_users desc) as rank from movie_genres order by genre, num_voted_users desc) mg where mg.rank <= 1' > 11.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select mg.genre as genre, mg.movie_id as movie_id, mg.movie_title as movie_title, mg.release_year as release_year, mg.num_critic_for_reviews as num_critic_for_reviews from (select genre, movie_id, movie_title, release_year, num_critic_for_reviews, row_number() over (partition by genre order by num_critic_for_reviews desc) as rank from movie_genres order by genre, num_critic_for_reviews desc) mg where mg.rank <= 1' > 12.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select genre, avg(production_budget) as average_budget from movie_genres where production_budget <> 0 group by genre' > 13.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select genre, avg(worldwide_gross) as average_gross from movie_genres where worldwide_gross <> 0 group by genre' > 14.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select genre, avg(imdb_score) as average_rating from movie_genres where imdb_score is not null group by genre' > 15.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select * from top_directors' > 16.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select * from top_actors' > 17.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select * from imdb_top_words' > 18.csv

beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/xl2700 -n xl2700 -w /home/xl2700/password --outputformat=csv2 -e 'select * from twitter_top_words' > 19.csv
