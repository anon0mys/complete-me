
# This is a node.
class Node
  def initialize(letter, word = false)
    @letter = letter
    @word = word
  end

  def inspect
    "#{@letter}"
  end

  def word?
    @word
  end
end
