#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import json

sys.path.append('.')

for line in sys.stdin:
	try:
		movie_info = json.loads(line.strip().strip(','), encoding='utf-8')
	except:
		pass
	else:
		movie_id = movie_info['movie_id'] 
		movie_imdb_link = movie_info['movie_imdb_link']
		movie_title = movie_info['movie_title']
		release_year = movie_info['release_year']
		color = '|'.join(movie_info['color'])
		duration = movie_info['duration']
		genres = '|'.join(movie_info['genres'])
		plot_keywords = '|'.join(movie_info['plot_keywords'])
		language = '|'.join(movie_info['language'])
		country = '|'.join(movie_info['country'])
		content_rating = movie_info['content_rating'] if movie_info['content_rating'] else ''
		#storyline = movie_info['storyline']
		movie_facebook_likes = movie_info['movie_facebook_likes']
		num_user_for_reviews = movie_info['num_user_for_reviews']
		num_critic_for_reviews = movie_info['num_critic_for_reviews']
		num_voted_users = movie_info['num_voted_users']
		imdb_score = movie_info['imdb_score']
		production_budget = movie_info['production_budget']
		worldwide_gross = movie_info['worldwide_gross']
		domestic_gross = movie_info['domestic_gross']
		cast_info = movie_info['cast_info']
		cast_total_facebook_likes = 0
		for actor_info in cast_info:
			cast_total_facebook_likes += actor_info['actor_facebook_likes']
		sorted_cast_by_likes = sorted(cast_info, key=lambda x: x['actor_facebook_likes'], reverse=True)
		top_cast_info = {}
		for i in range(3):
			actor_i_name = "actor_{0}_name".format(i + 1)
			actor_i_id = "actor_{0}_id".format(i + 1)
			actor_i_facebook_likes = "actor_{0}_facebook_likes".format(i + 1)
			if i < len(sorted_cast_by_likes):
				top_cast_info[actor_i_name] = sorted_cast_by_likes[i]['actor_name']
				top_cast_info[actor_i_id] = sorted_cast_by_likes[i]['actor_id']
				top_cast_info[actor_i_facebook_likes] = sorted_cast_by_likes[i]['actor_facebook_likes']
			else:
				top_cast_info[actor_i_name] = ''
				top_cast_info[actor_i_id] = ''
				top_cast_info[actor_i_facebook_likes] = 0
		director_info = movie_info['director_info']
		director_name = director_name = director_info['director_name'] if director_info['director_name'] else ''			
		director_id = director_info['director_id'] if director_info['director_id'] else ''
		director_facebook_likes = director_info['director_facebook_likes'] if director_info['director_facebook_likes'] else 0
		#print movie_id, '\t', ','.join([movie_imdb_link, movie_title, str(release_year), color, str(duration), genres, plot_keywords, language, country, content_rating, str(movie_facebook_likes), str(num_user_for_reviews), str(num_critic_for_reviews), str(num_voted_users), str(imdb_score), str(production_budget), str(worldwide_gross), str(domestic_gross), str(cast_total_facebook_likes), top_cast_info['actor_1_name'], top_cast_info['actor_1_id'], str(top_cast_info['actor_1_facebook_likes']), top_cast_info['actor_2_name'], top_cast_info['actor_2_id'], str(top_cast_info['actor_2_facebook_likes']), top_cast_info['actor_3_name'], top_cast_info['actor_3_id'], str(top_cast_info['actor_3_facebook_likes']), director_name, director_id, str(director_facebook_likes)]).encode('utf-8')
		print '\t'.join([movie_id, movie_imdb_link, movie_title, str(release_year), color, str(duration), genres, plot_keywords, language, country, content_rating, str(movie_facebook_likes), str(num_user_for_reviews), str(num_critic_for_reviews), str(num_voted_users), str(imdb_score), str(production_budget), str(worldwide_gross), str(domestic_gross), str(cast_total_facebook_likes), top_cast_info['actor_1_name'], top_cast_info['actor_1_id'], str(top_cast_info['actor_1_facebook_likes']), top_cast_info['actor_2_name'], top_cast_info['actor_2_id'], str(top_cast_info['actor_2_facebook_likes']), top_cast_info['actor_3_name'], top_cast_info['actor_3_id'], str(top_cast_info['actor_3_facebook_likes']), director_name, director_id, str(director_facebook_likes)]).encode('utf-8')
