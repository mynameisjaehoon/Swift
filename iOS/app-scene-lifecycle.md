# 앱/Scene 생명주기
## 앱의 생명주기란?
앱의 생명주기란 앱의 실행부터 종료까지의 주기를 말한다. 시스템알림에 응답하고 여러 시스템관련 이벤트를 처리하는 단계를 말한다. 이와 비슷하게 뷰의 생명주기(viewDidLoad, viewWillAppear, ...)등 도 있다.

### 왜 생명주기를 생각해야하죠?
- iOS 모바일 환경도 하나의 CPU가 제한된 메모리와 시간을 앱에 할당한다.
- 앱을 번갈아가면서 사용할 때 다른 앱을 사용한다고 해서 이전에 사용하던 앱의 데이터가 초기화된다면 사용성을 해치게 된다.
- iOS 앱의 생명주기를 이해해야 다음과 같은 처리를 통해 앱의 사용성을 보장할 수 있다.
    - 앱이 백그라운드로 갔을 때 데이터를 저장
    - 보안이 중요한 애브의 경우 로그인을 일부러 다시하게 한다.

### Main Run Loop

<img width="600" src="https://user-images.githubusercontent.com/76734067/209846225-8115863c-5419-427b-a5e8-8c4fd2a5cf73.png">

사용자의 터치 이벤트를 받는 시점부터 코드로 구현된 여러 로직이 돌아가는 시점까지에 대한 흐름을 살펴보자

앱의 Main Run Loop는 모든 사용자가 발생시키는 이벤트에 따라 처리된다. 이벤트가 발생했을 때, UIKit에 의해 설정된 Port에 따라 내부의 Event Queue에 이벤트를 담아 놓고,
Main Run Loop에서 담겨있는 이벤트를 하나씩 실행한다.

main loop를 시작하기 전에 사용자가 앱에 이벤트를 주지 않아도 앱 아이콘을 눌러서 실행시킨 시점에 `UIApplication`의 생성과 `@UIApplicationMain`(이제는 `@main`)어노테이션이 붙은 클래스를 찾아서 `AppDelegate`를 생성하는 일을 추가적으로 한다.

### UIApplication, AppDelegate
- UIApplication객체는 싱글톤으로 Event Loop에서 발생하는 이벤트를 감지하고 Delegate에 전달하는 역할을 한다.
- UIApplication객체로부터 전달된 메세지를 AppDelegate객체가 받고 각각의 상황에서 실행할 함수를 정의한다.
- 여기서 `상황`이 앱의 생명주기와 같고, 이 상황(State)는 세가지의 모드에 다섯가지의 상태로 구분된다.
    1. Not Running
        - 앱이 실행되지 않은 상태. 모드와 상태를 둘다 지칭할 때 쓰인다.
    2. Foreground
        - Inactive: 앱이 실행중이지만 아무런 이벤트를 받지 않는 상태
        - Active: 앱이 실행중이고 이벤트가 발생한 상태
    3. Background
        - Running: 앱이 백그라운드에 있는 상태, 그러나 실행되는 코드가 있는 상태
        - Suspended: 앱이 백그라운데 있고 실행되는 코드가 없는 상태<br>

    이렇게 다섯가지의 상태가 있고 각각의 상태에서 실행할 함수들을 정의할 수 있다. 그것이 `AppDelegate.swift`에서 볼수 있었던 delegate 메서드 들이다.

    <img width="550" alt="image" src="https://user-images.githubusercontent.com/76734067/209847726-8d65cf1d-0b92-4ce2-83ff-6015f5a5c242.png">

    이 함수들 중에서 내가 필요로 하는 것만 찾아서 쓰면된다. 문서를 보거나 아니면 위처럼 func application만 입력해도 정의할 수 있는 delegate 메서드들을 자동완성기능으로 확인할 수 있다.

### 다섯가지의 상태

<img width="350" alt="image" src="https://user-images.githubusercontent.com/76734067/209848472-399691c6-e1f4-44a9-b56d-1ea9eb6ef46c.png">

