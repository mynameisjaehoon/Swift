# Concurrency

Swift는 구조화된 방식으로 비동기 및 병렬 코드를 작성할 수 있도록 지원합니다. 비동기 코드는 한번에 하나의 프로그램만 실행되지만 일시 중단했다가 나중에 다시 시작할 수 있도록 해줍니다. 프로그램에서 코드를 일시 중단했다가 다시 시작하면 UI업데이트 같은 단기 작업은 계속 진행하면서 네트워크를 통한 데이터 통신이나 파일 분석과같은 장기적인 작업을 계속 진행할 수 있습니다. 병렬코드는 여러개의 코드가 동시에 실행되는 것을 의미합니다. 예를 들어 4코어 프로세서가 장착된 컴퓨터는 각 코어가 하나의 작업을 수행하면서 동시에 4개의 코드를 실행할 수 있습니다. 병렬 및 비동기 코드를 사용하는 프로그램은 한번에 여러 작업을 수행하며, 외부 시스템에서 대기중인 작업을 일시 중단하고 메모리 안전 방식(memory-safe way)으로 코드를 더 쉽게 작성할 수 있게 해줍니다.

병렬 또는 비동기 코드의 추가적인 스케줄링이 유연해지면 복잡성이 증가하게 됩니다. 예를들어 Actor를 사용하여 변경가능한 상태에 안전하게 액세스할 수 있는 등 Swift를 사용하면 컴파일 타임에 일부 확인이 가능한 방식으로 표현할 수 있습니다. 하지만 느리거나 버그가 있는 코드에 동시성을 추가한다고 해서 코드가 빠르거나 정확해진다는 보장은 없습니다. 오히려 동시성을 추가함으로써 코드를 디버깅하기가 더 어려워질 수도 있습니다. 그러나 동시성이 필요한 코드에서 동시성에 대한  Swift의 언어 수준 지원(language-level support)을 사용하면 컴파일시에 문제를 파악하는데 도움이 될 수 있습니다.

이 문서의 나머지 부분에서는 비동기 코드와 병렬코드의 일반적인 조합을 지칭하기 위해서 동시성(concurrency)라는 용어를 사용합니다.


> 이전에 동시 코드(concurrent code)를 작성해본 적이 있다면 스레드 작업에 익숙할 것입니다. Swift의 동시성 모델은 스레드 위에 구축되지만 스레드와 직접 상호작용하지는 않습니다. Swift의 비동기 함수는 실행중인 스레드를 포기할 수 있으며, 첫 번째 함수가 차단되는 동안 다른 비동기함수가 해당스레드에서 실행될 수 있습니다. 비동기 함수가 재개될 때 Swift는 해당 함수가 어떤 스레드에서 실행될지 보장하지 않습니다.

Swift의 언어 지원을 사용하지 않고도 동시 코드(cuncurrent code)를 작성할 수 있지만, 해당 코드는 읽기 어려운 경향이 있습니다. 예를 들어서 다음 코드는 사진 이름 목록을 다운로드 하고 해당 목록에서 첫번째 사진을 다운로드한 후 사용자에게 해당사진을 표시하는 코드입니다.

```swift
listPhotos(inGallery: "Summer Vacation") { photoNames in
    let sortedNames = photoNames.sorted()
    let name = sortedNames[0]
    downloadPhoto(named: name) { photo in
        show(photo)
    }
}
```

이 간단한 경우에도 코드를 일련의 완료 핸들러(completion handler)로 작성해야 하므로 중첩된 클로저를 작성하게 됩니다. 이런 스타일에서 깊은 중첩이 있는 복잡한 코드가 될수록 다루기 어려워질 수 있습니다.

# 비동기 함수 정의 및 호출하기

비동기 함수 또는 비동기 메서드는 실행 도중에 일시 중단할 수 있는 특수한 종류의 함수 또는 메서드 입니다. 이는 완료될 때까지 실행되거나 오률 발생시키거나 반환되지 않는 일반적인 동기식 함수 및 메서드와 대조적입니다. 비동기 함수나 메서드는 여전히 이 세가지 중 하나를 수행하지만, 무언가를 기다리는 동안 중간에 일시 중지할 수도 있습니다. 비동기 함수나 메서드의 본문 안에는 실행을 일시중지할 수 있는 각 위치를 표시합니다.

함수나 메서드가 비동기임을 표시하려면 매개변수 뒤에 선언에 `async` 키워드를 쓰면 되는데, 이는 에러를 던지는 함수를 표시할 때 `throw`를 사용하는 것과 유사합니다. 함수나 메서드가 값을 반환하는 경우 반환 화살표(→)앞에 `async`키워드를 작성합니다. 예를 들어 갤러리에서 사진의 이름을 가져오는 방법은 다음과 같습니다.

