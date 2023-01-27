# WWDC - Understanding Swift Performance

> [WWDC16 UnderStanding Swift Performance](https://developer.apple.com/videos/play/wwdc2016/416/)에서 소개한 스위프트 성능과 관련된 내용을 작성해보려 합니다.

스위프트 코드를 작성하면서 무지성으로 작성하는 것보다야 당연히 좋은 성능을 기대하면서 작성하는것이
바람직합니다. WWDC영상에서는 다음 세가지를 중심으로 성능에 대해서 이야기합니다.
- Allocation: 인스턴스를 생성했을 때 Stack, Heap중 어디에 저장되는지
- Reference Counting: 인스턴스를 통해서 레퍼런스 카운트가 몇개 발생하는지
- Method Dispatch: 인스턴스에서 메서드를 호출했을 때 메서드 디스패치가 정적인지 동적인지

# Allocation
스위프트는 자동으로 메모리의 할당과 해제를 처리하는데, 이 메모리가 할당되고 해제되는 공간에는 Stack과 Heap이 있습니다.
## 스택 그리고 힙
스택은 LIFO(Last In First Out)의 단순한 구조로 메모리 할당과 해제가 편리합니다. 스택은 스택 포인터를 사용해서 할당, 해제를 처리합니다. 단순한 구조를 가진 만큼 시간복잡도는 **`O(1)`** 으로 매우 빠릅니다.

힙은 스택보다 복잡한 구조를 가지고 있습니다. dynamic한 할당방법을 사용하는데, 힙 영역에서 사용하지 않는 블록을 찾아서 메모리 할당을 처리합니다. 할당을 해제하기 위해서는 해당 메모리를 적절한 위치로 다시 삽입합니다. 여러 스레드가 동시에 힙에 메모리를 할당할 수 있기 때문에 locking 또는 기타 동기화 매커니즘을 사용해서 무결성을 보호해야합니다.

위의 설명에서도 볼 수 있듯이 **스택에 할당하는 것이 힙에 할당하는 것보다 비용이 적게 들어가고, 속도가 더빠른 할당방법 입니다.**

## Value and Reference Semantics
메모리 할당시에 스택과 힙에 저장되는 기준은 **semantics**로 결정됩니다. **value semantics**, **reference semantics**로 나뉩니다.

> semantics는 어떤 타입, 기호가 내부적으로 어떤의미인지를 뜻합니다.

### Value Semantics: Struct
Value Semantics 타입들의 인스턴스는 스택에 할당됩니다. `struct`가 대표적으로 value semantics를 따르고 있고, 구조체 이외에도 열거형과 튜플도 이에 해당됩니다. (value semantics라고 무조건 스택에 저장되는 것은 아니지만 여기서는 편의를 위해서 이렇게 설명하겠습니다.)

Struct인스턴스를 생성해서 다른 인스턴스에 할당하면, 전체 값은 그대로 **복사**됩니다. 복사된 인스턴스는 기존 인스턴스와 구분되어서 stack에 저장되기 때문에 내부의 값을 변경해도 원래 값에 영향을 주지 않습니다. 힙을 사용하지 않기 때문에 reference counting도 사용되지 않습니다. Reference Counting은 힙에서 발생하는 것인데 아래에서 더 자세히 설명하겠습니다.

<p align="center">
<img width="90%" alt="image" src="https://user-images.githubusercontent.com/76734067/215083245-7d6daf7f-9bd3-4aaf-a9d9-209474c7117d.png">
</p>

### Reference Semantics: Class
Reverence semantics는 스택에는 reference인 주소값을 할당하고, 실질적인 데이터는 heap에 할당합니다. 대표적으로 `class`가 있고, `function`또한 reference semantics입니다.

Class는 struct가 인스턴스 내부 변수 개수에 맞추어 2words의 사이즈로 스택에 할당되는 것과달리, 아래의 이미지를 보면 추가된 파란색 박스부분에 힙에 4words size로 할당되는 것을 볼 수 있습니다. 이게 **스위프트가 클래스를 관리하기 위한 방법입니다.**

> **word란?**<br>
> 하나의 단위로 word하나에 하나의 변수를 저장할 수 있습니다.

클래스는 reference semantics로 항상 **하나의 identity**라는 것에 유의해야합니다. 아래의 이미지를 보면 Point 클래스의 인스턴스를 생성하고 복사하게 되면 스택에 있는 레퍼런스, 주소값이 복사되기 때문에 point1, point2가 동일한 인스턴스를 가리키게 됩니다. 그렇기 때문에 복사된 인스턴스를 수정하면 원래 인스턴스 데이터도 함께 변경되는 것처럼 보이게 됩니다.

<p align="center">
<img width="90%" src="https://user-images.githubusercontent.com/76734067/215087553-e989c654-c807-4de2-ab3c-8656a027ea66.png">
</p>



### Heap Allocation 피하기 예시
메세지 애플리케이션에서 사용하는 코드를 예시로 들어주었습니다. 뷰 레이어에서 사용되는 코드이고, `makeBalloon(_::)`라는 말풍선 이미지를 반환하는 함수입니다.

`Color`, `Orientation`,`Tail` 열거형(enum)을 사용해서 각각의 케이스에 따라 말풍선이미지를 반환하도록 구현되어있습니다. 

<p align="center">
<img width="90%" src="https://user-images.githubusercontent.com/76734067/215092847-612aacd8-b991-4ffa-83a4-f26c1702769f.png">
</p>

여기서 사용자가 스크롤을 할 때 뷰를 부드럽게 처리하기 위해서 캐싱을 위한 `Dictionary`타입의 `cache`를 만들어 주었습니다. 이렇게 되면 한번 만들어둔 말풍선 이미지는 또 생성해서 만들 피룡없이
캐시에서 조회하고 dictionary를 통해 바로 가져올 수 있습니다. cache에서 캐싱을 위한 키 역할을 하는 `dictionary`의 `key`는 `Color`, `Orientation`, `Tail`을 직렬화한 `String`타입인것도 볼 수 있씁니다.

<p align="center">
<img width="90%" src="https://user-images.githubusercontent.com/76734067/215093271-c14911aa-fe12-4429-a4f4-484d8d84ea24.pn">
</p>

`그래서 지금 이 코드가 무엇이 문제인가?`를 이야기해봅시다. 일단 `key`가 `String`타입이기 때문에 다른 값이 들어갈 수 있는 위험이 있습니다.
또한 `String`은 value type이지만, `Character`타입의 문자들을 heap에 간접적으로 저장하는 특징이 있기 때문에 `String`을 사용하게 되면 Heap Allocation또한 발생하게 됩니다.
그렇기 때문에 위와 같은 구조에서는 `makeBalloon(_::)`함수를 호출할 때마다 `key`로 인하여 heap allocation이 발생하게 됩니다.

해결방법은 struct를 하나 더 만드는 것입니다. `Attributes` 구조체를 cache Dictionary의 key타입으로 사용하게 되면 Stack Allocation이 발생하기 때문에 비용과 시간을 감소시킬 수 있습니다.
그리고 `Attributes` 구조체는 `String`이 사용되지 않고 정해진 enum값들의 조합만으로 생성되기 때문에 dictionary의 key로 사용하기에 더욱 안전한 방법입니다.

```swift
struct Attributes {
    var color: Color
    var orientation: Orientation
    var tail: Tail
}
```

<p align="center">
<img width="90%" src="https://user-images.githubusercontent.com/76734067/215094471-f95e264f-dffc-4508-8be3-90433f8045b3.png">
</p>

<p align="center">
<img width="90%" src="">
</p>