위에서 언급한 다섯가지의 상태(State)에 대해서 조금더 자세히 알아보자
- **`Not Running`**
    - 아무것도 실행하고 있는 않은 상태.(또는 실행중이지만 시스템에 의해 종료된 상태)
- **`Inactive`**
    - 앱이 foreground상태로 돌아가지만 이벤트를 받지 않는 상태
    - 앱의 상태전환과정에서 잠시 머물때의 상태
    - 앱사용중 통화가 오거나, 알람과 같은 인터럽트가 발생해서 잠시 유저 이벤트를 받을 수 없는 상태
- **`Active`**
    - 일반적으로 앱을 사용하면서 이벤트를 받을 수 있는 상태
- **`Background`**
    - 앱이 백그라운드에 있고, 다른앱으로 전환되었거나 홈 버튼을 눌러 나갔을 때의 상태
    - Background상태로 실행되는 앱은 inactive대신 background상태로 진입한다.
    - suspended상태가 되기 전 잠깐 머무는 상태
    - 코드가 실행중이지만 사용자의 이벤트를 받을 수는 없다.
    - 홈버튼을 두번 눌러서 앱을 다시 열었으 ㄹ때 처음부터 재실행되지 않는다면 background상태에 있다가 올라온 것이다.
- **`Suspended`**
    - 앱이 `Background`상태에 있지만 아무 코드도 실행하지 않은 상태
    - 백그라운드에서 특별한 작업이 없을 경우 `Suspended`상태가 된다.
    - 이 상태에서는 앱이 메모리에 올라가있지만 아무 일도 하지않기 때문에 배터리를 사용하지 않습니다.
    - 메모리 부족현상이 발생하면 OS에 의해 메모리에서 없어질 수 있고, 메모리에서 사라질 때 알림을 해주지도 않습니다.

## SceneDelegate
정리하면 앱의 생명주기에는 다섯가지의 상태(`Not Running`, `Inactive`, `Active`, `Background`, `Suspended`)가 있고 각각의 상태에서 실행되는 함수를 AppDeleagte에서 UIApplicationDelegate 프로토콜을 채택하여 정의할 수 있다.

**AppDelegate는 앱의 생명주기 중 여러단계에서 해야할 일들을 개발자가 코드로 정의해줄수 있도록 도와주는 객체이다.**

### Scene, Multiple Scene
- 스토리보드에서 사용하는 Scene 이라는 용어와 Multiple Scene에서 사용하는 Scene이라는 용어는 의미가 다르다
- 스토리보드에서는 각 화면이 하나의 Scene을 의미한다.
- Multiplie Scene기능에서의 Scene은 하나의 앱이 여러 분신처럼 동시에 사용되는 경우, 각각의 분신을 의미한다.

<p align="center">
<img width="500" src="https://user-images.githubusercontent.com/76734067/209853996-894a1e69-ddce-4de8-9d71-78f087d69b2a.png">
</p>

- iOS13부터 지원되는 기능으로, 동일한 메모 앱이 두 화면으로 나뉘어서 사용되고 있고 이 각각의 Scene이라고 한다. 
- 각각의 Scene이 자신만의 생명주기가 필요하기 때문에 이를 컨트롤하기 위해 AppDelegate에 더해 SceneDelegate가 추가되었다.

Scene-based 라이프 사이클도 앱 생명주기와 크게 다르지 않다. 여러 상태가 있고 각 상태에서 delegate함수들이 호출되며, 이 함수들을 오버라이드 할 수 있다.

<p align="center">
<img width="430" alt="image" src="https://user-images.githubusercontent.com/76734067/209854334-86f08b70-ebb2-4550-87e5-0ce6a76560db.png">
</p>

지금까지 알아본 생명주기의 흐름을 하나의 이미지로 나타내 보면 다음과 같다.

![image](https://user-images.githubusercontent.com/76734067/209854432-ae693316-52df-4a02-8e8c-2882daddb70b.png)