#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import json
import string

sys.path.append('.')

for line in sys.stdin:
	try:
		movie_info = json.loads(line.strip().strip(','), encoding='utf-8')
	except:
		pass
	else:
		movie_id = movie_info['movie_id']
		genres = set([x.lower() for x in movie_info['genres']])
		for genre in genres:
			print '%s\t%s' % (movie_id, string.capwords(genre))