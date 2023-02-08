# 스위프트와 함수형 프로그래밍

스위프트는 함수형프로그래밍 패러다임을 지향한다. 면접때에도 함수형 프로그래밍에 대해 설명해달라는 요청을 받았으나 제대로 설명하지 못했다 간단하게 스위프트에 있는 클로저등도 함수형프로그래밍의 특징이라고 하는데 자세히 알아보자.

## 함수형 프로그래밍이란?
- 프로그램이 상태의 변화 없이 데이터 처리를 수학적 함수의 계산으로 취급하고자 하는 프로그래밍
- 값이나 상태의 변화보다는 함수 자체의 응용을 중요하게 여긴다.
- 코드 이해와 실행 결과의 관점에서, 순수하게 함수에 전달된 인자 값만 결과에 영향을 주기 때문에 **상태 값을 갖지 않고 순수하게 함수만으로 동작한다.**
    - 어떤상황에서 프로그램을 실행하더라도 **일정하게 같은 결과**를 도출할 수 있다.
- 프로그램 동작과정에서 상태가 변하지 않으면 함수 호출이 각각 상호간섭없이 실행되므로 병렬처리를 할 때 부작용이 거의 없다는 장점이 있습니다.
    - 필요한 만큼 함수를 나누어서 처리할 수 있도록 스케일업 할 수 있기 때문에 대규모 병렬처리에 큰 강점을 가집니다.


## 일급 객체란?

또다른 함수형 프로그래밍의 특징으로는 함수를 일급 객체로 다룬다는 점입니다.

### 일급객체의 조건
- 전달인자로 전달할 수 있다.
- 동적 프로퍼티 할당이 가능하다.
- 변수나 데이터 구조 안에 담을 수 있따.
- 반환 값으로 사용할 수 있다.
- 할당할 때 사용된 이름과 관계없이 고유한 객체로 구별 가능하다.

스위프트에서 함수는 일급객체의 조건을 모두 갖출 수 있기 때문에 함수를 일급 객체로 취급합니다.

## 고차함수
고차함수(Higher-order function)은 `다른 함수를 전달인자로 받거나 함수실행의 결과를 함수로 반환하는 함수`를 뜻합니다.

스위프트의 함수(클로저)또한 일급 객체이기 때문에 함수의 전달인자로 전달할 수 있으며 함수의 결과값으로도 반환할 수 있습니다. 스위프트 라이브러리에서 제공하는 고차함수로는 `map`, `filter`, `reduce`, `compactMap`, `flatMap`등이 있습니다.