```swift
func listPhotos(inGallery name: String) async -> [String] {
    let result = // ... some asynchronous networking code ...
    return result
}
```

비동기이면서 에러를 던지는 함수나 메서드인 경우, 에러를 던지기 전에 async를 작성합니다.

비동기 메서드를 호출하면 해당 메서드가 반환될 때까지 실행이 일시 중단됩니다. 호출 앞에 `await`를 써서 가능한 일시 중단 지점을 표시합니다. 이는 `throw`함수를 호출할 때 `try`를 작성하여 오류가 발생했을 때 프로그램의 흐름이 변경될 수 있음을 표시하는 것과 같습니다. 비동기 메서드 내부에서는 다른 비동기 메서드를 호출할 때만 실행흐름이 일시중단되며, 일시 중단은 암시적이거나 선제적이지 않으므로 가능한 모든 일시중단 시점이 `await`로 표시됩니다.

예를 들어 아래 코드는 갤러리에 있는 모든 사진의 이름을 가져온 다음 첫번째 사진을 표시합니다.

```swift
let photoNames = await listPhotos(inGallery: "Summer Vacation")
let sortedNames = photoNames.sorted()
let name = sortedNames[0]
let photo = await downloadPhoto(named: name)
show(photo)
```

`listPhotos(inGallery:)`및 `downloadPhoto(named:)`함수는 모두 네트워크 요청을 해야하기 때문에 완료하는데 상대적으로 오랜 시간이 걸릴 수 있습니다. **반환 화살표앞에 `async`를 작성하여 두 함수를 모두 비동기화하면 이 코드가 사진이 준비될 때까지 기다리는 동안 앱의 나머지 코드가 계속 실행될 수 있습니다.**

위 예제의 동시성을 이해하기 위해 위 코드의 실행 순서를 보면 다음과 같습니다.

1. 코드는 첫번째 줄부터 실행을 시작하여 첫번째 `await`까지 실행됩니다. 이 코드는 `listPhotos(inGallery:)`함수를 호출하고 해당 함수가 반환될 때까지 기다리는 동안 실행을 일시 중단합니다.
2. 이 코드의 실행이 일시 중단되는 동안 같은 프로그램에서 다른 동시코드가 실행됩니다. 예를 들어 오래 실행되는 백그라운드 작업에서 새 사진 갤러리 목록을 계속 업데이트하고 있을 수 있습니다. 이 코드도 대기 중으로 표시된 다음 일시 중단 지점까지 또는 완료될 때까지 실행됩니다.
3. `listPhotos(inGallery:)`가 반환된 후 이 코드는 해당 시점부터 실행을 계속합니다. 이 코드는 반환된 값을 `photoNames`에 할당합니다.
4. `sortedNames`와 `name`을 정의하는 줄은 일반적인 동기식 코드입니다. 이 줄에는 `await`이라는 키워드가 없기 때문에 가능한 중단 지점이 없습니다.
5. 다음 `await`은 `downloadPhoto(named:)`함수에 대한 호출을 표시합니다. 이 코드는 해당 함수가 반환될 때까지 실행을 다시 일시중지하여 다른 동시코드가 실행될 수 있는 기회를 제공합니다.
6. `downloadPhoto(named:)`가 반환된 후 반환값이 `photo`에 할당된 다음 `show(_:)`를 호출할 때 인수로 전달됩니다.

코드에서 await로 표시된 중단 지점은 현재 코드가 비동기 함수나 메서드가 반환되기를 기다리는 동안 실행을 일시 중지할 수 있음을 나타냅니다. 이를 스레드 양보(yeilding the thread)라고 부르는데, 그 이유는 Swift가 백그라운드에서 현재 스레드에서 코드 실행을 일시 중단하고 대신 해당 스레드에서 다른 코드를 실행하기 때문입니다. await 코드는 실행을 일시 중단할 수 있어야 하므로 다음과 같은 프로그램의 특정 위치에서만 비동기함수나 메서드를 호출할 수 있습니다.

- 비동기 함수, 메서드 또는 프로퍼리를 의미합니다. 본문에 있는 코드입니다.
- `@main`으로 표시된 구조체, 클래스 또는 열거형의 정적 main()에 있는 코드.
- Unstructured Concurrency에 표시된 것처럼 비정형(unstructured) 하위 작업의 코드

가능한 일시 중단 지점 사이에 있는 코드는 다른 동시 코드에 의해 중단될 가능성 없이 순차적으로 실행됩니다. 예를 들어 아래의 코드는 한 갤러리에서 다른 갤러리로 사진을 이동시킵니다.

```swift
let firstPhoto = await listPhotos(inGallery: "Summer Vacation")[0]
add(firstPhoto toGallery: "Road Trip")
// At this point, firstPhoto is temporarily in both galleries.
remove(firstPhoto fromGallery: "Summer Vacation")
```

