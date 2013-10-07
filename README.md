## Web Crawler/ Google Clone

[Chong](http://www.chongkim.org/) and I paired on this awesome fun project! We
made a Google clone (well, that's probably a little ambitious, but that was the
goal!).

Chong came to me with the idea of creating a google clone. 

First we implemented a web crawler `crawler.rb`

We first started with the higest level abstraction we could, we used a gem
[Anemone](http://anemone.rubyforge.org/) to crawl a website, and worked our way
down until we were implementing it at the lowest level, which is what you're
seeing today.

I'm using a Sqlite3 database and ActiveRecord, as well as Sockets.

Right now the crawler crawls [Chong's Blog](http://chongkim.org/) and gets every
word on the page and the amount of times the word shows up.



### See it in Action

#### Set Up
`git clone git@github.com:meaganewaller/webcrawler.git`

`cd webcrawler`

`bundle install`

#### Crawl the Blog

`ruby crawler.rb`

#### Search for Specific Words on the Blog

`ruby search.rb [yourwordhere]`

This search will return the page on which the word is found the most often.





