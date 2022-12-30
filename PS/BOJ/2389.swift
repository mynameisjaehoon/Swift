import Foundation

var n: Int = Int(readLine()!)!
var count: Int = 0

while n >= 0 {
    if n % 5 == 0 {
        count += (n / 5)
        print(count)
        exit(0)
    }
    n -= 3
    count += 1
}
print(-1)