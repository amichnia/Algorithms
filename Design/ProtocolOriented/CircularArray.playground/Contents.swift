import UIKit

struct CircularArray<T>: ExpressibleByArrayLiteral {
    typealias Element = T
    typealias ArrayLiteralElement = Element

    // Private storage
    private var underlyingArray: [Element]
    private(set) var shift: Int = 0

    lazy var count: Int = { return underlyingArray.count }()

    // Expressible by literal init
    init(arrayLiteral elements: Element...) {
        self.underlyingArray = elements
    }

    /// Rotates array by shifting elements to the left
    ///
    /// - Parameter shift: shift elements to the left (if positive) or riht (if negative)
    mutating func rotate(shift: Int) {
        self.shift = (self.shift + shift) % count
    }

    /// Rotates array
    ///
    /// - Parameter shift: shift elements to the left (if positive) or riht (if negative)
    /// - Returns: Rotated array
    func rotated(shift: Int) -> CircularArray<Element> {
        var array = self
        array.rotate(shift: shift)
        return array
    }
}

extension CircularArray: Collection {
    typealias Index = Array<Element>.Index

    // Required index handling
    var startIndex: Index {
        return underlyingArray.startIndex
    }
    var endIndex: Index {
        return underlyingArray.endIndex
    }

    // Required subscript, based on a dictionary index
    subscript(index: Index) -> Iterator.Element {
        get { return underlyingArray[(index + count + shift) % count] }
    }
    // Method that returns the next index when iterating
    func index(after i: Index) -> Index {
        return underlyingArray.index(after: i)
    }
}

var array: CircularArray = [1,2,3,4,5,6,7,8]
print("Count \(array.count) shift: \(array.shift)")

for i in array {
    print(i)
}

let first = array.rotated(shift: -6)

print("Count \(first.count) shift: \(first.shift)")

for i in first {
    print(i)
}

let second = array.rotated(shift: 2)

print("Count \(second.count) shift: \(second.shift)")

for i in second {
    print(i)
}

let third = array.rotated(shift: -2)

print("Count \(third.count) shift: \(third.shift)")

for i in third {
    print(i)
}


print("=== END ===")
print(#line)
