require 'dot_writer'

class VisitedGraphWriter < DotWriter
	
	def initialize(filename)
		@dot_file = File.open(filename,'w')			
		@dot_file.write preamble
		@flush_freq = 0
	end
	
	def flush_if_required
		@flush_freq +=1
		if @flush_freq > 20
			@dot_file.flush
			@flush_freq = 0
		end
	end
	
	def new_edge(from, to)			
		@dot_file. write %Q{"#{from.name}" -> "#{to.name}" [label="} + sprintf("%.2f",from.weight_to_node(to)) + '"];' + "\n"	
		flush_if_required
	end
	
	def close
		@dot_file.write postfix
		@dot_file.close
	end
	
end