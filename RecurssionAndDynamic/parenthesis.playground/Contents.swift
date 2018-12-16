import Foundation

extension String {
    private typealias LookupTable = Dictionary<String, Int>

    func parenthesis(producing value: Bool) -> Int {
        // Check if input is correct? make throw

        var dict: LookupTable = [:]
        let array = self.map({ $0 })

        return String.parenthesis(array[...], produce: value ? "1" : "0", lookup: &dict)
    }

    private static func parenthesis(_ expression: ArraySlice<Character>, produce value: Character, lookup: UnsafeMutablePointer<LookupTable>) -> Int {
        guard !expression.isEmpty else { return 0 }
        guard expression.count > 1 else {
            return expression.first! == value ? 1 : 0
        }

        let expressionString = String(expression) + "=\(value)"

        if let cached = lookup.pointee[expressionString] {
            return cached
        } else {
            var result: Int = 0
            var i = expression.startIndex + 1
            while i < expression.endIndex {
                // For every operator
                switch (expression[i], value) {
                case ("&", "0"):
                    let left0 = parenthesis(expression[..<i], produce: "0", lookup: lookup)
                    let left1 = parenthesis(expression[..<i], produce: "1", lookup: lookup)
                    let right0 = parenthesis(expression[(i+1)...], produce: "0", lookup: lookup)
                    let right1 = parenthesis(expression[(i+1)...], produce: "1", lookup: lookup)
                    result += left0 * right0
                    result += left1 * right0
                    result += left0 * right1
                case ("&", "1"):
                    let left1 = parenthesis(expression[..<i], produce: "1", lookup: lookup)
                    let right1 = parenthesis(expression[(i+1)...], produce: "1", lookup: lookup)
                    result += left1 * right1
                case ("|", "0"):
                    let left0 = parenthesis(expression[..<i], produce: "0", lookup: lookup)
                    let right0 = parenthesis(expression[(i+1)...], produce: "0", lookup: lookup)
                    result += left0 * right0
                case ("|", "1"):
                    let left0 = parenthesis(expression[..<i], produce: "0", lookup: lookup)
                    let left1 = parenthesis(expression[..<i], produce: "1", lookup: lookup)
                    let right0 = parenthesis(expression[(i+1)...], produce: "0", lookup: lookup)
                    let right1 = parenthesis(expression[(i+1)...], produce: "1", lookup: lookup)
                    result += left1 * right1
                    result += left1 * right0
                    result += left0 * right1
                case ("^", "0"):
                    let left0 = parenthesis(expression[..<i], produce: "0", lookup: lookup)
                    let left1 = parenthesis(expression[..<i], produce: "1", lookup: lookup)
                    let right0 = parenthesis(expression[(i+1)...], produce: "0", lookup: lookup)
                    let right1 = parenthesis(expression[(i+1)...], produce: "1", lookup: lookup)
                    result += left1 * right1
                    result += left0 * right0
                case ("^", "1"):
                    let left0 = parenthesis(expression[..<i], produce: "0", lookup: lookup)
                    let left1 = parenthesis(expression[..<i], produce: "1", lookup: lookup)
                    let right0 = parenthesis(expression[(i+1)...], produce: "0", lookup: lookup)
                    let right1 = parenthesis(expression[(i+1)...], produce: "1", lookup: lookup)
                    result += left1 * right0
                    result += left0 * right1
                default: break
                }

                i += 2
            }

            lookup.pointee[expressionString] = result
            return result
        }
    }
}

print(#line)

_ = "1^0|0|1".parenthesis(producing: false)
_ = "0&0&0&1^1|0".parenthesis(producing: true)

print("END")
print(#line)
