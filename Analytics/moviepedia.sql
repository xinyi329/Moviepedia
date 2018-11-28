connect compute-1-1;

use moviepedia;

drop table if exists movie;

create external table movie (movie_id string, movie_imdb_link string, movie_title string, release_year int, color string, duration int, genres string, plot_keywords string, language string, country string, content_rating string, movie_facebook_likes int, num_user_for_reviews int, num_critic_for_reviews int, num_voted_users int, imdb_score float, production_budget int, worldwide_gross int, domestic_gross int, cast_total_facebook_likes int, actor_1_name string, actor_1_id string, actor_1_facebook_likes int, actor_2_name string, actor_2_id string, actor_2_facebook_likes int, actor_3_name string, actor_3_id string, actor_3_facebook_likes int, director_name string, director_id string, director_facebook_likes int)
row format delimited fields terminated by '\t'
location '/user/xl2700/class9/output4/';

drop table if exists genres;

create external table genres (movie_id string, genre string)
row format delimited fields terminated by '\t'
location '/user/xl2700/class9/output5/';

drop table if exists people;

create external table people (person_id string, facebook_likes int)
row format delimited fields terminated by '\t'
location '/user/xl2700/class9/output6/';

-- 	top 10 worldwide money-making movies

select distinct movie_id, movie_title, worldwide_gross
from movie
order by worldwide_gross desc
limit 10;


-- 	top 10 domestic money-making movies

select distinct movie_id, movie_title, domestic_gross
from movie
order by domestic_gross desc
limit 10;

-- top 10 imdb rating movies

select distinct movie_id, movie_title, imdb_score
from movie
order by imdb_score desc
limit 10;

-- top 10 popular movies (by num_voted_users in imdb)

select distinct movie_id, movie_title, num_voted_users
from movie
order by num_voted_users desc
limit 10;

-- top 10 popular movies among critics

select distinct movie_id, movie_title, num_critic_for_reviews
from movie
order by num_critic_for_reviews desc
limit 10;

-- top worldwide money-making movie within each genre

select distinct genres.genre, movie.movie_id, movie_title, worldwide_gross
from genres, movie
where genres.movie_id = movie.movie_id
group by genres
order by worldwide_gross desc
limit 1;

-- top domestic money-making movie within each genre

select distinct genres.genre, movie.movie_id, movie_title, domestic_gross
from genres, movie
where genres.movie_id = movie.movie_id
group by genres
order by domestic_gross desc
limit 1;

-- top imdb-rating movie within each genre

select distinct genres.genre, movie.movie_id, movie_title, imdb_score
from genres, movie
where genres.movie_id = movie.movie_id
group by genres
order by imdb_score desc
limit 1;

-- top popular movie within each genre (by num_voted_users in imdb)

select distinct genres.genre, movie.movie_id, movie_title, num_voted_users
from genres, movie
where genres.movie_id = movie.movie_id
group by genres
order by num_voted_users desc
limit 1;

-- top popular movie among critics within each genre

select distinct genres.genre, movie.movie_id, movie_title, num_critic_for_reviews
from genres, movie
where genres.movie_id = movie.movie_id
group by genres
order by num_critic_for_reviews desc
limit 1;

-- movies made each year

select release_year, count(movie_id) as num_movies
from movie
group by release_year
order by release_year asc;

/* should not be accurate, need test cascading */

-- average budget for each genre

select distinct genres.genre, avg(budget) as average_budget
from genres, movie
where genres.movie_id = movie.movie_id
group by genres;

-- average gross box for each genre

select distinct genres.genre, avg(worldwide_gross) as average_box
from genres, movie
where genres.movie_id = movie.movie_id
group by genres;