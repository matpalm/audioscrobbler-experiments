require 'dot_writer'

class ShortestPathWriter < DotWriter
	
	def initialize(shortest)
		@shortest = shortest
	end
	
	def dot_edge(from, to)
		%Q{"#{from.name}" -> "#{to.name}" [label="} + sprintf("%.2f",from.weight_to_node(to)) + '"];' + "\n"	
	end
	
	def write_to(filename)
		File.open(filename,'w') do |f| 
			f.write preamble
			node = @shortest.get_node(@shortest.to)
			node_from = @shortest.get_node(@shortest.from)
			last = nil
			while node != node_from	
				f.write dot_edge(node, last) + "\n" if last
				last = node
				node = node.last_node			
			end
			f.write dot_edge(node, last)
			f.write postfix
		end		
	end

end