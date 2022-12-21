import Foundation

let dx: [Int] = [-1, 1, 0, 0]
let dy: [Int] = [0, 0, -1, 1]

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

let t = Int(readLine()!)!

for _ in 0..<t {
    // 가로길이 M, 세로길이 N, 배추가 심어져 있는 위치의 개수K
    var answer: Int = 0
    let input = readLine()!.split(separator: " ").map{ Int($0)! }
    let m = input[0]
    let n = input[1]
    let k = input[2]
    
    var board: [[Int]] = Array(repeating: Array(repeating: 0, count: m), count: n)
    var visit: [[Bool]] = Array(repeating: Array(repeating: false, count: m), count: n)
    
    // 배추의 위치가 (세로, 가로)로 주어진다.
    for _ in 0..<k {
        let input = readLine()!.split(separator: " ").map{ Int($0)! }
        let x = input[1]
        let y = input[0]
        
        board[x][y] = 1
    }
    
    for i in 0..<n {
        for j in 0..<m {
            if visit[i][j] || board[i][j] == 0 { continue }
            answer += 1
            var queue = Queue<Point>()
            visit[i][j] = true
            queue.push(Point(x: i, y: j))
            
            while !queue.isEmpty {
                guard let cur = queue.dequeue() else { continue }
                for dir in 0..<4 {
                    let nx = cur.x + dx[dir]
                    let ny = cur.y + dy[dir]
                    
                    if nx < 0 || nx >= n || ny < 0 || ny >= m { continue }
                    if visit[nx][ny] || board[nx][ny] == 0 { continue }
                    
                    visit[nx][ny] = true
                    queue.push(Point(x: nx, y: ny))
                }
            }
        }
    }
    print(answer)
}

