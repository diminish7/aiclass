# A node in a graph or tree
class Node
  attr_reader :name, :h, :edges
  attr_accessor :path
  
  # h: The heuristic cost (e.g. crow-fly distance to destination)
  # edges: The edges of the graph leaving this node
  def initialize(name, h, edges=[])
    @name = name
    @h = h
    @edges = edges
    @path = [] # Path to get here
  end
  
  def add_edge(node, cost)
    @edges << Edge.new(self, node, cost)
  end
  
  # Cost to get here (sum of costs of edges in path to here)
  def cost
    @path.inject(0) { |cost, edge| cost += edge.cost }
  end
  
  # Sum of cost plus heuristic
  def estimated_cost
    @h + cost
  end
  
  def inspect
    "#<Node:#{object_id} @name=\"#{@name}\" @estimated_cost=\"#{estimated_cost}\">"
  end
end