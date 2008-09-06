require 'node'
require 'web_cache'
require 'rubygems'
require 'hpricot'

class Nodes
	attr_reader :cached
	
	def initialize()
		@cached = {}
		@web_cache = WebCache.new()		
	end

	def get_node(id)
		return @cached[id] if @cached[id]
		@cached[id] = new_node(id)
	end

	def get_nodes(ids)
		ids.collect { |id| get_node(id) }
	end

	def visited(id) 
		id = id.name if id.is_a? Node
		return false unless @cached[id]
		return @cached[id].visited
	end
	
	def new_node(id)
		edges = []		
		doc= Hpricot(@web_cache.data_for(id))
		(doc/'artist').each do |elem|
			name = (elem/'name').inner_text.downcase.to_sym
			match = (elem/'match').inner_text.to_f
			edges << [name,101-match]
		end
		Node.new(id, edges)
	end

end