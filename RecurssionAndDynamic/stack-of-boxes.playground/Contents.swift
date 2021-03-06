import Foundation

class Box: Hashable, CustomStringConvertible {
    let width: Int
    let depth: Int
    let height: Int

    init(_ width: Int, _ depth: Int, _ height: Int) {
        self.width = width
        self.height = height
        self.depth = depth
    }

    var hashValue: Int {
        return width.hashValue
    }

    static func == (lhs: Box, rhs: Box) -> Bool {
        guard lhs.width == rhs.width else { return false }
        guard lhs.depth == rhs.depth else { return false }
        guard lhs.height == rhs.height else { return false }
        return true
    }

    var description: String {
        return "(\(width), \(depth), \(height))"
    }
}

typealias SetOfBoxes = [Box]

class BoxBuilder {
    private var lookup: [Box: Int] = [:]
    private var sortedByWidth: [Box] = []

    func heighestStack(for boxes: SetOfBoxes) -> Int {
        lookup = [:]
        sortedByWidth = boxes.sorted(by: { $0.width == $1.width ? $0.height > $1.height : $0.width > $1.width })

        return sortedByWidth
        .enumerated()
        .map { offset, box in
            let slice = sortedByWidth[(offset+1)...]
            return self.heighestStack(from: slice, constrainedTo: box)
        }
        .max() ?? 0
    }

    private func heighestStack(from boxes: ArraySlice<Box>, constrainedTo bottom: Box) -> Int {
        guard !boxes.isEmpty else { return bottom.height }

        if let cached = lookup[bottom] {
            return cached
        } else {
            let height = bottom.height
            var result = 0
            for i in boxes.startIndex..<boxes.endIndex {
                guard boxes[i].canBePlaced(on: bottom) else { continue }
                let aspiringResult = heighestStack(from: boxes[(i+1)...], constrainedTo: boxes[i])
                result = Swift.max(result, aspiringResult)
            }
            result += height
            lookup[bottom] = result
            return result
        }
    }
}

fileprivate extension Box {
    func canBePlaced(on other: Box) -> Bool {
        return width < other.width && depth < other.depth
    }
}

let builder = BoxBuilder()

_ = builder.heighestStack(for: [
    Box(5, 5, 1),
    Box(2, 7, 7),
    Box(4, 3, 3),
    Box(3, 1, 8),
    Box(3, 1, 8),
    Box(3, 1, 8),
    Box(3, 1, 8),
    Box(3, 1, 8),
    Box(3, 1, 8),
    Box(3, 1, 10),
])

_ = builder.heighestStack(for: [
    Box(5, 5, 1),
    Box(2, 7, 7),
    Box(4, 3, 3),
    Box(3, 3, 8),
    Box(3, 3, 8),
    Box(3, 3, 8),
    Box(1, 1, 5),
    Box(2, 2, 3),
    Box(3, 1, 8),
    Box(3, 1, 3),
])

print(#line)
