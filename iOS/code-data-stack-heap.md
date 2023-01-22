# 메모리구조 - Code, Data, Stack, Heap

OS에서 중요하게 등장하는 영역인 코드, 데이터, 스택, 힙 영역을 iOS와 연결지어서 작성해보려 한다. 프로그램을 실행하면
OS에서 메모리 영역을 할당해주는데, 그 메모리 영역이 코드, 데이터, 스택, 힙 영역으로 나누어져 있다. 그리고 이 각 영역에
저장되는 데이터의 종류가 다르다. 아래 그림을 보면 이런 차이점을 확인할 수 있다.

<img width="25%" src="https://user-images.githubusercontent.com/76734067/210954444-672d382d-41a8-42d1-bd5e-7dba7916ea66.png">

## Code
- 코드 영역은 프로그래머가 작성한 소스코드가 0, 1의 바이너리 형태로 저장되는 공간으로, **텍스트영역**이라고도 한다.
- 프로그램 실행 중 수정되어서는 안되므로 읽기전용(Read-Only)로 저장된다.
- CPU가 코드영역에 저장된 명령어를 하나씩 가져가서 처리한다.

## Data
- 전역 변수와 정적(static) 변수가 저장되는 영역이다.
- 프로그램 시작과 함께 할당되며, 프로그램이 종료되면 소멸한다.
```swift 
struct Jaehoon {
    // 정적(static)변수로 데이터 영역에 할당된다.
    static let name: String = "jaehoon so" 
}

// 전역변수로 데이터 영역에 할당된다.
var name: String?
var age: Int?
```

## Stack
- 함수의 호출과 관계되는 지역변수와 매개변수가 저장되는 영역이다.
- 함수의 호출과 함께 할당되고, 함수의 호출이 완료되면 소멸한다.
- 스택영역에 저장되는 함수의 호출정보를 스택프레임(stack frame)이라고 한다.
- LIFO방식으로 작동해서 가장 늦게 저장된 데이터가 가장 빨리 pop된다.
- CPU에 의해서 관리되고 최적화되서 속도가 매우빠르다는 장점이 있다.
- 메모리의 높은주소 -> 낮은 주소 방향으로 할당된다.
```swift
func add(a: Int, b: Int) -> Int { // 매개변수 a, b는 스택영역에 할당된다.
    let result = a + b // 지역변수 result는 스택영역에 할당된다.
    return result
}
```

## Heap
- 사용자에 의해 메모리 공간이 동적으로 할당되고 해제된다.
- 메모리의 낮은 주소 -> 높은 주소 방향으로 할당된다.
```swift
class Person {
    var name: String?
    var age: Int?
}

var person: Person = Person() // 클래스 인스턴스는 힙, person변수는 스택영역에 할당된다.
```

## 비교
### Code & Data vs. Stack & Heap
