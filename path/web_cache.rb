require 'open-uri'
require 'cgi'

class WebCache
	@@CACHE_DIR = '_cache'
	
	def initialize()		
#		FileUtils.mkdir_p(@@CACHE_DIR)
	end
	
	def data_for(artist) 
		filename = "#{@@CACHE_DIR}/#{artist}.xml".gsub(/[:*?"&<>]/,'')
		if File.exists? filename		
			puts "artist: #{artist} [web cache hit]"
			IO.read(filename) 
		else
			uri = "http://ws.audioscrobbler.com/1.0/artist/#{CGI.escape(artist.to_s).gsub('%26','%2526')}/similar.xml"			
			begin
				puts "artist: #{artist} [web cache miss]"
				dloaded = open(uri).read
				File.open(filename,'w') {|f| f.write(dloaded) }			
				sleep 3 # audioscrobbler allows 1 hit/sec so be nice!
				return dloaded
			rescue
				$stderr.puts "problem dloading #{uri} #{$!}"
				''
			end
		end			
	end	
	
end
