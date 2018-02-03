require_relative 'test_helper'
require './lib/completeme'

class CompleteMeTest < MiniTest::Test
  def test_completion_tree_exists
    completion = CompleteMe.new
    assert_instance_of CompleteMe, completion
  end

  def test_completion_initializes_with_head
    completion = CompleteMe.new

    assert_instance_of Node, completion.head
  end

  def test_completion_can_insert_node_on_head
    completion = CompleteMe.new
    completion.insert('p')

    assert_instance_of Node, completion.head.children['p']
  end

  def test_can_insert_letter
    completion = CompleteMe.new
    completion.insert('p')

    assert completion.head.children.keys.include?('p')
    assert_equal 'p', completion.head.children['p'].letter
  end

  def test_can_insert_word
    completion = CompleteMe.new
    completion.insert('pizza')

    assert completion.head.children.keys.include?('p')
    assert completion.head.children['p'].children.keys.include?('i')
    assert completion.head
                     .children['p']
                     .children['i']
                     .children['z']
                     .children['z']
                     .children.keys.include?('a')
  end

  def test_can_insert_a_different_word
    completion = CompleteMe.new
    completion.insert('pizza')
    completion.insert('pize')

    assert_equal %w[p], completion.head.children.keys
    assert_equal %w[z e], completion.head
                                    .children['p']
                                    .children['i']
                                    .children['z']
                                    .children.keys
  end
end
