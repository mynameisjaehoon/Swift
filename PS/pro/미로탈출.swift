import Foundation

func solution(_ maps:[String]) -> Int {
    let maps = maps.map{ Array($0) }
    // 시작한 곳에서 레버까지의 최소 시간
    // 레버에서 출구까지의 최소시간
    // 두 가지를 구한다.
    var dist1: [[Int]] = Array(repeating: Array(repeating: -1, count: maps[0].count), count: maps.count)
    var dist2: [[Int]] = Array(repeating: Array(repeating: -1, count: maps[0].count), count: maps.count)
    
    var queue1: [(Int, Int)] = []
    var queue2: [(Int, Int)] = []
    var front: Int = 0
    var start = (0, 0)
    var lever = (0, 0)
    var gate = (0, 0)
    
    let dx = [-1, 1, 0, 0]
    let dy = [0, 0, -1, 1]
    
    for i in 0..<maps.count {
        for j in 0..<maps[i].count {
            if maps[i][j] == "S" {
                start = (i, j)
                queue1.append((i, j))
                dist1[i][j] = 0
            }
            else if maps[i][j] == "L" {
                lever = (i, j)
                queue2.append((i, j))
                dist2[i][j] = 0
            }
            else if maps[i][j] == "E" {
                gate = (i, j)
            }
        }
    }
    
    var (diff1, diff2) = (-1, -1)
    
    /// BFS1
    while front < queue1.count {
        let (x, y) = queue1[front]
        front += 1
        
        if (x, y) == lever {
            diff1 = dist1[x][y]
            break
        }
        
        for dir in 0..<4 {
            let nx = x + dx[dir]
            let ny = y + dy[dir]
            if nx < 0 || nx >= maps.count || ny < 0 || ny >= maps[0].count { continue }
            if maps[nx][ny] == "X" { continue }
            if dist1[nx][ny] > 0 { continue }
            
            dist1[nx][ny] = dist1[x][y] + 1
            queue1.append((nx, ny))
        }
    }
    
    front = 0
    
    /// BFS2
    while front < queue2.count {
        let (x, y) = queue2[front]
        front += 1
        if (x, y) == gate {
            diff2 = dist2[x][y]
            break
        }
        
        for dir in 0..<4 {
            let nx = x + dx[dir]
            let ny = y + dy[dir]
            if nx < 0 || nx >= maps.count || ny < 0 || ny >= maps[0].count { continue }
            if maps[nx][ny] == "X" { continue }
            if dist2[nx][ny] > 0 { continue }
            
            dist2[nx][ny] = dist2[x][y] + 1
            queue2.append((nx, ny))
        }
    }
    
    if diff1 != -1 && diff2 != -1 {
        return diff1 + diff2
    }
    
    return -1
}