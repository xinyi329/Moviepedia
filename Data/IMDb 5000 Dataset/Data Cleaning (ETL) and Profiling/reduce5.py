#!/usr/bin/env python

import sys

last_movie_info = None

for line in sys.stdin:
	movie_info = line.strip()
	if last_movie_info and last_movie_info != movie_info:
		(movie_id, genre) = last_movie_info.split('\t')
		print '%s\t%s' % (movie_id, genre)
		last_movie_info = movie_info
	else:
		last_movie_info = movie_info

if last_movie_info:
	(movie_id, genre) = last_movie_info.split('\t')
	print '%s\t%s' % (movie_id, genre)