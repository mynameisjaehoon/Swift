# 스위프트의 컴파일 과정
<p align="center">
<img width="40%" src="https://user-images.githubusercontent.com/76734067/212902404-1df721cc-724d-4be1-9266-73c0e9ac17e8.png">
</p>

## 1. 전처리(Preprocessor)
- 전처리 단계에서는 컴파일러에 제공할 수 있는 방식으로 프로그램을 변환하는 것이다.
- 매크로를 실제 정의로 바꾼다.(`#define`등)
- 파일 간의 참조관계(종속성)을 파악(#include)
- 컴파일 조건문을 파악한다(`#if`~, `#if else`, `#endif`)

그러나 잘 알고있듯이 Swift 컴파일러에는 전처리기가 없습니다. 그래서 지금까지 코드를 작성하면서 swift에서는 매크로를 사용할 수 없었습니다.<br>
스위프트에서도 파일간의 참조관계(종속성)이나 컴파일 조건문은 존재하는데 이를 어떻게 처리하는 걸까?<br>
- llbuild(하위 레벨 빌드 시스템)을 통해서 종속성을 해결하고 있다.
    - llbuild(low-level build system)은 빌드시스템을 구축하기 위한 라이브러리 세트를 말합니다.
    - 참고: [apple/swift-llbuild](https://github.com/apple/swift-llbuild)
- 컴파일 조건문은 프로젝트의 Build Setting에서 flag를 설정하여 사용할 수 있습니다.
    <p align="center">
    <img width="70%" src="https://user-images.githubusercontent.com/76734067/212905684-5124be66-7f2e-4dc8-a6e7-4e203a2904ef.png">
    </p>
- Active Compliation Conditions에 RELEASE를 추가하여 DEBUG모드냐, RELEASE모드냐에 따라 코드가 다르게 동작하도록 할 수 있습니다.
    ```swift
    #if RELEASE
    print("work at RELEASE")
    #elseif DEBUG
    print("work at DEBUG")
    #endif
    ```

## 2. 컴파일러(Compiler)
소스코드에 대한 정보를 수집하는 symbol table을 작성하고 고수준언어를 저수준언어인 어셈블리어로 변환하는 단계입니다.<br>
Swift의 컴파일 과정은 LLVM을 거쳐서 실행됩니다.
### LLVM(Low Level Virtual Machine)
- 프로그램을 컴파일, 링크, 런타임 등의 상황에서 프로그램의 작성언어에 상관업싱 최적화를 쉽게 구현할 수 있도록 구성되어있는 컴파일러이자 툴킷
- 중간 표현(Itermediate Representation, IR), 이진(Binary)코드를 구성, 최적화 및 생성하는데 사용되는 라이브러리

<p align="center">
<img width="70%" src="https://user-images.githubusercontent.com/76734067/212907342-e9a55681-709d-4c91-be71-06014387f705.png">
</p>

어려워서 나중에 이어서

# Reference
- [Understanding Xcode Build System](https://www.vadimbulavin.com/xcode-build-system/)
- [swift의 빌드과정은 어떻게 되는 것일까](https://velog.io/@minjunkim-dev/swift%EC%9D%98-%EB%B9%8C%EB%93%9C-%EA%B3%BC%EC%A0%95%EC%9D%80-%EA%B3%BC%EC%97%B0-%EC%96%B4%EB%96%BB%EA%B2%8C-%EB%90%98%EB%8A%94%EA%B1%B8%EA%B9%8C)