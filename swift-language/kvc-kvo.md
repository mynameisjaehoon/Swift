# KVC (Key-Value Coding)
- 객체의 값을 직접 가져오지 않고 Key또는 KeyPath를 이용해서 간접적으로 데이터를 가져오거나 수정하는 방법.
- keyPath는 `\BaseType.PropertyName`으로 KeyPath를 만들 수 있다.


# KVO(Key-Value Observing)

KVO란 특정 객체의 프로퍼티 변경사항을 다른 객체에 알리기 위해 사용하는 코코아 프로그래밍 패턴이다.

## 특징
- KVO를 사용하려면 `NSObject`를 상속받은 클래스이어야 한다. (순수 스위프트 코드의 작성이 어렵다.)
- 상속을 받아야하기 때문에 클래스에서만 사용이 가능하다.
- observe하려는 프로퍼티에 `@objc`attribute와 `dynamic`modifier를 추가해주어야한다.
    - dynamic modifier를 선언함으로써 Objective-C 런타임 방식을 사용하겠다는 것이고, 런타임 시점에 호출해야할 특정 메서드의 구현을 결정하게 된다.

## 언제사용되나요?
- 모델 객체에서 값이 변경되었을 경우, 변경된 값을 UI에 반영해야할 때 사용합니다.
- 모델 객체에 대허서 `observe`를 도입하여 델리게이트에 메세지를 보내 처리하게하는 방식으로 주로 사용된다.

## 장단점
- **장점**
    1. 두 객체간의 동기화가 가능하다(Model과 View와 같이 분리된 파트간의 변경사항을 전달하기에 유용하다.)
    2. 내부 소스의 변경없이, 상태변화에 대응할 수 있다.
        - 라이브러리에 들어있는 , 내가 변경하지 못하는 코드가 `@objc dynamic`으로 선언되어있는 경우 변경사항을 감지할 수 있게 된다. 그런데 이 경우에는 라이브러리의 클래스가 `NSObject`를 상속하지 않고, 또 `@objc dynamic`도 붙어이씾 않다면 사용하지 못하는 것 아닌가? 하는 생각도 든다.
    3. 변경전/후의 값을 파악할 수 있다.
        - 변경 전/후의 값을 `WillSet/DidSet`과 비슷하게 `newValue`, `oldValue`라는 프로퍼티들로 확인할 수있다. `willSet/DidSet`을 정의한 프로퍼티는 타입 정의 내부에 위치해야하는 반면에 KVO는 타입 정의 외부에서 observer를 추가할 때 사용한다는 점이 다르다.
    4. observer를 따로 해제해주지 않아도 된다. 시스템이 알아서 옵저버를 제거해준다.
        - 이 [포스트](https://fpotter.org/posts/when-is-kvo-unregistration-automatic)에 따르면 iOS 11 이상의 버전이라면 자동으로 해제해 준다는 것 같다.
- **단점**
    - NSObject를 상속해야하므로 Objective-C 런타임에 의존하게 된다.
