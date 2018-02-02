require_relative 'test_helper.rb'
require './lib/node'

class NodeTest < Minitest::Test

  def test_node_exists
    node = Node.new
    assert_instance_of Node, node
  end

end
