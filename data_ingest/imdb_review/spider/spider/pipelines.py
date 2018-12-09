# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://doc.scrapy.org/en/latest/topics/item-pipeline.html

import os
class SpiderPipeline(object):
    def __init__(self):
        if os.path.isfile("reviews.txt")==False:
            with open("reviews.txt","w+") as file:
                    file.write("movieID,score,review,spoiler,url\n")
            self.file=open("reviews.txt","a+")
        else:
            self.file=open("reviews.txt","a+")
    def process_item(self, item, spider):
        input=item["movieID"]+","
        input+=item["score"]+","
        input+=item["review"]+","
        input+=item["spoiler"]+","
        input+=item["url"]+"\n"
        self.file.write(input)
        return item
    def close_spider(self,spider):
        self.file.close()

