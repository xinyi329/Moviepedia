#!/usr/bin/env python

import sys

sys.path.append('.')

(last_key, last_actor_name, last_actor_facebook_likes) = (None, None, None)

for line in sys.stdin:
	(key, actor_name, actor_facebook_likes) = line.strip().split('\t')
	if last_key and last_key != key:
		(movie_id, actor_id) = last_key.split(' ')
		print '%s\t%s\t%s\t%s' % (movie_id, actor_id, last_actor_name, last_actor_facebook_likes)
		(last_key, last_actor_name, last_actor_facebook_likes) = (key, actor_name, actor_facebook_likes)
	else:
		last_key = key
		last_actor_name = actor_name
		if last_actor_facebook_likes and last_actor_facebook_likes < actor_facebook_likes:
			last_actor_facebook_likes = actor_facebook_likes
		elif not last_actor_facebook_likes:
			last_actor_facebook_likes = actor_facebook_likes

if last_key:
	(movie_id, actor_id) = last_key.split(' ')
	print '%s\t%s\t%s\t%s' % (movie_id, actor_id, last_actor_name, last_actor_facebook_likes)

