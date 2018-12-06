#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import json
import codecs

sys.path.append('.')

UTF8Writer = codecs.getwriter('utf-8')
sys.stdout = UTF8Writer(sys.stdout)

for line in sys.stdin:
	try:
		movie_info = json.loads(line.strip().strip(','), encoding='utf-8')
	except:
		pass
	else:
		movie_id = movie_info['movie_id']
		cast_info = movie_info['cast_info']
		for cast in cast_info:
			key = '%s %s' % (movie_id, cast['actor_id'])
			#try:
			print '\t'.join([key, cast['actor_name'], str(cast['actor_facebook_likes'])])
			#except UnicodeDecodeError:
				#pass
				#print '\t'.join([key, cast['actor_name'].encode('utf-8', 'ignore'), str(cast['actor_facebook_likes'])])