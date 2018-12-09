# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy


from scrapy.item import Field,Item

class SpiderItem(Item):
    url = Field()
    movieID = Field()
    score = Field()
    review = Field()
    spoiler = Field()