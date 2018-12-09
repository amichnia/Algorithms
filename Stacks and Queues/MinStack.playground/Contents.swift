protocol AnyStack {
    associatedtype T

    func push(_ value: T)
    func pop() -> T?
    func peek() -> T?
}

class Stack<T>: AnyStack {
    private class Node<T> {
        let value: T
        let next: Node<T>?

        init(_  value: T, next: Node<T>? = nil) {
            self.value = value
            self.next = next
        }
    }
    private var head: Node<T>?

    init() {
        // Initialize empty Stack
    }

    func push(_ value: T) {
        head = Node(value, next: head)
    }

    @discardableResult
    func pop() -> T? {
        defer { head = head?.next }
        return peek()
    }

    func peek() -> T? {
        return head?.value
    }
}

class MinStack<T: Comparable>: Stack<T> {
    private let minimums = Stack<T>()

    func minimum() -> T? {
        return minimums.peek()
    }

    override func push(_ value: T) {
        super.push(value)

        guard let currentMinimum = minimums.peek() else { return minimums.push(value) }
        guard value <= currentMinimum else { return }

        minimums.push(value)
    }

    @discardableResult
    override func pop() -> T? {
        let value = super.pop()

        guard let currentMinimum = minimums.peek() else { return value }
        guard let current = value, current <= currentMinimum else { return value }

        minimums.pop()
        return value
    }
}

let stack = MinStack<Int>()

let testcase: [Int?] =
    [212,22,13,nil,nil,53,55,2,nil,22,14,8,6,5,1,0,0,0,1,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]

for value in testcase {
    if let value = value {
        stack.push(value)
    } else {
        stack.pop()
    }

    stack.minimum()
}

print(#line)
