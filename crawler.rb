require 'active_record'
require 'net/http'
require 'uri'
require 'cgi'
require 'debugger'
require 'socket'

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


Page.destroy_all
Link.destroy_all

Link.create(:url => "http://chongkim.org/").save!

def tcpsocket(hostname, port)
  s = Socket.new Socket::AF_INET, Socket::SOCK_STREAM
  s.connect Socket.pack_sockaddr_in(port, hostname)
  s
end

def get(url)
  socket = tcpsocket(url.hostname, url.port) 
  socket.write(<<-EOS)
GET #{url.path}?#{url.query} HTTP/1.0\r
Host: #{url.hostname}\r
\r
  EOS
  socket.flush
  read_info = socket.read
  socket.close
  read_info
end

link_models = Link.where(:visited_at => nil).limit(1)
while !link_models.empty? 
  link_model = link_models[0]
  url = URI(link_model.url)
  puts url.inspect
  html = get(url) 
  html =~ /<title>\s*(.*)\s*<\/title>/m
  title = $1

  links =[]
  html_copy = html.dup
  while (index = html_copy =~ /<a\s*href=\"(.*?)\"/m) do 
    html_copy = html_copy[(index + 1)..-1]
    link = $1
    if link.start_with?('http') 
      links << link 
    else
      links << "http://#{url.host}#{link}"
    end
  end


  body = html.gsub(/<script>.*?<\/script>/m, "").gsub(/<.*?>/, "")
  body = CGI.unescapeHTML(body)

  page = Page.create(:title => title, :body => body, :url => url.to_s)
  page.save!
  links.each do |l|
    Link.create(:url => l.to_s, :page_id => page.id).save! if l.to_s.start_with?('http:')
  end
  link_model.update_attributes(:visited_at => DateTime.now)

  word_hash = Hash.new(0)
  body.split.each { |word| word_hash[word] += 1 }
  word_hash.each { |word, frequency| Word.create(:word => word, :frequency => frequency, :page_id => page.id).save! }

  puts word_hash.inspect

  link_models = Link.where(:visited_at => nil).limit(1)
end
