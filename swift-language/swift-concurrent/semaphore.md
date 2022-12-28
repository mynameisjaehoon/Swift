# DispatchSemaphore
## 세마포어란?
- 공유리소스에 접근 가능한 작업의 수를 제한하는 것
- DispatchSemaphore에 value파라미터를 줘서 진입가능한 작업의 수를 정해줄 수 있습니다.
- `wait` 메서드는 작업을 시작할 수 있지만, 작업숫자가 제한되어 있으니 **일단 기다려**라는 의미.
- `signal` 메서드는 한개의 작업이 끝났으니 다음 작업을 시작할 수 있도록 Semaphore를 하나 줄게 라는 의미입니다.
- `DispatchGroup`은 입장, 퇴장의 숫자를 일치 시켜서 실제로 비동기 작업이 종료되는 시점을 알고싶은 개념이다.
- `DispatchSemaphore`는 작업의 숫자를 제한할 때 사용하는 개념입니다.

<img width="1463" alt="image" src="https://user-images.githubusercontent.com/76734067/209788958-b4b5af85-dba1-4de3-8efe-d81b8587b2c9.png">

```swift
let semaphore = DispatchSemaphore(value: 3)

queue.async(group: group1) {
    group1.enter() // 입장 1
    semaphore.wait()
    someAsyncMethod {
        group1.leave() // 퇴장 1
        semaphore.signal()
    }
}
```

실제로 코드를 살펴보자
```swift
let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInteractive)

// 공유리소스에 접근가능한 작업수를 4개로 제한
let semaphore = DispatchSemaphore(value: 4)


for i in 1...10 {
    group.enter()
    semaphore.wait()
    queue.async(group: group) {
        // 다운로드 시뮬레이팅
        print("시뮬레이팅 \(i)시작")
        sleep(3)
        print("시뮬레이팅 \(i)종료★")
        semaphore.signal()
        group.leave()
    }
}

group.notify(queue: DispatchQueue.global()) {
    print("=====모든 일이 종료됨=====")
}
```
- group: 디스패치 그룹
- queue: group의 작업이 모두 종료되었을 때 종료작업을 수행할 큐
- semaphore: `DispatchSemaphore`, 여기서는 한번에 접근가능한 작업의 수를 4개로 제한하고 있습니다.

for-반복문으로 10번 돌면서 3초가 걸리는 작업을 group에 등록하고 실행하고 있습니다. 작업이 시작될 때 group에 작업이 추가되었다고 카운트를 늘려주는 enter 메서드와 semaphore를 할당하는 wait메서드를 사용하고있습니다., 작업이 끝났을 때 group의 카운트를 줄여주는 leave 메서드를 사용하고 있고 semaphore를 다시 할당해주는 signal 메서드를 사용하고 있습니다.

위에서도 설명드렸듯이 그룹과 세마포어는 서로 다른 개념이기 때문에 어느것이 먼저와도 상관은 없습니다.