# 애니메이션 동작시키기

iOS에서 애니메이션을 표현하고 싶을 때 애플에서 제공하고 있으므로 드로잉 코드를 작성할 필요가 없다. 애니메이션을 트리거 하고 코어 애니메이션이 개별 프레임의 렌더링을 처리하도록 하기만 하면 됩니다.

애니메이션의 유형에는 다음 3가지가 있습니다.

- UIKit
- Core Animation
- UIViewPropertyAnimator

세가지 중 어느것을 사용해야할까?

- `UIKit`: UIKit 스타일의 애니메이션은 Core Animation 스타일 애니메이션으로 변환됩니다. 즉 모든것이 코어 애니메이션을 사용하여 애니메이션 됩니다.
- `Core Animation`: 기본 레이어의 속성을 애니메이션할 때 Core Animation을 사용합니다. CPU에 부담을 주거나 앱의 속도를 저하시키지 않으면서 높은 프레임 속도와 부드러운 애니메이션을 제공하는 시각적 요소를 렌더링, 구성, 애니메이션화 합니다.
- `UIViewPropertyAnimator`: `UIView` 프로퍼티의 복잡하고 동적인 애니메이션을 허용합니다.

## UIKit Animation

UIKit을 사용하면 코드를 가장 쉽게 구현할 수 있습니다. 초보자가 사용하기에 매우 간단한 API 입니다. 

iOS의 모든 애니메이션은 Core Animation을 이용하여 실행됩니다. UIKit의 블록기반 애니메이션 메서드는 단순히 편의기능일 뿐입니다.

UIKit과 Core Animation은 모두 애니메이션을 지원하지만 뷰 계층 구조의 다른 부분에 대한 액세스도 제공합니다.

### UIView animate 프로퍼티

`frame`, `bounds center` , `transform`, `alpha`, `backgroundColor`, `contentStretch`

```swift
class func animate(
    withDuration duration: TimeInterval,
    delay: TimeInterval,
    options: UIView.AnimationOptions = [],
    animations: @escaping () -> Void,
    completion: ((Bool) -> Void)? = nil
)
```

지정된 기간, 지원, 옵션 및 컴플리션 핸들러를 사용하여 하나 이상의 뷰에 변경사항을 애니메이션으로 적용하게 됩니다.

`duration` 은 애니메이션의 총 기간, delay는 애니메이션을 시작하기 전에 대기할 시간(초) 입니다. options는 애니메이션을 수행하는 방법을 나타내는 마스크 오프 옵션입니다. `.autoreverse`, `.repeat` , `.curveEaseOut`, `.curveEaseIn` 등이 있습니다. 더 자세한 내용은 [문서](https://developer.apple.com/documentation/uikit/uiview/animationoptions)를 참고해주세요


> 트랜지션(transition)의 경우 옵션은 `trans-`로 시작합니다.<br>
ex) `.transitionCrossDissolve`



`animations`는 뷰에 커밋할 변경내용이 포함된 블록 개체, 마지막으로 `completion`는 애니메이션 시퀀스가 종료될 때 실행할 블록 개체 입니다.

그러면 이제 직접 코딩을 통해서 살펴보도록 하겠습니다. 뷰로 간단한 애니메이션을 만들기 위해서 UIView 인스턴스를 하나 만들고 다음 두가지를 수행해보겠습니다.

1. 뷰의 배경색 변경
2. 뷰의 너비 및 높이 변경하기

<img width= "70%" src="https://user-images.githubusercontent.com/76734067/218485010-4843346e-dbfc-4bac-a6f7-99578bb336a6.png">

<img width= "70%" src="https://user-images.githubusercontent.com/76734067/218485023-81778a72-075c-41fe-942b-989801645d7d.png">

코드를 실행하면 뷰의 배경색이 분홍색으로 변경되고 뷰의 크기가 커집니다. 하지만 이 애니메이션 바로 뒤에 다른 애니메이션을 수행하려면 어떻게 해야할까요? 뷰의 위치와 뷰의 색상을 변경하고 싶습니다.

completion handler를 사용하여 애니메이션 뒤에 다른 애니메이션을 제공할 수 있습니다.

<img width= "70%" src="https://user-images.githubusercontent.com/76734067/218485032-202e709c-13e6-4003-a4f1-7e3c297bdf96.png">

참고로 애니메이션이 진행되는 동안 터치 이벤트가 비활성화 되므로, 활성화 하려면 허용 사용자 상호작용을 true로 설정해야합니다.

SpringWithDampling을 사용하여 제공되는 다른 메서드가 있습니다. 이 메서드는 실제 스프링의 움직임에 해당하는 타이밍 커브를 사용해서 뷰 애니메이션을 사용합니다.

<img width= "70%" src="https://user-images.githubusercontent.com/76734067/218485041-6cdb19d5-e44d-4c3f-aa08-4ccd29ae6061.png">


dampingRatio는 애니메이션을 진동없이 부드럽게 감속하려면 1을 사용하면 됩니다.

velocity는 초기 스프링의 속도입니다. `1` 이라는 값이 의미하는 바가 1초동안 이동한 총 애니메이션의 거리에 해당합니다.(0에 가까워질수록 빨라집니다.)

하지만 코드블록이 여러개의 애니메이션을 수행하려 하는 경우 중첩되는 것을 볼 수 있습니다. 위처럼 2개밖에 없는 경우라면 별로 문제가 되지 않지만 10개정도 되는 갯수라면…? 너무 복잡해지고 말것입니다.

### animateKeyframes

그렇기 때문에 keyframe을 이용해서 지저분한 코드블록을 하나로 개선합니다. AnimateKeyframe은 현재 뷰에 대한 키프레임 기반 애니메이션을 설정하는데 사용할 수 있는 애니메이션 블록 객체를 만듭니다.

```swift
class func animateKeyframes(
    withDuration duration: TimeInterval,
    delay: TimeInterval,
    options: UIView.KeyframeAnimationOptions = [],
    animations: @escaping () -> Void,
    completion: ((Bool) -> Void)? = nil
)
```

애니메이션 뷰에 커밋할 변경사항이 포함된 블록 객체. 일반적으로 `addKeyframe(withRelativeStartTime:relativeDuration:animations:)`메서드를 호출합니다.

addKeyframes: 키프레임 애니메이션의 단일 프레임에 대한 타이밍 및 애니메이션 값을 지정합니다.

frameStartTime: 지정된 애니메이션을 시작할 시간입니다. 0에서 1사이의 값이어야합니다.

frameDuration: 지정된 값으로 애니메이션을 적용할 시간입니다. 이 값은 0에서 1사이의 범위여야하고 전체 애니메이션 길이에 대한 상대적인 시간을 나타냅니다.

<img width= "80%" src="https://user-images.githubusercontent.com/76734067/218485046-fcd74e61-bb6e-406c-b297-9111b94087bb.png">

UIView.animateKeyframes(withDuration: 4, …)가 애니메이션의 총길이가 4초임을 나타내고, withRelativeStartTime은 애니메이션의 상대적인 시작시간을 의미합니다. 0.25이면 4초의 1/4을 의미하며 1초에 해당합니다.

1. 배경색을 .magenta로 변경한다.
2. 알파값을 0.5로 설정한다.
3. x의 중심을 변경한다.
4. x의 중심을 변경한다.

네가지 작업을 1초마다 수행하고 있습니다.

여기까지가 UIView 애니메이션에 대한 내용입니다.

# Reference

- **[Animation In Swift](https://medium.com/doyeona/animations-in-swift-f1ee069e21a7)**