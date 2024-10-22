class TreeNode
  attr_accessor :value, :left, :right
  #node is initialized with a value, and two children are nil
  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end
