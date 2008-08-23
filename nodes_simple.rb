require 'node'
class Nodes
	
	def initialize()
		@cached = {}		
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
		case id
			when :s
				Node.new(:s, [[:u,10],[:x,5]])
			when :x
				Node.new(:x, [[:u,3],[:v,9],[:y,2]])
			when :y
				Node.new(:y, [[:s,7],[:v,6]])
			when :u
				Node.new(:u, [[:x,2],[:v,1]])				
			when :v
				Node.new(:v, [[:y,4]])				
			else
				raise "unknown node! #{id}"
		end	
	end

end