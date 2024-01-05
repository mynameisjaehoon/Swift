# 동시성과 관련된 문제들(Concurrency Problems)

동시성 문제가 발생하는 이유는 2개 이상의 쓰레드를 사용하면서 동일한 메모리 접근 등으로 인해 발생할 수 있는 문제. 반대되는 개념으로는 Thread Safe가 있다. 여러쓰레드가 동시에 쓰여도 안전하고 동시적인 처리를 하면서 문제없이 스레드를 안전하게 사용한다는 개념이다.

그래서 어떤 객체나 변수에 여러 쓰레드를 사용하여 접근하여도 한번에 한개의 쓰레드만 접근가능하도록 처리하여 경쟁상황의 문제없이 사용할 수 있도록 만든것을 Thread Safe하게 처리했다 라는 것을 의미한다.

동시성 문제들에는 다음 세가지의 주제들이 있다.

1. Race Condition
2. Deadlocks
3. Priority Inversion

## Race Condition