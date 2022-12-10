# GCD
> 멀티코어 시스템에서 동시성 실행을 위해 제공하는 런타임 라이브러리

# DispatchQueue
> GCD의 개념으로 동시성 프로그래밍을 제공하는 Swift API

- 자바나 C언어가 직접 스레드를 만들어서 작업을 할당해주어야 했던 것과는 다르게 DispatchQueue에 작업을 넣어주면 알아서 스레드를 할당해주고, 개발자는 어떤 스레드가 사용될지 알 수 없다.

### Serial / Concurrent
- serial
    - 큐에 등록된 작업을 순서대로 하나씩 쓰레드에 할당하는 것
    - 먼저 들어온 작업이 완료되어야 다음작업을 시작한다.
    - 그렇다고 작업들이 무조건 같은 쓰레드에서 실행되는 것을 의미하는 것은 아님. 시스템에 따라 다르다.
- concurrent
    - 큐에 들어온 자겁이 동시에 여러개씩 수행될 수 있다.
    - 각 스레드에서 작업을 수행하기 때문에 작업의 순서대로 수행되지는 않는다.

### Queue 종류

- Main Queue
    - Queue 종류중에서 유일하게 Main Thread **하나**의 스레드만 사용한다.
    - UI관련된 작업은 Main Thread에서 동작해야 하므로 Main Queue에 할당하게 된다. 딜레이가 생기면 UI도 버벅거린다.
    - 메인 스레드에서 동작하므로 하나만 존재하고, **Serial** 한 특성을 가지고 있다. 큐에 쌓이는 작업을 순서대로 처리한다.
- Global Queue
    - Main Queue가 Main Thread에서만 작업하는 것과 다르게, Main Thread를 제외한 다른 스레드에서 작업을 처리한다.
    - **Concurrent**의 속성을 가진다. 여러 스레드로 작업이 분산되어서 처리된다.
- Custom Queue

### Sync / Async
- 동기 (Sync)
    - 
- 비동기 (Async)