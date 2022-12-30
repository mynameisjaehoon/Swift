struct Meeting {
    let start: Int
    let end: Int
    
    init(start: Int, end: Int) {
        self.start = start
        self.end = end
    }
}

let n = Int(readLine()!)!
var meetings = [Meeting]()
for _ in 0..<n {
    let input = readLine()!.split(separator: " ").compactMap{ Int($0) }
    meetings.append(Meeting(start: input[0], end: input[1]))
}

meetings = meetings.sorted{
    if $0.end == $1.end {
        return $0.start < $1.start
    }
    return $0.end < $1.end
}
var currentTime: Int = 0
var answer: Int = 0

for meeting in meetings {
    if currentTime <= meeting.start {
        currentTime = meeting.end
        answer += 1
    }
}

print(answer)