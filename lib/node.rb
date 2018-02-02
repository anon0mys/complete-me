# This is a node.
class Node
  def initialize(letter, word = false)
    @letter = letter
    @word = word
  end

  def inspect
    @letter.to_s
  end

  def word?
    @word
  end
end