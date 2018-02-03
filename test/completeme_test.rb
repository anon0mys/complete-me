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

  def test_last_letter_has_word_flag
    completion = CompleteMe.new
    completion.insert('pize')

    assert completion.head
                     .children['p']
                     .children['i']
                     .children['z']
                     .children['e']
                     .word?
  end

  def test_can_count_one_word
    completion = CompletMe.new
    completion.insert('pizza')

    assert_equal 1, completion.count
  end

  def test_can_count_multiple_words
    completion = CompleteMe.new
    completion.insert('pizza')
    copmletion.insert('pizzle')

    assert_equal 2, completion.count
  end

  def test_can_find_nodes
    completion = CompleteMe.new
    completion.insert('pizza')
    completion.insert('parlor')

    assert_equal 'p', completion.find_node('p').letter
    assert_equal 'z', completion.find_node('pizz').letter
    assert_equal 'o', completion.find_node('parlo').letter
    assert_equal 'r', completion.find_node('parlor').letter
    assert_equal 'Node does not exist.', completion.find_node('x')
  end

  def test_populate_method
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)

    assert_equal 'y', completion.find_node('party')
    assert completion.find_node('party').word?
    assert_equal 'o', completion.find_node('abstractio')
    refute completion.find_node('abstractio').word?
  end
end
