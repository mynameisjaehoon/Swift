## MRC
- Manual Reference Counting
- `retain`, `release`, `autorelease`등의 명령어를 사용하여 수동으로 메모리를 관리하는 방법이다.
    - `retain`: retain count(= reference count)를 증가시켜서 현재 Scope에 객체가 유지되는 것을 보장한다.
    - `release`: retain count를 감소시킨다. retain 후에 필요없어졌을 때 사용한다.
    - `autorelease`
        - 참조 카운트가 나중에 감소되는 것을 보장받는 기법이다.
        - 고화질 이미지를 여러개 받는경우, 용량이 기가단위로 넘어가고 메모리가 부족해서 앱이 죽는 경우가 
        발생할 수 있다. 이럴때 autorealse를 사용하여 메모리에서 해제해 줄 수 있다.
        - `autorelease`가 해제될 때 내부의 객체들이 release된다.
        - autorelease pool 을 자주 생성하고 해제하면 오버헤드가 커질 수 있으므로 주의해야한다.

## ARC
- ARC란 자동으로 메모리를 관리해주는, 참조카운트를 관리하고, 카운트가 0이 되면 자동으로 메모리에서 해제해주는 매커니즘이다.
- runtime이 아니라 컴파일 타임에 실행된다.
- retain cycle에 유의해야 한다.
- Objective-C 에서 MRC로 수동으로 메모리를 관리하던 것을 자동으로 해주니 편리하다.
- 코드의 양도 줄어든다.
- 컴파일 타임에 MRC에서 사용하던 `retain`, `release`명령어를 적재적소에 삽입하는 것으로 구현된다.
    - 인스턴스의 초기화가 일어날 때 `retain`명령어가 실행된다.
    - 인스턴스를 마지막으로 실행한 코드 다음에 `release`명령어가 실행된다.
- ARC를 통해서 관리하는 메모리 영역은 Code, Heap, Stack, Data 중에서 Heap 영역이다.
    - Heap은 클래스, 클로저 같은 참조형 데이터가 저장되어 있는 곳이기 때문에 관리가 필요하다.
    - Swift Runtime에 모든 오브젝트에 대한 정보를 HeapObject라는 구조체로 표현하고, `HeapObject`에서 
    Swift 객체를 구성하는 모든 데이터, reference count, type metadata를 담고있다.
        1. 동적할당으로 오브젝트가 생성되면 HeapObject라는 구조체로 정보가 관리
        2. HeapObject 내부에는 reference count도 포함된다.
        3. 클래스의 HeapObject 구조체 인스턴스를 통해서 reference count를 관리할 수 있다.

- retain count, reference count의 차이
    - retain count: 객체에 의해서 유지되는 내부 카운트, retain이 해당 객체로 전송된 횟수
    - reference count: 얼마나 많은 객체가 이 객체를 참조하고 있는지 나타내는 것
    - retain count와 reference count를 같게 만들어주는 것이 메모리 관리의 목표이다.

- weak, unowned
    - 두 클래스가 서로에 대한 강한 참조를 유지하고 있는 경우 강한 참조 사이클(strong reference cycle)이 발생할 수 있다.
    - 강한 참조 사이클이 발생하면 두 클래스가 메모리에서 해제되지 못해 메모리 릭이 발생한다.
    - 레퍼런스 카운트를 증가시키지 않으면서 객체를 참조할 수 있다.
    - 다른 인스턴스가 먼저 사라지는 경우 weak reference, 다른 인스턴스의 수명이 같거나 더 긴경우 unowned reference를 
    사용한다.
    - 약한참조는 런타임에 값을 nil로 변경하는 것을 허락해야하므로 상수 `let`이 아닌 변수 `var`로 선언되어야한다.

- 클로저의 강한 참조 사이클
    - 클로저는 기본적으로 클로저내에서 사용하는 데이터들을 캡쳐하고 있다.
    - 클로저가 인스턴스(self)의 프로퍼티나 메서드에 접근하기 때문에 발생하는 강한 참조 사이클이다.
    - 클로저도 1급객체이기 때문에 참조타입이고, 프로퍼티에 클로저를 할당하게 되면 클로저에 참조를 할당하게 되는 것이다.
    - 


## [weak self]
- 약한 참조(weak reference) 
- 두 가지 이상의 객체가 서로에 대한 강한 참조를 가지면 메모리 릭이 발생한다. 이를 해결하기 위해 약한 참조를 사용한다.
- weak reference 의 특징
    - 인스턴스를 strong하게 유지하지 않는다. weak reference가 참조를 유지 중이여도 참조하고 있는 것이 해제될 수 있다.
    - weak reference는 optional이고 런타임에도 값을 `nil`로 만들 수 있다.
    - 레퍼런스 카운트를 증가시키지 않는다.
- weak self를 사용하는 시점
    - escaping closure에서 지연할당의 가능성이 있는 경우(네트워크 비동기 통신, 타이머 등)
    - escaping closure가 아닐 경우에는 범위내에서 클로저가 실행되므로 strong reference cycle을 유발하지 않아서
    weak self를 사용해줄 필요가 없다.
    - 클로저가 객체에 대한 지연 deallocate 가능성이 있는 경우
        - escaping, non-escaping 클로저 둘다에서 발생할 수 있는 상황이다.
        - 클로저가 끝나고 나서 실행한 작업이 끝나는 경우를 말한다. 타이머등을 예로 들 수 있다.
        - 메모리 릭은 아니지만 실제로 작업이 끝나기 전까지 메모리에서 해제되지 않는다.