# Beginner 질문

kodeco에서 준비된 interview Question에 대한 답을 정리합니다.

## Beginner Written Questions
### Question #1
다음 코드에서 
```swift
struct Tutorial {
  var difficulty: Int = 1
}

var tutorial1 = Tutorial()
var tutorial2 = tutorial1
tutorial2.difficulty = 2
```
`tutorial1.difficulty`와 `tutorial2.difficulty`값은 무엇인가요? 만약 `Tutorial`이 클래스타입이였다면 어떤가요?

**나의 답**
    `tutorial1.difficulty`는 1, t=`tutorial2.difficulty`는 2일 것이다. 구조체는 값타입이고, 다른 변수에 할당되면 값의 복사가 일어나기 때문이다. 클래스라면 두 인스턴스의 difficulty프로퍼티의 값이 둘다 2일 것이다. 

**해설**
tutofial1.difficulty = 1, tutorial2.difficulty = 2이다. 구조체는 Swift의 값 타입이다. 참조가 아닌 값을 복사한다. 그러므로 아래의 코드는 tutorial1의 복사본을 tutorial2에 대입(assign) 하는 코드일 것이다.
```
var tutorial2 = tutorial1
```
따라서 tutorial2의 변경사항이 tutorial1에 반영되지 않는다.

만약 Tutorial이 클래스타입이였다면 두 인스턴스의 difficulty프로퍼티의 값이 모두 2일 것이다. 클래스는 스위프트의 참조타입으로 두개의 변수가 같은 인스턴스를 보고있으므로 tutorial1의 프로퍼티를 변경하면 tutorial2에도 영향을 미친다.

### Question #2

`var`로 `view1`을 선언하고, `let`으로 `view2`를 선언했습니다. 차이점이 무엇이고, 마지막줄이 컴파일 될까요?

```swift
import UIKit

var view1 = UIView()
view1.alpha = 0.5

let view2 = UIView()
view2.alpha = 0.5 // Will this line compile?
```

**나의 답**
    `UIView`는 클래스타입이므로 상수 `let`으로 선언되어있어도 프로퍼티를 수정할 수 있고, 컴파일에는 문제가 없을 것이다. 클래스타입은 참조타입이고 참조의 대상을 바꾸지만 않으면 되기 때문이다.

**해설**
마지막 줄은 컴파일이 된다. view1은 변수이고 UIView의 인스턴스를 재할당(reassign)할 수 있다. let 키워드로는 한번만 할당(assign)이 가능하므로 아래의 코드는 컴파일이 불가능하다.
```swift
view2 = view1 // Error: view2 is immutable
```
하지만 UIView는 클래스이며 참조 시멘틱(reference semantics)이므로 view2의 프로퍼티를 변경할 수 있다.
```swift
let view2 = UIView()
view2.alpha = 0.5 // Yes!
```

### Question #3
다음 코드는 알파벳 배열을 정렬하는 코드입니다. 클로저를 할수있는만큼 간단하게 만들어보세요
```swift
var animals = ["fish", "cat", "chicken", "dog"]
animals.sort { (one: String, two: String) -> Bool in
    return one < two
}
print(animals)
```

**나의 답**
```swift
var animals = ["fish", "cat", "chicken", "dog"]
animals.sort(by: <)
print(animals)
```

**해설**
타입추론 시스템이 자동으로 클로저 내의 두 매개변수와 반환값의 타입을 계산할 것이다. 그러므로 해당 부분을 코드에서 제거할 수 있다.
```swift
animals.sort { (one, two) in return one < two }
```
또한, `$i` 표기(notation)로 매개변수의 이름을 대체(substitute) 할 수 있다.
```swift
animals.sort { return $0 < $1 }
```
single statement 클로저에서는 return 키워드를 생략할 수 있다. 마지막 구문(last statement)의 값이 클로저의 반환값이 된다.
```swift
animals.sort { $0 < $1 }
```
마지막으로, Swift는 배열의 원소들이 `Equatable` 프로토콜을 채택하는 것을 알고 있으므로 아래와 같이 간단하게 쓸 수 있다.
```swift
animals.sort(by: <)
```

