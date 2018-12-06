/*
Progress this week:
1. Add genre queries
2. Compile and debug all the commands listed
To do:
1. Join IMDb Rating & Twitter sentiment level, plot correlation
2. Do word count of reviews by genre, to form word clouds (IMDb vs. Twitter)
3. K means to find similar movies - Ongoing (Learning Spark MLlib)
*/

use xl2700;

drop table if exists movie;

create external table movie (movie_id string, movie_imdb_link string, movie_title string, release_year int, color string, duration int, genres string, plot_keywords string, language string, country string, content_rating string, movie_facebook_likes int, num_user_for_reviews int, num_critic_for_reviews int, num_voted_users int, imdb_score float, production_budget int, worldwide_gross int, domestic_gross int, cast_total_facebook_likes int, actor_1_name string, actor_1_id string, actor_1_facebook_likes int, actor_2_name string, actor_2_id string, actor_2_facebook_likes int, actor_3_name string, actor_3_id string, actor_3_facebook_likes int, director_name string, director_id string, director_facebook_likes int)
row format delimited fields terminated by '\t'
location '/user/xl2700/class9/output4/';

drop table if exists genres;

create external table genres (movie_id string, genre string)
row format delimited fields terminated by '\t'
location '/user/xl2700/class9/output5/';

drop table if exists actor;

create external table actor (movie_id string, person_id string, person_name string, facebook_likes int)
row format delimited fields terminated by '\t'
location '/user/xl2700/class9/output6/';

/* Previous Great Works - Overall */

-- 	top 10 money-making movies

select distinct movie_id, movie_title, release_year, worldwide_gross
from movie
order by worldwide_gross desc
limit 10;

-- top 10 imdb rating movies

select distinct movie_id, movie_title, release_year, imdb_score
from movie
order by imdb_score desc
limit 10;

-- top 10 popular movies (by num_voted_users in imdb)

select distinct movie_id, movie_title, release_year, num_voted_users
from movie
order by num_voted_users desc
limit 10;

-- top 10 popular movies among critics

select distinct movie_id, movie_title, release_year, num_critic_for_reviews
from movie
order by num_critic_for_reviews desc
limit 10;

/* Trend */

-- movies made each year

select release_year, count(movie_id) as num_movies
from movie
where release_year is not null
group by release_year
order by release_year asc;

-- average budget for movies made each year

select release_year, avg(production_budget) as average_budget
from movie
where release_year is not null and production_budget <> 0
group by release_year
order by release_year asc;

-- average box for movies made each year

select release_year, avg(worldwide_gross) as average_gross
from movie
where release_year is not null and worldwide_gross <> 0
group by release_year
order by release_year asc;

/* Previous Great Works - By Genre */

drop table if exists movie_genres;

create table movie_genres as
select distinct m.movie_id as movie_id, movie_title, release_year, genre, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, director_name, director_id, director_facebook_likes
from genres g join movie m
on (g.movie_id = m.movie_id and g.movie_id is not null and m.movie_id is not null);

-- top money-making movie within each genre

select mg.genre as genre, mg.movie_id as movie_id, mg.movie_title as movie_title, mg.release_year as release_year, mg.worldwide_gross as worldwide_gross
from (
select genre, movie_id, movie_title, release_year, worldwide_gross, row_number() over (partition by genre order by worldwide_gross desc) as rank
from movie_genres
order by genre, worldwide_gross desc
) mg
where mg.rank <= 1;

-- top imdb-rating movie within each genre

select mg.genre as genre, mg.movie_id as movie_id, mg.movie_title as movie_title, mg.release_year as release_year, mg.imdb_score as imdb_score
from (
select genre, movie_id, movie_title, release_year, imdb_score, row_number() over (partition by genre order by imdb_score desc) as rank
from movie_genres
order by genre, imdb_score desc
) mg
where mg.rank <= 1;

-- top popular movie within each genre (by num_voted_users in imdb)

