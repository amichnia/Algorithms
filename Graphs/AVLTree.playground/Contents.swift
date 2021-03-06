
class AVLTree<T: Comparable> {
    var root: Node<T>?
    var height: Int { return root?.height ?? 0 }

    init() { }

    func insert(_ value: T) {
        print("=== INS: \(value) ================================================================== ")
        self.root = root?.insert(value) ?? Node(value)
        self.root?.printNode(indent: 0)
    }
}

class Node<T: Comparable> {
    typealias Subtree = Node<T>

    // Which of subtrees is bigger
    enum Balance {
        case equal
        case leftBigger
        case rightBigger
    }

    var left: Subtree?
    var right: Subtree?

    let value: T
    var height = 1

    private var isBalanced: Bool {
        return Swift.abs((left?.height ?? 0) - (right?.height ?? 0)) <= 1
    }
    private var balance: Balance {
        let left = self.left?.height ?? 0
        let right = self.right?.height ?? 0
        switch left - right {
        case let n where n > 0: return .leftBigger
        case let n where n < 0: return .rightBigger
        default: return .equal
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func insert(_ value: T) -> Subtree {
        if value < self.value {
            left = left?.insert(value) ?? Node(value)
        } else {
            right = right?.insert(value) ?? Node(value)
        }

        updateHeight()

        return rebalanced()
    }

    private func updateHeight() {
        height = 1 + Swift.max(left?.height ?? 0, right?.height ?? 0)
    }

    private func rebalanced() -> Subtree {
        defer {
            self.updateHeight()
        }

        guard !isBalanced else { return self }

        switch (balance, left?.balance ?? .equal, right?.balance ?? .equal) {
        case (.leftBigger, .rightBigger, _):
            self.left = left?.rotatedLeft()
            return rotatedRight()
        case (.leftBigger, _, _):
            return rotatedRight()
        case (.rightBigger, _, .leftBigger):
            right = right?.rotatedRight()
            print("case RL for \(value)")
            return rotatedLeft()
        case (.rightBigger, _, _):
            print("case RR for \(value)")
            return rotatedLeft()
        default:
            // This might indicate failure
            assertionFailure("Should ont be here?")
            return self
        }
    }

    private func rotatedRight() -> Subtree {
        guard let left = self.left else {
            return self
        }
        defer {
            self.updateHeight()
            left.updateHeight()
        }
        self.left = left.right
        left.right = self
        return left
    }

    private func rotatedLeft() -> Subtree {
        guard let right = self.right else {
            return self
        }
        defer {
            self.updateHeight()
            right.updateHeight()
        }
        self.right = right.left
        right.left = self
        return right
    }

    func printNode(indent: Int) {
        let indentString = (0...indent).map { _ in return  "\t" }.joined()
        right?.printNode(indent: indent + 1)
        print("\(indentString)\(value)")
        left?.printNode(indent: indent + 1)
    }
}

let tree = AVLTree<Int>()

tree.insert(9)
tree.insert(3)
tree.insert(2)

tree.insert(8)
tree.insert(7)
tree.insert(6)

tree.insert(5)
tree.insert(4)
tree.insert(1)
tree.insert(0)

tree.insert(9)
tree.insert(3)
tree.insert(2)

tree.insert(8)
tree.insert(7)
tree.insert(6)

tree.insert(5)
tree.insert(4)
tree.insert(1)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(0)
tree.insert(10)

tree.insert(11)
tree.insert(12)
tree.insert(13)
tree.insert(14)
tree.insert(15)
tree.insert(16)
tree.insert(17)
tree.insert(18)
