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
		if len(movie_info.keys()) == 7:
			# movie_budget_2018.json
			print "%s\tbox %s %s %s" % (re.sub('^http', 'https', movie_info['imdb_search_link']),
				re.sub('[^0-9,]', '', movie_info['production_budget']).replace(',', ''),
				re.sub('[^0-9,]', '', movie_info['worldwide_gross']).replace(',', ''),
				re.sub('[^0-9,]', '', movie_info['domestic_gross']).replace(',', ''))
		elif len(movie_info.keys()) == 3:
			# fetch_imdb_url_2018.json
			movie_id = re.search("(tt[0-9]{7})", movie_info['movie_imdb_link']).group()
			print "%s\tlink %s" % (movie_info['imdb_search_link'], movie_id)
	