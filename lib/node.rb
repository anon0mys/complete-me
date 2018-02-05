# This is a node.
class Node
  attr_reader :letter
  attr_accessor :children, :word, :weight_holder
  def initialize(letter, word = false)
    @letter = letter
    @children = {}
    @word = word
    @weight_holder = {}
  end

  def inspect
    @letter.to_s
  end

  def word?
    @word
  end
end
