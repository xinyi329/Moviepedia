import scrapy
import pandas as pd
from spider.items import SpiderItem
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.contrib.linkextractors import LinkExtractor

class MovieSpider(scrapy.Spider):

    name = "movieSpider"
    allowed_domains = ["imdb.com"]

    movie_list=pd.read_csv("~/Desktop/spider/movie_metadata.csv")

    movie_urls=movie_list["movie_imdb_link"].tolist()

    review_urls=[]
    for movie_url in movie_urls:
        right_index = movie_url.rfind('/')
        movie_url = movie_url[:right_index+1]+"reviews"
        review_urls.append(movie_url)

    start_urls = review_urls

    def parse(self, response):
        reviews = response.xpath("//div[contains(@class,'lister-item mode-detail imdb-user-review  with-spoiler')]")
        group = response.url.split('/')
        movieID = group[4]
        for review in reviews.extract():
            element = scrapy.Selector(text=review)
            spiderItem = SpiderItem()
            spiderItem['url']=response.url
            spiderItem['review'] = element.xpath("//div[contains(@class, 'text show-more__control')]/text()").extract_first().replace('\n',' ')
            spiderItem['movieID'] = movieID
            if len(element.xpath("//span[contains(@class, 'spoiler-warning')]")) != 0:
                spiderItem['spoiler'] = "true"
            else :
                spiderItem['spoiler'] = "false"
            score = element.xpath("//div[contains(@class,'ipl-ratings-bar')]/span/span/text()")
            if len(score) != 0:
                spiderItem['score'] = score.extract_first()
            else :
                spiderItem['score'] = ""
            yield spiderItem
        if len(self.start_urls) <= 40000:
            loader = response.xpath("//div[contains(@class,'load-more-data')]/@data-key").extract_first()
            if loader != None:
                url = 'https://www.imdb.com/title/'+movieID+'/reviews/_ajax?paginationKey='+loader
                self.start_urls.append(url)