## map
`map`은 배열 내부의 값을 하나씩 매핑한다고 생가갛면 된다.
배열에 대한 각 요소에 대한 값을 변경하고자 할 때 사용하고, 각 값을 변경한 상태의 배열을 넘겨준다.
```swift
func map<T>(_ transform: (Self.Element) throws -> T) rethrows -> [T]
```

## flatMap, compactMap
swift 4.1부터는 `flatMap`이 `compactMap`으로 변경되었다고 한다. 그렇다고 flatMap이 없어진 것은 아니다.
### 정의
- flatMap
    ```swift
    func flatMap<SegmentOfResult>(_ transform: (Self.Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence
    ```

- compactMap

    컨테이너 각각의 요소에 조건을 적용하고, `nil`이 아닌 배열을 반환한다.

    컨테이너의 요소를 매개변수로 받아서 선택적으로 값을 반환하는 클로저입니다.
    ```swift
    func compactMap<ElementOfResult>(_ transform: (Self.Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
    ```

    `map`과 `compactMap`으로 간단하게 실행해보면 다음과 같은 결과를 얻을 수 있습니다.
    ```swift
    let array = ["1", "2", "3", "4", "five"]

    let mapResult = array.map{ Int($0) }
    print(mapResult) // [Optional(1), Optional(2), Optional(3), Optional(4), nil]

    let compactMapResult = array.compactMap{ Int($0) }
    print(compactMapResult) // [1, 2, 3, 4]
    ```

    `map`은 옵셔널을 처리해주지 않는데, `compactMap`의 결과는 `nil`을 포함하지 않고, 
    옵셔널 바인딩까지 해주는 것을 확인할 수 있었습니다.

`flatMap`이나 `compactMap`이나 일차원배열에서는 동일한 결과를 나타냅니다.

`flatMap`의 원래 역할은 다음과 같았습니다.
1. 배열을 flat하게 만들어준다.
2. `nil`을 제거한다.
3. 옵셔널 바인딩을 해준다.

`Swift 4.1` 이후부터는 1차원배열에서 위와같은 역할을 하고싶을 때는 `compactMap`을 사용하면 됩니다.

1차원배열이 아니라 2차원배열일 경우에는 `flatMap`이나 `compactMap`이 `nil`을 제거하지 않습니다.

다른점은 `flatMap`은 2차원 배열을 1차원배열로 `flatten`하게 만들어주는 반면, `compactMap`은 1차원
배열로 만들지 않고 2차원배열의 모습을 그대로 유지해준다는 차이점이 있네요

2차원배열을 1차원배열로 만들고 싶다면 `flatMap`을 사용하면 됩니다.
