#!/usr/bin/env python
"""
Created on Thu Dec  6 17:45:09 2018

@author: liyiming
"""

import sys
import re

stopwords = set()
dic = {}
def read_stop():
    f = open('english','r')
    for line in f:
        stopwords.add(line.strip())

def read_senti():
    f = open('SentiWords.txt','r')
    for line in f:
        (words, senti) = line.split('\t')
        (word, pos) = words.split('#')
        dic[word] = float(senti)

read_stop()
read_senti()

for line in sys.stdin:
    (key,review) = line.split('\t')
    sum = 0.0
    num = 0.0
    count_word = set()
    clean_tweet = re.sub("(@[A-Za-z0-9]+)|([^A-Za-z \t])|(\w+:\/\/\S+)", " ",review.strip())
    useful_text = re.sub(r"\b\w{1,3}\b", " ", clean_tweet)
    useful_text = useful_text.lower()
    words = useful_text.split()
    useful_words = [w for w in words if not w in stopwords]
    for word in useful_words:
        if word in dic:
            sum = sum + dic[word]
            count_word.add(word)
            num = num + 1
    for cnt_w in count_word:
        print "%s\t%s\t%s\t%s" % (key, word, "1",str(sum/num))  
    