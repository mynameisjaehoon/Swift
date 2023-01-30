# 스위프트 질문 모음

### class와 struct의 차이
클래스는 참조타입이고, ARC로 메모리를 관리합니다. 참조타입이기 때문에 같은 클래스 인스턴스를 여러개의 변수에 할당한 다음에 하나의 변수에서 프로퍼티를 수정하면 모든 변수에 영향을 줍니다. 상속이 가능하고, 타입 캐스팅을 통해서 런타임에서 클래스인스턴스의 타입을 확인할 수 있습니다.

구조체는 클래스와 달리 값타입입니다. 구조체 변수를 새로운 변수에 할당할 때마다 개발자가 COW를 구현하지 않았다면 새로운 구조체가 복사되어서 할당됩니다. 그러므로 여러개의 변수에 할당시킨다음 하나의 변수의 값을 변경시키더라도 다른변수에 영향을 주지 않습니다.

구조체는 언제 사라질지 컴파일 단계에서 알 수 있기 때문에 메모리의 스택공간에 할당되고 클래스는 참조가 어디서 어떻게 될지 모르기 때문에 힙이라는 공간에 할당되게 됩니다. 하지만 클래스라고 해서 무조건 힙에 할당되는 것은 아닙니다.

- 값타입을 포함하는 참조타입
    - 간단하게 말해서 클래스안에 구조체 프로퍼티가 존재하는 경우입니다.
    - 이 경우에는 참조타입이 할당 해제되기 전에 값타입도 할당 해제되지 않게 하기 위해서 값타입도 힙에 저장됩니다.
    - 클로저 내부에서 사용되는 값타입도 위의 경우에 해당합니다.
- 참조타입을 포함하는 값타입
    - 간단하게 말해서 구조체안에 클래스 프로퍼티가 존재하는 경우입니다.
    - 이 경우 값 타입이 힙에 할당되지는 않지만 내부에 참조타입이 있기 때문에 참조카운트를 해주어야합니다.

### class A와 class B에 동일한 함수가 있다면 어떻게 바꿀 수 있나요?
두 클래스에서 메서드가 수행해야 하는 역할이 완전히 동일하다면 공통된 기능을 담은 클래스를 정의하고, 그곳에 메서드를 정의하고 두 클래스가 슈퍼클래스를 상속받도록 할 것 같습니다.

### enum/function/closure는 각각 value type인가? reference type인가?
enum은 value type, function과 closure는 reference type입니다.<br>

> `function`, `closure`에 대한 추가적인 공부 필요

### 

# Reference
- [스위프트 75문 75답 모음](https://jeonyeohun.tistory.com/331)
- [스위프트 개발자 면접 질문 모음집](https://jasunhee.tistory.com/253)