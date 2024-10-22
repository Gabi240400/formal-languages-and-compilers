require_relative 'tree_node'

class BST
  attr_accessor :root, :size
  def initialize()
    @root = nil
    @size = 0;
  end

  def insert(value)
    if @root == nil
      @root = TreeNode.new(value)
    else
      curr_node = @root
      previous_node = @root
      #while loop helps finding the position of insertion
      while curr_node != nil
        previous_node = curr_node
        if value < curr_node.value
          curr_node = curr_node.left
        else
          curr_node = curr_node.right
        end
      end
      if value < previous_node.value
        previous_node.left = TreeNode.new(value)
      else
        previous_node.right = TreeNode.new(value)
      end
    end
    @size += 1
  end

  def contains?(value, node = self.root)
    if node == nil
      return false
    elsif value < node.value
      return contains?(value, node.left)
    elsif value > node.value
      return contains?(value, node.right)
    else
      return true
    end
  end

  def find_parent_and_sibling(node = self.root, val, parent: -1, sibling: nil)
    return if node == nil
    if node.value == val && sibling
      return [parent, sibling.value]
    elsif node.value == val
      return [parent, -1]
    else
      p1 = find_parent_and_sibling(node.left, val, parent: node.value, sibling: node.right)
      p2 = find_parent_and_sibling(node.right, val, parent: node.value, sibling: node.left)
      return p1 if p1
      return p2
    end
  end

  def find_sibling(node = self.root, val)
    return nil if node == nil || node.value == val
  end
end
