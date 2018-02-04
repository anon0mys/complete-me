# This is a CompleteMe class
require_relative 'node'
require 'pry'
class CompleteMe
  attr_reader :head
  def initialize
    @head = Node.new(nil)
  end

  def insert(word, node = @head)
    length = word.chars.length
    letter = word.chars.first
    unless node.children[letter]
      node.children[letter] = create_node(letter, length)
    end
    return nil if length == 1
    insert(word[1..-1], node.children[letter])
  end

  def create_node(letter, length)
    if length == 1
      Node.new(letter, true)
    else
      Node.new(letter)
    end
  end

  def find_node(word)
    ptr = head
    word.chars.each do |char|
      ptr = ptr.children[char] unless ptr.nil?
    end

    if ptr.nil?
      'Node does not exist.'
    else
      ptr
    end
  end

  def count(starting_point = @head, total_words = [])
    total_words.push(1) if starting_point.word?
    unless starting_point.children.keys[0].nil?
      starting_point.children.each_value do |child|
        count(child, total_words)
      end
    end
    total_words.count
  end

  def suggest(word, suggestion_array = [])
    node = find_node(word)
    if node == 'Node does not exist.'
      []
    else
      suggestion_array.push word if node.word?
      node.children.each_key do |letter|
        suggest(word + letter, suggestion_array)
      end
      suggestion_array.uniq
    end
  end
end
