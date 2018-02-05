# This is a CompleteMe class
require_relative 'node'
require 'pry'
class CompleteMe
  attr_reader :head
  def initialize
    @head = Node.new(nil)
  end

  def insert(word)
    if find_node(word) == 'Node does not exist.'
      build_branch(word)
    else
      find_node(word).word = true
    end
  end

  def build_branch(word, node = @head)
    length = word.chars.length
    letter = word.chars.first
    unless node.children[letter]
      node.children[letter] = create_node(letter, length)
    end
    return if length == 1
    build_branch(word[1..-1], node.children[letter])
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

  def populate(dictionary)
    dictionary = dictionary.split("\n")
    dictionary.each do |word|
      insert(word.strip)
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

  def suggest(word, prefix = word, suggestion_array = [])
    node = find_node(word)
    if node == 'Node does not exist.'
      []
    else
      suggestion_array.push word if node.word?
      node.children.each_key do |letter|
        suggest(word + letter, prefix, suggestion_array)
      end
      suggestion_sorter(suggestion_array.uniq, prefix)
    end
  end

  def suggestion_sorter(suggestion, prefix)
    weights = suggestion.map do |item|
      find_node(item).weight_holder[prefix] || 0
    end

    sorted = suggestion.zip(weights).to_h
    sorted = sorted.sort_by { |_k, v| -v }.flatten!
    sorted.select { |item| item.is_a?(String) }
  end

  def select(prefix, desired)
    return 'Invalid combination.' if find_node(desired).is_a?(String)
    word = find_node(desired)
    if word.weight_holder[prefix].nil?
      word.weight_holder[prefix] = 1
    else
      word.weight_holder[prefix] += 1
    end
  end

  def delete(word)
    node = find_node(word)
    if node.class == String
      node
    else
      node.word = false
      prune(node, word)
    end
  end

  def prune(node, word)
    parent_node = find_node(word[0..-2])
    return unless parent_node.children[word[-1]].children.empty? && !node.word?
    parent_node.children.clear
    prune(parent_node, word[0..-2])
  end
end
