class DotWriter
	
	def preamble
		"digraph G {\n" +
		"graph [splines=true overlap=false]\n" 
		#"graph [bgcolor=\"#00ff0000\"]\n"
	end
	
	def postfix
		'}'
	end
	
end