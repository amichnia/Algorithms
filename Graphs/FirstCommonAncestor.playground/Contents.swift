// When not having parent in node definition

class Tree<T> {
    class Node<T> {
        let value : T
        var left: Node<T>?
        var right: Node<T>?

        init(_ value: T) {
            self.value = value
        }
    }

    var root: Node<T>?

    init() {
        // Create empty graph
    }
}

extension Tree {
    func firstCommonAncestor(p: Tree.Node<T>, q: Tree.Node<T>) -> Tree.Node<T>? {
        guard p !== q else { return p } // Should I check when p is not in the tree?

        return root?.firstCommonAncestor(p: p, q: q)
    }
}

extension Tree.Node {
    func firstCommonAncestor(p: Tree.Node<T>, q: Tree.Node<T>) -> Tree.Node<T>? {
        return covers(p: p, q: q).ancestor
    }

    private enum Cover {
        case one
        case both
        case none
    }

    private func covers(p: Tree.Node<T>, q: Tree.Node<T>) -> (ancestor: Tree.Node<T>?, cover: Cover) {
        let leftResult = left?.covers(p: p, q: q) ?? (nil, .none)
        let rightResult = right?.covers(p: p, q: q) ?? (nil, .none)
        let selfResult = self === p || self === q

        // Early return if we already have found common ancestor in one of the subtrees
        if let common = leftResult.ancestor ?? rightResult.ancestor {
            return (ancestor: common, cover: .both)
        }

        // Check left and right coverage cases
        switch (leftResult.cover, rightResult.cover, selfResult) {
        // In distinc subtrees
        case (.one, .one,    _): return (ancestor: self, cover: .both)
        // P is ancesor of Q, or Q is ancestor of P
        case (.one,    _, true): return (ancestor: self, cover: .both)
        case (   _, .one, true): return (ancestor: self, cover: .both)
        // Either left or right is ancestor of one of them
        case (.one,    _,    _): return leftResult
        case (   _, .one,    _): return rightResult
        // Current node is p or q - covers one of them
        case (   _,    _, true): return (ancestor: nil, cover: .one)
        // Current subtree do not cover either p or q
        default: return (ancestor: nil, cover: .none)
        }
    }
}

let tree = Tree<Int>()

let nodes = (0...11).map { Tree<Int>.Node($0) }

tree.root = nodes[0]
tree.root?.left = nodes[1]
tree.root?.left?.left = nodes[3]
tree.root?.left?.left?.left = nodes[4]
tree.root?.left?.left?.right = nodes[5]
tree.root?.left?.left?.right?.left = nodes[6]
tree.root?.left?.right = nodes[7]

tree.root?.right = nodes[2]
tree.root?.right?.left = nodes[8]
tree.root?.right?.right = nodes[9]


tree.firstCommonAncestor(p: nodes[7], q: nodes[7])?.value
tree.firstCommonAncestor(p: nodes[4], q: nodes[5])?.value
tree.firstCommonAncestor(p: nodes[6], q: nodes[9])?.value
tree.firstCommonAncestor(p: nodes[6], q: nodes[1])?.value
tree.firstCommonAncestor(p: nodes[6], q: nodes[11])?.value
tree.firstCommonAncestor(p: nodes[11], q: nodes[11])?.value


print(#line)
