
func volume(histogram: [Int]) -> Int {
    let maxToLeft = histogram.reduce(into: [Int]()) { result, element in
        result.append(Swift.max(element, result.last ?? 0))
    }

    let maxToRight = histogram.reversed().reduce(into: [Int]()) { result, element in
        result.append(Swift.max(element, result.last ?? 0))
    }
    .reversed().map { $0 }

    let volume = histogram.enumerated().reduce(0) { result, current in
        let height = Swift.min(maxToLeft[current.offset], maxToRight[current.offset])
        guard height > current.element else { return result }

        return result + (height - current.element)
    }

    return volume
}

volume(histogram: [])
volume(histogram: [0])
volume(histogram: [0,0,0,0])
volume(histogram: [0,0,1000,0])
volume(histogram: [4,4])
volume(histogram: [1,2,3,4,5,8,12,13,12,11,8,7,6,5,4,3,2])
volume(histogram: [4,0,4])
volume(histogram: [4,0,3,1234])
volume(histogram: [0,0,4,0,0,6,0,0,3,0,5,0,1,0,0,0])

print("====")
print(#line)
