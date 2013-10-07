require 'active_record'


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'meagan.db'
)

class Page < ActiveRecord::Base
end

class Link < ActiveRecord::Base
end

class Word < ActiveRecord::Base
end

word = ARGV[0]

Word.where(:word => word).order('frequency DESC').limit(10).each do |w|
  page = Page.find(w.page_id)
  puts "------------"
  puts page.title
  puts page.url
  puts page.body[200..300]
end


