import Foundation

let dx: [Int] = [-1, 1, 0, 0]
let dy: [Int] = [0, 0, -1, 1]


let n = Int(readLine()!)!
var board: [[Character]] = []
var visited: [[Bool]] = Array(repeating: Array(repeating: false, count: n), count: n)
for _ in 0..<n {
    let input = readLine()!
    board.append(Array(input))
}

var count: Int = 0
var areas: [Int] = []


for i in 0..<n {
    for j in 0..<n {
        if visited[i][j] { continue }
        if board[i][j] == "0" { continue }
        count += 1
        areas.append(bfs(i, j))
    }
}

print(count)
for area in areas.sorted() {
    print(area)
}


func bfs(_ x: Int, _ y: Int) -> Int {
    var area: Int = 0
    var queue = Queue<Point>()
    queue.push(Point(x: x, y: y))
    visited[x][y] = true
    
    while !queue.isEmpty {
        guard let current = queue.dequeue() else { continue }
        area += 1
        for dir in 0..<4 {
            let nx = current.x + dx[dir]
            let ny = current.y + dy[dir]
            
            if nx < 0 || ny < 0 || nx >= n || ny >= n { continue }
            if visited[nx][ny] || board[nx][ny] == "0" { continue }
            
            visited[nx][ny] = true
            queue.push(Point(x: nx, y: ny))
        }
    }
    return area
}


struct Point {
    let x: Int
    let y: Int
}

struct Queue<T> {
    private var queue: [T] = []
    public var count: Int {
        queue.count
    }
    public var isEmpty: Bool {
        queue.isEmpty
    }
    public mutating func push(_ element: T) {
        queue.append(element)
    }
    
    public mutating func front() -> T? {
        isEmpty ? nil : queue.first!
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty { return nil }
        var tempQueue: [T] = queue.reversed()
        let result = tempQueue.removeLast()
        queue = tempQueue.reversed()
        return result
    }
}
