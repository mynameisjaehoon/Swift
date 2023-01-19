# CPU 스케줄러

스케줄러에서 스케줄링할 대상은 Ready Queue에 있는 프로세스를 대상으로 한다.
## FCFS(First Come First Serve)
- 먼저온 작업을 먼저 처리해주는 방식이다.
- `Non-preemptive` 스케줄링
    - CPU를 잡으면 작업이 완료될 때까지 CPU를 반환하지 않는다. 할당되었던 CPU가 반환될 때만 스케줄링이 이루어진다.
- 소요시간이 긴 프로세스가 먼저 도달하게 되면 효율성이 낮아진다.

## SJF(Shortest-Job-First)
- 다른 프로세스가 먼저 도착했어도 CPU사용시간이 짦은 프로세스에게 CPU가 먼저 할당된다.
- `Non-preemptive` 스케줄링 방식이다.
- `starvation`
    - 효율성을 추구하는 것이 가장 중요하긴 하지만, 수행시간이 긴 프로세스가 영원히 CPU를 할당받지 못할수도 있다.

## SRTF(Shortest Remaing Time First)
- `SJF`의 preemtive한 버전이라고 생각하면 편하다.
- 새로운 프로세스가 도착할 때마다 새로운 스케줄링이 이루어진다.
- 선점형(`Preemptive`) 스케줄링
    - 현재 수행중인 프로세스의 남은 CPU 타임보다 더 짧은 CPU 타임을 가지는 프로세스가 도착하면 더 짧은 프로세스에게 CPU를 넘겨주는 스케줄링 방식이다.
- `starvation`
    - `SJF`와 동일하게 `starvation`문제가 있다.

## Priority-Scheduling
- `SJF`나 `SRTF`에서는 시간 짧게 걸리는 작업이 높은 우선순위를 가지고 처리되었다. 하지만 우선순위가 낮은 프로세스는 계속해서 뒤로 밀려서 CPU를 할당받지 못할수도 있는데, 이를 `starvation`이라고 한다.
- 우선순위가 가장 높은 프로세스에게 CPU를 할당하는 스케줄링을 말한다.
- Preemptive Scheduling
    - 더 높은 우선순위의 프로세스가 도착하면 실행중인 프로세스를 멈추고 CPU를 선점한다.
- Non-Premmptive Scheduling
    - 더 높은 우선순위의 프로세스가 도작하면 Ready Queue의 Head에 넣는다.
- 우선순위가 낮은 프로세스는 계속해서 뒤로 밀려서 CPU를 할당받지 못하는, `starvation`문제가 발생할 수 있다.
- 우선순위가 낮았던 프로세스라도 오래 기다리면 높은 우선순위를 주는 `aging`이라는 방법을 사용해서 해결한다.

### Round-Robin (~~정보처리기사 시험에서 갑자기 기억이 나지 않아서 쓰지 못했던~~)
- interactive한 작업을 할 때 현대에 보편적으로 사용할 수 있는 방법이다.
- 각 프로세스가 동일한 크기의 할당시간(time quantum)을 가지게 된다.
- 할당시간이 지나면 CPU가 다른 프로세스에게 선점당하고 ready queue의 가장 뒤에가서 다시 줄을 선다
- CPU사용시간이 랜덤한 프로세스들이 섞여있을 때 효율적이다.
- 프로세스의 context를 save할 수 있기 때문에 가능한 방식이다.
- 응답이 빠르다는 장점이 있지만, context switching이 자주 일어나는만큼 오버헤드가 많이 소모된다는 단점이 있다.

> ⚠️ 주의점<br>
> `time quantum`이 너무길어지면 `FCFS` 알고리즘과 다를바 없어진다.<br>
> `time quantum`이 너무 짧으면 context switching이 그만큼 자주일어나 오버헤드가 많이 소모된다.<br>
> 따라서 적절한 수준의 `time quantum`을 찾는 것이 중요하다.