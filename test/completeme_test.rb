require_relative 'test_helper.rb'

class CompleteMeTest < MiniTest::Test
  def test_node_exists
    completion = CompleteMe.new
    assert_instance_of CompleteMe, completion
  end
end
