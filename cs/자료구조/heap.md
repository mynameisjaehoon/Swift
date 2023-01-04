# 힙

---

## 힙이란?
- **완전이진트리**의 일종으로, 우선순위 큐를 위하여 만들어진 자료구조이다.
- 여러개의 값들 중에서 최댓값이나 최솟값을 빠르게 찾아내도록 만들어진 자료구조이다.
- 힙은 일종의 반정렬 상태(느슨한 정렬 상태)를 유지한다.
    - 큰 값이 상위레벨에 있고 작은 값이 하위레벨에 있다는 정도
    - 간단히 말하면 부모노드의 키값이 자식노드의 키값보다 항상 큰(작은)이진트리를 말한다.
- 힙 트리에서는 중복된 값을 허용한다.
## 힙의 종류
- 최대 힙(max heap)
    - 부모 노드의 키 값이 자식 노드의 키 값보다 크거나 같은 완전 이진 트리
    - `key(부모 노드) >= key(자식 노드)`
- 최소 힙(min heap)
    - 부모 노드의 키 값이 자식 노드의 키 값보다 작거나 같은 완전 이진 트리
    - key(부모 노드) <= key(자식 노드)

<p>
<img width="60%" src="https://user-images.githubusercontent.com/76734067/210577347-d4a1f458-5d78-4190-9b64-38e9bdac0af1.png">
</p>

## 힙 구현하기
- 힙을 저장하는 표준적인 자료구조는 **배열** 이다.
- 구현을 쉽게 하기 위하여 배열의 첫 번째 인덱스인 0은 사용되지 않는다.
- 특정 위치의 노드 번호는 새로운 노드가 추가되어도 변하지 않는다.
    - 예를 들어 루트 노드의 오른쪽 노드의 번호는 항상 3이다.
- 힙에서의 부모 노드와 자식 노드의 관계
    - 왼쪽 자식의 인덱스 = `(부모의 인덱스) * 2`
    - 오른쪽 자식의 인덱스 = `(부모의 인덱스) * 2 + 1`
    - 부모의 인덱스 = `(자식의 인덱스) / 2`
<p>
<img width="60%" src="https://user-images.githubusercontent.com/76734067/210577928-c56f8490-4690-4acd-9653-88a583aabd4a.png">
</p>

스위프트로 작성한 힙은 다음과 같다.
```swift
struct Heap<T: Comparable> {
    var heap: Array<T> = []
    
    init() {  }
    init(data: T) {
        heap.append(data) // 0번 index 채우기용. 편의를 위해서 1번인덱스부터 시작한다.
        heap.append(data) // 실제 루트노드 채우기
    }
}
```


### 힙의 삽입

1. 힙에 새로운 요소가 들어오면, 일단 새로운 노드를 힙의 마지막 노드에 이어서 삽입한다.
2. 새로운 노드를 부모 노드들과 교환해서 힙의 성질을 만족시킨다.

아래의 이미지는 최대 힙(max heap)에 새로운 요소 8을 삽입하는 것이다.

<p>
<img width="70%" src="https://user-images.githubusercontent.com/76734067/210590299-3a94899c-ad11-4e93-b47a-d317b80db03d.png">
</p>

스위프트를 이용해서 힙의 삽입을 구현해보자
```swift
mutating func insert(_ data: T) {
    if heap.count == 0 {
        heap.append(data)
        heap.append(data)
        return
    }
    
    heap.append(data)
    
    func isMoveUp(_ insertIndex: Int) -> Bool {
        if insertIndex <= 1 {
            return false
        }
        
        let parentIndex: Int = insertIndex / 2
        return heap[insertIndex] > heap[parentIndex] ? true : false
    }
    
    var insertIndex: Int = heap.count - 1
    while isMoveUp(insertIndex) {
        let parentIndex: Int = insertIndex / 2
        heap.swapAt(insertIndex, parentIndex)
        insertIndex = parentIndex
    }
}
```

### 데이터 꺼내기(삭제하기)
1. 최대 힙에서 최댓값은 루트노드이므로 루트노드가 삭제된다.
2. 삭제된 루트노드에는 힙의 마지막 노드를 가져온다.
3. 힙을 재구성한다.

아래의 이미지는 최대힙(max Heap)에서 최댓값을 삭제하는 모습이다.

<p>
<img width="60%" src="https://user-images.githubusercontent.com/76734067/210594572-0fbaeaed-1d7c-43bc-ad89-49d3142b76f6.png">
</p>

스위프트를 사용해서 힙의 데이터 꺼내기(삭제)를 구현해보자
```swift
enum moveDownStatus { case none, left, right }

mutating func pop() -> T? {
    if heap.count <= 1 { return nil }
    
    let returnData = heap[1]
    heap.swapAt(1, heap.count-1)
    heap.removeLast()
    
    func moveDown(_ poppedIndex: Int) -> moveDownStatus {
        let leftChildIndex = (poppedIndex * 2)
        let rightChildIndex = leftChildIndex + 1
        
        if leftChildIndex >= heap.count {
            return .none
        }
        
        if rightChildIndex >= heap.count {
            return heap[leftChildIndex] > heap[poppedIndex] ? .left : .none
        }
        
        let isLeftChildSmaller = heap[leftChildIndex] < heap[poppedIndex]
        let isRightChildSmaller = heap[rightChildIndex] < heap[poppedIndex]
        let isLeftChildBiggerThanRight = heap[leftChildIndex] > heap[rightChildIndex]
        
        if isLeftChildSmaller && isRightChildSmaller {
            return isLeftChildBiggerThanRight ? .left : .right
        }
        
        return isLeftChildBiggerThanRight ? .left : .right
    }
    
    var poppedIndex = 1
    while true {
        switch moveDown(poppedIndex) {
        case .none:
            return returnData
        case .left:
            let leftChildIndex = poppedIndex * 2
            heap.swapAt(poppedIndex, leftChildIndex)
            poppedIndex = leftChildIndex
        case .right:
            let rightChildIndex = poppedIndex * 2 + 1
            heap.swapAt(poppedIndex, rightChildIndex)
            poppedIndex = rightChildIndex
        }
    }
}
```

# Reference
- [Github 블로그 - 힙(heap)이란?](https://gmlwjd9405.github.io/2018/05/10/data-structure-heap.html)
- [티스토리 - Swift) 힙(Heap)](https://babbab2.tistory.com/109)