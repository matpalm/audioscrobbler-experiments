require 'artist'

class MultiDimScaling
	
	def process	
		
		artists_names = File.new('artists').readlines.collect! { |line| line.chomp.strip }
		#artists_names = ['cher', 'tina turner', 'donna summer']
		
		artists = artists_names.collect { |name| Artist.new(name) }

		uniq_tags_dedup = {}
		artists.each do |artist|						
			artist.coords.keys.each do |tag|				
				# stupid ppl who put \r\n in a tag!
				uniq_tags_dedup[tag] = nil unless !!(tag.to_s=~/\r/)
			end
		end
		uniq_tags = uniq_tags_dedup.keys

puts "#{uniq_tags.length}"
raise 'd'
				
		artists.each do |artist|
			row = []
			uniq_tags.each do |tag|
				if artist.coords.has_key? tag
					row << artist.coords[tag]
				else
					row << '0'
				end
			end
			puts row.join(',')
		end
	
	end
end

MultiDimScaling.new.process