select mg.genre as genre, mg.movie_id as movie_id, mg.movie_title as movie_title, mg.release_year as release_year, mg.num_voted_users as num_voted_users
from (
select genre, movie_id, movie_title, release_year, num_voted_users, row_number() over (partition by genre order by num_voted_users desc) as rank
from movie_genres
order by genre, num_voted_users desc
) mg
where mg.rank <= 1;

-- top popular movie among critics within each genre

select mg.genre as genre, mg.movie_id as movie_id, mg.movie_title as movie_title, mg.release_year as release_year, mg.num_critic_for_reviews as num_critic_for_reviews
from (
select genre, movie_id, movie_title, release_year, num_critic_for_reviews, row_number() over (partition by genre order by num_critic_for_reviews desc) as rank
from movie_genres
order by genre, num_critic_for_reviews desc
) mg
where mg.rank <= 1;

/* Characteristics of Each Genre / Which Genre to Pick */

-- average budget for each genre

select genre, avg(production_budget) as average_budget
from movie_genres
where production_budget <> 0
group by genre;

-- average gross box for each genre

select genre, avg(worldwide_gross) as average_gross
from movie_genres
where worldwide_gross <> 0
group by genre;

-- average imdb rating for each genre

select genre, avg(imdb_score) as average_rating
from movie_genres
where imdb_score is not null
group by genre;

/* Film Crew */

-- best directors for each genre

drop table if exists director_norm;

create table director_norm as
select d.genre as genre, d.director_id as director_id, d.director_name as director_name, max(d.facebook_likes_norm) as facebook_likes, avg(d.gross_norm) as average_gross, avg(d.imdb_score_norm) as average_rating
from (
select genre, director_id, director_name, director_facebook_likes / max(director_facebook_likes) over () as facebook_likes_norm, worldwide_gross / max(worldwide_gross) over () as gross_norm, imdb_score / 10 as imdb_score_norm
from movie_genres
) d
group by genre, director_id, director_name;

alter table director_norm add columns (director_score float);

insert overwrite table director_norm
select genre, director_id, director_name, facebook_likes, average_gross, average_rating, (facebook_likes * 20 + average_gross * 40 + average_rating * 40) as director_score
from director_norm;

select d.genre as genre, d.director_id as director_id, d.director_name as director_name, d.director_score as director_score
from (
select genre, director_id, director_name, director_score, row_number() over (partition by genre order by director_score desc) as rank
from director_norm
order by genre, director_score desc
) d
where d.rank <= 5;

-- best actors/actresses for each genre

drop table if exists movie_genres_actor;

create table movie_genres_actor as
select distinct genre, mg.movie_id as movie_id, worldwide_gross, imdb_score, person_id, person_name, facebook_likes
from movie_genres mg join actor a
on (mg.movie_id = a.movie_id and mg.movie_id is not null and a.movie_id is not null);

drop table if exists actor_norm;

create table actor_norm as
select mga.genre as genre, mga.person_id as actor_id, mga.person_name as actor_name, max(mga.facebook_likes_norm) as facebook_likes, avg(mga.gross_norm) as average_gross, avg(mga.imdb_score_norm) as average_rating
from (
select genre, person_id, person_name, facebook_likes / max(facebook_likes) over () as facebook_likes_norm, worldwide_gross / max(worldwide_gross) over () as gross_norm, imdb_score / 10 as imdb_score_norm
from movie_genres_actor
) mga
group by genre, person_id, person_name;

alter table actor_norm add columns (actor_score float);

insert overwrite table actor_norm
select genre, actor_id, actor_name, facebook_likes, average_gross, average_rating, (facebook_likes * 20 + average_gross * 40 + average_rating * 40) as actor_score
from actor_norm;

select a.genre as genre, a.actor_id as actor_id, a.actor_name as actor_name, a.actor_score as actor_score
from (
select genre, actor_id, actor_name, actor_score, row_number() over (partition by genre order by actor_score desc) as rank
from actor_norm
order by genre, actor_score desc
) a
where a.rank <= 5;