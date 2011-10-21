require 'set'
require File.join(File.dirname(__FILE__), 'edge')
require File.join(File.dirname(__FILE__), 'node')

# A graph
class Graph
  VALID_STATES = [:exploring, :failed, :succeeded]
  attr_reader :starting_node, :goal_node, :selected_path, :explored
  
  def initialize(starting_node, goal_node)
    @starting_node = starting_node
    @goal_node = goal_node
    @frontier = Set.new([@starting_node])
    @explored = Set.new
    @selected_path = nil
    @state = :exploring # :exploring, :failed, :successed
  end
  
  # Explore the graph in search of the goal node
  def explore!
    expand_frontier while exploring?
    succeeded?
  end
  
  # State queries and changes
  def exploring?
    @state == :exploring
  end
    
  def failed?
    @state == :failed
  end
  
  def fail!
    @state = :failed
  end
  
  def succeeded?
    @state == :succeeded
  end
  
  def succeed!
    @state = :succeeded
  end
  
  def inspect
    "#<Graph:#{object_id}>"
  end
  
protected
  # Find the node in the frontier with the least estimated cost and explore it
  def expand_frontier
    # Find the next node in the frontier to look at
    to_explore = nil
    @frontier.each do |node|
      # Skip nodes we've seen before
      next if @explored.include?(node)
      # Explore the node with the least estimated cost
      to_explore = node if (to_explore.nil? || node.estimated_cost < to_explore.estimated_cost)
    end
    if to_explore.nil?
      # We didn't find anything, and there's nothing else to explore. Fail.
      fail!
    else
      # Explore it
      explore_node(to_explore)
    end
  end
  
  # Explore a node, adding the nodes it is connected to to the frontier
  def explore_node(to_explore)
    # Remove it from the frontier and add it to explored
    @frontier.delete(to_explore)
    @explored << to_explore
    # If this is the goal, we win
    if to_explore == @goal_node
      @selected_path = to_explore.path
      succeed!
    else
      # Otherwise, explore its edges
      to_explore.edges.each do |edge|
        new_node = edge.node
        unless @explored.include?(new_node)
          # Set up the path to get here, then add it to the frontier
          new_node.path = to_explore.path + [edge]
          @frontier << new_node
        end
      end
    end
  end
end