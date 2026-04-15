import Foundation

struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: Int64) {
        let normalized = UInt64(bitPattern: seed)
        self.state = normalized == 0 ? 0x9E3779B97F4A7C15 : normalized
    }

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}

extension Array {
    func shuffled<R: RandomNumberGenerator>(using generator: inout R) -> [Element] {
        var copy = self
        copy.shuffle(using: &generator)
        return copy
    }
}
