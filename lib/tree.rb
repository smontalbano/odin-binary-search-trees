# frozen_string_literal: true

require_relative 'node'

class Tree
  def initialize(arr)
    @root = build_tree(arr.uniq.sort)
  end

  def build_tree(arr)
    return nil if arr.empty?

    mid = arr.length / 2

    node = Node.new(arr[mid])

    node.left = build_tree(arr[0...(mid)])
    node.right = build_tree(arr[mid + 1..])

    node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(val, root = @root)
    if root.nil?
      root = Node.new(val)
    elsif root.data == val
      return root
    elsif root.data > val
      root.left = insert(val, root.left)
    else
      root.right = insert(val, root.right)
    end
    root
  end

  def delete(val, root = @root)
    if root.nil?
      root
    elsif val < root.data
      root.left = delete(val, root.left)
    elsif val > root.data
      root.right = delete(val, root.right)
    elsif root.left.nil?
      return root.right
    elsif root.right.nil?
      return root.left
    else
      succ = get_succ(root.right)
      root.data = succ.data
      root.right = delete(succ.data, root.right)
    end
    root
  end

  def find(val, root = @root)
    return nil if root.nil?

    if root.data > val
      root = find(val, root.left)
    elsif root.data < val
      root = find(val, root.right)
    else
      root
    end   
  end

  def level_order
    queue = [@root]
    result = []

    until queue.empty?
      current = queue.shift
      
      if block_given?
        yield(current)
      else
        result << current.data
      end

      queue << current.left unless current.left.nil?
      queue << current.right unless current.right.nil?
    end
    result unless block_given?
  end

  def preorder(root = @root, arr = [], &block)
    return if root.nil?

    if block_given?
      yield(root)
    else
      arr << root.data
    end

    preorder(root.left, arr, &block)
    preorder(root.right, arr, &block)

    arr unless block_given?
    
  end

  def inorder(root = @root, arr = [], &block)
    return if root.nil?

    inorder(root.left, arr, &block)

    if block_given?
      yield(root)
    else
      arr << root.data
    end

    inorder(root.right, arr, &block)
    
    arr unless block_given?
  end

  def postorder(root = @root, arr = [], &block)
    
    return if root.nil?

    postorder(root.left, arr, &block)
    postorder(root.right, arr, &block)

    if block_given?
      yield(root)
    else
      arr << root.data
    end

    arr unless block_given?
  end

  def height(root = @root)
    return -1 if root.nil?

    [height(root.left), height(root.right)].max + 1
  end

  def depth(node, root = @root)
    return -1 if root.nil?
    
    depth = -1
    if root.data == node.data
      return depth + 1
    end
    depth = depth(node, root.left)
    if depth >= 0
      return depth + 1
    end
    depth = depth(node, root.right)
    if depth >= 0
      return depth + 1
    end
    depth
  end

  def balanced?(root = @root)
    return true if root.nil?

    left = height(root.left)
    right = height(root.right)

    if (left - right).abs <= 1 && balanced?(root.left) == true && balanced?(root.right) == true
      return true
    end
    return false
  end

  def rebalance
    @root = build_tree(inorder.uniq.sort)
  end

  private

  def get_succ(current)
    while !current.nil? && !current.left.nil?
      current = current.left
    end
    current
  end
end
