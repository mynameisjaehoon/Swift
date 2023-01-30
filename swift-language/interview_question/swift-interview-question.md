# Swift 질문모음

<details>
<summary><h4>class와 struct의 차이점에 대해 설명해주세요</h4></summary>
<div markdown="1">  

클래스는 참조타입, 구조체는 값타입으로 모든 경우에 그런것은 아니지만 클래스는 주로 힙에, 구조체는 스택에 저장됩니다. 클래스 같은경우는 ARC로 참조 카운트를 관리하고 상속이 가능하다는 특징이 있습니다. 
클래스는 참조타입이기 때문에 다른 변수에 기존에 있던 인스턴스를 할당하게 되면 하나의 변수에서 프로퍼티를 수정했을때 다른 변수로 조회해도 변경되어있는 것을 확인할 수 있고, 구조체는 다른변수에 할당하면 복사가 일어나기 때문에 다른변수에서 프로퍼티를 수정해도 기존변수에는 변화가 일어나지 않습니다.
클래스는 주로 힙에, 구조체는 주로 스택에 저장된다는 특징 때문에 비용은 클래스가 더 많이 듭니다. 스택같은경우는 컴파일타임에 언제 할당되고 해제되는 지를 미리 알고있고 스레드마다 스택을 따로 가지고 있기 때문에 동기화의 비용도 들지 않습니다. 하지만 힙은 참조에 대한 계산도 해주어야하고 동기화도 고려해야하므로 비용이 더 들게됩니다.
</details>
<details>
<summary><h4>클래스는 무조건 힙에, 구조체는 무조건 스택에 저장되는 것인가요?</h4></summary>
<div markdown="1">  

코딩을 하다보면 클래스안에 구조체 프로퍼티가 있거나, 구조체 안에 클래스 프로퍼티가 존재하게 되는 경우가 있습니다.
클래스안에 구조체 프로퍼티가 존재하는 경우에는 클래스가 메모리에서 해제되기 전에 구조체가 해제되지 않도록 값타입도 힙에 저장하게 됩니다.
</details>
<details>
<summary><h4>Copy on write는 어떤 방식으로 동작하는지 설명해보시오.</h4></summary>
<div markdown="1">  

Copy On Write는 값타입의 데이터를 다른 변수에 할당했을때 바로 복사가 이루어지지 않고 데이터의 변경일어났을 때 복사가 일어나게 됩니다. 
</details>
<details>
<summary><h4>AnyObject에 대해 설명하시오.</h4></summary>
<div markdown="1">  

AnyObject는 모든 클래스 타입의 인스턴스를 나타내는 프로토콜입니다. 모든 클래스가 AnyObject 프로토콜 암시적으로 준수하게 됩니다.
</details>
<details>
<summary><h4>Optional이란 무엇인지 설명하시오</h4></summary>
<div markdown="1">  

Optional이란 스위프트에서 값이 있을 수도 있고, 없을수도 있다 라는 것을 표현하기 위해서 사용하는 것입니다. 변수의 타입 뒤에 `?`를 붙여서 표현합니다. 옵셔널 타입을 선언함으로써 값이 없다라는 의미인 `nil`을 변수에 넣어줄 수 있게 됩니다.

또 Optional로 선언된 변수들은 값이 있는 것인지, nil인 것인지 wrap되어서 모르는 상태가 됩니다. 실제로 옵셔널 변수를 그냥 출력해보면 value가 있다고 하더라고 value가 바로 출력되지 않고 `Optional`로 감싸져 있는 형태로 출력됩니다. 이 wrapping되어있는것을 사용하기 위해서는 Unwrapping이라는 과정이 필요합니다.
</details>
<details>
<summary><h4>subscript에 대해 설명하시오</h4></summary>
<div markdown="1">  

클래스, 구조체, 열거형에서 시퀀스의 멤버요소에 접근하기 위한 바로가기 문법을 말합니다. 대표적으로 배열에서 대괄호안에 index를 넣어줘서 멤버요소에 접근하는 것있습니다.

콜렉션, 리스트, 시퀀스 등 집합의 특정 member elements에 간단하게 접근할 수 있는 문법을 말합니다. 입력되는 숫자에 제한이 없고, 입력 인자의 타입과 반환되는 타입에 제한도 없습니다. 하지만 in-out인자나 기본인자값을 제공할 수는 없습니다.
</details>
<details>
<summary><h4>String은 왜 subscript로 접근이 안되는지 설명하시오.</h4></summary>
<div markdown="1">  

인덱스로 접근한다는 것은 배열에서 메모리의 주소를 계산해서 데이터 타입의 크기만큼 읽어들인 다는 것을 의미한다. String을 먼저 살펴보면 구조체이고, Character의 Collection, 즉 Array<Element>에서 element가 Character인 배열입니다. Swift에서 Character는 1개 이상의 Unicode Scalar로 이루어져있기 때문에 크기가 가변적입니다. 따라서 다른 언어 와 같이 정수로 접근해서 저장되어있는 위치를 정확하게 계산할 수 없기 때문에 subscript로 접근할 수 없습니다.

따라서 String은 subscript를 `Int`가 아니라 `String.Index`를 통해서 값을 확인할 수 없습니다.
</details>
<details>
<summary><h4>instance 메서드와 class 메서드의 차이점을 설명하시오.</h4></summary>
<div markdown="1">  
</details>
<details>
<summary><h4>class 메서드와 static 메서드의 차이점을 설명하시오.</h4></summary>
<div markdown="1">  
</details>

<details>
<summary><h4>Delegate 패턴을 활용하는 경우를 예를 들어 설명하시오.</h4></summary>
<div markdown="1">  
</details>
<details>
<summary><h4>Singleton 패턴을 활용하는 경우를 예를 들어 설명하시오.</h4></summary>
<div markdown="1">  
</details>
<details>
<summary><h4>KVO 동작 방식에 대해 설명하시오.</h4></summary>
<div markdown="1">  
</details>
<details>
<summary><h4>Delegates와 Notification 방식의 차이점에 대해 설명하시오.</h4></summary>
<div markdown="1">  
</details>
<details>
<summary><h4>멀티 쓰레드로 동작하는 앱을 작성하고 싶을 때 고려할 수 있는 방식들을 설명하시오.</h4></summary>
<div markdown="1">  
</details>
<details>
<summary><h4>MVC 구조에 대해 블록 그림을 그리고, 각 역할과 흐름을 설명하시오.</h4></summary>
<div markdown="1">  
</details>
<details>
<summary><h4>프로토콜이란 무엇인지 설명하시오.</h4></summary>
<div markdown="1">  
</details>
<details>
<summary><h4>Protocol Oriented Programming과 Object Oriented Programming의 차이점을 설명하시오.</h4></summary>
<div markdown="1">  
</details>
<details>
<summary><h4>Hashable이 무엇이고, Equatable을 왜 상속해야 하는지 설명하시오.</h4></summary>
<div markdown="1">  
</details>
<details>
<summary><h4>mutating 키워드에 대해 설명하시오.</h4></summary>
<div markdown="1">  
</details>
<details>
<summary><h4>탈출 클로저에 대하여 설명하시오.</h4></summary>
<div markdown="1">  
</details>
<details>
<summary><h4></h4></summary>
<div markdown="1">  
</details>