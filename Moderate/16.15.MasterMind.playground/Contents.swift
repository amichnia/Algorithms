import Foundation

enum GuessError: Error {
    case inputLengthDoNotMatch
}

func make(guess: String, for solution: String) throws -> (hit: Int, pseudoHit: Int) {
    guard guess.count == solution.count else { throw GuessError.inputLengthDoNotMatch }
    let guess = guess.map { $0 }
    let solution = solution.map { $0 }

    var hits = 0
    var pseudoHits = 0
    var charactersLeft: [Character: Int] = [:]

    let potentialPseudoHits = guess.enumerated().filter { offset, guess in
        if guess == solution[offset] {
            hits += 1
            return false
        } else {
            charactersLeft.increment(forKey: solution[offset])
            return true
        }
    }

    potentialPseudoHits.forEach { _, character in
        guard let _ = charactersLeft.decrement(forKey: character) else { return }
        pseudoHits += 1
    }

    return (hit: hits, pseudoHit: pseudoHits)
}

extension Dictionary where Value == Int {
    mutating func increment(forKey key: Key) {
        let value = self[key] ?? 0
        self[key] = value + 1
    }
    mutating func decrement(forKey key: Key) -> Value? {
        guard let value = self[key] else { return nil }
        guard value > 1 else {
            self.removeValue(forKey: key)
            return value
        }
        self[key] = value - 1
        return value
    }
}

let first = try! make(guess: "RGGB", for: "RBBG")
let secon = try! make(guess: "RGGB", for: "RGGB")
let third = try! make(guess: "RGYY", for: "YYYY")
