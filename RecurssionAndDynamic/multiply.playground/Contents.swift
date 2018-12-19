import UIKit

extension Int {
    var isEven: Bool {
        let shifted = (self >> 1) << 1
        return self - shifted == 0
    }
}

func multiply(_ lhs: Int, _ rhs: Int) -> Int {
    guard lhs >= rhs else { return multiply(rhs, lhs) }
    guard rhs > 0 else { return 0 } // throw if below?

    let rest = rhs.isEven ? 0 : lhs
    let half = multiply(lhs, rhs >> 1)
    return half + half + rest
}

let bound = 100

for a in 0...bound {
    for b in 0...bound {
        _ = a * b
    }
}

print(#line)

for a in 0...bound {
    for b in 0...bound {
        let val = multiply(a, b)
        assert(a * b == val)
    }
}

print(#line)
