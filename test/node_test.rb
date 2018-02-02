<<<<<<< HEAD
<<<<<<< HEAD
require_relative 'test_helper'
=======
require_relative 'test_helper.rb'
>>>>>>> master
=======
require_relative 'test_helper'
>>>>>>> 68da9486e317e6b826612ee9da1cf7da51305760
require './lib/node'

class NodeTest < Minitest::Test
  def test_node_exists
    node = Node.new('a')

    assert_instance_of Node, node
  end
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 68da9486e317e6b826612ee9da1cf7da51305760

  def test_node_word_method
    node = Node.new('s')

    refute node.word?

    node = Node.new('s', true)

    assert node.word?
  end

  def test_node_inspect_displays_letter
    node = Node.new('x')

    assert_equal 'x', node.inspect
  end
<<<<<<< HEAD
=======
>>>>>>> master
=======
>>>>>>> 68da9486e317e6b826612ee9da1cf7da51305760
end
