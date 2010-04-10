require 'rubygems'
require 'sinatra'
require 'active_support'
require 'redcloth'

get '/' do
  id = File.readlines(Dir[File.join(File.dirname(__FILE__), 'public', 'podcasts','*','details')].last).first
  redirect "/podcast/#{id}"
end

get '/todos' do
  @months   = []
  @podcasts = {}
  Dir[File.join(File.dirname(__FILE__), 'public', 'podcasts','*','details')].each do |path|
    details = File.readlines(path)
    month = details.last
    unless @podcasts[month]
      @months << month
      @podcasts[month] = []
    end
    @podcasts[month] << [details[1],"/podcast/#{details[0]}"]
  end
  haml :list
end

get '/info' do
  haml :info
end
  
get '/podcast/:id' do
  @id = params[:id].size < 4 ? "0"*(4-params[:id].size)+params[:id] : params[:id] 
  if File.directory?(podcasts_path=File.join(File.dirname(__FILE__), 'public', 'podcasts', "pc_#{@id}"))
    @post          = RedCloth.new(File.read(File.join(podcasts_path,"post.textile"))).to_html
    @mp3_path      = "/podcasts/pc_#{@id}/pc_#{@id}.mp3"
    @player_html   = "<embed height='27' width='400' flashvars='playerMode=embedded' wmode='window' 
                        bgcolor='#ffffff' quality='best' allowscriptaccess='never' type='application/x-shockwave-flash'
                        src='http://www.google.com/reader/ui/3247397568-audio-player.swf?audioUrl=#{request.script_name + @mp3_path}' />"
    params[:clean] ? "clean" : haml(:pc_show)
  else
    "URL inválido!"
  end
end
