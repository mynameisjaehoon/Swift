# DispatchWorkItem

## DispatchWorkItem이란?

- 작업을 클래스화 한 객체이다.
- 지금까지는 단순히 클로저안에 작업을 넣어서 비동기화 했다면, 이번에는 작업 자체를 클래스화해서 객체화 하는 것이다.
- 빈약한 취소기능을 내장
- 빈약한 순서기능을 내장

### 코드예시

```swift
// 1
let item1 = DispatchWorkItem(qos: .utility) {
	print("task1")
	print("task2")
}

// 2
let item2 = DispatchWorkItem {
	print("task3")
	print("task3")
}

// 3
let queue = DispatchQueue(label: "jaehoon")

// 4 
queue.async(execute: item1)
queue.async(execute: item2)
```

1. `item1`: DispatchWorkItem를 글로벌 utility큐로 등록
2. `item2`: DispatchWorkItem을 글로벌 디폴트큐로 등록
3. 시리얼 큐를 하나 생성
4. 큐에 비동기적으로 작업을 보낸다.

### 빈약한 취소 기능

- cancel메서드를 요청할 수 있다.
    - 작업이 아직 시작되지 않은 경우(아직 큐에 작업이 있을 경우) 작업이 제거된다.
    - 작업이 실행중인 경우 `isCancelled` 속성이 `true`로 설정된다. 
    직접적으로 실행중인 작업을 멈추는 것은 아니다.
    
    ```swift
    let item1 = DispatchWorkItem(qos: .utility) {
    	print("task1")
    	print("task2")
    }
    
    item.cancel()
    
    let queue = DispatchQueue(label: "jaehoon")
    
    queue.async(execute: item1)
    ```
    
- item1.cancel()메서드를 호출하면 async(execute:)에서 아이템을 호출하였더라도 실행되지 않는다.

### 빈약한 순서 기능

- notify(queue:execute:) 다음작업을 실행할 큐와 그 다음에 실행할 DispatchWorkItem을 넘겨주게 된다.
- 단순히 작업이 끝나고 난 후에 어떤 작업을 실행하라는 의미
- 아래의 코드는 item1의 작업이 끝난 후, item2의 작업을 실행하라는 의미이다.
    
    ```swift
    let item1 = DispatchWorkItem(qos: .utility) {
    	print("task1")
    	print("task2")
    }
    
    let item2 = DispatchWorkItem() {
    	print("task1")
    	print("task1")
    }
    
    item1.notify(queue: DispatchQueue.global(), execute: item2)
    
    queue.async(execute: item1)
    ```
    
    notify 메서드를 통해서 item1의 작업이 끝난 후, item2작업을 [DispatchQueue.global](http://DispatchQueue.global) 디폴트 큐에서 실행하라고 표현하고 있다.
