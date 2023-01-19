# 프로세스 동기화
## `Critical Section`
- 앞의 멀티스레딩의 문제점에서도 보았듯이, 동일한 자원에 동시에 접근하는 작업을 실행하는 **코드 영역**을 `Critical Section`이라 부른다.

## Critical Section Problem(임계 영역문제)
- 프로세스들이 `Critical Section`을 함께 사용할 수 있는 프로토콜을 설계해야한다.
- 해결을 위한 기본 조건
    - Mutual Exclusive(상호 배제)
        - 하나의 프로세스가 `Critical Section` 내부에서 시행중이라면, 다른 프로세스들은 그들이 거쳐야하는 `Critical Section`에서 실행될 수 없다.
    - Progress(진행)
        - `Ciritical Section`에서 실행중인 프로세스가 없고, 별도의 동작이 없는 프로세스들만 `Ciritcal Section`의 진입 후보가 될 수 있다.
    - Bounded Waiting(한정된 대기)
        - 어떤 프로세스가 `Ciritical Section`에 진입 신청 후부터 받아들여질 때까지, 다른 프로세스들이 `Ciritical Section`에 진입하는 횟수는 제한이 있어야한다.

## 동기화 문제 해결책
## Mutex Lock
- 공유자원에 동시에 접근하는 것을 막기 위해서 Ciritical Section에 진입하는 프로세스가 Lock을 획득하고, 나올때 Lock을 방출해서 동시에 접근되지 않도록 하는 방법이다.
- 하지만 다중 처리기 환경에서는 시간적인 효율성 측면에서 적용할 수 없다.
## Semaphore(세마포어)
- Mutex Lock과 마찬가지고 Critical Section에 접근하는 문제를 해결하기 위해서 만든 동기화 도구이다.
- 세마포어에는 Counting/Binary Semaphore 추가지 종류가 있다.
    - 카운팅 세마포어(Counting Semaphore)
        - 세마포어의 개수만큼 스레드가 자원에 접근할 수 있다.
        - 당연히 자원에 접근할 수 있는 수만큼 세마포어 값이 초기화된다.
        - 자원을 사용하면 세마포어가 감소, 방출하면 세마포어가 증가한다.
    - 이진 세마포어(Binary Semaphore)
        - MUTEX라고도 부르며, 상호배제의(Mutext Exclusive)의 머릿글자를 따서 만들어졌다.
        - 이름처럼 0과 1사이의 값만 가능하다. 다중 프로세스들 사이의 Critical Section 문제를 해결하기 위해서 사용한다.
- 단점
    - Busy Waiting
        - spin lock이란 만약 다른 스레드가 lock을 소유하고 있다면, 그 lock이 반환될 때까지 계속 확인하며 기다리는 것이다.
        - 말 그대로 바쁘게 기다리는 Busy Waiting이다. Critical Section에 진입해야 하는 프로세스가 진입코드를 계속 반복해서 실행해야한다.
        - CPU 시간을 낭비하게 된다.
        - 해결방법으로는 Semaphore에서 Ciritical Section에 접근하려다 실패한 프로세스를 Block 시킨 다음에 Ciritical Section에 자리가 났을 때 깨우는 방식을 사용한다.
            - Busy Waiting으로 인한 시간 낭비 문제가 해결된다.
## Deadlock(교착상태)
- 세마포어가 Ready Queue를 가지고 있고, 둘 이상의 프로세스가 Critical Section의 진입을 무한정 기다리고 있고, Ciritical Section에서 실행되는 프로세스는 진입 대기중인 프로세스가 실행되어야만 빠져나올 수 있는 상황을 지칭한다.