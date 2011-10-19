require File.join(File.dirname(__FILE__), '../../lib/astar/graph')

describe Node do
  before do
    @node1 = Node.new(9)
    @node2 = Node.new(7)
    @node3 = Node.new(3)
    @node1.add_edge(@node2, 4)
    @node2.add_edge(@node3, 3)
    @node2.path = [@node1.edges.first]
    @node3.path = [@node1.edges.first, @node2.edges.first]
  end
  
  describe "#cost" do
    it "should be the sum of the costs of edges" do
      @node1.cost.should be_zero
      @node2.cost.should == 4
      @node3.cost.should == 7
    end
  end
  
  describe "#estimated_cost" do
    it "should be the sum of the cost and h" do
      @node1.estimated_cost.should == 9
      @node2.estimated_cost.should == 11
      @node3.estimated_cost.should == 10
    end
  end
end