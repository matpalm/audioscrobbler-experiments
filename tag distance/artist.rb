require 'web_cache'
require 'rubygems'
require 'hpricot'

class Artist	
	attr_reader :name
	@@web_cache = WebCache.new		
	
	def initialize(name)
		@name = name				
	end
	
	def coords
		return @coords if @coords
		coords = {}
		doc = Hpricot(@@web_cache.tags_for_artist(@name))
		(doc/'tag').each do |tag|
			name = (tag/'name').inner_text.downcase.to_sym
			count = (tag/'count').inner_text.to_i
			# audioscrobbler has tags, with count zero?
			coords[name] = count unless count==0
		end
		#coords.sort! { |a,b| a[0] <=> b[0] }		
		# coords.collect! { |e| [e[0].to_sym, e[1]] }		
		@coords = coords.freeze
	end
	
	def similiar_to
		return @edges if @edges
		edges = []		
		doc= Hpricot(@@web_cache.similiar_artists(@name))
		(doc/'artist')[0..19].each do |elem|
			name = (elem/'name').inner_text.downcase.to_sym	
			match = (elem/'match').inner_text.downcase.to_i
			edges << name #if match > 75
		end				
		@edges = edges.freeze
	end
	
end

