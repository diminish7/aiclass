require File.join(File.dirname(__FILE__), '../../lib/astar/graph')

describe Graph do
  before do
    # BUILD THE GRAPH FROM THE LECTURE
    @arad = Node.new(366)
    @zerind = Node.new(374)
    @sibiu = Node.new(253)
    @timisoara = Node.new(329)
    @oradea = Node.new(380)
    @fagaras = Node.new(176)
    @lugoj = Node.new(244)
    @mehadia = Node.new(241)
    @drobeta = Node.new(242)
    @craiova = Node.new(160)
    @rimnicu_vilcea = Node.new(193)
    @pitesti = Node.new(100)
    @bucharest = Node.new(0)
    
    @arad.add_edge(@zerind, 75)
    @arad.add_edge(@sibiu, 140)
    @arad.add_edge(@timisoara, 118)
    
    @zerind.add_edge(@oradea, 71)
    @zerind.add_edge(@arad, 75)
    
    @sibiu.add_edge(@oradea, 151)
    @sibiu.add_edge(@arad, 140)
    @sibiu.add_edge(@fagaras, 99)
    @sibiu.add_edge(@rimnicu_vilcea, 80)
    
    @timisoara.add_edge(@arad, 118)
    @timisoara.add_edge(@lugoj, 111)
    
    @oradea.add_edge(@zerind, 71)
    @oradea.add_edge(@sibiu, 151)
    
    @fagaras.add_edge(@sibiu, 99)
    @fagaras.add_edge(@bucharest, 211)
    
    @lugoj.add_edge(@timisoara, 111)
    @lugoj.add_edge(@mehadia, 70)
    
    @mehadia.add_edge(@lugoj, 70)
    @mehadia.add_edge(@drobeta, 75)
    
    @drobeta.add_edge(@mehadia, 75)
    @drobeta.add_edge(@craiova, 120)
    
    @craiova.add_edge(@drobeta, 120)
    @craiova.add_edge(@rimnicu_vilcea, 146)
    @craiova.add_edge(@pitesti, 138)
    
    @rimnicu_vilcea.add_edge(@sibiu, 80)
    @rimnicu_vilcea.add_edge(@craiova, 146)
    @rimnicu_vilcea.add_edge(@pitesti, 100)
    
    @pitesti.add_edge(@rimnicu_vilcea, 97)
    @pitesti.add_edge(@craiova, 138)
    @pitesti.add_edge(@bucharest, 101)
    
    @bucharest.add_edge(@pitesti, 101)
    @bucharest.add_edge(@fagaras, 211)
    
    @graph = Graph.new(@arad, @bucharest)
  end
  
  describe "#initialize" do
    it "should start in an :exploring state" do
      @graph.should be_exploring
    end
    it "should start with an empty explored set" do
      @graph.explored.should be_empty
    end
  end
  
  describe "states" do
    it "should read the state correctly" do
      Graph::VALID_STATES.each do |state|
        @graph.instance_variable_set("@state", state)
        @graph.send("#{state}?").should be_true
        other_states = Graph::VALID_STATES - [state]
        other_states.each do |other_state|
          @graph.send("#{other_state}?").should be_false
        end
      end
    end
    
    it "should set the state correctly" do
      @graph.fail!
      @graph.failed?.should be_true
      @graph.exploring?.should be_false
      @graph.succeeded?.should be_false
      @graph.succeed!
      @graph.failed?.should be_false
      @graph.exploring?.should be_false
      @graph.succeeded?.should be_true
    end    
  end
  
  describe "#explore!" do
    it "should find the correct path" do
      @graph.explore!.should be_true
      @graph.succeeded?.should be_true
      path = @graph.selected_path
      # Follow the path (Arad -> Sibiu -> Rimnicu Vilcea -> Pitesti -> Bucharest):
      index = 0
      [[@arad, @sibiu], [@sibiu, @rimnicu_vilcea], [@rimnicu_vilcea, @pitesti], [@pitesti, @bucharest]].each do |parent, node|
        edge = path[index]
        edge.parent.should == parent
        edge.node.should == node
        index += 1
      end
      path.collect { |edge| edge.cost }.sum.should == 418
    end
  end
end