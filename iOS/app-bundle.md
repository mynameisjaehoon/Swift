# iOS 앱 번들 구조

## iOS앱 번들 구조
### 번들이란?
- 번들은 실행가능한 코드와 관련된 리소스(이미지, 사운드)을 한 공간에 묶은 파일 시스템에 있는 디렉토리이다.
- iOS, OS X 환경에서는 애플리케이션, 프레임워크, 플러그인, 그리고 다른 타입의 소프트웨어들이 번들이라고 할 수 있다.

## Application Bundle

Application Bundle은 개발자들에 의해서 가장 흔하게 생성되는 번들 타입이다. 앱을 성공적으로 실행시키기 위한 모든 것들을 저장합니다.
더 상세한 세팅이나 구조는 플랫폼(iOS, macOS)에 따라 달라지지만 번들을 사용하는 방법은 동일합니다.

애플리케이션 번들에 있는 파일들은 다음과 같습니다.

- **Info.plist**
    - 앱을 위한 설정(Configuration)정보를 담은 구조화된 파일(structured file)이다. 시스템이 이파일에 의존해서 애플리케이션 및 모든 관련 파일에 대한 정보를 식별하게 된다.
- **Executable**
    - 모든 애플리케이션은 반드시 실행가능한 파일이 필요하다. 이 파일은 애플리케이션의 메인 진입점(main entry point)와 앱 타겟과 정적으로 link된 모든 모드를 포함한다.
- **Resource files**
    - Executable file밖에 없는 데이터들을 의미한다.
    - 보통 이미지, 아이콘, 사운드, nib파일, 문자열 파일, 설정(Configuration)파일, 데이터 파일을 포함한다.
    - 모든 리소스 파일은 localized또는 nonlocalized될 수 있다.
    - localized된 파일이라면 Resource 서브디렉토리내에 대응하는 언어나 locale정보가 `lproj`확장자를 가진 파일로 저장된다.
- **Other support files**
    - 맥의 앱에는 추가적인 high-level리소스(private framework, plug-in, 도큐먼트 템플릿, 커스템 데이터 리소스등)을 추가할 수 있다.
    - iOS에서는 custom data resource를 포함하는 것이 가능하지만 custom framework, plug-ins는 불가능하다.

애플리케이션 번들 중 리소스는 거의 옵셔널하지만 항상 그런것은 아니다. 예를 들어 iOS 앱은 보통 추가적인 아이콘 이미지를 요구하기도 한다.(Xcode 14에 와서는 하나로 통일 할 수 있게 되었다.)

보통 iOS 앱의 애플리케이션 번들은 실행파일(executable)과 앱에 의해 사용되는 리소스(아이콘, 이미지, localized 컨텐츠)를 최상위 번들 
디렉토리에 포함한다. 아래는 Archive에 있는 MyApp이라는 앰의 구조이다. 서브디렉토리로 존재하는 파일들은 localized를 위한 파일이다. 하지만 얼마든지 서브디렉토리는 개발자가 직접생성하고 관련된 파일 끼리 리소를 관리하는 것도 가능하다.
```
MyApp.app
   MyApp
   MyAppIcon.png
   MySearchIcon.png
   Info.plist
   Default.png
   MainWindow.nib
   Settings.bundle
   MySettingsIcon.png
   iTunesArtwork
   en.lproj
      MyImage.png
   fr.lproj
      MyImage.png
```
위의 번들 구조에 포함되어있는 컨텐츠들에 대해 하나씩 살펴보자
- **MyApp**: 실제 앱 이름에서 `.app`확장자를 뗀 것이 곧 실행파일(executable)이다. 번들구조에 반드시 있어야한다.
- **Application icons**: `MyAppIcon.png`, `MySearchIcon.png`, `mySettingIcon.png`가 여기에 속한다. 아이콘은 앱을 나타내는데 사용하고, 홈 화면 또는 앱을 검색했을 때 아이콘이 가장먼저 보여지는 정보이므로 반드시 포함되어야한다.
- **Info.plist**: 번들ID, 버전 번호, 디스플레이 네임 등과 같은 앱의 설정(Configuration)정보를 담고 있는 파일로 꼭 포함되어야한다.
- **Launch Image**: 위 구조에서는 `Default.png`가 여기에 속한다. 앱의 initial interface를 보여주는 이미지이다. 시스템은 제공된 런치 이미지 중 하나를 앱이 윈도우와 유저 인터페이스를 로드할 동안 임시 배경으로 사용한다. 만약 이 런치 이미지가 없다면 검은 화면이 보여질 것이다.
-**MainWindow.nib**: 앱의 main nib file은 Launch Time에 앱을 로드하기 위한 기본 인터페이스 오브젝트를 포함한다. 보통 앱의 메인 윈도우 객체와 앱 델리게이트 객체를 가지고 있다.
- **Setting.bundle**: 앱의 specific preferences를 포함하는 특별한 타입의 플러그인이다. 이 번들은 preferences를 configure하고 디스플레이 하기 위한 property list와 다른 리소스 파일을 포함한다. 
- **Custom resource files**: non-localized 리소스들은 탑 레벨 리소스에, localized 리소스는 language-specific 서브 디렉토리에 위치한다.

### 정리
- 번들은 하나의 앱을 구성하는 여러가지 요소(실행파일, 리소스, Configuration등)을 한곳에 묶어서 관리하는 하나의 디렉토리, 묶음
- 필수적으로 포함되어야 하는것과 필수는 아니지만 포함시키기를 권장되는 것들이 있고 여기에는 각각의 역할이 있다.


# Reference
- [Documentation Archive - Bundle Structures](https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/BundleTypes/BundleTypes.html#//apple_ref/doc/uid/10000123i-CH101-SW1)