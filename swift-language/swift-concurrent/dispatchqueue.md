# DispatchQueue의 종류와 특성

- [큐의 종류](#큐의-종류)
- [메인 큐(Main Queue)](#메인-큐-main-queue)
- [글로벌 큐](#글로벌-큐)
- [이미 할당한 글로벌 큐보다 더 qos가 더 높다면?](#이미-할당한-글로벌-큐보다-더-qos가-높다면)
- [커스텀 큐](#프라이빗커스텀-큐)
    - [OS가 QOS를 추론한다](#os가-qos를-알아서-추론)

---

## 큐의 종류
큐의 종류는 다음과 같이 나누어진다.

- GCD
    - DispatchQueue
        - (글로벌)메인
        - 글로벌
        - 프라이빗(커스텀)
- OperationQueue

대기열마다 다른 특성을 가지고 있고, 특성에 따라 원하는 큐로 작업을 보내면 된다. 큐로 작업을 보내면 큐의 특성에 따라 알아서 다른 스레드에 작업을 보내고 처리한다.

## 메인 큐 (Main Queue)
유일하게 한개의 스레드(메인 스레드)에서 시리얼(직렬)로 동작한다. 메인 큐 라는 말이 메인쓰레드를 의미한다.

1번스레드는 사실은 메인큐이기도 하다. 

유일하고 코드로 `DispatchQueue.main` 이렇게 명명합니다.

```swift
DispatchQueue.main.async {

}
```

위와 같은 코드는 작업을 main스레드로 보낸다는 것을 의미한다.

## 글로벌 큐

- 글로벌 큐는 서비스 품질(.QOS)에 따라서 6가지로 나누어진다.
- 기본설정은 Concurrent이다. 여러개의 스레드로 작업을 분산처리한다.

```swift
DispatchQueue.global().async {

}
```

qos에는 다음이 온다. 중요도 순으로 작성했다.

- `.userInteractive`
    - 거의 즉시 작업이 필요할 때
    - 유저와 직접적인 인터렉티브: UI업데이트, 애니메이션, UI반응 관련 어떤 것이든(사용자와 상호작용)
- `.userInitiated`
    - 몇초 안에 실행이 필요한 작업
    - 유저가 즉시 필요하긴 하지만, 비동기적으로 처리된 작업
- `디폴트`
- `.utility`
    - ProgressIndicator와함께 길게 실행되는 작업, 계산, IO, Networking, 지속적인 데이터 feeds
- `.background`
    - 속도보다는 에너지 효율성을 중시, 몇분이상
    - 유저가 직접적으로 인지하지 않고(시간이 중요하지 않은작업)작업, 데이터 미리 가져오기, 데이터베이스 유지
- `.unspecified`
    - 레거시 API

이렇게 글로벌 큐는 6가지 종류가 있고 사용해야 하는 상황도 따로 있다.

- 글로벌 큐의 우선순위 따라 어떻게 구분을 줄까? 
    - iOS 시스템에서 더 중요한 일임을 인지하고 쓰레드에 우선순위를 매겨서 더 여러개의 쓰레드를 배치하고 배터리를 더 집중해서 사용하도록 한다.

### 이미 할당한 글로벌 큐보다 더 qos가 높다면?
> 글로벌 큐 안에서 또 글로벌 큐로 작업을 보내는 상황에서 현재 글로벌 큐보다 더 높은 qos로 작업을 보내면 어떻게 될까?

- 만약 `.background`로 보낸 작업에서 또 `.utility`로 보냈다면? 큐의 우선순위를 백그라운드로 만들었는데 보내는 작업의 서비스 품질이 더 높다면 어떻게 될까?
    ```swift
    // 백그라운드로 정의
    let queue = DispatchQueue.global(qos: .background)

    // 작업을 보낼 때 더 높은 우선순위의 큐로 보낸
    queue.async(qos:.utility) {
        // ... 작업들
    }
    ```

- 백그라운드 품질의 큐로 보냈지만 **작업의 영향을 받아서 더 높은 품질의 큐로 변화**한다.

## 프라이빗(커스텀) 큐

- 커스텀으로 만든다
- 디폴트 설정은  `Serial`이나 `Concurrent`로도 만들수 있다.
- Qos도 설정할 수 있다.
- 디폴트 설정은 Serial이여서 직렬적으로 이용한다

커스텀 큐는 다음과 같이 생성할 수 있다.

DispatchQueue에 문자열로 레이블을 붙여서 생성한다.

attributes옵션을 줘서 concurrent하게 만들수도 있다. private한 큐가 된다.

```swift
let queue = DispatchQueue(label: "jaehoon So")
queue.async {

}

let queue2 = DispatchQueue(label: "jaehoon So", attributes: .concurrent) // concurrent큐
```

### OS가 QoS를 알아서 추론
- private/커스텀 큐는 OS가 내부적으로 작업의 서비스 품질을 판단해준다.

<img width="1351" alt="image" src="https://user-images.githubusercontent.com/76734067/209479738-8e12c6d7-c085-4988-9e07-2939f7c91315.png">
