class Node
	
	attr_accessor :weight, :last_node
	attr_reader :outgoing_edges, :name, :visited
	
	def initialize(name,edges)		
		@name = name
		@outgoing_edges = edges.sort { |elem1, elem2| elem1[1] <=> elem2[1] }		
		@outgoing_edges.collect! { |e| [name,e[0],e[1]] }
		@visited = false
	end

	def weight_to_node(other_node)
		edge = @outgoing_edges.find { |elem| elem[1] ==other_node.name }
		weight + edge[2]
	end
	
	def visit
		@visited = true
	end
	
end