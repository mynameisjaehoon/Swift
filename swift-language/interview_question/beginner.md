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
빌드를 해보면 에러없이 컴파일이 잘 되는 것을 확인할 수 있습니다. 그리고 **Ray의 주소를 확인해 보았을때, Ray또한 새로운 집으로 이사된것을 확인할 수 있습니다.** 이런현상이 왜 발생했을까요?

**나의 답**


**해설**



### 1. Optional이 무엇이고, 어떤 문제를 해결해주나요?
옵셔널은 값이 없음을 나타낼 수 있게 해줍니다. 값이 있을 수도 있고 없을 수도 있음을 나타냅니다.
오브젝티브 C에서는 어떤 객체 참조값이든 nil이 될수 있기 때문에 오브젝티브 C로부터 nil을 받을 수 있어야 했고, 또 변수, 인스턴스, 프로퍼티의 초기화를 연기할 수 있다는 점도 있습니다.

### 2. 구조체와 클래스의 주요 차이점을 말해주세요.
- 클래스, 구조체의 공통점
    - 값을 저장할 프로퍼티를 선언할 수 있습니다..
    - 함수적 기능을 하는 메서드를 선언할 수 있습니다.
    - 생성자를 이용해서 초기 상태를 설정할 수 있습니다.
    - 익스텐션을 사용하여 기능을 확장할 수 있습니다.
    - 프로토콜을 채택하여 기능을 설정할 수 있습니다.
- 클래스 구조체의 차이점
    - 클래스
        - 참조타입 입니다.
        - ARC로 메모리를 관리합니다.
        - 같은 클래스 인스턴스를 여러개의 변수에 할당한 뒤 값을 변경시키면 할당한 모든 변수에 영향을 줍니다.
        - 상속이 가능합니다.
        - 타입 캐스팅을 통해 런타임에서 클래스 인스턴스의 타입을 확인할 수 있습니다.
        - `deinit`을 통하여 클래스 인스턴스의 메모리 할당을 해제할 수 있습니다.
    - 구조체
        - 값타입 입니다.
        - 구조체 변수를 새로운 변수에 할당하고 새로운 구조체가 할당됩니다. Copy on write는 원시타입과 Collection들에만 구현되어 있어서  커스텀 구조체에서는 직접 구현해주어야 합니다.

### 3. 제네릭이란 무엇이고 어떤문제를 해결해주나요?
- 제네릭은 코드가 중복되는 문제를 해결해줍니다. 메서드의 파라미터로 특정 타입만 받도록 구현해놓으면 다른 타입을 받아야 할때 똑같은 기능을 하는 메서드를 한번더 선언해야 하는 문제를 해결해줍니다.

### 4. 암묵적 언래핑을 피할 수 없는 경우가 있습니다. 언제, 왜 그런가요?
- 이니셜라이저를 통한 초기화 시간에 프로퍼티를 초기화할 수 없는 경우 사용하게 됩니다. 대표적인 예로는 Interface Builder Outlet이 있습니다. 




        

    