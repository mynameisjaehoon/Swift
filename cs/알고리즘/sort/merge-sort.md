# 병합정렬

병합정렬(Merge Sort)는 재귀적으로 수열을 나누어 정렬한 후 합치는 정렬법 입니다.

삽입, 선택, 버블 정렬이 `O(N^2)`에 동작하는 정렬인 반면에 병합정렬의 경우에는 O(NlogN)의 시간복잡도를 가지게 됩니다.

병합정렬을 하기 위해서는 먼저 서로다른 두 정렬된 리스트를 합쳐서 정렬된 리스트를 만드는 방법을 알아야 합니다. 두 리스트의 길이를 각각 N, M이라고 했을 때, 버블정렬과같은 방법을 사용하게 되면 시간복잡도는 `O((N+M)^2)`가 됩니다. 그런데 이것보다 훨씬 바르게 정렬할 수 있는 방법이 있습니다.

병합정렬을 하는 서로다른 두 정렬은 `정렬되어 있음`을 가정하기 때문에 가장 작은 원소를 찾기 위해서 N+M개의 원소를 찾을 필요없이 제일 앞에 가장 작은 원소가 있으므로 `O(1)`에 알 수 있습니다.

각 두개의 리스트를 비교해가면서 현재의 인덱스에서 작은 숫자를 완성된 리스트에 넣고, 넣은쪽의 인덱스를 증가시키는 쪽으로 진행하게 됩니다. 만약 둘중 하나의 리스트가 전부 완성된 배열에 들어갔다면 다른쪽의 리스트의 원소를 모두 집어넣으면 됩니다.

## 시간복잡도

병합정렬의 전체 과정을 살펴보면 리스트가 분할하는 부분과 합쳐나가는 부분으로 구분할 수 있습니다.

### 분할
분할하는 부분에서는 특별한 연산을 하는 것은 아니고, 함수 호출을 통해 개념적으로 분할하는 연산을 합니다. 함수호출의 횟수는 `1, 2, 4, ..., 2^k`으로 함수호출은 `1+2+4+...+2^k = 2N-1 = O(N)`번 발생합니다. 즉 분할하는 과정의 시간복잡도는 O(N)입니다.

### 병합
한 단계에서 다음단계로 나아가기 위해서 필요한 연산의 횟수는 전체원소의 갯수만큼 필요하다는 것을 알 수 있습니다. 전체 원소의 갯수가 N인 배열에서 지금 배열이 N/4로 나누어져 있는 경우라면 필요한 연산의 횟수는 `N/4 + N/4 + N/4 + N/4 = N`이 됩니다.

그리고 이러한 과정을 리스트원소가 1개일 때부터 `2^k`개가 될때까지 매번 2배씩 커지기 때문에 k번 수행하게 됩니다. 그렇기 때문에 합쳐나가는 과정은 `O(NK) = O(NlogN)`의 시간복잡도를 가집니다.

## 코드
코딩테스트를 파이썬으로 준비하는 관계로 파이썬으로 작성해보았습니다.

```python
arr = [6, -8, 1, 12, 8, 15, 7, -7]
tmp = [0] * 10000

def merge(start, end):
    mid = int((start + end) / 2)
    left_index = start
    right_index = mid

    for i in range(start, end):
        if right_index == end:
            tmp[i] = arr[left_index]
            left_index += 1
        elif left_index == mid:
            tmp[i] = arr[right_index]
            right_index += 1
        elif arr[left_index] <= arr[right_index]:
            tmp[i] = arr[left_index]
            left_index += 1
        else:
            tmp[i] = arr[right_index]
            right_index += 1

    for i in range(start, end):
        arr[i] = tmp[i]

def merge_sort(start, end):
    if end == start + 1:
        return
    mid = int((start + end) / 2)
    merge_sort(start, mid)
    merge_sort(mid, end)
    merge(start, end)

print(arr) # [6, -8, 1, 12, 8, 15, 7, -7]
merge_sort(0, len(arr))
print(arr) # [-8, -7, 1, 6, 7, 8, 12, 15]
```