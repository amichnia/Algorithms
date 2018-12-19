import Foundation

func pondSizes(land: [[Int]]) -> [Int] {
    guard !land.isEmpty else { return [] }
    guard !land[0].isEmpty else { return [] }

    let rows = land.count
    let cols = land[0].count

    // Easier to traverse representation
    var landMap = Array(repeating: Array(repeating: 1, count: rows + 2), count: cols + 2 )

    // Copy values from original one
    for row in 1...rows {
        for col in 1...cols {
            landMap[row][col] = land[row - 1][col - 1]
        }
    }

    // Visited Map
    var visitedMap = Array(repeating: Array(repeating: -1, count: rows + 2), count: cols + 2 )

    // Traverse
    var lastLake = 0
    var solution: [Int] = []

    func markPond(lake: Int, at coordinate: (row: Int, col: Int)) {
        guard landMap[coordinate.row][coordinate.col] == 0 else { return }
        guard visitedMap[coordinate.row][coordinate.col] < 0 else { return }

        solution[lake] += 1
        visitedMap[coordinate.row][coordinate.col] = lake

        markPond(lake: lake, at: (coordinate.row - 1, coordinate.col - 1))
        markPond(lake: lake, at: (coordinate.row - 1, coordinate.col ))
        markPond(lake: lake, at: (coordinate.row - 1, coordinate.col + 1))
        markPond(lake: lake, at: (coordinate.row, coordinate.col - 1))
        markPond(lake: lake, at: (coordinate.row, coordinate.col + 1))
        markPond(lake: lake, at: (coordinate.row + 1, coordinate.col - 1))
        markPond(lake: lake, at: (coordinate.row + 1, coordinate.col))
        markPond(lake: lake, at: (coordinate.row + 1, coordinate.col + 1))
    }

    for row in 1...rows {
        for col in 1...cols {
            if visitedMap[row][col] < 0, landMap[row][col] == 0  {
                solution.append(0)
                markPond(lake: lastLake, at: (row, col))
                lastLake += 1
            }
        }
    }

    return solution
}

let ponds = pondSizes(land: [
    [0,2,1,0],
    [0,1,0,1],
    [1,1,0,1],
    [0,1,0,1]
])

print(#line)
