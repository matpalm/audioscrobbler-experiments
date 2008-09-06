#!/usr/bin/env ruby
require 'yaml'

similiarities = YAML.load($stdin)

puts <<EOF
graph G {
graph [splines=true overlap=false]
EOF

# calc bidirectional edges
bidirectional = []
similiarities.keys.each do |a|
	similiarities[a].keys.each do |b|
		bidirectional << [a,b]  if similiarities[b] and similiarities[b][a] and a.to_s > b.to_s
	end
end

# remove one of bidirectional relations (average a->b and b->a weighting)
bidirectional.each do |a,b|
	a_b_weight = similiarities[a].delete(b)
	similiarities[b][a] = (similiarities[b][a] + a_b_weight ) /2
end

# output in dot format
similiarities.keys.each do |a|
	similiarities[a].keys.each do |b|
		print %Q{"#{a}" -- "#{b}" }
		#print "[len=#{Math.log10(101-similiarities[a][b])+1}]" # for edge length proportional to similiarity
		print ";\n"
	end
end

puts "}"
