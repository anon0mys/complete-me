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

  def count(starting_point = @head, total_words = 0)
    total_words += 1 if starting_point.word?
    binding.pry
    if !starting_point.children.empty?
      count(starting_point.children.values[0], total_words)
    end
    total_words
  end
end

completion = CompleteMe.new
completion.insert('pizza')
binding.pry
