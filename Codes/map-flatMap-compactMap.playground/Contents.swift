import Foundation

let array = ["1", "2", "3", "4", "five"]

let mapResult = array.map{ Int($0) }
print(mapResult) // [Optional(1), Optional(2), Optional(3), Optional(4), nil]

let compactMapResult = array.compactMap{ Int($0) }
print(compactMapResult) // [1, 2, 3, 4]
