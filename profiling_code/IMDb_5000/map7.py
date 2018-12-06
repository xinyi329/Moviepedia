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
		storyline = movie_info['storyline']