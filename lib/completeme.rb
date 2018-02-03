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
    insert_helper(letter_array.first, node)
    return nil unless letter_array.length.positive?
    insert(letter_array[1..-1].join, node.children[letter_array.first])
  end

  def insert_helper(letter, node)
    if node.children[letter]
      insert_helper(letter, node.children[letter])
    else
      node.children[letter] = Node.new(letter)
    end
  end
end
