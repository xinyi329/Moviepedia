use xl2700;

drop table if exists movie;

create external table movie (movie_id string, movie_imdb_link string, movie_title string, release_year int, color string, duration int, genres string, plot_keywords string, language string, country string, content_rating string, movie_facebook_likes int, num_user_for_reviews int, num_critic_for_reviews int, num_voted_users int, imdb_score float, production_budget int, worldwide_gross bigint, domestic_gross bigint, cast_total_facebook_likes int, actor_1_name string, actor_1_id string, actor_1_facebook_likes int, actor_2_name string, actor_2_id string, actor_2_facebook_likes int, actor_3_name string, actor_3_id string, actor_3_facebook_likes int, director_name string, director_id string, director_facebook_likes int)
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

drop table if exists imdb_review;

create external table imdb_review (movie_id string, word string, count int, rating float)
row format delimited fields terminated by '\t'
location '/user/xl2700/moviepedia/imdb/';

drop table if exists twitter_review;

create external table twitter_review (movie_id string, word string, count int, rating float)
row format delimited fields terminated by '\t'
location '/user/xl2700/moviepedia/twitter/';

/* Trend */

-- 1 / movies made each year

select release_year, count(movie_id) as num_movies
from movie
where release_year is not null
group by release_year
order by release_year asc;

-- 2 / average budget for movies made each year

select release_year, avg(production_budget) as average_budget
from movie
where release_year is not null and production_budget <> 0
group by release_year
order by release_year asc;

-- 3 / average box for movies made each year

select release_year, avg(worldwide_gross) as average_gross
from movie
where release_year is not null and worldwide_gross <> 0
group by release_year
order by release_year asc;

-- 3a / outliers

select movie_title, release_year, movie_id, worldwide_gross
from movie
where release_year = 1937 or release_year = 1939 or release_year = 1942
order by release_year asc;

/* Correlation */

-- 4 / correlation

-- release_year, duration, movie_facebook_likes, num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, cast_total_facebook_likes, actor_1_facebook_likes, actor_2_facebook_likes, actor_3_facebook_likes, director_facebook_likes

