# A directed edge connecting two nodes
class Edge
  attr_reader :parent, :node, :cost
  
  # parent: The node that is the starting point of the edge
  # node: The node that is at the end of the edge
  # cost: The cost to traverse the edge
  def initialize(parent, node, cost)
    @parent = parent
    @node = node
    @cost = cost
  end
  
  def inspect
    "#<Edge:#{object_id}>"
  end
  
end