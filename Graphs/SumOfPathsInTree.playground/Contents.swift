class Tree<T> {
    class Node<T> {
        let value: T
        var left: Node<T>?
        var right: Node<T>?

        init(_ value: T) {
            self.value = value
        }
    }

    var root: Node<T>?

    init() {
        // Start new empty tree
    }
}

extension Tree where T == Int { // Numeric?
    func sumOfPaths(with size: T) -> Int {
        guard let root = root else { return 0 }

        var lookup = [T: Int]()

        return root.sumOfPaths(with: size, current: 0, &lookup)
    }
}

extension Tree.Node where T == Int {
    func sumOfPaths(with size: T, current sum: T, _ lookup: UnsafeMutablePointer<[T: Int]>) -> Int {
        var total = 0
        let sum = sum + value
        let current = sum - size // fill

        if current == 0 {
            total += 1
        }

        if let counts = lookup.pointee[current] {
            total += counts
        }

        lookup.pointee.increment(at: sum)

        total += left?.sumOfPaths(with: size, current: sum, lookup) ?? 0
        total += right?.sumOfPaths(with: size, current: sum, lookup) ?? 0

        lookup.pointee.decrement(at: sum)

        return total
    }
}

extension Dictionary where Value == Int {
    subscript (default key: Key) -> Value {
        return self[key] ?? 0
    }

    mutating func increment(at key: Key) {
        if let current = self[key] {
            self[key] = current + 1
        } else {
            self[key] = 1
        }
    }

    mutating func decrement(at key: Key) {
        if let current = self[key], current > 1 {
            self[key] = current - 1
        } else {
            self.removeValue(forKey: key)
        }
    }
}

let tree = Tree<Int>()

let values = [1,1,1,-7,5,3,8,2,-2,3]
let nodes = values.map { Tree<Int>.Node($0) }

tree.root                               = nodes[0]
tree.root?.left                         = nodes[1]
tree.root?.left?.left                   = nodes[2]
tree.root?.left?.right                  = nodes[3]
tree.root?.left?.right?.left            = nodes[4]
tree.root?.left?.right?.left?.right     = nodes[5]
tree.root?.left?.right?.right           = nodes[6]
tree.root?.right                        = nodes[7]
tree.root?.right?.right                 = nodes[8]
tree.root?.right?.right?.right          = nodes[9]

tree.sumOfPaths(with: 3) // 7


print(#line)
