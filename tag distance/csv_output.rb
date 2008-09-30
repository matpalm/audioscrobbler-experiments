require 'artist'

class CsvOutput
	
	def process	
		
		artists_names = File.new('artists').readlines.collect! { |line| line.chomp.strip }
		#artists_names = ['bad religion','nofx','madonna','usher']
		
		artists = artists_names.collect { |name| Artist.new(name) }

		uniq_tags_dedup = {}
		artists.each do |artist|			
			artist.coords.keys.each do |tag|				
				# stupid ppl who put \r\n in a tag!
				uniq_tags_dedup[tag] = nil unless !!(tag.to_s=~/\r/)
			end
		end
		uniq_tags = uniq_tags_dedup.keys
		#puts "uniq keys #{uniq_tags.inspect}"
				
		puts ",#{artists_names.join(',')}"
		
		uniq_tags.each do |tag|
			row = [tag.to_s]
			artists.each do |artist|						
				if artist.coords.has_key? tag
					row << artist.coords[tag]
				else
					row << ''
				end
			end
			puts row.join(',')
		end
	
	end
end

CsvOutput.new.process