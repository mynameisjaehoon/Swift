import Foundation

let input = readLine()!.split(separator: " ").map{ Int($0)! }
let n = input[0]
let m = input[1]

var graph: [[Character]] = []
var dist: [[Int]] = Array(repeating: Array(repeating: -1, count: 101), count: 101)

for _ in 0..<n {
    let input = readLine()!
    graph.append(Array(input))
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

struct Point {
    let x: Int
    let y: Int
}


var queue: Queue<Point> = Queue<Point>()
queue.push(Point(x: 0, y: 0))
dist[0][0] = 1

let dx: [Int] = [-1, 1, 0, 0]
let dy: [Int] = [0, 0, -1, 1]


while !queue.isEmpty {
    guard let current = queue.dequeue() else { continue }
    for dir in 0..<4 {
        let nx = current.x + dx[dir]
        let ny = current.y + dy[dir]
        
        if nx < 0 || nx >= n || ny < 0 || ny >= m { continue }
        if dist[nx][ny] > 0 { continue }
        if graph[nx][ny] == "0" { continue }
        
        dist[nx][ny] = dist[current.x][current.y] + 1
        if nx == n-1 && ny == m-1 {
            print(dist[nx][ny])
        }
        queue.push(Point(x: nx, y: ny))
        
    }
}



