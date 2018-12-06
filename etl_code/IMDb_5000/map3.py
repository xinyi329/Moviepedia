#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import json
import re

sys.path.append('.')

'''
from parse_scraped_data import parse_facebook_likes_number, parse_duration, parse_aspect_ratio
Credit: https://github.com/sundeepblue/movie_rating_prediction
'''

def parse_facebook_likes_number(num_likes_string):
	# eg: "8.5K" --> "85000"
	if not num_likes_string:
		return 0
	#size = len(num_likes_string)
	if num_likes_string[-1] == 'K':
		try:
			num_likes = int(float(num_likes_string[:-1]) * 1000)
		except:
			return 0
		else:
			return num_likes
	elif num_likes_string.isdigit():
		return int(num_likes_string)
	else: 
		return 0

def parse_duration(duration_string):
	if not duration_string:
		return 0
	#n = re.findall('[0-9,]+', duration_string)
	if "min" in duration_string:
		if "h" in duration_string: # eg: "2h 49min"
			s = duration_string.split("h")
			hours = int(s[0])
			if len(s) > 1: # has minute number
				if "min" in s[1]:
					minutes = int(s[1].strip().split("min")[0])
				else:
					minutes = 0
			else:
				minutes = 0
			return 60 * hours + minutes
		else: # eg: "169 min"
			return int(duration_string.split('min')[0])
	else:
		if "h" in duration_string: # eg: "2h"
			return int(duration_string.split('h')[0].strip()) * 60
		else:
			return None

def parse_aspect_ratio(ratio_string):
	if not ratio_string:
		return None
	if ":" in ratio_string:
		return float(ratio_string.split(":")[0].strip())
	else:
		return float(re.search('[0-9,.]+', ratio_string).group())

'''
Map Phase
'''

for line in sys.stdin:
	try:
		movie_info = json.loads(line.strip().strip(','), encoding='utf-8')
	except:
		pass
	else:
		if len(movie_info.keys()) == 9:
			# output from MapReduce 2
			#print "%s\t%s" % (movie_info['movie_id'], json.dumps(movie_info, ensure_ascii=False, encoding='utf-8'))
			print movie_info['movie_id'], '\t', json.dumps(movie_info)
		elif len(movie_info.keys()) == 23:
			# imdb_output_2017.json
			movie_id = re.search("(tt[0-9]{7})", movie_info['movie_imdb_link']).group()
			movie_title = movie_info['movie_title'].strip()
			release_year = None if movie_info['title_year'] is None else int(movie_info['title_year'])
			color = [c.strip() for c in movie_info['color']]
			duration = movie_info['duration']
			if not duration:
				duration = None
			else:
				if len(duration) == 1:
					duration = parse_duration(duration[0].strip())
				else:
					duration = parse_duration(duration[-1].strip())
			genres = [g.strip() for g in movie_info['genres']]
			plot_keywords = [k.strip() for k in movie_info['plot_keywords']]
			language = [l.strip() for l in movie_info['language']]
			country = [c.strip() for c in movie_info['country']]
			content_rating = None if movie_info['content_rating'] is None or len(movie_info['content_rating']) == 0 else movie_info['content_rating'][0].strip()
			storyline = None if not movie_info['storyline'] else movie_info['storyline'].replace('\t', ' ').strip()
			movie_facebook_likes = parse_facebook_likes_number(movie_info['num_facebook_like'])
			cast_info = [] if movie_info['cast_info'] is None or len(movie_info['cast_info']) == 0 else movie_info['cast_info']
			for actor_info in cast_info:
				actor_info['actor_name'] = actor_info['actor_name']
				actor_info['actor_facebook_likes'] = parse_facebook_likes_number(actor_info['actor_facebook_likes'])
				actor_info['actor_id'] = re.search("(nm[0-9]{7})", actor_info['actor_link']).group()
			director_info = {} if movie_info['director_info'] is None else movie_info['director_info']
			if not director_info:
				director_info['director_name'] = None
				director_info['director_link'] = None
				director_info['director_id'] = None
				director_info['director_facebook_likes'] = None
			else:
				director_info['director_name'] = director_info['director_name']
				director_info['director_facebook_likes'] = parse_facebook_likes_number(director_info['director_facebook_likes'])
				director_info['director_id'] = re.search("(nm[0-9]{7})", director_info['director_link']).group()
			parsed_info = {'movie_id': movie_id, 'movie_title': movie_title, 'release_year': release_year, 'color': color, 'duration': duration, 'genres': genres, 'plot_keywords': plot_keywords, 'language': language, 'country': country, 'content_rating': content_rating, 'storyline': storyline, 'movie_facebook_likes': movie_facebook_likes, 'cast_info': cast_info, 'director_info': director_info}
			#print "%s\t%s" % (movie_id, json.dumps(parsed_info, ensure_ascii=False, encoding='utf-8').encode('utf-8'))
			print movie_id, '\t', json.dumps(parsed_info, ensure_ascii=False, encoding='utf-8').encode('utf-8')
