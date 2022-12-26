func dfs(_ x: Int) {
    visited[x] = true
    for next in board[x] {
        if visited[next] { continue }
        dfs(next)
    }
}

let input = readLine()!.split(separator: " ").compactMap{ Int($0) }
let (n, m) = (input[0], input[1])
var board: [[Int]] = Array(repeating: [], count: n+1)
var visited: [Bool] = Array(repeating: false, count: n+1)
var answer: Int = 0

for _ in 0..<m {
    let input = readLine()!.split(separator: " ").compactMap{ Int($0) }
    let (start, end) = (input[0], input[1])
    board[start].append(end)
    board[end].append(start)
}

for x in 1...n {
    if visited[x] { continue }
    answer += 1
    dfs(x)
}

print(answer)