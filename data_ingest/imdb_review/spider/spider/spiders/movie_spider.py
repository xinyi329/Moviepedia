import scrapy
import pandas as pd
from spider.items import SpiderItem
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.contrib.linkextractors import LinkExtractor
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from lxml import etree

class MovieSpider(scrapy.Spider):

    name = "movie"
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
        driver = webdriver.Chrome()
        reviews = response.xpath("//div[contains(@class,'lister-item mode-detail imdb-user-review  with-spoiler')]")
        driver.get(response.url)
        right_index = response.url.rfind('/')
        left_index = response.url[:right_index].rfind('/')
        movieID = response.url[left_index+1:right_index]
        while len(reviews) <= 100:
            driver.find_element_by_class_name("ipl-load-more").click()
            html = driver.page_source
            reviews = scrapy.Selector(text=html).xpath("//div[contains(@class,'lister-item mode-detail imdb-user-review  with-spoiler')]")
        for review in reviews[:100].extract():
            element = scrapy.Selector(text=review)
            spiderItem = SpiderItem()
            spiderItem['url']=response.url
            spiderItem['review'] = element.xpath("//div[contains(@class, 'text show-more__control')]/text()").extract_first()
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
