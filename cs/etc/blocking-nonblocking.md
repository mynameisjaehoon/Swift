# Blocking-Non-Blocking / Synchronous-Asynchronous

블록킹과 논클로킹, 동기와 비동기를 구분할때 보통 아래의 이미지를 참고한다. 

<img width="70%" src="https://user-images.githubusercontent.com/76734067/213707324-721cd71d-f057-443a-b9c9-208bdb2c4872.png">

얼핏보면 Blocking이 Synchronous와 비슷해보이고, Non-Blocking이 Asynchronous와 비슷해 보인다.<br>
그래서 보통은 아래의 그림이 표시하는 개념을 잘 알고있다.

<img width="70%" src="https://user-images.githubusercontent.com/76734067/213708336-632f5350-2311-4063-a2e9-21e235481ff1.png">

두가지는 관심사가 다르다는 점을 이해해야 한다.
## Blocking/NonBlocking
> Blocking/NonBlocking은 `호출되는 함수`가 호출한 함수에게 제어권을 건내주는 유무의 차이라고 볼 수 있다.

- Blocking: 호출된 함수가 할일을 다 마칠 때까지 제어권을 가지고 있는다. 호출한 함수는 호출된 함수가 다 마칠 때까지 기다려야한다.
- Non-Blocking: 호출된 함수가 일을 다 마치지 않았어도 호출한 함수에게 제어권을 넘겨준다. 호출한함수가 호출된 함수를 기다리면서도 다른일을 진행할 수 있다.

즉, 호출된 함수에서 일을 시작할때 제어권을 리턴해주느냐, 할일을 마치고 리턴해주느냐에 따라 블럭과 논블럭으로 나누어진다고 볼 수 있다.

## Synchronous/Asynchronous
> Synchronous/Asynchronous는 호출되는 함수의 작업 완료 여부를 누가 신경쓰냐가 관심사이다.

- Synchronous: 호출하는 함수가 호출되는 함수의 작업 완료 후 리턴을 기다리거나, 호출되는 함수로부터 바로 리턴받아도 작업 완료 여부를 호출하는 함수 스스로 계속 확인하며 신경쓰는 것
- Asynchronous: 호출되는 함수에게 콜백을 전달해서 호출되는 함수의 작업이 완료되면 호출되는 함수가 전달받는 콜백을 실행하고 호출하는 함수는 작업완료 여부를 신경쓰지 않는 것.

## NonBlocking-Sync
위에서 설명한 대로 이해해보면 NonBlocking-Sync는 호출되는 함수는 제어권을 바로 호출한 함수로 넘기고, 작업완료 여부를 호출하는 함수가 신경쓰는 것이다. 신경쓰는 방법에는 기다리거나 물어보거나 두가지가 있는데 논 블로킹 함수를 호출했다면 제어권을 바로 돌려받으니 기다릴 필요는 없고 물어보는 일이 남는다.

논 블로킹메서드 호출 후 바로 반환 받아서 다른 작업을 할 수 있게 되지만 메서드 호출에 의해 수행되는 작업이 완료되는 것은 아니고, 호출하는 메서드가 호출되는 메서드 쪽에 계속 작업완료 여부를 문의하는 상태이다.

<img width="70%" src="https://user-images.githubusercontent.com/76734067/213715698-67c3b8a5-2cff-48b6-8218-e215d8b49e0c.png">

## Blocking-Async
이것도 위에서 설명한대로 이해해보면, 호출되는 함수가 바로 리턴되지 않고(=제어권을 바로 넘기지 않고), 호출하는 함수는 작업완료 여부를 신경쓰지 않는 것이다.

그림으로 살펴보면 다음과 같다.

<img width="70%" src="https://user-images.githubusercontent.com/76734067/213716065-18b56172-1e15-4d3b-93ac-3e0c9efaa569.png">

그림만봐도 Async이기 때문에 메서드가 완료되었는지 여부도 관심없으면서 제어권도 돌려받지 못하는 것을 보면 매우 비효율적인 것으로 보인다. 이점이 없어서 일부러 이방식을 사용할 필요는 없지만 의도하지 않게 Blocking-Async로 동작하는 경우가 있다고 한다. 원래는 NonBlocking-Async를 추구하다가 의도와는 다르게 실제로는 Blocking-Async가 되어버리는 경우라고 한다.

Blocking-Async의 대표적인 케이스가 Node.js와 MySQL의 조합이라고 한다.

Node.js쪽에서 콜백 지옥을 헤치면서 Async로 구현을 해도 결국 DB 작업 호출 시에는 MySQL에서 제공하는 드라이버를 호출하게 되는데, 이 드라이버가 Blocking방식이라고 한다. 

## 정리
> Blocking/NonBlocking은 호출되는 함수가 바로 리턴되느냐(=제어권을 바로 넘기느냐)의 차이.
>   - 바로 리턴하지 않으면 `Blocking`
>   - 바로 리턴하면 `NonBlocking`

> Synchronous/Asynchronous는 호출되는 함수의 작업 완료 여부를 누가 신경쓰느냐가 관심사이다.
>   - 호출되는 함수의 작업완료를 호출한 함수가 신경쓰면 `Synchronous`
>   - 호출되는 함수의 작업완료를 호출한 함수가 신경쓰지 않으면 `Asynchronous``

- 성능과 자원의 효율적 사용 관점에서 가장 유리한 모델은 `Async-NonBlocking`모델이다.


# Reference
- [Blocking-NonBlocking-Synchronous-Asynchronous](http://homoefficio.github.io/2017/02/19/Blocking-NonBlocking-Synchronous-Asynchronous/)