## Question #4
아래의 코드는 Address와 Person이라는 클래스를 생성하고 있습니다. 그리고 Ray와 Brian을 나타내기 위해 두개의 Person 클래스 인스턴스를 생성합니다.
```swift
class Address {
    var fullAddress: String
    var city: String

    init(fullAddress: String, city: String) {
        self.fullAddress = fullAddress
        self.city = city
    }
}

class Person {
    var name: String
    var address: Address

    init(name: String, address: Address) {
        self.name = name
        self.address = address
    }
}

var headquarters = Address(fullAddress: "123 Tutorial Street", city: "Appletown")
var ray = Person(name: "Ray", address: headquarters)
var brian = Person(name: "Brian", address: headquarters)
```
Brian이 반대편에 있는 집으로 이사를 갔다고 가정해봅시다. 이때, 주소를 다음과 같이 수정하고 싶습니다.
```swift
brian.address.fullAddress = "148 Tutorial Street"
```
빌드를 해보면 에러없이 컴파일이 잘 되는 것을 확인할 수 있습니다. 그리고 **Ray의 주소(address)를 확인해 보았을때, Ray또한 새로운 집으로 이사된것을 확인할 수 있습니다.** 이런현상이 왜 발생했을까요?

**나의 답**
Address는 클래스로, 참조타입으로 ray와 brian의 address프로퍼티가 동일한 Address인스턴스를 참조하고 있습니다. 따라서 Brian을 통해서 address인스턴스의 프로퍼티를 수정했을때, ray도 바뀐 것처럼 보이는 것입니다. 

**해설**
Address는 클래스이며 참조 시멘틱(reference semantics)이므로 headquarters는 ray나 brian 중 어떤 객체를 통해 접근해도 동일한 인스턴스이다. headquarters의 주소를 바꿈으로써 두 쪽 모두 바꾸게 될 것이다. 이를 해결하기 위한 방법은 brian을 위한 Address를 새로 생성하든지 Address를 구조체로 바꾸는 것이다.

## Question #5
옵셔널이란 무엇이고, 어떤문제를 해결해주산요?

**나의 답**
옵셔널은 한변수의 "값의 부재"를 허용해주는 기능이다. 옵셔널을 통해 데이터의 값 자체뿐만 아니라 **데이터가 있고 없음을 표현할 수 있다.**

**해설**
옵셔널은 값의 부재(lack of value)를 허용한다. Objective-C에서는 값의 부재가 nil이라는 특별한 값을 이용하여 참조타입에만 허용됐었다. 값 타입의 경우 (int, float과 같은) 이런 것이 불가능했다.

Swift는 값의 부재를 참조와 값 타입 모두에 대해 확장한다. 옵셔널 변수는 특정 값이나 nil을 가질 수 있다.

## Question #6
구조체와 클래스의 차이점을 간단하게 요약하시오

**나의 답**
- 구조체는 값타입이다. 상속을 지원하지 않는다.
- 클래스는 참조타입이다. 상속을 지원한다.

**해설**
나의 답과 동일

## Question #7
제네릭이란 무엇이고 어떤 문제를 해결해주나요?

**나의 답**
제네릭은 타입을 특정하지 않고 또 특정 클래스나 프로토콜을 채택한 자료형을 받아들일 수 있도록 해준다. 여러타입으로 구현되어야 하는 코드 등 중복된 코드를 줄여준다. 

**해설**
Swift에서는 generics를 데이터(클래스, 구조체, 열거형)와 함수 모두에 대해 사용할 수 있다.

Generics는 코드 중복의 문제를 해결한다. 한 타입의 매개변수를 받는 메소드가 있을 때 일반적으로 다른 타입에 대해 동일한 메소드를 수행하기 위해서는 이 메소드를 복제하기 마련이다.

예를 들어 아래 코드에서 second function은 first function과 정수 대신 문자열을 매개변수로 받는 것을 제외하고 동일하다(clone)
```swift
func areIntEqual(_ x: Int, _ y: Int) -> Bool {
    return x == y
}

func areStringsEqual(_ x: String, _ y: String) -> Bool {
    return x == y
}

areStringsEqual("ray", "ray") // true
areIntEqual(1, 1) // true
```
generics를 사용(adopt)함으로써, 두 함수를 하나로 합칠수 있고 type safety를 지킬 수 있다.
```swift
func areTheyEqual<T: Equatable>(_ x: T, _ y: T) -> Bool {
    return x == y
}

areTheyEqual("ray", "ray")
areTheyEqual(1, 1)
```
이 경우에는 equality를 체크하는 메소드이기 때문에 매개변수로 전달되는 모든 타입은 Equatable 프로토콜을 구현해야한다.



        

    