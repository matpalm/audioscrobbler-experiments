#!/usr/bin/ruby
require 'node'
require 'nodes'
require 'visited_graph_writer'
require 'shortest_path_writer'

class Shortest
	attr_reader :from, :to
	
	def initialize(from, to)
		@from = from
		@to = to		
		@nodes = Nodes.new()
		@edges_todo = []	
		@visited_graph = VisitedGraphWriter.new('visited_graph.dot')
	end
	
	def merge(edges_a, edges_b) 
		merged = []
		continue = ! (edges_a.empty? or edges_b.empty?)
		while continue do
			list_to_pop_from = edges_a.first[2] < edges_b.first[2] ? edges_a : edges_b
			merged << list_to_pop_from.shift
			continue = !list_to_pop_from.empty?
		end	
		merged += edges_a		
		merged += edges_b
		merged
	end

	def get_node(id)
		@nodes.get_node(id)
	end
	
	def next_edge_to_examine
		node_from_id, node_to_id, weight = @edges_todo.shift
		node_from, node_to = @nodes.get_nodes([node_from_id, node_to_id])
		[node_from, node_to, weight]
	end
		
	def prune_edges_already_visited edges
		edges.reject! { |from,to,weight| @nodes.visited(to) }
	end
	
	def process(max_tries)
		# bootstrap 
		node = get_node(@from)
		node.weight = 0	
		node.visit
		
		@edges_todo = node.outgoing_edges.clone
		found_target = false
	
		while ! (@edges_todo.empty? or found_target or max_tries==0)

			puts "#todo #{@edges_todo.length}"

			# pop next edge to handle
			node_from, node_to, weight = next_edge_to_examine
			
			# ignore if the node_to has already been visited
			if ! @nodes.visited(node_to)
				@visited_graph.new_edge(node_from, node_to)
				
				# set node back trace and weighting
				node_to.last_node = node_from
				node_to.weight = weight
				node_to.visit

				# combine next nodes edges with edges todo
				outgoing_edges = node_to.outgoing_edges.clone
				@edges_todo = merge(@edges_todo, outgoing_edges)
				prune_edges_already_visited @edges_todo
								
				# are we there yet?
				found_target = node_to.name == @to				
			end
			
			max_tries -= 1			
			$stdout.flush
		end
		
		@visited_graph.close
		return max_tries!=0
	end				
end

raise 'usage: shortest.rb from to max_steps' unless ARGV.length==3
from,to,max_steps = ARGV

shortest = Shortest.new(from.to_sym, to.to_sym)
path_found = shortest.process(max_steps.to_i)
puts "path #{'not ' unless path_found}found"

ShortestPathWriter.new(shortest).write_to('shortest_path.dot') if path_found