`add(:toGallery:)`와 `remove(_:fromGallery:)`호출 사이에 다른 코드가 실행될 수 없습니다. 그동안 첫번째 사진이 두 갤러리에 모두 표시되어 앱의 불변성 중 하나가 일시적으로 깨집니다. 이 코드 덩어리가 나중에 추가될 때까지 기다리지 않아야 한다는 점을 더욱 명확히 하려면 해당 코드를 아래와 같이 동기함수로 리팩토링 하면 됩니다.

```swift
func move(_ photoName: String, from source: String, to destination: String) {
    add(photoName, to: destination)
    remove(photoName, from: source)
}
// ...
let firstPhoto = await listPhotos(inGallery: "Summer Vacation")[0]
move(firstPhoto, from: "Summer Vacation", to: "Road Trip")
```

위 예제에서 `move(_:from:to:)` 함수가 동기식이기 때문에 가능한 중단지점을 포함할 수 없습니다. 앞으로 이 함수에 동시코드를 추가하여 가능한 중단지점을 도입하려고 하면 버그가 발생하는 대신 컴파일 타임 오류가 발생합니다.


> `Task.sleep(until:tolerance:clock:)`메서드는 동시성 작동 방식을 배우기 위해 간단한 코드를 작성할 때 유용합니다. 이 메서드는 아무 작업도 수행하지 않고 주어진 나노초를 기다린 후 반환합니다. 
아래의 코드는 `sleep(until:torlerance:clock:)`를 사용하여 네트워크 작동을 기다리는 시뮬레이션을하는 `listPhotos(inGallery)`함수 버전입니다.
>
> ```swift
> func listPhotos(inGallery name: String) async throws -> [String] {
>    try await Task.sleep(until: .now + .seconds(2), clock: .continuous)
>    return ["IMG001", "IMG99", "IMG0404"]
> }
> ```
> 

</aside>

# 비동기 시퀀스(Asynchronous Sequences)

이전 섹션의 `listPhotos(inGallery:` 함수는 배열의 모든 요소가 준비된 후 전체 배열을 한번에 비동기적으로 반호나합니다. 또 다른 접근 방식은 비동기 시퀀스를 사용하여 컬렉션의 요소를 한번에 하나씩 기다리는 것입니다. 비동기 시퀀스를 반복하는 모습은 다음과 같습니다. 

```swift
import Foundation

let handle = FileHandle.standardInput
for try await line in handle.bytes.lines {
    print(line)
}
```

위 예제에서는 일반적인 `for-in` 루프를 사용하는 대신, 그뒤에 `await`를 사용하여 `for`를 작성합니다. 비동기 함수나 메서드를 호출할 때와 마찬가지로 `await`를 쓰면 가능한 일시 중단 지점을 나타냅니다. `for-await-in` 루프는 다음 요소를 사용할 수 있을 때까지 기다리고 각 반복의 시작부분에서 실행을 일시 중단할 수 있씁니다. 

