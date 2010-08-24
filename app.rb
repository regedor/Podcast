require 'rubygems'
require 'sinatra'
require 'active_support'
require 'redcloth'
require 'time'
require 'builder'
require 'fileutils'

def url_for url_fragment, mode=:full
  case mode
    when :path_only
      base = request.script_name
    when :full
      scheme = request.scheme
      if (scheme == 'http' && request.port == 80 || scheme == 'https' && request.port == 443)
        port = ""
      else
        port = ":#{request.port}"
      end
      base = "#{scheme}://#{request.host}#{port}#{request.script_name}"
    else
      raise TypeError, "Unknown url_for mode #{mode}"
  end
  "#{base}#{url_fragment}"
end

def cache(text)
 # requests to / should be cached as index.html
 uri = request.env["REQUEST_URI"] == "/" ? 'index' : request.env["REQUEST_URI"]
 # Don't cache pages with query strings.
 unless uri =~ /\?/ || uri =~ /localhost/
    uri << '.html'
    # put all cached files in a subdirectory called 'cache'
    path = File.join(File.dirname(__FILE__), 'cache', uri)

    # Create the directory if it doesn't exist
    FileUtils.mkdir_p(File.dirname(path))

    # Write the text passed to the path
    File.open(path, 'w') { |f| f.write( text ) }
  end
  return text
end 

get '/' do
  id = File.readlines(Dir[File.join(File.dirname(__FILE__), 'public', 'podcasts','*','details')].sort.last).first
  redirect "/podcast/#{id}"
end

get '/todos' do
  @months   = []
  @podcasts = {}
  Dir[File.join(File.dirname(__FILE__), 'public', 'podcasts','*','details')].sort.reverse.each do |path|
    details = File.readlines(path)
    month = details.last
    unless @podcasts[month]
      @months << month
      @podcasts[month] = []
    end
    @podcasts[month] << [details[1],"/podcast/#{details[0]}"]
  end
  cache haml(:list)
end


get '/todos.rss' do
  xml = Builder::XmlMarkup.new
  xml.instruct! :xml, :version => "1.0" 
  rss = xml.rss :version => "2.0", 'xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd", 'xmlns:media' => "http://search.yahoo.com/mrss/" do
    xml.channel do
      xml.title "Podcast do CeSIUM"
      xml.description "Lots of Podcasts by Miguel Regedor"
      xml.link url_for("/todos")
      xml.lastBuildDate Time.now.to_s(:rfc822)
      xml.image do
        xml.url url_for("/images/logo.png")
        xml.title "Podcast do CeSIUM"
        xml.link url_for("/todos")
      end
      Dir[File.join(File.dirname(__FILE__), 'public', 'podcasts','*','details')].sort.reverse.each do |path|
        details = File.readlines(path)
        id = details[0].strip
        title = details[1].strip
        date = Time.parse(details[2].strip).to_s(:rfc822)
        podcast_path = url_for "/podcast/#{id}"
        mp3_path     = url_for "/podcasts/pc_#{id}/pc_#{id}.mp3"
        File.read(File.join(path[0..-8],"post.textile")) =~ /h2.*?\n(.*)/m
        post = RedCloth.new($1.to_s).to_s
        xml.item do
          xml.title title
          xml.description post
          xml.pubDate date
          xml.enclosure nil, :length => "42130414", 
          	          :url => mp3_path, 
          		  :type => "audio/mpeg" 
          xml.link podcast_path
          xml.guid podcast_path
        end
      end
    end
  end 
  cache rss
end


get '/info' do
  cache haml :info
end
  
get '/podcast/:id' do
  @id = params[:id].size < 4 ? "0"*(4-params[:id].size)+params[:id] : params[:id] 
  if File.directory?(podcasts_path=File.join(File.dirname(__FILE__), 'public', 'podcasts', "pc_#{@id}"))
    @post          = RedCloth.new(File.read(File.join(podcasts_path,"post.textile"))).to_html
    @mp3_path      = "/podcasts/pc_#{@id}/pc_#{@id}.mp3"
    @player_html   = "<embed height='27' width='378' flashvars='playerMode=embedded' wmode='window' 
                        bgcolor='#ffffff' quality='best' allowscriptaccess='never' type='application/x-shockwave-flash'
                        src='http://www.google.com/reader/ui/3523697345-audio-player.swf?audioUrl=#{request.script_name + @mp3_path}' />"
    #@player_html   = "<object width=\"378\" height=\"24\" type=\"application/x-shockwave-flash\" name=\"pod_audio_1\" style=\"outline: medium none; visibility: visible;\" data=\"#{ url_for '/player.swf'}\" id=\"pod_audio_1\"><param name=\"bgcolor\" value=\"#FFFFFF\"><param name=\"wmode\" value=\"transparent\"><param name=\"menu\" value=\"false\"><param name=\"flashvars\" value=\"soundFile=#{url_for @mp3_path}&amp;playerID=pod_audio_1\"></object>"
    cache params[:clean] ? "clean" : haml(:pc_show)
  else
    "URL inválido!"
  end
end
