import Foundation

let input = readLine()!.split(separator: " ").map{ Int($0)! }
let m = input[0]
let n = input[1]
let v = input[2]

var visited: [Bool] = Array(repeating: false, count: 1001)
var board: [[Int]] = Array(repeating: [], count: 1001)

for _ in 0..<n {
    let pointInput = readLine()!.split(separator: " ").map{ Int($0)! }
    let start = pointInput[0]
    let end = pointInput[1]
    
    board[start].append(end)
    board[end].append(start)
    
    board[start] = board[start].sorted()
    board[end] = board[end].sorted()
}

func dfs(x: Int) {
    visited[x] = true
    print(x, terminator: " ")
    for i in 0..<board[x].count {
        let next = board[x][i]
        if !visited[next] { dfs(x: next) }
    }
}



func bfs(x: Int) {
    
    var queue: Queue<Int> = Queue<Int>()
    queue.enqueue(x)
    visited[x] = true
    while !queue.isEmpty {
        guard let current = queue.front() else { continue }
        queue.dequeue()
        print(current, terminator: " ")
        
        for i in 0..<board[current].count {
            let next = board[current][i]
            if !visited[next] {
                visited[next] = true
                queue.enqueue(next)
            }
        }
        
    }
    
}

dfs(x: v)
visited = Array(repeating: false, count: 1001)
print("")
bfs(x: v)

struct Queue<T> {
    
    private var queue: [T] = []
    public var count: Int {
        queue.count
    }
    public var isEmpty: Bool {
        queue.isEmpty
    }
    
    public mutating func front() -> T? {
        isEmpty ? nil : queue.first!
    }
    
    public mutating func last() -> T? {
        isEmpty ? nil : queue.last!
    }
    
    public mutating func enqueue(_ element: T) {
        queue.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if queue.isEmpty { return nil }
        var tempQueue: [T] = queue.reversed()
        let result = tempQueue.removeLast()
        queue = tempQueue.reversed()
        
        return result
    }
    
}
