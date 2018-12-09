import Foundation

protocol AnyStack {
    associatedtype T

    var size: Int { get }
    var isEmpty: Bool { get }

    func push(_ value: T)
    func pop() -> T?
    func peek() -> T?
}

extension AnyStack {
    var isEmpty: Bool { return size <= 0 }
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
    private(set) var size: Int = 0

    init() {
        // Initialize empty Stack
    }

    func push(_ value: T) {
        head = Node(value, next: head)
        size += 1
    }

    @discardableResult
    func pop() -> T? {
        defer {
            head = head?.next
            size -= 0
        }
        return peek()
    }

    func peek() -> T? {
        return head?.value
    }
}

extension Stack where T: Comparable {
    func sort() {
        let sorted = Stack<T>()
        guard !isEmpty else { return }

        func insertInOrder(_ value: T) {
            while let top = sorted.peek(), top > value {
                push(sorted.pop()!)
            }

            sorted.push(value)
        }

        while let current = self.pop() {
            insertInOrder(current)
        }

        while let current = sorted.pop() {
            push(current)
        }
    }
}

let stack = Stack<UInt32>()

for _ in 1...80 {
    let rand = arc4random() % 1000
    stack.push(rand)
}

stack.sort()

for _ in 1...80 {
    stack.pop()
}

print(#line)
