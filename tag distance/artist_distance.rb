require 'artist_info'

class ArtistDistance
	
	def initialize(start,target)	
		@artist_info = ArtistInfo.new
		@start = start
		@target = target
	end
	
	def merge(edges_a, edges_b) 
		merged = []
		continue = ! (edges_a.empty? or edges_b.empty?)
		while continue do
			list_to_pop_from = edges_a.first[:dist] < edges_b.first[:dist] ? edges_a : edges_b
			merged << list_to_pop_from.shift
			continue = !list_to_pop_from.empty?
		end	
		merged += edges_a		
		merged += edges_b
		merged
	end
	
	def distance_between_artists(artist1, artist2)
		euclidean_distance(@artist_info.coords(artist1), @artist_info.coords(artist2))
	end
	
	def euclidean_distance(coords1, coords2)	
		dist = 0
		
		coords1.keys.each do |key|		
			if coords2.has_key? key
				diff = coords1[key] - coords2[key]
				dist += diff * diff
			else				
				dist += coords1[key] * coords1[key]
			end			
		end
		
		# need the keys in 2 not in 1
		keys2 = coords2.keys
		keys2.reject! { |key| coords1.keys.include? key }
		keys2.each do |key| 
			dist += coords2[key] * coords2[key]
		end
		
		Math.sqrt(dist)
	end
	
	def process		
		artist = @start
		similiar_artists = @artist_info.similiar_to(artist)
		puts "#{similiar_artists.inspect}"
		
		stack_additions = []
		stack_depth = 1
		similiar_artists.each_with_index do |similar_artist, idx|
			dist = distance_between_artists similar_artist, @target
			stack_additions << {:dist => dist, :depth => stack_depth, :from => artist, :to => similar_artist}
			puts "#{idx}/100 #{similar_artist} -> #{@target} = #{dist}"
		end
		
		stack_additions.sort! { |a,b| a[:dist]<=>b[:dist] }
		stack_additions.each {|e| puts e.inspect}
		
	end
end

ArtistDistance.new('celion dion', 'napalm death').process


