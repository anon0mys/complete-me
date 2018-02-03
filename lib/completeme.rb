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
    node.children[letter] = Node.new(letter) unless node.children[letter]
    return nil unless letter_array.length.positive?
    insert(letter_array[1..-1].join, node.children[letter_array.first])
  end

  def find_node(word)
    ptr = self.head
  
    word.chars.each do |char|
      ptr = ptr.children[char]
    end
  
    unless ptr.nil?
      ptr
    else
      "Node does not exist."
    end
  end


end
