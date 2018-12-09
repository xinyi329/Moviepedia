#!/usr/bin/env python
"""
Created on Thu Dec  6 18:06:11 2018

@author: liyiming
"""
import sys
dic = {}
(keyword, word, count, senti) = (None, None, 0, 0)
for line in sys.stdin:
    (tt, w, cnt, sen) = line.split('\t')
    cnt = int(cnt)
    sen = float(sen)
    if keyword and keyword != tt:
    	for i in dic:
    		print "%s\t%s\t%s\t%s" % (keyword, i, str(dic[i][0]),str(dic[i][1]))
        #print "%s\t%d\t%f" % (keyword, count, senti)
        dic.clear()
        (keyword, word, count, senti) = (tt, w, cnt, sen)
        dic[w] = [cnt, sen]
    else:
        if keyword is None:
            keyword = tt
    	if w in dic:
    		dic[w] = [dic[w][0]+cnt, dic[w][1]+sen]
    	else:
    		dic[w] = [cnt,sen]
if keyword:
    for i in dic:
    	print "%s\t%s\t%s\t%s" % (keyword, i, str(dic[i][0]),str(dic[i][1]))
    #print "%s\t%s\t%s\t%s" % (keyword, count, senti)
