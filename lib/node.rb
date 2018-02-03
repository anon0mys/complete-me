# This is a node.
class Node
  attr_reader :letter
  attr_accessor :children
  def initialize(letter, word = false)
    @letter = letter
    @children = Hash.new
    @word = word
  end

  def inspect
    @letter.to_s
  end

  def word?
    @word
  end
end