create table correlation as
select c.release_year as release_year, c.duration as duration, c.movie_facebook_likes as movie_facebook_likes, c.num_user_for_reviews as num_user_for_reviews, c.num_critic_for_reviews as num_critic_for_reviews, c.num_voted_users as num_voted_users, c.imdb_score as imdb_score, c.production_budget as production_budget, c.worldwide_gross as worldwide_gross, c.cast_total_facebook_likes as cast_total_facebook_likes, c.actor_1_facebook_likes as actor_1_facebook_likes, c.actor_2_facebook_likes as actor_2_facebook_likes, c.actor_3_facebook_likes as actor_3_facebook_likes, c.director_facebook_likes as director_facebook_likes
from (
select corr(release_year, release_year) as release_year, corr(release_year, duration) as duration, corr(release_year, movie_facebook_likes) as movie_facebook_likes, corr(release_year, num_user_for_reviews) as num_user_for_reviews, corr(release_year, num_critic_for_reviews) as num_critic_for_reviews, corr(release_year, num_voted_users) as num_voted_users, corr(release_year, imdb_score) as imdb_score, corr(release_year, production_budget) as production_budget, corr(release_year, worldwide_gross) as worldwide_gross, corr(release_year, cast_total_facebook_likes) as cast_total_facebook_likes, corr(release_year, actor_1_facebook_likes) as actor_1_facebook_likes, corr(release_year, actor_2_facebook_likes) as actor_2_facebook_likes, corr(release_year, actor_3_facebook_likes) as actor_3_facebook_likes, corr(release_year, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(duration, release_year) as release_year, corr(duration, duration) as duration, corr(duration, movie_facebook_likes) as movie_facebook_likes, corr(duration, num_user_for_reviews) as num_user_for_reviews, corr(duration, num_critic_for_reviews) as num_critic_for_reviews, corr(duration, num_voted_users) as num_voted_users, corr(duration, imdb_score) as imdb_score, corr(duration, production_budget) as production_budget, corr(duration, worldwide_gross) as worldwide_gross, corr(duration, cast_total_facebook_likes) as cast_total_facebook_likes, corr(duration, actor_1_facebook_likes) as actor_1_facebook_likes, corr(duration, actor_2_facebook_likes) as actor_2_facebook_likes, corr(duration, actor_3_facebook_likes) as actor_3_facebook_likes, corr(duration, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(movie_facebook_likes, release_year) as release_year, corr(movie_facebook_likes, duration) as duration, corr(movie_facebook_likes, movie_facebook_likes) as movie_facebook_likes, corr(movie_facebook_likes, num_user_for_reviews) as num_user_for_reviews, corr(movie_facebook_likes, num_critic_for_reviews) as num_critic_for_reviews, corr(movie_facebook_likes, num_voted_users) as num_voted_users, corr(movie_facebook_likes, imdb_score) as imdb_score, corr(movie_facebook_likes, production_budget) as production_budget, corr(movie_facebook_likes, worldwide_gross) as worldwide_gross, corr(movie_facebook_likes, cast_total_facebook_likes) as cast_total_facebook_likes, corr(movie_facebook_likes, actor_1_facebook_likes) as actor_1_facebook_likes, corr(movie_facebook_likes, actor_2_facebook_likes) as actor_2_facebook_likes, corr(movie_facebook_likes, actor_3_facebook_likes) as actor_3_facebook_likes, corr(movie_facebook_likes, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(num_user_for_reviews, release_year) as release_year, corr(num_user_for_reviews, duration) as duration, corr(num_user_for_reviews, movie_facebook_likes) as movie_facebook_likes, corr(num_user_for_reviews, num_user_for_reviews) as num_user_for_reviews, corr(num_user_for_reviews, num_critic_for_reviews) as num_critic_for_reviews, corr(num_user_for_reviews, num_voted_users) as num_voted_users, corr(num_user_for_reviews, imdb_score) as imdb_score, corr(num_user_for_reviews, production_budget) as production_budget, corr(num_user_for_reviews, worldwide_gross) as worldwide_gross, corr(num_user_for_reviews, cast_total_facebook_likes) as cast_total_facebook_likes, corr(num_user_for_reviews, actor_1_facebook_likes) as actor_1_facebook_likes, corr(num_user_for_reviews, actor_2_facebook_likes) as actor_2_facebook_likes, corr(num_user_for_reviews, actor_3_facebook_likes) as actor_3_facebook_likes, corr(num_user_for_reviews, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(num_critic_for_reviews, release_year) as release_year, corr(num_critic_for_reviews, duration) as duration, corr(num_critic_for_reviews, movie_facebook_likes) as movie_facebook_likes, corr(num_critic_for_reviews, num_user_for_reviews) as num_user_for_reviews, corr(num_critic_for_reviews, num_critic_for_reviews) as num_critic_for_reviews, corr(num_critic_for_reviews, num_voted_users) as num_voted_users, corr(num_critic_for_reviews, imdb_score) as imdb_score, corr(num_critic_for_reviews, production_budget) as production_budget, corr(num_critic_for_reviews, worldwide_gross) as worldwide_gross, corr(num_critic_for_reviews, cast_total_facebook_likes) as cast_total_facebook_likes, corr(num_critic_for_reviews, actor_1_facebook_likes) as actor_1_facebook_likes, corr(num_critic_for_reviews, actor_2_facebook_likes) as actor_2_facebook_likes, corr(num_critic_for_reviews, actor_3_facebook_likes) as actor_3_facebook_likes, corr(num_critic_for_reviews, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(num_voted_users, release_year) as release_year, corr(num_voted_users, duration) as duration, corr(num_voted_users, movie_facebook_likes) as movie_facebook_likes, corr(num_voted_users, num_user_for_reviews) as num_user_for_reviews, corr(num_voted_users, num_critic_for_reviews) as num_critic_for_reviews, corr(num_voted_users, num_voted_users) as num_voted_users, corr(num_voted_users, imdb_score) as imdb_score, corr(num_voted_users, production_budget) as production_budget, corr(num_voted_users, worldwide_gross) as worldwide_gross, corr(num_voted_users, cast_total_facebook_likes) as cast_total_facebook_likes, corr(num_voted_users, actor_1_facebook_likes) as actor_1_facebook_likes, corr(num_voted_users, actor_2_facebook_likes) as actor_2_facebook_likes, corr(num_voted_users, actor_3_facebook_likes) as actor_3_facebook_likes, corr(num_voted_users, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(imdb_score, release_year) as release_year, corr(imdb_score, duration) as duration, corr(imdb_score, movie_facebook_likes) as movie_facebook_likes, corr(imdb_score, num_user_for_reviews) as num_user_for_reviews, corr(imdb_score, num_critic_for_reviews) as num_critic_for_reviews, corr(imdb_score, num_voted_users) as num_voted_users, corr(imdb_score, imdb_score) as imdb_score, corr(imdb_score, production_budget) as production_budget, corr(imdb_score, worldwide_gross) as worldwide_gross, corr(imdb_score, cast_total_facebook_likes) as cast_total_facebook_likes, corr(imdb_score, actor_1_facebook_likes) as actor_1_facebook_likes, corr(imdb_score, actor_2_facebook_likes) as actor_2_facebook_likes, corr(imdb_score, actor_3_facebook_likes) as actor_3_facebook_likes, corr(imdb_score, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(production_budget, release_year) as release_year, corr(production_budget, duration) as duration, corr(production_budget, movie_facebook_likes) as movie_facebook_likes, corr(production_budget, num_user_for_reviews) as num_user_for_reviews, corr(production_budget, num_critic_for_reviews) as num_critic_for_reviews, corr(production_budget, num_voted_users) as num_voted_users, corr(production_budget, imdb_score) as imdb_score, corr(production_budget, production_budget) as production_budget, corr(production_budget, worldwide_gross) as worldwide_gross, corr(production_budget, cast_total_facebook_likes) as cast_total_facebook_likes, corr(production_budget, actor_1_facebook_likes) as actor_1_facebook_likes, corr(production_budget, actor_2_facebook_likes) as actor_2_facebook_likes, corr(production_budget, actor_3_facebook_likes) as actor_3_facebook_likes, corr(production_budget, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(worldwide_gross, release_year) as release_year, corr(worldwide_gross, duration) as duration, corr(worldwide_gross, movie_facebook_likes) as movie_facebook_likes, corr(worldwide_gross, num_user_for_reviews) as num_user_for_reviews, corr(worldwide_gross, num_critic_for_reviews) as num_critic_for_reviews, corr(worldwide_gross, num_voted_users) as num_voted_users, corr(worldwide_gross, imdb_score) as imdb_score, corr(worldwide_gross, production_budget) as production_budget, corr(worldwide_gross, worldwide_gross) as worldwide_gross, corr(worldwide_gross, cast_total_facebook_likes) as cast_total_facebook_likes, corr(worldwide_gross, actor_1_facebook_likes) as actor_1_facebook_likes, corr(worldwide_gross, actor_2_facebook_likes) as actor_2_facebook_likes, corr(worldwide_gross, actor_3_facebook_likes) as actor_3_facebook_likes, corr(worldwide_gross, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(cast_total_facebook_likes, release_year) as release_year, corr(cast_total_facebook_likes, duration) as duration, corr(cast_total_facebook_likes, movie_facebook_likes) as movie_facebook_likes, corr(cast_total_facebook_likes, num_user_for_reviews) as num_user_for_reviews, corr(cast_total_facebook_likes, num_critic_for_reviews) as num_critic_for_reviews, corr(cast_total_facebook_likes, num_voted_users) as num_voted_users, corr(cast_total_facebook_likes, imdb_score) as imdb_score, corr(cast_total_facebook_likes, production_budget) as production_budget, corr(cast_total_facebook_likes, worldwide_gross) as worldwide_gross, corr(cast_total_facebook_likes, cast_total_facebook_likes) as cast_total_facebook_likes, corr(cast_total_facebook_likes, actor_1_facebook_likes) as actor_1_facebook_likes, corr(cast_total_facebook_likes, actor_2_facebook_likes) as actor_2_facebook_likes, corr(cast_total_facebook_likes, actor_3_facebook_likes) as actor_3_facebook_likes, corr(cast_total_facebook_likes, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(actor_1_facebook_likes, release_year) as release_year, corr(actor_1_facebook_likes, duration) as duration, corr(actor_1_facebook_likes, movie_facebook_likes) as movie_facebook_likes, corr(actor_1_facebook_likes, num_user_for_reviews) as num_user_for_reviews, corr(actor_1_facebook_likes, num_critic_for_reviews) as num_critic_for_reviews, corr(actor_1_facebook_likes, num_voted_users) as num_voted_users, corr(actor_1_facebook_likes, imdb_score) as imdb_score, corr(actor_1_facebook_likes, production_budget) as production_budget, corr(actor_1_facebook_likes, worldwide_gross) as worldwide_gross, corr(actor_1_facebook_likes, cast_total_facebook_likes) as cast_total_facebook_likes, corr(actor_1_facebook_likes, actor_1_facebook_likes) as actor_1_facebook_likes, corr(actor_1_facebook_likes, actor_2_facebook_likes) as actor_2_facebook_likes, corr(actor_1_facebook_likes, actor_3_facebook_likes) as actor_3_facebook_likes, corr(actor_1_facebook_likes, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(actor_2_facebook_likes, release_year) as release_year, corr(actor_2_facebook_likes, duration) as duration, corr(actor_2_facebook_likes, movie_facebook_likes) as movie_facebook_likes, corr(actor_2_facebook_likes, num_user_for_reviews) as num_user_for_reviews, corr(actor_2_facebook_likes, num_critic_for_reviews) as num_critic_for_reviews, corr(actor_2_facebook_likes, num_voted_users) as num_voted_users, corr(actor_2_facebook_likes, imdb_score) as imdb_score, corr(actor_2_facebook_likes, production_budget) as production_budget, corr(actor_2_facebook_likes, worldwide_gross) as worldwide_gross, corr(actor_2_facebook_likes, cast_total_facebook_likes) as cast_total_facebook_likes, corr(actor_2_facebook_likes, actor_1_facebook_likes) as actor_1_facebook_likes, corr(actor_2_facebook_likes, actor_2_facebook_likes) as actor_2_facebook_likes, corr(actor_2_facebook_likes, actor_3_facebook_likes) as actor_3_facebook_likes, corr(actor_2_facebook_likes, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(actor_3_facebook_likes, release_year) as release_year, corr(actor_3_facebook_likes, duration) as duration, corr(actor_3_facebook_likes, movie_facebook_likes) as movie_facebook_likes, corr(actor_3_facebook_likes, num_user_for_reviews) as num_user_for_reviews, corr(actor_3_facebook_likes, num_critic_for_reviews) as num_critic_for_reviews, corr(actor_3_facebook_likes, num_voted_users) as num_voted_users, corr(actor_3_facebook_likes, imdb_score) as imdb_score, corr(actor_3_facebook_likes, production_budget) as production_budget, corr(actor_3_facebook_likes, worldwide_gross) as worldwide_gross, corr(actor_3_facebook_likes, cast_total_facebook_likes) as cast_total_facebook_likes, corr(actor_3_facebook_likes, actor_1_facebook_likes) as actor_1_facebook_likes, corr(actor_3_facebook_likes, actor_2_facebook_likes) as actor_2_facebook_likes, corr(actor_3_facebook_likes, actor_3_facebook_likes) as actor_3_facebook_likes, corr(actor_3_facebook_likes, director_facebook_likes) as director_facebook_likes
from movie
union all
select corr(director_facebook_likes, release_year) as release_year, corr(director_facebook_likes, duration) as duration, corr(director_facebook_likes, movie_facebook_likes) as movie_facebook_likes, corr(director_facebook_likes, num_user_for_reviews) as num_user_for_reviews, corr(director_facebook_likes, num_critic_for_reviews) as num_critic_for_reviews, corr(director_facebook_likes, num_voted_users) as num_voted_users, corr(director_facebook_likes, imdb_score) as imdb_score, corr(director_facebook_likes, production_budget) as production_budget, corr(director_facebook_likes, worldwide_gross) as worldwide_gross, corr(director_facebook_likes, cast_total_facebook_likes) as cast_total_facebook_likes, corr(director_facebook_likes, actor_1_facebook_likes) as actor_1_facebook_likes, corr(director_facebook_likes, actor_2_facebook_likes) as actor_2_facebook_likes, corr(director_facebook_likes, actor_3_facebook_likes) as actor_3_facebook_likes, corr(director_facebook_likes, director_facebook_likes) as director_facebook_likes
from movie
) c;

/* Previous Great Works - Overall */

-- 	5 / top 10 money-making movies

select distinct movie_id, movie_title, release_year, worldwide_gross
from movie
order by worldwide_gross desc
limit 10;

-- 6 / top 10 imdb rating movies

select distinct movie_id, movie_title, release_year, imdb_score
from movie
order by imdb_score desc
limit 10;

-- 7 / top 10 popular movies (by num_voted_users in imdb)

select distinct movie_id, movie_title, release_year, num_voted_users
from movie
order by num_voted_users desc
limit 10;

-- 8 / top 10 popular movies among critics

select distinct movie_id, movie_title, release_year, num_critic_for_reviews
from movie
order by num_critic_for_reviews desc
limit 10;

/* Previous Great Works - By Genre */

drop table if exists movie_genres;

create table movie_genres as
select distinct m.movie_id as movie_id, movie_title, release_year, genre, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, director_name, director_id, director_facebook_likes
from genres g join movie m
on (g.movie_id = m.movie_id and g.movie_id is not null and m.movie_id is not null);

-- 9 / top money-making movie within each genre

select mg.genre as genre, mg.movie_id as movie_id, mg.movie_title as movie_title, mg.release_year as release_year, mg.worldwide_gross as worldwide_gross
from (
select genre, movie_id, movie_title, release_year, worldwide_gross, row_number() over (partition by genre order by worldwide_gross desc) as rank
from movie_genres
order by genre, worldwide_gross desc
) mg
where mg.rank <= 1;

-- 10 / top imdb-rating movie within each genre

select mg.genre as genre, mg.movie_id as movie_id, mg.movie_title as movie_title, mg.release_year as release_year, mg.imdb_score as imdb_score
from (
select genre, movie_id, movie_title, release_year, imdb_score, row_number() over (partition by genre order by imdb_score desc) as rank
from movie_genres
order by genre, imdb_score desc
) mg
where mg.rank <= 1;

-- 11 / top popular movie within each genre (by num_voted_users in imdb)

select mg.genre as genre, mg.movie_id as movie_id, mg.movie_title as movie_title, mg.release_year as release_year, mg.num_voted_users as num_voted_users
from (
select genre, movie_id, movie_title, release_year, num_voted_users, row_number() over (partition by genre order by num_voted_users desc) as rank
from movie_genres
order by genre, num_voted_users desc
) mg
where mg.rank <= 1;

-- 12 / top popular movie among critics within each genre

select mg.genre as genre, mg.movie_id as movie_id, mg.movie_title as movie_title, mg.release_year as release_year, mg.num_critic_for_reviews as num_critic_for_reviews
from (
select genre, movie_id, movie_title, release_year, num_critic_for_reviews, row_number() over (partition by genre order by num_critic_for_reviews desc) as rank
from movie_genres
order by genre, num_critic_for_reviews desc
) mg
where mg.rank <= 1;

/* Characteristics of Each Genre / Which Genre to Pick */

-- 13 / average budget for each genre

select genre, avg(production_budget) as average_budget
from movie_genres
where production_budget <> 0
group by genre;

-- 14 / average gross box for each genre

select genre, avg(worldwide_gross) as average_gross
from movie_genres
where worldwide_gross <> 0
group by genre;

-- 15 / average imdb rating for each genre

select genre, avg(imdb_score) as average_rating
from movie_genres
where imdb_score is not null
group by genre;

/* Film Crew */

-- 16 / best directors for each genre

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

drop table if exists top_directors;

create table top_directors as
select d.genre as genre, d.director_id as director_id, d.director_name as director_name, d.director_score as director_score
from (
select genre, director_id, director_name, director_score, row_number() over (partition by genre order by director_score desc) as rank
from director_norm
order by genre, director_score desc
) d
where d.rank <= 5;

-- 17 / best actors/actresses for each genre

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

drop table if exists top_actors;

create table top_actors as
select a.genre as genre, a.actor_id as actor_id, a.actor_name as actor_name, a.actor_score as actor_score
from (
select genre, actor_id, actor_name, actor_score, row_number() over (partition by genre order by actor_score desc) as rank
from actor_norm
order by genre, actor_score desc
) a
where a.rank <= 5;

/* Review Word Count - Word Cloud */

-- 18 / review top word count by genre from imdb

create table imdb_top_words as
select iggr.genre as genre, iggr.word as word, iggr.count as count, iggr.sentiment as sentiment
from (
select igg.genre as genre, igg.word as word, igg.count as count, igg.sentiment as sentiment, row_number() over (partition by genre order by count desc) as rank
from (
select ig.genre as genre, ig.word as word, sum(ig.count) as count, (sum(ig.rating) / sum(ig.count) - 5) as sentiment
from (
select g.genre as genre, i.word as word, i.count as count, i.rating as rating
from imdb_review i join genres g
on (i.movie_id = g.movie_id and i.movie_id is not null and g.movie_id is not null)
where (i.word != 'http' and i.word != 'https' and i.word != 'movie' and i.word != 'movies' and i.word != 'film' and i.word != 'films')
) ig
group by ig.genre, ig.word
) igg
order by genre, count desc
) iggr
where iggr.rank <= 50;

-- 19 / review top word count by genre from twitter

create table twitter_top_words as
select tggr.genre as genre, tggr.word as word, tggr.count as count, tggr.sentiment as sentiment
from (
select tgg.genre as genre, tgg.word as word, tgg.count as count, tgg.sentiment as sentiment, row_number() over (partition by genre order by count desc) as rank
from (
select tg.genre as genre, tg.word as word, sum(tg.count) as count, (sum(tg.rating) / sum(tg.count) * 5) as sentiment
from (
select g.genre as genre, t.word as word, t.count as count, t.rating as rating
from twitter_review t join genres g
on (t.movie_id = g.movie_id and t.movie_id is not null and g.movie_id is not null)
where (t.word != 'http' and t.word != 'https' and t.word != 'movie' and t.word != 'movies' and t.word != 'film' and t.word != 'films')
) tg
group by tg.genre, tg.word
) tgg
order by genre, count desc
) tggr
where tggr.rank <= 50;

show tables;