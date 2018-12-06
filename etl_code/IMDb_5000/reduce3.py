#!/usr/bin/env python

import sys
import json

sys.path.append('.')

(last_movie_id, movie_title, release_year, color, duration, genres, plot_keywords, language, country, content_rating, storyline, movie_facebook_likes, cast_info, director_info, num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, domestic_gross, movie_imdb_link, original, update) = (None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, 0, 0)

i = 0

for line in sys.stdin:
	(movie_id, value) = line.strip().split('\t')
	movie_id = movie_id.strip()
	if last_movie_id and last_movie_id != movie_id:
		if original != 0 and update == 1:
			joined_info = {'movie_id': last_movie_id, 'movie_title': movie_title, 'release_year': release_year, 'color': color, 'duration': duration, 'genres': genres, 'plot_keywords': plot_keywords, 'language': language, 'country': country, 'content_rating': content_rating, 'storyline': storyline, 'movie_facebook_likes': movie_facebook_likes, 'cast_info': cast_info, 'director_info': director_info, 'num_user_for_reviews': int(num_user_for_reviews), 'num_critic_for_reviews': int(num_critic_for_reviews), 'num_voted_users': int(num_voted_users), 'imdb_score': float(imdb_score), 'production_budget': int(production_budget), 'worldwide_gross': int(worldwide_gross), 'domestic_gross': int(domestic_gross), 'movie_imdb_link': movie_imdb_link}
			print json.dumps(joined_info, ensure_ascii=False, encoding='utf-8').encode('utf-8')
		movie_info = json.loads(value.strip())
		if len(movie_info.keys()) == 14:
			# original
			(last_movie_id, movie_title, release_year, color, duration, genres, plot_keywords, language, country, content_rating, storyline, movie_facebook_likes, cast_info, director_info, num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, domestic_gross, movie_imdb_link, original, update) = (movie_id, movie_info['movie_title'], movie_info['release_year'], movie_info['color'], movie_info['duration'], movie_info['genres'], movie_info['plot_keywords'], movie_info['language'], movie_info['country'], movie_info['content_rating'], movie_info['storyline'], movie_info['movie_facebook_likes'], movie_info['cast_info'], movie_info['director_info'], None, None, None, None, None, None, None, None, 1, 0)
		elif len(movie_info.keys()) == 9:
			# update
			(last_movie_id, movie_title, release_year, color, duration, genres, plot_keywords, language, country, content_rating, storyline, movie_facebook_likes, cast_info, director_info, num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, domestic_gross, movie_imdb_link, original, update) = (movie_id, None, None, None, None, None, None, None, None, None, None, None, None, None, movie_info['num_user_for_reviews'], movie_info['num_critic_for_reviews'], movie_info['num_voted_users'], movie_info['imdb_score'], movie_info['production_budget'], movie_info['worldwide_gross'], movie_info['domestic_gross'], movie_info['movie_imdb_link'], 0, 1)
	else:
		movie_info = json.loads(value.strip())
		if len(movie_info.keys()) == 14:
			# original
			(last_movie_id, movie_title, release_year, color, duration, genres, plot_keywords, language, country, content_rating, storyline, movie_facebook_likes, cast_info, director_info, num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, domestic_gross, movie_imdb_link, original, update) = (movie_id, movie_info['movie_title'], movie_info['release_year'], movie_info['color'], movie_info['duration'], movie_info['genres'], movie_info['plot_keywords'], movie_info['language'], movie_info['country'], movie_info['content_rating'], movie_info['storyline'], movie_info['movie_facebook_likes'], movie_info['cast_info'], movie_info['director_info'], num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, domestic_gross, movie_imdb_link, original + 1, update)
		elif len(movie_info.keys()) == 9:
			# update
			(last_movie_id, movie_title, release_year, color, duration, genres, plot_keywords, language, country, content_rating, storyline, movie_facebook_likes, cast_info, director_info, num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, domestic_gross, movie_imdb_link, original, update) = (movie_id, movie_title, release_year, color, duration, genres, plot_keywords, language, country, content_rating, storyline, movie_facebook_likes, cast_info, director_info, movie_info['num_user_for_reviews'], movie_info['num_critic_for_reviews'], movie_info['num_voted_users'], movie_info['imdb_score'], movie_info['production_budget'], movie_info['worldwide_gross'], movie_info['domestic_gross'], movie_info['movie_imdb_link'], original, update + 1)

if last_movie_id:
	if original != 0 and update == 1:
		joined_info = {'movie_id': last_movie_id, 'movie_title': movie_title, 'release_year': release_year, 'color': color, 'duration': duration, 'genres': genres, 'plot_keywords': plot_keywords, 'language': language, 'country': country, 'content_rating': content_rating, 'storyline': storyline, 'movie_facebook_likes': movie_facebook_likes, 'cast_info': cast_info, 'director_info': director_info, 'num_user_for_reviews': int(num_user_for_reviews), 'num_critic_for_reviews': int(num_critic_for_reviews), 'num_voted_users': int(num_voted_users), 'imdb_score': float(imdb_score), 'production_budget': int(production_budget), 'worldwide_gross': int(worldwide_gross), 'domestic_gross': int(domestic_gross), 'movie_imdb_link': movie_imdb_link}
		print json.dumps(joined_info, ensure_ascii=False, encoding='utf-8').encode('utf-8')