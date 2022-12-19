# Set

- [Set 생성하기](#set-생성하기)
- [Set의 개수 확인하기](#set의-개수-확인하기)
- [Set에 어떤 원소가 있는지 확인하기](#set에-어떤-원소가-있는지-확인하기)
- [Set에 값 추가하기](#set에-값-추가하기)

---

- 집합(Set)은 정렬되지 않은 컬렉션이다.
- 중복된 요소를 포함시키고 싶지 않을 때 사용하자.
- 해시를 통해서 검색하기 때문에 배열에 비해서 검색속도가 빠르다.
- Set에 들어갈 수 있는 요소는 `Hashable`프로토콜을 준수해야한다.

## Set 생성하기
```swift
// Set은 배열과 다르기 때문에 타입 추론으로는 생성할 수 없다.
// 아래의 코드는 Set이 아닌 Array로 추론된다.
var mySet1 = [1,5,2,3,2,1]

// 타입 Annotation으로 생성하기
var mySet2: Set<Int> = []

// 생성자로 생성하기
var mySet3 = Set<Int>()
```
`Set`을 생성하는 방법에는 다음 두가지 방법이 있다.
1. 타입 Annotation으로 생성하기
2. 생성자로 생성하기

Set은 배열과 동일하게 대괄호 `[]` 로 생성하기 때문에 타입추론으로는 생성할 수 없음에 유의해야한다.<br>
여러타입을 저장하고 싶을 경우, `Any`타입을 넣을 수 있는 딕셔너리와는 다르게 `Hashable`을 준수하는 자료형만 저장할 수 있음에 유의해야한다.

여러 타입을 저장하고 싶다면 Objective-C의 NSSet을 사용하면 된다.
```swift
// 여러 타입을 저장하는 Set은 NSSet을 사용한다.
var mySet4: NSSet = [1, "string"]
```

## Set의 개수 확인하기
- `count`프로퍼티를 통해서 간단하게 몇개의 원소가 있는지 확인할 수 있다.
- Set이 비어있는지의 확인은 `isEmpty`프로퍼티를 사용하도록 하자.
```swift
var mySet1: Set<Int> = [1,5,2,3,2,1]

print(mySet1.count) // 6
print(mySet1.isEmpty) // false
```

## Set에 어떤 원소가 있는지 확인하기
- 배열과 동일하게 `contains`메서드를 사용해서 원소가 Set안에 존재하는지 확인할 수 있다.
- 배열은 처음부터 끝까지 탐색해 나가면서 원소가 있는지 찾기 때문에 `O(N)`시간이 걸리지만, Set은 해시로 구현되어있어 시간복잡도가 `O(1)`에 불과하다.
```swift
var mySet1: Set<Int> = [1,5,2,3,2,1]

print(mySet1.contains(1)) // true
```

## Set에 값 추가하기
- `insert` 메서드
    - 값이 존재하지 않았을 때 값을 추가하고 `(true, 추가된 값)`을 리턴한다.
    - 값이 중복될 때는 값을 추가하고 `(false, 추가된 값)`을 리턴한다.
- `update` 메서드
    - 값이 존재하지 않으면 추가하고 nil을 리턴한다.
    - 값이 존재하면 덮어쓰고, 덮어쓰기 이전의 값을 리턴한다.

```swift
var mySet1: Set<Int> = [1,4,2,3,5]

print(mySet1.insert(1)) // (inserted: false, memberAfterInsert: 1)
print(mySet1.insert(10)) // (inserted: true, memberAfterInsert: 10)

print(mySet1.update(with: 1)) // Optional(1)
print(mySet1.update(with: 12)) // nil
```

## Set 원소 삭제하기
- `remove` 메서드
    - 한가지 요소를 삭제할 때 사용한다. 삭제 후 삭제한 값을 리턴하고, 없는 요소를 삭제할 때는 `nil`을 리턴한다.
- `removeAll` 메서드
    - Set의 전체 요소를 삭제한다.

```swift
var mySet1: Set<Int> = [1,4,2,3,5]

print(mySet1.remove(1)) // Optional(1)
print(mySet1.remove(10)) // nil

mySet1.removeAll() // 전체삭제
print(mySet1) // []
```

## 다른 Set과 비교하기
- ==와 != 연산자로 비교할 수 있다.
- 순서에 상관없이 모든 원소가 같으면 같은것으로 판단된다.
```swift
let mySet2: Set<Int> = [1,2,5,0]
let mySet3: Set<Int> = [2,0,5,1]

print(mySet2 == mySet3) // true
```

## Set 연산
- 교집합
    - `a.intersection(b)`
- 차집합
    - `a.subtracting(b)`
- 대칭차
    - `a.symmetricDifference(b)`
- 합집합
    - `a.union(b)`