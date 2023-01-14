# ARC와 Side Table
이번에는 ARC란 무엇이고, strong, unowned, weak키워드와 같은 기본적인 내용 외에 실제로 오브젝트의 어떤 부분이 달라지는지등 디테일한 부분을 다루어 보고자 한다.

## Weak, Unowned Reference?
그동안 `weak`, `unowned`로 참조하는 내용은 레퍼런스 카운트를 증가시키지 않고 두가지의 차이는 단지 `옵셔널인지 아닌지`여부에 있다고 생각했다. unowned reference가 남아있다면 strong reference의 count가 0으로 줄어도 여전히 dangling pointer를 남긴다고 ㅎ나다. 

그동안 weak, unowned의 차이점은 단지 옵셔널인지 아닌지에만 달려있다고 생각했고, strong reference count가 0이 되면 메모리에서 정상적으로 deallocated된다고 생각했는데 dangling pointer가 발생한다니.. 지금까지 알고있던 지식이 부정당아하는 느낌이였다.

## Deinitialize와 Deallocate
이를 이해하기 위해서는 먼저 Deinitialize와 Deallocate에 대해 이해하고 있어야 한다. `Side Table`은 메모리 관리 향ㅇ상을 위해 Swift 4부터 추가되었는데, 무엇때문에 추가된 것일까? Swift 4이전의 메모리관리 개념에 대해 알아보자. 보통은 아래의 내용들만을 알고있다.
- Strong Reference는 인스턴스를 강하게 참조하여 strong reference count가 1이상으로 남아있으면 인스턴스는 deallocate되지 않는다.(=메모리에서 해제되지 않는다.)
- Weak Reference는 인스턴스를 강하게 참조하지 않아 ARC가 참조된 인스턴스를 해제하는 것을 막지 않는다.
- Unowned Reference는 Weak Reference와 마찬가지로 인스턴스를 강하게 참조하지 않는다. 단, Unowned Reference Count가 0일 때 접근하면 런타임에러가 발생한다.

기존의 내용은 보통 공부했던 내용과 대부분 차이가 없을 것이다. 그렇다면 side table이 어떻게 쓰이고, strong reference count가 0이어도 unowned reference count가 1이상이라면 왜 dangling pointer가 발생할 수 있는지에 대해 알아보자.

아래와 같이 id, email프로퍼티를 가진 User라는 클래스가 있다.
```swift
class User {
    let id: Int
    let email: String
}
```
이 클래스의 인스턴스를 강하게 참조하면 아래의 사진과 같다.

<img width="60%" src="https://user-images.githubusercontent.com/76734067/212491562-e9b30c65-4d99-42e7-87d9-7887a036acea.png">

약한 참조를 사용하면 아래와 같다.

<img width="60%" src="https://user-images.githubusercontent.com/76734067/212491604-6ec95b23-dcd6-49fe-88dd-01839d4a36b3.png">

weak reference가 1이지만 strong reference가 0 이므로, ARC에 의해서 객체가 메모리에서 삭제될 것처럼 보인다. 위 사진의 deinitialized라는 것에 주목하자. **객체가 `deinitialize` 되었다는 것이 객체가 메모리에서 `deallocate` 되었다는 것을 의미하지는 않는다.** Mike Ash의 Friday Q&A에서 이 현상을 다음과 같이 설명하고 있다.
>  the object is destroyed but its memory is not deallocated. This leaves a sort of zombie object sitting in memory, which the remaining weak references point to.

사용하지도 않으면서, 메모리에 계속 남아있는 객체를 **`좀비 객체`** 라고 한다. 그럼 이 좀비객체를 가지고 있는 메모리는 언제 deallocate될까? weak reference가 로드되면 좀비객체가 있는지 런타임에 체크하게 되고, 만약 있다면 weak reference를 0으로 만들고 그제서야 객체의 메모리가 deallocate된다. 다시말하면 좀비객체는 자신을 참조하는 weak reference가 접근된 다음에야 사라질 수 있음을 의미한다. 결론적으로 strong reference count가 0이 되어 객체가 deinitialize되었을 지라도 memory deallocation은 일어나지 않았으며 좀비객체는 그때까지 살아남아있을 수 있다는 것이다.

이런 문제점을 해결하기 위해서 **`Side Table`** 이 등장하였다.

## Side Table
- Side Table은 객체의 추가적인 정보를 저장하기 위해서 분리된 메모리이다.
- 객체가 side table을 참조하고 있고, side table도 객체를 참조하고 있다.
- side table은 옵셔널이여서 처음에는 존재하지 않다가 객체가 weak reference에 의해 참조되면 생성된다.

<img width="60%" src="https://user-images.githubusercontent.com/76734067/212493226-4505339c-18f1-4736-bb11-45866d212ef7.png">

- 이미지에서 볼 수 있듯이 strong, unowned reference는 객체자체를 찹조하고 있으나, weak reference는 side table을 참조하고 있다.
- 이것이 메모리 관리 향상을 위한 side table의 사용이고, weak와 unowned reference의 차이점이라고 말할 수 있다.

<img width="60%" wrc="https://user-images.githubusercontent.com/76734067/212493303-c417306e-c24b-456c-ab70-568acffdded7.png">

- swift 4부터 weak reference가 side table을 참조하는 특성을 가진다.
- **strong reference count가 0에 도달하면 weak reference count와 상관없이 `object deinitialize`, `memory deallocate`가 모두 일어나게 된다.

# 결론
- weak reference와 unowned reference의 차이점은 객체를 직접 참조하느냐(unowned), 객체의 side table을 참조하느냐(weak)에 있다.

# Reference
- [Side Table in Swift](https://sihyungyou.github.io/iOS-side-table/)
- [Friday Q&A 2017-09-22: Swift 4 Weak References](https://www.mikeash.com/pyblog/friday-qa-2017-09-22-swift-4-weak-references.html)
- [Discover Side Tables - Weak Reference Management Concept in Swift](https://maximeremenko.com/swift-arc-weak-references)