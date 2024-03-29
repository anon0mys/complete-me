require_relative 'node'

# This is a CompleteMe class
class CompleteMe
  attr_reader :head
  def initialize
    @head = Node.new(nil)
  end

  def insert(word)
    if find_node(word).is_a?(String)
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
    Node.new(letter, length == 1)
  end

  def find_node(word, ptr = head)
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
    dictionary.each { |word| insert(word.strip) }
  end

  def count(starting_point = @head, total_words = [])
    total_words << 1 if starting_point.word?
    unless starting_point.children.empty?
      starting_point.children.each_value do |child|
        count(child, total_words)
      end
    end
    total_words.length
  end

  def suggest(word)
    nodes = case_desensitizer(word)
    return [] if nodes.empty?
    suggestions = nodes.map { |prefix, node| suffix_builder(prefix, node) }
    suggestions.flatten!
    suggestion_sorter(suggestions, word)
  end

  def case_desensitizer(word)
    nodes = {}
    unless find_node(word.downcase).is_a?(String)
      nodes[word.downcase] = find_node(word.downcase)
    end
    proper_word = word[0].upcase + word[1..-1]
    unless find_node(proper_word).is_a?(String)
      nodes[proper_word] = find_node(proper_word)
    end
    nodes
  end

  def suffix_builder(word, node, suggestion_array = [])
    suggestion_array << word if node.word?
    node.children.each do |letter, child|
      suffix_builder(word + letter, child, suggestion_array)
    end
    suggestion_array
  end

  def suggest_substring(substring, prefix = '', node = @head, matches = [])
    unless node.nil?
      node.children.each do |key, value|
        match = find_node(prefix + substring)
        matches << suggest(prefix + substring) if match.is_a?(Node)
        suggest_substring(substring, prefix + key, value, matches)
      end
    end
    matches.flatten.uniq
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
    word.weight_holder[prefix] = 0 if word.weight_holder[prefix].nil?
    word.weight_holder[prefix] += 1
  end

  def delete(word)
    node = find_node(word)
    if node.is_a?(String)
      node
    else
      node.word = false
      prune(word, node)
    end
  end

  def prune(word, node)
    parent_node = find_node(word[0..-2])
    child_node = parent_node.children[word[-1]]
    return if !child_node.children.empty? || child_node.word?
    parent_node.children.delete(word[-1])
    prune(word[0..-2], node)
  end
end
