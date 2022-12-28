# Swift Cache
스위프트의 캐시 하면 역시 `NSCache`를 주로 사용하게 된다. 애플리케이션을 개발하면서 이미지나, API로부터 불러온 정보등을 NSCache에 저장하였는데 
그냥 사용만해왔지 어떤 알고리즘으로 NSCache가 운용되는지는 고민해보지 않은 것 같아 이번기회에 다루어보려고한다.

## NSCache
- `NSCache`는 Cocoa에서 사용할 수 있는 캐싱을 위한 클래스 입니다. `NSDictionary`처럼 Key-Value 형태로 되어 있습니다.
- 메모리가 충분할 때는 주어진 모든 데이터를 캐싱합니다. 반면 가용메모리가 적을 때는 다른 앱을 위해 캐싱된 데이터를 자동으로 버립니다.

### 프로퍼티
- **`countLimit: Int`**
    - NSCache가 캐싱하는 데이터의 개수를 제한할 수 있습니다. `countLimit`이 10인데, 11개의 데이터를 넣게 되면 1개는 자동으로 버리게 됩니다.
- **`totalCostLimit: Int`**
    - 객체를 추가할 때 cost(Int)를 함께 설정할 수 있습니다. `totalCostLimit`은 여기서 cost들의 총합이고, 캐싱된 데이터들의 cost가 `totalCostLimit`을 넘게되면 `NSCache`가 데이터를 버리게 됩니다.
- **`evictsObjectsWithDiscardedContent: Bool`**
    - `NSCache`는 시스템에서 너무 많은 메모리를 사용하지 않도록 디자인 되어있습니다. 그래서 캐싱된 데이터를 지우는 다양한 정책을 사용하고 있습니다.
    - 이 프로퍼티는 캐싱된 데이터가 너무 많은 메모리를 사용했을 때 캐싱된 데이터를 삭제할 지 여부를 결정합니다.

### NSCache구현
- `NSCache`는 기본적으로 연결리스트로 구현되어 있습니다.
- 연결리스트로 구현되어있는 정확한 이유는 찾을 수 없었지만, 캐시의 중간에 있는 데이터 추가와 삭제가 빈번하기 때문에 이를 효율적으로 하기 위해서(연결리스트는 삭제, 삽입의 시간복잡도가 **`O(1)`**)연결리스트로 구현된 것이라 생각됩니다.

### NSCache 데이터 교체 알고리즘
그러면 캐시하는 데이터의 개수 제한이나, 메모리 용량의 제한을 넘게 되었을 때 데이터를 교체하게 되는데 `NSCache`는 어떤 알고리즘을 사용해서 교체하는지 생각해봅시다.
흔히 교체 알고리즘이라고 하면 FIFO, LRU, LFU등의 알고리즘이 사용되는데, `NSCache`는 조금 다른 방식으로 데이터를 교체한다고 합니다.

NSCache는 개별 데이터마다 cost값을 부여하게 되고, `

새로운 데이터를 삽입하는 코드를 살펴보면 다음과 같습니다. 코드는 [apple/swift-corelibs-foundation](https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSCache.swift)에서 읽어보실 수 있습니다.
```swift
private func insert(_ entry: NSCacheEntry<KeyType, ObjectType>) {
    guard var currentElement = _head else {
        // The cache is empty
        entry.prevByCost = nil
        entry.nextByCost = nil
        
        _head = entry
        return
    }
    
    guard entry.cost > currentElement.cost else {
        // Insert entry at the head
        entry.prevByCost = nil
        entry.nextByCost = currentElement
        currentElement.prevByCost = entry
        
        _head = entry
        return
    }
    
    while let nextByCost = currentElement.nextByCost, nextByCost.cost < entry.cost {
        currentElement = nextByCost
    }
    
    // Insert entry between currentElement and nextElement
    let nextElement = currentElement.nextByCost
    
    currentElement.nextByCost = entry
    entry.prevByCost = currentElement
    
    entry.nextByCost = nextElement
    nextElement?.prevByCost = entry
}
```
`NSCache`에 데이터를 추가할 때 cost값을 기준으로 정렬을 수행하는 것을 볼 수 있습니다. 또한 삭제의 경우, 새로운 값을 추가할 때, 값이 작은 데이터들을 순차적으로 제거하여 `totalCostLimit`을 유지하는 방식을 활용하고있습니다.

```swift
var purgeAmount = (totalCostLimit > 0) ? (_totalCost - totalCostLimit) : 0
    while purgeAmount > 0 {
        if let entry = _head {
            delegate?.cache(unsafeDowncast(self, to:NSCache<AnyObject, AnyObject>.self), willEvictObject: entry.value)
            
            _totalCost -= entry.cost
            purgeAmount -= entry.cost
            
            remove(entry) // _head will be changed to next entry in remove(_:)
            _entries[NSCacheKey(entry.key)] = nil
        } else {
            break
    }
}
```
- `open func setObject(_ obj: ObjectType, forKey key: KeyType, cost g: Int)`의 일부 발췌한 것입니다.
- 첫째줄에서 `purgeAmount` 변수의 값을 결정할 때 `totalCostLimit`에 기반해서 제거해야할 데이터의 양을 결정하고 있습니다.
- `purgeAmount`가 줄여야하는 cost의 총량을 의미합니다.

코드의 다른 부분을 살펴보시면 count를 통해서도 해당 작업과 똑같은 것을 수행하시는 것을 볼 수 있습니다.

# Reference
- [애플 공식문서 - NSCache](https://developer.apple.com/documentation/foundation/nscache)
- [애플 깃헙 - NSCache 코드](https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSCache.swift)
- [깃헙 블로그 - NSCache](https://hcn1519.github.io/articles/2018-08/nscache)
- [티스토리 - NSCache에 대해 알아보자!](https://felix-mr.tistory.com/13)