#!/usr/bin/env python

import sys
import json

sys.path.append('.')

(last_movie_id, movie_imdb_link, num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, domestic_gross, box, review) = (None, None, None, None, None, None, None, None, None, 0, 0)

for line in sys.stdin:
	(movie_id, value) = line.strip().split('\t')
	if last_movie_id and last_movie_id != movie_id:
		if box == 1 and review != 0:
			joined_info = {'movie_id': last_movie_id, 'movie_imdb_link': movie_imdb_link, 'num_user_for_reviews': int(num_user_for_reviews), 'num_critic_for_reviews': int(num_critic_for_reviews), 'num_voted_users': int(num_voted_users), 'imdb_score': float(imdb_score), 'production_budget': int(production_budget), 'worldwide_gross': int(worldwide_gross), 'domestic_gross': int(domestic_gross)}
			print json.dumps(joined_info)
		movie_info = value.strip().split(' ')
		if movie_info[0] == 'box':
			(last_movie_id, movie_imdb_link, num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, domestic_gross, box, review) = (movie_id, None, None, None, None, None, movie_info[1], movie_info[2], movie_info[3], 1, 0)
		elif movie_info[0] == 'review':
			(last_movie_id, movie_imdb_link, num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, domestic_gross, box, review) = (movie_id, movie_info[1], movie_info[2], movie_info[3], movie_info[4], movie_info[5], None, None, None, 0, 1)
	else:
		movie_info = value.strip().split(' ')
		if movie_info[0] == 'box':
			(last_movie_id, movie_imdb_link, num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, domestic_gross, box, review) = (movie_id, movie_imdb_link, num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, movie_info[1], movie_info[2], movie_info[3], box + 1, review)
		elif movie_info[0] == 'review':
			(last_movie_id, movie_imdb_link, num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score, production_budget, worldwide_gross, domestic_gross, box, review) = (movie_id, movie_info[1], movie_info[2], movie_info[3], movie_info[4], movie_info[5], production_budget, worldwide_gross, domestic_gross, box, review + 1)

if last_movie_id:
	if box == 1 and review != 0:
		joined_info = {'movie_id': last_movie_id, 'movie_imdb_link': movie_imdb_link, 'num_user_for_reviews': int(num_user_for_reviews), 'num_critic_for_reviews': int(num_critic_for_reviews), 'num_voted_users': int(num_voted_users), 'imdb_score': float(imdb_score), 'production_budget': int(production_budget), 'worldwide_gross': int(worldwide_gross), 'domestic_gross': int(domestic_gross)}
		print json.dumps(joined_info)