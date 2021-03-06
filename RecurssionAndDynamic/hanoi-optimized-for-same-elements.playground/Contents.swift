import Foundation

var moves: [String] = []

class HanoiTower: CustomStringConvertible {
    let name: String
    var count: Int = 0
    var head: Node?
    var tail: Node?

    class Node {
        let value: Int
        var next: Node?
        var previous: Node?

        init(_ value: Int) {
            self.value = value
        }
    }

    init(name: String, array: [Int]) {
        self.name = name
        array.reversed().forEach { push($0) }
    }

    func peek() -> Int? {
        return head?.value
    }

    func pop() -> Int? {
        guard let value = head?.value else { return nil }

        head = head?.next
        head?.previous = nil
        count -= 1
        if head == nil {
            tail = nil
        }

        return value
    }

    func push(_ value: Int) {
        let oldHead = head
        head = Node(value)
        head?.next = oldHead
        oldHead?.previous = head
        tail = tail ?? head
        count += 1
    }

    func bottomCount() -> Int {
        var bottom = 1
        var current = tail
        while current?.value == current?.previous?.value {
            current = current?.previous
            bottom += 1
        }
        return bottom
    }

    var description: String {
        var pieces: [String] = []
        var current: Node? = head
        while current != nil {
            pieces.append("\(current!.value)")
            current = current?.next
        }
        return "\(name) : [\(pieces.joined(separator: ","))]"
    }
}

func hanoi(from: HanoiTower, to: HanoiTower, temp: HanoiTower) {
    hanoi(from: from, to: to, temp: temp, depth: from.count)
}

private func hanoi(from: HanoiTower, to: HanoiTower, temp: HanoiTower, depth: Int) {
    guard depth > 0 else { return }
    guard depth > 1 else {
        return move(from: from, to: to)
    }

    let count = from.bottomCount()

    hanoi(from: from, to: temp, temp: to, depth: depth - count)

    for _ in 1...count {
        move(from: from, to: to)
    }

    hanoi(from: temp, to: to, temp: from, depth: depth - count)
}

private func move(from: HanoiTower, to: HanoiTower) {
    guard let value = from.pop() else { return }
    moves.append("Moving \(value) from \(from.name) to \(to.name)")
    to.push(value)
}

let start = HanoiTower(name: "A", array: [1,2,3,3,3,3,3,3,3,3,3,4,5,5,5,5])
let temp = HanoiTower(name: "B", array: [])
let final = HanoiTower(name: "C", array: [])

print(start)
print(temp)
print(final)

hanoi(from: start, to: final, temp: temp)

print(moves.joined(separator: "\n"))

print(start)
print(temp)
print(final)

print("TOTAL: \(moves.count)")
// O(2^x) where x = number of distinctive elements in start tower

print(#line)
