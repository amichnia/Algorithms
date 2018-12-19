import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        guard index >= 0, index < self.endIndex else { return nil }
        return self[index]
    }
}

func minimalSortableArea(for array: [Int]) -> (m: Int, n: Int)? {
    guard !array.isEmpty else { return nil }

    let minOnRight = array
    .enumerated()
    .reversed()
    .reduce(into: Array<Int>(repeating: 0, count: array.count)) { minOnRight, current in
        let next = minOnRight[safe: current.offset + 1] ?? current.element
        minOnRight[current.offset] = Swift.min(next, current.element)
    }

    var n = 0
    var i = 0
    while i < array.count - 1, minOnRight[i] >= array[i] {
        n += 1
        i += 1
    }

    guard n < array.count else { return nil }

    let maxOnLeft = array
    .enumerated()
    .reduce(into: Array<Int>(repeating: 0, count: array.count)) { maxOnLeft, current in
        let previous = maxOnLeft[safe: current.offset - 1] ?? current.element
        maxOnLeft[current.offset] = Swift.max(previous, current.element)
    }

    var m = array.count
    i = array.count - 1
    while i >= 0, array[i] >= maxOnLeft[i] {
        m -= 1
        i -= 1
    }

    return m > 0 ? (m: m, n: n) : nil
}

let a = minimalSortableArea(for: [])
let b = minimalSortableArea(for: [1, 2, 8, 9, 3, 9, 2, 2, 9, 10, 12])
let c = minimalSortableArea(for: [1,2,5,1,7,3,7,90])
