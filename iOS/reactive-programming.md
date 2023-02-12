# Reactive Programming이란?
> 다음글은 [What is Reactive Programming?](https://medium.com/@kevalpatel2106/what-is-reactive-programming-da37c1611382)를 그대로 번역한 것 입니다.

## What is Reactive Programming?
요즘 모두가 반응형 프로그래밍에 대해 이야기하고 있고, 우리는 반응형 프로그래밍이라는 새로운 것을 배우는데 호기심을 가지고 있습니다. 몇 군데에서 리액티브 프로그래밍이 사용되는 것을 본 적이 있지만 여전히 약간 혼란스러워서 몇가지 설명이 듣고 싶을 수도 있습니다.

이번 글에서는 리액티브 프로그래밍의 기본개념에 대해 알아보겠습니다. 다음 글부터는 실제 프로그래밍을 해보고 안드로이드 애플리케이션 개발에서 RxJava를 사용하는 방법을 배워보도록 하겠습니다.

먼저 우리가 가지고 잇는 문제가 무엇인지 설명해봅시다. 왜 반응형 프로그래밍이 필요할까요? 문제가 없다면 반응형프로그래밍을 사용할 필요도 없으니까요. 그렇죠??

## 비동기 작업이 필요한 이유가 무엇인가요??
간단한 대답은 **사용자 경험을 개선하기 위해서**입니다. 애플리케이션의 응답성을 높이고 싶기 때문입니다. 메인스레드가 멈추거나 속도가 느려지지 않고 사용자에게 원활한 사용자 경험을 제공하고자 하며, 사용자에게 불안정한 성능을 제공하고 싶지 않습니다.

메인스레드를 멈추지 않게 하려면 백그라운드에서 시간이 많이 걸리는 무거운 작업을 많이 수행해야 합니다. 또한 모바일 기기는 무거운 작업을 수행하기에 성능이 조힞 않기 때문에 서버에서 무거운 작업과 복잡한 계산을 수행하고자 합니다. 따라서 네트워크 운영을 위해 비동기 작업이 필요합니다.

## 평가 매트릭스(Evaluation Matrix)
<img width="50%" src="https://user-images.githubusercontent.com/76734067/218275735-f2753b93-a88f-40e8-9690-36bd717ddaa7.png">

모든 비동기작업을 처리하는 라이브러리에서 무엇이 필요한지 살펴보자. 아래 4가지를 비동기 라이브러리의 평가 매트릭스로 생각해볼 수 있습니다.

### Explicit execution
**새 스레드에서 여러 작업의 실행을 시작하면 이를 제어할 수 있어야 한다.** 백그라운드에서 작업을 수행하려는 경우 정보를 수집하고 준비합니다. 준비가 되면 바로 백그라운드 작업을 시작할 수 있습니다.

### Easy Thread Management(간편한 스레드 관리)
비동기 작업에서는 스레드 관리가 핵심입니다. 작업 중간이나 작업 종료 시 백그라운드 스레드에서 메인 스레드의 UI를 업데이트 해야하는 경우가 종종 있습니다. 그러기 위해서는 한 스레드(백그라운드 스레드)에서 다른 스레드(여기서는 메인 스레드)로 작업을 전달해야 합니다. 따라서 스레드를 쉽게 전환하고 필요할 때 작업을 다른 스레드로 전달할 수 있어야 합니다.

### Easy Composable(구성하기 쉬워야 한다)
비동기 작업을 생성하고 백그라운드 스레드를 돌리기 시작하면 다른 스레드(특히 UI스레드)에 의존하지 않고 작업을 수행하고 작업을 맟칠 때까지 다른 스레드와 독립적으로 유지하면 좋을 것입니다. 하지만 현실에서는 UI를 업데이트하고, 데이터베이스를 변경하고, 스레딩을 상호 의존적으로 만드는 더 많은 일들이 필요합니다. 따라서 비동기 라이브러리는 쉽게 Composable(구성)할 수 있어야하고 오류가 발생할 여지가 적어야합니다.

### Minimum the side effects(부작용 최소화)
여러 스레드로 작업하는 동안 다른 스레드로 인한 부작용이 최소화되어야 합니다. 이렇게 하면 새로운 사람이 코드를 쉽게 읽고 이해할 수 있으며 오류를 쉽게 추적할 수 있습니다.

## 그래서 반응형 프로그래밍이란 무엇인가?
위키백과에 따르면 다음과 같이 나와 있습니다.
> 반응형 프로그래밍은 데이터 흐름과 변화의 전파를 중심으로 하는 프로그래밍 패러다임입니다. 즉, 사용되는 프로그래밍 언어에서 정적 또는 동적 데이터 흐름을 쉽게 표현할 수 있어야 하며, 기본 실행 모델이 데이터 흐름을 통해 자동으로 변경사항을 전파합니다.

간단히 말해, Rx프로그래밍에서는 한 컴포넌트에서 데이터 흐름을 내보내면 Rx 라이브러리가 제공하는 기본 구조가 해당 데이터 변경사항을 수신하도록 등록된 다른 컴포넌트에 해당 변경사항을 전파합니다. 간단히 말해서 Rx는 세가지 핵심 요소로 구성됩니다.

`Rx = Observable + Observer + Schedulers`

### Observable
`Observable`은 데이터 스트림입니다. 하나의 스레드에서 다른 스레드로 전달할 수 있는 데이터를 담습니다. 기본적으로 설정에따라서 주기적으로 또는 라이브 사이클에 따라 한번만 데이터를 방출합니다. Observer가 특정 이벤트에 따라 특정 이벤트를 내보낼 수 있도록 도와주는 다양한 연산자가 있지만, 다음 편에서 살펴보겠습니다. 지금은 Observeer를 공급자로 생각할 수 있습니다. 이들은 데이터를 처리해서 다른 컴포넌트에 공급합니다. 

### Observer
`Observer`는 `Observable`이 방출하는 데이터 스트림을 소비합니다. 옵저버는 `subscribeOn()`메서드를 사용해서 `Observer`는 `Observable`이 방출하는 데이터를 받습니다. `Observable`이 데이터를 방출할 때마다 등록된 모든 `Observer`가 `onNext()` 콜백으로 데이터를 수신하게 됩니다. 여기서 `JSON`응답을 파싱하거나 UI를 업데이트하는 등 다양한 작업을 수행할 수 있습니다. `Observer`에서 에러가 발생하면 `Observer`가 `onError()`로 에러를 수신하게 됩니다.

### Schedulers
Rx는 비동기 프로그래밍을 위한 것으로 스레드 관리가 필요하다고 하였습니다. 여기서 Scheduler가 등장합니다. 스케줄러는 옵저버와 옵저버가 어느 스레드에서 실행해야 하는지 알려주는 Rx의 구성요소 입니다. 옵저버에게 어느 스레드에서 옵저버를 실행해야 하는지 알려주는 메서드인 observeOn()을 사용할 수 있습니다. 또한 scheduleOn()메서드를 사용하여 어떤 스레드에서 실행해야 하는지 옵저버에게 알릴 수 있습니다.

## 애플리케이션에서 Rx를 사용하기 위한 3단계

<img width="50%" src="https://user-images.githubusercontent.com/76734067/218329400-83e98024-1491-4a50-81d4-5e5ba2d4c2aa.png">

```java
Observable<String> database = Observable      //Observable. This will emit the data
                .just(new String[]{"1", "2", "3", "4"});    //Operator

 Observer<String> observer = new Observer<String>() {
           @Override
            public void onCompleted() {
                //...
            }

            @Override
            public void onError(Throwable e) {
                //...
            }

            @Override
            public void onNext(String s) {
                //...
            }
        };

database.subscribeOn(Schedulers.newThread())          //Observable runs on new background thread.
        .observeOn(AndroidSchedulers.mainThread())    //Observer will run on main UI thread.
        .subscribe(observer);  
```


### 1. 데이터를 방출하는 **`Observable`** 을 만든다.

`database`변수가 데이터를 방출하는 Observable입니다. 이 경우에는 문자열을 방출하고 있습니다. just()는 연산자이고, 기본적으로 인자에 제공된 데이터를 하나씩 출력합니다.

### 2. 데이터를 소비하는 **`Observer`** 를 생성한다.

위 코드에서 observer 변수가 database observable이 방출하는 데이터를 소비하는 observer이다. observer는 받은 데이터를 처리하고 내부에서 에러를 관리하기도 한다.

### 3. 동시성을 관리하는 **`Scheduler`** 를 정의한다.

마지막으로 병렬성을 관리하기 위한 scheduler를 정의한다. `subscribeOn(Schedulers.newThread())`는 observable에게 백그라운드 스레드에서 실행되도록 발하는 것이다. `observeOn(AndroidSchedulers.mainThread())`는 observer에게 메인 스레드에서 실행되도록 한다. 이것이 반응형 프로그래밍의 기본이다.