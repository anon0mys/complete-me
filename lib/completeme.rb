# This is a CompleteMe class
require_relative 'node'
require 'pry'
class CompleteMe
  attr_reader :head
  def initialize
    @head = Node.new(nil)
  end

  def insert(word, node = @head)
    letter_array = word.chars
    letter = letter_array.first
    unless node.children[letter]
      node.children[letter] = if letter_array.length == 1
                                Node.new(letter, true)
                              else
                                Node.new(letter)
                              end
    end
    return nil unless letter_array.length.positive?
    insert(letter_array[1..-1].join, node.children[letter_array.first])
  end

  def find_node(word)
    ptr = head
    word.chars.each do |char|
      ptr = ptr.children[char]
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
      count(starting_point.children.values[0], total_words)
    end
    total_words.count
  end
end
