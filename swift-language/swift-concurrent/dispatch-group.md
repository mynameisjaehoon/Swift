# 디스패치 그룹

## 디스패이 그룹이라는 개념이 왜 필요하지?

<img width="1463" alt="image" src="https://user-images.githubusercontent.com/76734067/209479894-db665784-68d7-45b1-97d1-33726ef4dae6.png">

- 지금까지 공부하고 있는 것: 작업을 다른 큐로 보내서 그 큐가 여러 스레드로 분산처리한다.
- `유사한`작업들을 묶어놓고 그 작업이 언제 끝날지 알고, 그 시점에 무언가 작업을 하고 싶을 때 사용한다.
    - 예시) 런치스크린이 실행되고 앱의 첫 화면이 나오기 전에 이미지를 불러오는 등 작업을 하고싶을 때
    <img width="450" alt="image" src="https://user-images.githubusercontent.com/76734067/209479901-21646691-0159-4c10-8a41-6f647199cb69.png">
    - `다운로드가 다끝난 다음에 화면을 띄우자`라는 기획 등...


```swift
let group1 = DispatchGroup()

// 큐로 보낼 때, 어떤 그룹에 넣을 것인지 정해주기
DispatchQueue.global(qos: ).async(group: group1) { ... }
DispatchQueue.global(qos: ).async(group: group1) { ... }
DispatchQueue.global().async(group: group1) { ... }

group1.notify(queue: DispatchQueue.main) { [weak self] in
    self?.textLabel.text = "모든 작업이 완료되었습니다."
}
```

- 작업을 async의 group파라미터에 넣으면 그것이 그룹에 묶이게 된다. 어떤 그룹에 넣을 것인지 지정해 줄 수 있다. 작업을 보낼 때 `group1이라고 꼬리표`를 붙여주는 느낌이다.
- 같은 그룹에 보내는 작업들은 무조건 같은 큐일 필요는 없다.
- `notify`를 사용해서 **그룹의 작업이 모두 끝나는 시점에 실행할 코드를 등록**할 수 있다.
- 큐의 파라미터로 이 작업을 어떤 큐에서 실행할지 명명할 수 있다.<br>

## 동기적인 기다림
- `wait` 메서드를 사용하여 디스패치 그룹에서 모든작업이 완료 될 때까지 현재 대기열을 차단하고 기다리는 동기적인 방법이 있다.
- main스레드 에서 실행시키면 앱이 멈추니 당연히 Main스레드에서 작업하면 안된다!
- 메인큐(메인스레드)가 아닌 이미 다른큐(다른스레드)에서는 wait메서드 사용가능할 수 있음.
- 작업의 시간제한을 두고싶을 때 사용할 수도 있다. 제일 아래의 코드는 작업을 60초 까지는 기다릴 수 있는데 그 이상을 기다릴 수 없다는 의미
    ```swift
    let group1 = DispatchGroup()

    // 큐로 보낼 때, 어떤 그룹에 넣을 것인지 정해주기
    DispatchQueue.global(qos: ).async(group: group1) { 동기적함수 }
    DispatchQueue.global(qos: ).async(group: group1) { 동기적함수 }
    DispatchQueue.global().async(group: group1) { 동기적함수 }

    group1.wait(timeout: DispatchTime.distantFuture)

    if group1.wait(timeout: .now() + 60) == .timeOut { ... }

    ```


## 비동기 디스패치 그룹

```swift
let group1 = DispatchGroup()

// 큐로 보낼 때, 어떤 그룹에 넣을 것인지 정해주기
DispatchQueue.global(qos: ).async(group: group1) { 비동기함수 }
DispatchQueue.global(qos: ).async(group: group1) { 비동기함수 }
DispatchQueue.global().async(group: group1) { 비동기함수 }

group1.notify(queue: DispatchQueue.main) { [weak self] in
    self?.textLabel.text = "모든 작업이 완료되었습니다."
}
```
- 지금까지는 작업의 내용이 동기적인것들만 살펴보았다면 작업을 보낼때 비동기함수가 들어있을 때 어떤 문제가 발생하는지 살펴보자
- 디스패치 그룹에서는 비동기적인함수를 호출할때 몇가지의 준비가 필요하다는 것이다

### 클로저에서 비동기함수를 호출할 때 어떤 문제가 있을까?

다음과 같이 클로저 내에서 비동기 메서드 asyncMethod를 실행한다고 가정해봅시다.

```swift
let group1 = DispatchGroup()

DispatchQueue.global().async(group: group1) {
    
    print("비동기 그룹 작업 시작")
    asyncMethod(input: url) { result in
        ...
    }
    print("비동기 그룹 작업 종료")
    
}
```

어떤 일이 발생하게 될까?

<img width="450" alt="image" src="https://user-images.githubusercontent.com/76734067/209480005-6c5b3412-e8af-4e5b-8932-3a676a62ab4f.png">
<img width="700" alt="image" src="https://user-images.githubusercontent.com/76734067/209480011-ec5007d8-02a8-4bcb-92b1-1008e4772660.png">


- 그룹의 작업이 끝난 시점이랑, 정말로 비동기 작업이 끝난 제대로 일이 끝난 시점은 다르기 때문에 디스패치 그룹의 작업이 끝난 시점을 잘못인식할 수 있다.
- 그렇다면 비동기 작업이 포함된 그룹의 작업일때 사전에 어떤 처리를 해주어야할까?
- `group1.enter()`
    - group1에 작업하나를 보낼 때 `enter()` 라는 메서드를 붙인다.
- `group1.leave()`
    - group1에 있는 작업하나를 완료하였을 때 `leave()` 메서드를 사용한다. 보통 컴플리션 핸들러에서 사용하거나, `defer`블록을 활용하여 사용한다.
- 작업의 입장과 퇴장한다는 것을 표기해서 비동기적인 작업을 할때 제대로된 시점을 인식할 수 있도록 하면 됩니다.
    ```swift
    queue.async(group: group1) {
        group1.enter() // 입장1
        someAsyncMethod {
                group1.leave() // 퇴장1
        }
    }
    ```
- 입장과 퇴장 수를 세어서 그룹의 작업이 언제끝나는지 인식하게 해줄 수 있습니다.