# 코딩테스트를 준비하면서 유의해야할 점들
> 코딩테스트를 준비하면서 유의해야할 점들을 작성하였습니다.

- 자료구조
    - [사전(Dictionary)](사전(Dictionary))

## 사전(Dictionary)
### 사전에 값을 추가하기
```swift
var dict1: [String: Int] = ["weight": 56, "footSize": 270]

// 1. subscript로 추가하기
dict1["weight"] = 53
dict1["footSize"] = 265

// 2. updateValue(forKey:) 메서드 사용하기
dict1.updateValue(53, forKey: "weight")
dict1.updateValue(265, forKey: "footSize")
```
`subscript`로 사용할 경우에는 삽입인지 업데이트인지 알 수 없지만 `updateValue(forKey:)`의 경우에는 리턴값을 통해서 삽입인지 업데이트인지 알 수 있다.
- `subscript`
    - Key 값이 없다면 값을 추가
    - Key 값이 이미 있다면 값을 업데이트
- `updateValue(forKey:)`
    - Key 값이 없다면 추가하고 `nil`을 리턴
    - Key 값이 있다면 덮어쓰고 덮어쓰기 전 값을 리턴

### 사전의 값을 삭제하기
```swift
var dict1: [String: Int] = ["weight": 56, "footSize": 270]

// 1. subscript로 삭제하기
dict1["weight"] = nil
dict1["footSize"] = nil

// 2. removeValue(forKey:)
dict1.removeValue(forKey: "weight")
dict1.removeValue(forKey: "footSize")

// 3. removeAll() -> 전체 삭제
dict1.removeAll()
```

### 키(key), 값(value)만 나열하기
keys, values 프로퍼티를 통해서 키와 값을 배열로 반환받을 수 있다.
값들이 정렬되지 않기 때문에 찍을 때마다 다르게 나온다.
```swift
var dict1: [String: Int] = ["weight": 56, "footSize": 270]

// 1. key 모두 나열하기
dict1.keys // ["weight", "footSize"]
dict1.keys.sorted() // ["footSize", "weight"]

// 2. value 모두 나열하기
dict1.values // [56, 270]
dict1.values.sorted()  // [56, 270]
```

### 사전 검색하기
클로저를 사용해서 원하는 키, 값 쌍이 있는지 확인하거나 쌍을 받아올 수 있다.

이때 클로저의 파라미터는 내가 지정한 딕셔너리의 타입을 가지는 튜플이어야 하고,

반환타입은 무조건 Bool타입이어야한다. ex) `((String, Int) -> Bool)`

```swift
var dict1: [String: Int] = ["weight": 56, "footSize": 270]

let condition: ((String, Int)) -> Bool = {
    $0.0.contains("w")
}

// 클로저 condition을 만족하는 요소가 하나라도 있을 경우 true
dict1.contains(where: condition)

// 클로저 condition을 만족하는 첫 번째 요소를 튜플로 리턴
dict1.first(where: condition)

// 클로저 condition을 만족하는 요소만 새 딕셔너리로 반환
dict1.filter(condition)

```