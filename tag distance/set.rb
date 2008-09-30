class Set
	def initialize
		@set={}
	end
	def add(values)
		values.each {|v| @set[v]=nil }
	end
	def values
		@set.keys
	end
end