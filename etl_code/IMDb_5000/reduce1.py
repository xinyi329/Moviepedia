#!/usr/bin/env python

import sys
import json

sys.path.append('.')

(last_imdb_search_link, movie_id, production_budget, worldwide_gross, domestic_gross, box, link) = (None, None, None, None, None, 0, 0)

for line in sys.stdin:
	(imdb_search_link, value) = line.strip().split('\t')
	if last_imdb_search_link and last_imdb_search_link != imdb_search_link:
		if box == 1 and link == 1:
			joined_info = {'movie_id': movie_id, 'production_budget': int(production_budget), 'worldwide_gross': int(worldwide_gross), 'domestic_gross': int(domestic_gross)}
			print json.dumps(joined_info)
		movie_info = value.strip().split(' ')
		if movie_info[0] == 'box':
			# movie_budget_2018.json
			(last_imdb_search_link, movie_id, production_budget, worldwide_gross, domestic_gross, box, link) = (imdb_search_link, None, movie_info[1], movie_info[2], movie_info[3], 1, 0)
		elif movie_info[0] == 'link':
			# fetch_imdb_url_2018.json
			(last_imdb_search_link, movie_id, production_budget, worldwide_gross, domestic_gross, box, link) = (imdb_search_link, movie_info[1], None, None, None, 0, 1)
	else:
		movie_info = value.strip().split(' ')
		if movie_info[0] == 'box':
			# movie_budget_2018.json
			(last_imdb_search_link, movie_id, production_budget, worldwide_gross, domestic_gross, box, link) = (imdb_search_link, movie_id, movie_info[1], movie_info[2], movie_info[3], box + 1, link)
		elif movie_info[0] == 'link':
			# fetch_imdb_url_2018.json
			(last_imdb_search_link, movie_id, production_budget, worldwide_gross, domestic_gross, box, link) = (imdb_search_link, movie_info[1], production_budget, worldwide_gross, domestic_gross, box, link + 1)

if last_imdb_search_link:
	if box == 1 and link == 1:
		joined_info = {'movie_id': movie_id, 'production_budget': int(production_budget), 'worldwide_gross': int(worldwide_gross), 'domestic_gross': int(domestic_gross)}
		print json.dumps(joined_info)
