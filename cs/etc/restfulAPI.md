# REST, REST API, RESTful

- [REST](#rest)
    - [REST 란?](#rest란)
    - [REST의 장단점](#rest의-장단점)
    - [REST가 필요한 이유](#rest가-필요한-이유)
    - [REST 구성요소](#rest-구성-요소)
    - [REST의 특징](#rest의-특징)
        - 서버-클라이언트 구조
        - 무상태
        - 캐시처리 가능
        - 계층화
        - Code on Demand
        - 인터페이스 일관성
- [REST API](#rest-api)
    - [REST API란?](#rest-api란)
    - [REST API의 특징](#rest-api의-특징)
    - [REST API 설계 기본 규칙](#rest-api-설계-기본-규칙)
- [RESTful](#restful)
    - [RESTful이란?](#restful이란)
    - [RESTful의 목적](#restful의-목적)
    - [RESTful하지 못한 경우](#restful하지-못한-경우)

---

## REST
### REST란?
> `Representational State Transfer`의 약자

- 자원을 이름으로 구분하여 해당자원의 상태(정보)를 주고받는 것을 의미한다.
- 자원(resource)의 표현(representation)에 의한 상태 전달
    - 자원의 표현이란?
        - 자원(resource)
            - 해당 소프트웨어가 관리하는 모든 것<br>
                예) 문서, 그림, 데이터, 해당 소프트웨어 등
        - 자원의 표현
            - 그 자원을 표현하기 위한 이름<br>
                예) DB의 학생 정보가 자원일 때, `students`를 자원의 표현으로 정한다.
    - 상태(정보)전달
        - 데이터가 요청되어지는 시점에서 자원의 상태(정보)를 전달한다.
        - JSON또는 XML을 통해 데이터를 주고받는것이 일반적이다.
- 월드 와이드 웹(www)과 같은 분산 하이퍼미디어 시스템을 위한 소프트웨어 개발아키텍처의 한 형식
    - REST는 기본적으로 웹의 기존 기술과 HTTP프로토콜을 그대로 활용하기 때문에 웹의 장점을 최대한 활용할 수 있는 아키텍처 스타일이다.
    - REST는 네트워크 상에서 클라이언트와 서버 사이의 통신 방법 중 하나이다. 
- REST의 구체적인 개념
    - HTTP URI(Uniform Resource Identifier)를 통해 자원(Resource)를 명시하고, HTTP Method(POST, GET, PUT, PATCH, DELETE)를 통해 해당 자원에 대한 CRUD Operation을 적용하는 것이다.
        - REST는 자원기반의 구조(ROA, Resource Oriented Architecture)설계의 중심에 Resource가 있고, HTTP Method를 통해 Resource를 처리하도록 설계된 아키텍쳐를 의미한다.
        - 웹 사이트의 이미지, 텍스트, DB내용 등의 모든 자원에 고유한 ID인 HTTP URI를 부여한다.
        - CRUD Operation
            - Create: 생성(POST)
            - Read: 조회(GET)
            - Update: 수정(PUT)
            - Delete: 삭제(DELETE)
            - HEAD: header정보 조회(HEAD)

### REST의 장단점

- **장점**
    - `HTTP` 프로토콜의 인프라를 그대로 사용하므로 `REST API`사용을 위한 별도의 인프라를 구현할 필요가 없다.
    - `HTTP` 프로토콜의 표준을 최대한 활용하여 여러 추가적인 장점을 함께 가져갈 수 있게 해준다.
    - `HTTP` 표준 프로토콜에 따르는 모든 플랫폼에서 사용이 가능하다.
    - Hypermedia API의 기본을 지키면서 범용성을 보장한다.
    - REST API 메시지가 의도하는 바를 명확하게 나타내므로 의도하는 바를 쉽게 파악할 수 있다.
    - 여러가지 서비스 디자인에서 생길 수 있는 문제를 최소화한다.
    - 서버와 클라이언트의 역할을 명확하게 분리한다.
- **단점**
    - 표준이 존재하지 않는다.
    - 사용할 수 있는 메서드가 4가지 밖에 없다.(?)
        - HTTP Method 형태가 제한적이다.
    - 브라우저를 통해 테스트할 일이 많은 서비스라면 쉽게 고칠 수 있는 URL보다 Header의 값이 어렵게 느껴진다.
    - 구형 브라우저가 아직 제대로 지원해주지 못하는 부분이 존재한다.
        - PUT, DELETE를 사용하지 못한다
        - pushState를 지원하지 않는다.

### REST가 필요한 이유
- 애플리케이션 분리 및 통합
- 다양한 클라이언트의 등장
- 최근의 서버 프로그램은 다양한 브라우저와 안드로이드, iOS폰과 같은 모바일 디바이스에서도 통신할 수 있어야한다.
- 이런 멀티 플랫폼에 대한 지원을 위해 서비스 자원에 대한 아키텍쳐를 세우고 이용하는 방법을 모색한 결과 REST에 관심을 가지게 되었다.

### REST 구성 요소
- 자원(Resource): URI
    - 모든 자원에 고유한 ID가 존재하고, 이 자원은 서버에 존재한다.
    - 자원을 구별하는 ID는 `/groups/:group_id`와 같은 HTTP URI이다.
    - 클라이언트는 URI를 이용해서 자원을 지정하고 해당자원의 상태(정보)에 대한 조작을 서버에 요청한다.
- 행위: HTTP Method
    - HTTP 프로토콜의 메서드를 사용한다.
    - HTTP 프로토콜 메서드로는 GET, POST, PUT, DELETE가 있따.
- 표현(Representation of Resource)
    - 클라이언트가 자원의 정보에 대한 조작을 요청하면 서버는 이에 적절한 응답(Representation)을 보낸다.
    - REST에서 하나의 자원은 JSON, XML, TEXT, RSS등 여러 형태의 Representation으로 나타내질 수 있다.
    - JSON혹은 XML을 통해 데이터를 주고받는 것이 일반적이다.

### REST의 특징
 - 서버-클라이언트 구조
    - 자원이 있는 쪽이 서버, 자원을 요청하는 쪽이 클라이언트가 된다.
        - REST 서버: API를 제공하고 비즈니스 로직 처리 및 저장을 담당한다.
        - ~~클라이언트: 사용자 인증이나 context(세션, 로그인 정보)등을 직접 관리하고 책임진다.~~ -> 클라이언트가 직접 관리하는 것은 위험하다.
    - 서로간의 의존성이 줄어든다
- 무상태(Stateless)
    - HTTP 프로토콜은 Stateless Protocol이므로 REST역시 무상태성을 갖는다.
    - 클라이언트의 context를 서버에 저장하지 않는다.
        - 즉, 세션과 쿠키와 같은 context정보를 신경쓰지 않아도 되므로 구현이 단순해진다.
    - 서버는 각각의 요청을 완전히 별개의 것으로 인식하고 처리한다.
        - 각 API서버는 클라이언트의 요청만을 단순 처리한다.
        - 즉, 이전요청이 다음요청의 처리에 관련되어서는 안된다.
        - 서버의 처리방식에 일관성을 부여하고 부담이 줄어들며, 서비스의 자유도가 높아진다.
- Cacheable(캐시 처리가능)
    - 웹 표준 HTTP프로토콜을 그대로 사용하므로 웹에서 사용하는 기존의 인프라를 그대로 활용할 수 있다.
        - HTTP가 가진 가장 강력한 특징 중 하나인 캐싱 기능을 적용할 수 있다.
        - HTTP 프로토콜 표준에서 사용하는 last-Modified태그나 E-Tag를 이용하면 캐싱 구현이 가능하다.
    - 대량의 요청을 효율적으로 처리하기 위해 캐시가 요구된다.
    - 캐시 사용을 통해 응답시간이 빨라지고 REST Server 트랜잭션이 발생하지 않기 때문에 전체 응답시간, 성능, 서버의 자원 이용률을 향상시킬 수 있다.
- Layered System(계층화))
    - 클라이언트는 REST API 서버만 호출한다.
    - REST 서버는 다중 계층으로 구성될 수 있다.
        - API 서버는 순수 비즈니스 로직을 수행하고 그 앞단에 보안, 로드밸런싱, 암호화, 사용자 인증등을 추가하여 구조상의 유연성을 줄 수 있다.
        - 또한 로드밸런싱, 공유캐시등을 통해 확장성과 보안성을 향상시킬 수 있다.
    - 프록시, 게이트웨이 같은 네트워크 기반의 중간 매체를 사용할 수 있다.
- Code On Demand(옵션)
    - 서버로부터 스크립트를 받아서 클라이언트에서 실행한다.
    - 반드시 충족할 필요는 없다.
- Uniform Interface(인터페이스 일관성)
    - URI로 지정한 Resource에 대한 조작을 통일되고 한정적인 인터페이스로 수행한다.
    - HTTP 표준 프로토콜을 따르는 모든 플랫폼에서 사용이 가능하다
        - 특정 언어나 기술에 종속되지 않는다.




## REST API
### REST API란?
- API(Application Programming Interface)
    - 데이터와 기능의 집합을 제공하여 컴퓨터 프로그램간 상호작용을 촉진하며, 서로 정보를 교환가능 하도록 하는 것
- REST API의 정의
    - REST기반으로 서비스 API를 구현한 것
    - OPEN API: 누구나 사용할 수 있도록 공개된 API, 구글맵, 공공 데이터 등
    - 마이크로 서비스: 하나의 큰 애플리케이션을 여러 개의 작은 애플리케이션으로 쪼개어 변경과 조합이 가능하도록 만든 아키텍쳐
    - OPEN API, 마이크로 서비스를 제공하는 업체 대부분은 REST API를 사용한다.
### REST API의 특징
- 사내 시스템들도 REST기반으로 시스템을 분산해 확장성과 재사용성을 높여 유지보수 및 운용을 편리하게 할 수 있다.
- REST는 HTTP표준을 기반으로 구현하므로, HTTP를 지원하는 프로그램 언어로 클라이언트, 서버를 구현할 수 있다.
- 즉, REST API를 제작하면 델파이 클라이언트 뿐만 아니라, 자바, C# 웹 등을 이용해 클라이언트를 제작할 수 있다.
### REST API 설계 기본 규칙
**참고 리소스 원형**
> - 도큐먼트: 객체 인스턴스나 데이터베이스 레코드와 유사한 개념 
> - 컬렉션: 서버에서 관리하는 디렉터리라는 소스
> - 스토어: 클라이언트에서 관리하는 리소스 저장소

- URI는 정보의 자원을 표현해야 한다
    1. resource는 동사보다는 명사를, 대문자보다는 소문자를 사용해야한다.
    2. resource의 도큐먼트 이름으로는 단수명사를 사용해야한다.
    3. resource의 컬렉션 이름으로는 복수명사를 사용해야한다.
    4. resource의 스토어 이름으로는 복수명사를 사용해야한다.
        - `GET /Memeber/1` -> `GET /members/1`
- 자원에 대한 행위는 HTTP Mehod(GET, PUT, POST, DELETE 등)로 표현한다.
    1. URI에 HTTP Method가 들어가면 안된다.
        - `GET /members/delete/1` -> `DELETE /members/1`
    2. URI에 행위에 대한 동사 표현이 들어가면 안된다(즉, CRUD 기능을 나타내는 것은 URI에 사용하지 않는다.)
        - `GET /members/show/1` -> `GET /members/1`
        - `GET /members/insert/2` -> `POST /members/2`
    3. 경로 부분 중 변하는 부분은 유일한 값으로 대체한다 (id는 하나의 특정 resource를 나타내는 고유 값이다.)
        - student를 생성하는 route: `POST /students`
        - id=12인 student를 삭제하는 route: `DELETE /students/12`

## RESTful
### RESTful이란?
- 일반적으로 REST 아키텍처를 구혀하는 웹 서비스를 나타내기 위해 사용되는 용어이다.
    - REST API를 제공하는 웹 서비스를 `RESTful`하다고 할 수 있다.
- RESTful은 REST를 REST답게 쓰기 위한 방법으로, 누군가가 공식적으로 발표한 것이 아니다.
    - 즉, REST원리를 따르는 시스템은 RESTful이란 용어로 지칭된다.

### RESTful의 목적
- 이해하기 쉽고 사용하기 쉬운 REST API를 만드는 것
- RESTful한 API를 구현하는 근본적인 목적은 일관적인 컨벤션을 통한 API의 이해도 및 호환성을 높이는 것이다.
- 성능이 중요한 상황에서는 굳이 RESTful한 API를 구현할 필요는 없다.

### RESTful하지 못한 경우
- CRUD를 모두 POST로만 처리하는 API
- route에 resource, id외의 정보가 들어가는 경우(`/student/updateName`)