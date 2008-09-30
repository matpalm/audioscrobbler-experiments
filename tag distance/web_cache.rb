require 'open-uri'
require 'cgi'

class WebCache	

	def cache_dir(type)
		"../_cache/#{type}"
	end
	
	def initialize()		
		['similiar', 'toptags'].each do |type|						
			FileUtils.mkdir_p(cache_dir(type))
		end	
	end
	
	def tags_for_artist(artist)
		data_for(artist, 'toptags')
	end
	
	def similiar_artists(artist) 
		data_for(artist, 'similar')
	end
	
	private
		
	def data_for(artist, type) 		
		filename = "#{cache_dir(type)}/#{artist}.xml".gsub(/[:*?"&<>]/,'')
		if File.exists? filename		
			puts "artist:#{type}: #{artist}  [web cache hit]"
			return IO.read(filename) 
		else
			uri = "http://ws.audioscrobbler.com/1.0/artist/#{CGI.escape(artist.to_s).gsub('%26','%2526')}/#{type}.xml"			
			begin
				puts "artist: #{artist} [web cache miss]"
				dloaded = open(uri).read
				File.open(filename,'w') {|f| f.write(dloaded) }
				#sleep 3 # 1/sec per hr or lockdown!!!
				return dloaded
			rescue OpenURI::HTTPError
				# problem with amp? 
				$stderr.puts "problem dloading #{uri} #{$!}"
				return ""
			end
		end			
	end	
	
end