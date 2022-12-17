# 아스키코드 ↔️ Character, String
> 아스키코드에서 `Character`나 `String` 타입으로 변환하는방법을 `UnicodeScalar`로 통일하였습니다.
### 아스키코드 ➡️ Character
```swift
print(UnicodeScalar("A").value) // 65
```
변수일 경우에는 다음과 같이 강제 옵셔널언래핑을 해주어야한다. 
```swift
print(UnicodeScalar(char)!.value)
```

### 아스키코드 ⬅️ Character
```swift
print(UnicodeScalar(63 + 2)) // Optional("A")
```