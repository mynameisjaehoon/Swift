# 스택 / 큐
## 스택

스택의 LIFO구조이기 때문에 간단하게 구현할 수 있다. 기본적으로 배열을 사용하고 배열의 마지막에 원소를 넣는 `append()`메서드와
가장 끝에 있는 원소를 제거하고 반환하는 `popLast()`메서드가 이미 주어져 있기 때문이다. 시간복잡도도 push, pop 둘다 **`O(1)`**이기 때문에
별로 문제되지 않을 것 같다.

PS를 풀면서 스택으로 이름 붙여서 사용하고 싶다면 아래의 코드를 작성해서 직접사용해도 되지만 사실은 배열을 그대로 사용해도 별로 문제는
없을 것 같다.

```swift
struct Stack<T> {
    
    private var stack: [T] = []
    
    public var count: Int {
        stack.count
    }
    
    public var isEmpty: Bool {
        stack.isEmpty
    }
    
    public func top() -> T? {
        isEmpty ? nil : stack.last!
    }
    
    public mutating func push(_ element: T) {
        stack.append(element)
    }
    
    public mutating func pop() -> T? {
        isEmpty ? nil : stack.popLast()
    }
    
}
```

## 큐

큐는 FIFO구조이기 때문에 스택과는 다르게 제거할 때(dequeue)고민을 했었다. 배열에 `removeFirst()`를 사용하면 가장 나중에 삽입했던것을
간단하게 제거할 수 있지만, 뒤에있는 원소들을 전부 앞으로 한칸씩 당겨야하기 때문에 **`O(N)`**의 시간복잡도를 가지는 단점이 있다.

`reversed()`메서드는 시간복잡도가 **`O(1)`**에 불과하고, 그 상태에서 `removeLast()`를 사용함으로서 상수시간에 제거를 구현할 수 있었다.

```swift
struct Queue<T> {
    
    private var queue: [T] = []
    
    public var count: Int {
        queue.count
    }
    
    public var isEmpty: Bool {
        queue.isEmpty
    }
    
    public func first() -> T? {
        isEmpty ? nil : queue.first!
    }
    
    public func last() -> T? {
        isEmpty ? nil : queue.last!
    }
    
    public mutating func enqueue(_ element: T) {
        queue.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty { return nil }
        
        var tempQueue: [T] = queue.reversed() // O(1)
        let dequeueResult = tempQueue.removeLast() // O(1)
        queue = tempQueue.reversed() // O(1)
        
        return dequeueResult
    }
    
}
```
