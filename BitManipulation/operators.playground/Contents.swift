import UIKit

var str = "Hello, playground"

// 1. XOR does not touch sign bit
let value = -5 ^ -1

// 1...101
// 1...001

_ = Int.max
func getBits(from value: Int32, count: Int32) -> String {
    var value = value
    var result = ""
    for _ in 1...count {
        result.append(value % 2 == 0 ? "0" : "1")
        value = value >> 1
    }
    return String(result.reversed())
}

let positive: Int32 = 25 // It is 25
print(getBits(from: positive, count: 32)) // 00000000000000000000000000011001
let inverted: Int32 = ~positive // It is -26
print(getBits(from: inverted, count: 32)) // 11111111111111111111111111100110

// MARK: - Mind complementary to 2 notation! all 111111...111 is actually -1 (not -0) so negating bits is equivalent of ~a = (a * -1) - 1 !!!

// 00000...01
// 11111...10
