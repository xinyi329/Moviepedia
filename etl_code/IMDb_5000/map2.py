#!/usr/bin/env python

import sys
import json
import re

sys.path.append('.')

for line in sys.stdin:
	try:
		movie_info = json.loads(line.strip().strip(','))
	except:
		pass
	else:
		if len(movie_info.keys()) == 4:
			# output from MapReduce 1
			print "%s\tbox %d %d %d" % (movie_info['movie_id'], movie_info['production_budget'], movie_info['worldwide_gross'], movie_info['domestic_gross'])
		elif len(movie_info.keys()) == 9:
			# imdb_output_2018.json
			movie_id = re.search("(tt[0-9]{7})", movie_info['movie_imdb_link']).group()
			num_user_for_reviews = movie_info['num_user_for_reviews'] if movie_info['num_user_for_reviews'] else 0
			num_critic_for_reviews = movie_info['num_critic_for_reviews'] if movie_info['num_critic_for_reviews'] else 0
			num_voted_users = movie_info['num_voted_users'] if movie_info['num_voted_users'] else 0
			imdb_score = float(movie_info['imdb_score'][0].strip()) if len(movie_info['imdb_score']) > 0 else 0
			print "%s\treview %s %d %d %d %.1f" % (movie_id, movie_info['movie_imdb_link'], num_user_for_reviews, num_critic_for_reviews, num_voted_users, imdb_score)
	