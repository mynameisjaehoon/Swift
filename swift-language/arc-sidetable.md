# Swift와 Side Table
weak, unowned의 차이점은 옵셔널의 여부일 뿐이고 strong reference count가 0이 되면 정상적으로 메모리에서 해제된다고 생각했지만 실제로는 다르다고 한다. unowned reference가 남아있다면 strong reference의 count가 0이 되어도 dangling pointer가 남아있다고 한다.

즉, weak, unowned reference count의 개수와 상관없이 strong reference count가 0이 되면 deallocate된다는 것은 사실이 아니다.

## Deinitialize란
Side Table 이라는 개념은 메모리 관리의 향상을 위해 Swift 4부터 추가된 개념이다. 무엇을 향상시켰는지 살펴보기 위해서 Swift 4 이전의 메모리 관리 개념에 대해 알아보자.
- Strong Reference는 인스턴스를 강하게 참조하여, strong reference count가 1이상이라면 인스턴스는 deallocate되지 않는다.
- Weak Reference는 인스턴스를 강하게 참조하지 않아서 ARC가 참조된 인스턴스를 처리하는 것을 막지 않는다.
- Unowned Reference는 weak reference처럼 인스턴스를 강하게 참조하지는 않으나, unowned reference count가 0일 때 참조하면 런타임 에러가 발생한다.

그렇다면 Swift 4이후로 무엇을 향상시키고, Side Table이 왜 쓰이고, Strong Reference count가 0이어도, unowned reference count가 1 이상이면 dangling pointer가 남는지 이해해봅시다.

id, email 프로퍼티를 가진 User 클래스가 있습니다.
```swift
class User {
    let id: Int
    let email: String
}
```

이 클래스를 강한 참조하면 아래와 같이 strong reference count가 올라갑니다.<br>
<img width="50%" src="https://user-images.githubusercontent.com/76734067/227705207-d46812b7-fa0a-46cd-896c-1023207b20aa.png">

약한 참조를 사용하면 아래와 같이 weak reference count가 올라갑니다.<br>
<img width="50%" src="https://user-images.githubusercontent.com/76734067/227705249-bd6915a8-6f61-4995-92bd-f65116790132.png">

weak reference는 1이지만, strong reference는 0이므로 ARC에 의해서 객체가 메모리에서 삭제 됩니다. 

여기서 위의 이미지에도 적혀있듯 deinitialize라는 단어에 주목해야합니다. 객체가 deinitialize 되었다는 것이 객체를 저장 해둔 메모리가 deallocate 되었다는 의미가 아니라는 것입니다.
사용되지도 않고 메모리에만 남아 있는 좀비 객체가 되는 것입니다. 

그렇다면 이 좀비객체는 언제 해제될까? weak reference가 로드되면 좀비 객체가 있는지 런타임에 체크하게 되고, 만약 있다면 weak reference 를 0으로 만들고 그 때 객체의 메모리가 deallocate되게 됩니다. weak reference가 한번 참조하고 나서야 사라진다는 의미입니다. 

결국 strong reference count가 0이 되어 deinitialize 됐을 지라도, memory deallocation은 일어나지 않고, 이런 좀비객체가 꽤 오랫동안 살아남을 수 있다는 문제가 있었습니다.


## Side Table
그래서 Side Table은 무엇일까? `Side Table은 객체의 추가적인 정보를 저장하기 위해 분리된 메모리`이다.
처음부터 Side Table이 존재하지 않고 그 자체가 optional 이였다가 weak reference에 의해 참조되면 생성된다.

<img width="50%" src="https://user-images.githubusercontent.com/35067611/128985891-addf923f-43cb-4049-94fa-67f7c52d1ede.png">

위 이미지를 보면 strong, unowned reference는 객체 자체를 참조하고 있으나 weak reference는 side table을 참조하고 있는 것을 볼 수 있습니다.
메모리 관리의 향상을 위해서 위와 같이 처리하고 여기서 weak, unowned의 차이점을 알 수 있습니다.
> weak는 객체의 side table을 참조하고, unowned는 객체 자체를 참조한다.

<img width="50%" src="https://user-images.githubusercontent.com/35067611/128985897-9e988be4-99a3-4834-a514-bee406fb58b1.png">

Swift 4부터 weak reference는 side table을 참조하기 때문에 strong reference count가 0이 되면 weak reference count와 상관없이 deinitialize와 deallocate가 둘다 일어난다.

# 정리
- Swift 4이전, strong reference count가 0이 되어도 객체는 deinitialize 될 뿐, 메모리에서 deallocate 된 것이 아니다.
- deallocate 되지 않은 객체는 좀비 객체가 되고, weak reference가 참조하고 나서야 사라질 수 있어 좀비객체가 꽤 오랫동안 살아남을 수 있다는 문제가 있었다.
- Swift 4이후로, strong, unowned reference는 객체 자체를 참조하고 weak reference는 side table을 참조한다. 
- 따라서 strong reference count가 0에 도달하면 weak reference count와 상관없이 deinitialize와 deallocate가 둘다 일어난다.

# Reference
- [Discover Side Tables - Weak Reference Management Concept in Swift](https://maximeremenko.com/swift-arc-weak-references)
- [Friday Q&A 2017-09-22: Swift 4 Weak References](https://www.mikeash.com/pyblog/friday-qa-2017-09-22-swift-4-weak-references.html)