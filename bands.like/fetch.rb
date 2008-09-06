#!/usr/bin/env ruby
require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'cgi'
require 'yaml'

class WebCache
	@@CACHE_DIR = 'cache'
	def initialize(minimum_match)
		@minimum_match = minimum_match
		Dir.mkdir(@@CACHE_DIR) unless File.exists? @@CACHE_DIR
	end

	def data_for(artist)
		filename = "#{@@CACHE_DIR}/#{artist}.xml"
		if File.exists? filename
			IO.read(filename)
		else
			uri = "http://ws.audioscrobbler.com/1.0/artist/#{CGI.escape(artist.to_s)}/similar.xml"
			begin
				dloaded = open(uri).read
				File.open(filename,'w') {|f| f.write(dloaded) }
				return dloaded
			rescue OpenURI::HTTPError
				# problem with amp?
				$stderr.puts "problem dloading #{uri} #{$!}"
				return ""
			end
		end
	end

	def fetch(artist)
		artists = []
		artist_similiarity = {}
		artists_elems = (Hpricot(data_for(artist))/'artist')
		above_minimum_match_level = true
		while above_minimum_match_level and not artists_elems.empty?
			elem = artists_elems.shift
			match = (elem/'match').inner_text.to_f
			if match > @minimum_match
				name = (elem/'name').inner_text.downcase.to_sym
				artists << name
				artist_similiarity[name] = match
			else
				above_minimum_match_level = false
			end
		end
		[artists, artist_similiarity]
	end

end

usage_message = 'usage: fetch.rb <artist> <minimum match (100=match none, 0=match all> <max to download>'
raise usage_message unless ARGV.length==3

bootstrap = ARGV[0]
minimum_match = ARGV[1].to_f
max_to_download = ARGV[2].to_i

web_cache = WebCache.new(minimum_match)
artist_similiarities = {}
artists_to_fetch = []
artists_to_fetch.push bootstrap.to_sym

number_downloaded = 1
while not artists_to_fetch.empty? and number_downloaded < max_to_download do
	artist = artists_to_fetch.shift
	$stderr.print "\r#{number_downloaded} #{artist}" + " "*60
	if not artist_similiarities.has_key? artist
		other_artists, artists_to_similiarity = web_cache.fetch(artist)
		artist_similiarities[artist] = artists_to_similiarity
		(artists_to_fetch.push other_artists).flatten!
		number_downloaded += 1
	end
end

$stderr.print "\rdone" + " "*60
puts YAML.dump(artist_similiarities)
