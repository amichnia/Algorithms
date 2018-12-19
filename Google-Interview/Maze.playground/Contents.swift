import Foundation

func canExit(from maze: inout [[Bool]], start: (row: Int, col: Int))-> Bool {
    // check if maze is not empty
    guard !maze.isEmpty else { return false }
    guard !maze[0].isEmpty else { return false }

    // check if free
    guard !maze[start.row][start.col] else { return false }

    // on border
    guard start.row > 0, start.row < maze.count - 1 else { return true }
    guard start.col > 0, start.col < maze[0].count - 1 else { return true }

    // visited
    maze[start.row][start.col] = true

    // visit surroundings
    var result = false

    // visit neighbours
    result = result || canExit(from: &maze, start: (row: start.row - 1,col: start.col))
    result = result || canExit(from: &maze, start: (row: start.row, col: start.col - 1))
    result = result || canExit(from: &maze, start: (row: start.row, col: start.col + 1))
    result = result || canExit(from: &maze, start: (row: start.row + 1,col: start.col))

    return result
}

print(#line)
