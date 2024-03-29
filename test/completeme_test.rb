require_relative 'test_helper'
require './lib/complete_me'

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
    assert completion.find_node('pizz').children.keys.include?('a')
  end

  def test_can_insert_a_different_word
    completion = CompleteMe.new
    completion.insert('pizza')
    completion.insert('pize')

    assert_equal %w[p], completion.head.children.keys
    assert_equal %w[z e], completion.find_node('piz').children.keys
  end

  def test_last_letter_has_word_flag
    completion = CompleteMe.new
    completion.insert('pize')

    assert completion.find_node('pize').word?
    refute completion.find_node('piz').word?
  end

  def test_can_insert_word_flag_on_existing_word
    completion = CompleteMe.new
    completion.insert('pickle')

    refute completion.find_node('pick').word?

    completion.insert('pick')

    assert completion.find_node('pick').word?
  end

  def test_can_count_one_word
    completion = CompleteMe.new
    completion.insert('pizza')

    assert_equal 1, completion.count
  end

  def test_can_count_multiple_words
    completion = CompleteMe.new
    completion.insert('pizza')
    completion.insert('pizzle')

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
    dictionary = File.read('/usr/share/dict/words')
    completion.populate(dictionary)

    assert_equal 'y', completion.find_node('party').letter
    assert completion.find_node('party').word?
    assert_equal 'o', completion.find_node('abstractio').letter
    refute completion.find_node('abstractio').word?
  end

  def test_suggest_method
    completion = CompleteMe.new
    completion.insert('the')
    completion.insert('there')
    completion.insert('territory')
    completion.insert('barnacle')

    assert_equal %w[the there territory], completion.suggest('t')
    assert_equal %w[the there], completion.suggest('th')
    assert_equal %w[barnacle], completion.suggest('barn')
    assert_equal [], completion.suggest('taxes')
  end

  def test_select_method
    completion = CompleteMe.new
    %w[pize pizza pizzeria pizzicato].each do |word|
      completion.insert(word)
    end

    3.times { completion.select('piz', 'pizzeria') }
    2.times { completion.select('pi', 'pizza') }
    completion.select('pi', 'pizzicato')

    assert_equal %w[pizzeria pize pizza pizzicato], completion.suggest('piz')
    assert_equal %w[pizza pizzicato pize pizzeria], completion.suggest('pi')
  end

  def test_removal_of_word_flag
    completion = CompleteMe.new
    %w[pie pizza pizzeria pick pickle].each do |word|
      completion.insert(word)
    end

    assert_equal 5, completion.count
    assert completion.find_node('pick').word?

    completion.delete('pick')

    assert_equal 4, completion.count
    refute completion.find_node('pick').word?
  end

  def test_pruning_of_tree_after_deletion
    completion = CompleteMe.new
    %w[pie pizza pizzeria pick pickle].each do |word|
      completion.insert(word)
    end
    completion.delete('pickle')

    assert_equal 'Node does not exist.', completion.delete('pickle')
    assert_equal 'Node does not exist.', completion.delete('pickl')
    assert_equal 'k', completion.find_node('pick').letter
    assert completion.find_node('pick').word?
  end

  def test_searching_for_words_via_substring
    completion = CompleteMe.new
    all_words = %w[complete completion incomplete intercom intercommunion]
    all_words.each do |word|
      completion.insert(word)
    end

    assert_equal completion.suggest_substring('com'), all_words
    assert_equal completion.suggest_substring('ple'), all_words[0..2]
    assert_equal completion.suggest_substring('nte'), all_words[3..4]
  end

  def test_can_insert_and_find_addresses
    completion = CompleteMe.new
    addresses = File.read('./addresses.txt')

    completion.populate(addresses)

    assert_equal ['5135 N Peoria St', '5135 N Perth Ct', '5135 N Perry St'],
                 completion.suggest('5135 N Pe')
    assert_equal [], completion.suggest('1122821 Imaginary Dr')
    assert_equal 8, completion.suggest('9999').size
  end
end