[Sequence](https://developer.apple.com/documentation/swift/sequence) 프로토콜에 적합성(conformance?)을 추가하여 for-in 루프에서 자체 유형을 사용할 수 있는 것과 마찬가지로, [AsyncSequence](https://developer.apple.com/documentation/swift/asyncsequence) 프로토콜에도 적합성을 추가하여 `for-await-in` 루프에서 자체 유형을 사용할 수 있습니다.

# 병렬로 비동기 함수 호출하기(Calling Asynchronous Function in Parallel)

`await`로 비동기 함수를 호출하면 한번에 하나의 코드만 실행됩니다. 비동기 코드가 실행되는 동안 호출자는 해당 코드가 완료될 때까지 기다렸다가 다음 코드 줄을 실행합니다. 예를 들어 갤러리에서 처음 세장의 사진을 가져오려면 다음과 같이 downloadPhoto(named:)함수에 대한 호출을 세번 기다려야 합니다.

```swift
let firstPhoto = await downloadPhoto(named: photoNames[0])
let secondPhoto = await downloadPhoto(named: photoNames[1])
let thirdPhoto = await downloadPhoto(named: photoNames[2])

let photos = [firstPhoto, secondPhoto, thirdPhoto]
show(photos)
```

이 접근 방식에는 중요한 단점이 있습니다. 다운로드가 비동기식이어서 다운로드가 진행되는 동안 다른 작업을 수행할 수 있지만, 한번에 `downloadPhotos(named:)`에 대한 호출은 한번만 실행됩니다. 각 사진은 다음 사진이 다운로드를 시작하기 전에 완전히 다운로드 됩니다. 그래서 이러한 작업은 기다릴 필요가 없습니다. 각 사진은 독립적으로 또는 동시에 다운로드할 수 있습니다.

비동기 함수를 호출하고 주변 코드와 병렬로 실행되도록 하려면 상수를 정의할 때 `let` 앞에 `async`를 작성한 다음 상수를 사용할 때마다 `await`를 사용하면 됩니다.

```swift
async let firstPhoto = downloadPhoto(named: photoNames[0])
async let secondPhoto = downloadPhoto(named: photoNames[1])
async let thirdPhoto = downloadPhoto(named: photoNames[2])

let photos = await [firstPhoto, secondPhoto, thirdPhoto]
show(photos)
```

이 예제에서는 이전 호출이 완료될 때까지 기다리지 않고 `downloadPhotos(named:)`에 대한 세개의 호출이 모두 시작됩니다. 사용가능한 시스템 리소스가 충분하면 동시에 실행할 수 있습니다. 이러한 함수 호출 중 어느것도 `await`으로 표시되지 않은 이유는 코드가 함수의 결과를 기다리기 위해 일시 중단되지 않기 때문입니다. 대신 사진이 정의된 줄까지 실행이 계속되는데, 이때 프로그램에는 이러한 비동기 호출의 결과가 필요하므로 세장의 사진 다운로드가 모두 완료될 때까지 실행을 일시 중지하는 `await`를 작성합니다.

이 두가지 접근 방식의 차이점에 대해 생각해 볼 수 있는 방법은 다음과 같습니다.

- 다음 줄의 코드가 해당함수의 결과에 의존하는 경우 await를 사용하여 비동기함수를 호출합니다. 이렇게하면 순차적으로 수행되는 작업이 생성됩니다.
- 코드의 후반부까지 결과가 필요하지 않은 경우 async-let으로 비동기함수를 호출합니다. 이렇게 하면 병렬로 수행할 수 있는 작업이 생성됩니다.
- `await`과 `async-let` 모두 일시 중단된 동안 다른 코드가 실행될 수 있도록 합니다ㅏ.
- 두 경우 모두 가능한 일시중단 지점을 await로 표시하여 필요한 경우 비동기 함수가 반환될 때까지 실행이 일시 중지됨을 나타냅니다.

동일한 코드에서 이 두가지 접근 방식을 혼합하여 사용할 수도 있습니다.

# Task와 Task Group

Task는 프로그램의 일부로 비동기적으로 실행할 수 있는 작업의 단위입니다. 모든 비동기 코드는 Task의 일부로 실행됩니다. 이전섹션에서 설명한 async-let구문은 하위 작업을 만듭니다. 또한 작업 그룹을 만들고 해당 그룹에 하위작업을 추가하여 우선순위와 취소를 더 잘 제어하고 동적으로 작업 수를 만들 수 있습니다.

Task는 계층구조로 정렬됩니다. Task Group의 각 Task는 동일한 상위 Task를 가지며 하위 Task를 가질 수 있습니다. Task와 Task Group간의 명시적인 관계때문에 이 접근방식을 구조화된 동시성(Structured Concurrency)라고도 합니다. 사용자가 정확성에 대한 일부 책임을 지지만, Task간의 명시적인 상위-하위 관계를 통해 Swift가 취소 전파 같은 일부 동작을 대신 처리하고 컴파일 시점에 일부 오류를 감지할 수 있습니다.

```swift
await withTaskGroup(of: Data.self) { taskGroup in
    let photoNames = await listPhotos(inGallery: "Summer Vacation")
    for name in photoNames {
        taskGroup.addTask { await downloadPhoto(named: name) }
    }
}
```

더 자세한 내용은 [Task Group문서](https://developer.apple.com/documentation/swift/taskgroup)를 참고하세요

## Unstructured Concurrency

이전 섹션에서 설명한 구조화된 동시성(Structured Concurrency)접근 방식 외에도 Swift는 구조화되지 않은 동시성(Unstructured Concurrency)도 지원합니다. task group의 일부인 task와는 달리, 구조화되지 않은 작업에는 부모 task가 없습니다. 따라서 프로그램에 필요한 방식으로 비정형 작업을 유연하게 관리할 수 있지만, 그 정확성에 대한 책임도 전적으로 사용자에게 있습니다. 현재 actor에서 실행되는 unstructured task를 생성하려면 Task.init(priority:operation:)이니셜라이저를 호출합니다. 현재 actor의 일부가 아닌 unstructured task, 보다 구체적으로 detached task라고 하는 task를 생성하려면 Task.detached(priority:operation:)클래스 메서드를 호출합니다. 이 두 작업 모두 결과를 기다리거나 취소하는 등 상호 작용할 수 있는 task를 반환합니다.

```swift
let newPhoto = // ... some photo data ...
let handle = Task {
    return await add(newPhoto, toGalleryNamed: "Spring Adventures")
}
let result = await handle.value
```

detached task 관리에 대한 자세한 내용은 [Task 문서](https://developer.apple.com/documentation/swift/task)를 참고하세요

## Task Cancellation
