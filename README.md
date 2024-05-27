# 💊 **삐릿(Pill It) - 복용약 알림, 정보 관리**

[![히히](https://github.com/Jin0331/Pill-IT/assets/42958809/726199d4-52b4-4d23-b667-e619cd81c0f1)](https://apps.apple.com/kr/app/%EC%82%90%EB%A6%BF-pill-it-%EB%B3%B5%EC%9A%A9%EC%95%BD-%EC%95%8C%EB%A6%BC-%EC%A0%95%EB%B3%B4-%EA%B4%80%EB%A6%AC/id6479727658)

![PillItImageMerge](https://github.com/Jin0331/Pill-IT/assets/42958809/61ff75bb-22f8-4c07-8824-829048969cf0)


> 출시 기간 : 2024.03.07 - 03.27 (약 3주)
>
> Release version : v1.0.5 (지속 업데이트 중 🚀)
>
> 기획/디자인/개발 1인 개발
>
> 프로젝트 환경 - iPhone 전용(iOS 15.0+), 라이트 모드 고정

---

<br>

## 🔆 **한줄소개**

***때맞춰 당신의 건강을 챙겨주는 빠릿빠릿한 약복용 비서 - 삐릿(Pill It)***

<br>

## 🔆 **핵심 기능**

* **의약품 정보 검색**

  * 식품의약안전처(의약품 제품 허가정보, 의약품 낱알식별 정보) API 연동 : 국내에서 신고 및 허가된 의약품(전문/일반)에 대한 정보 검색

  * 의약품 상세 검색 기반의 복용약 등록 : 품목명, 업체명, 주성분, 분류명 등에 따른 자신의 복용약을 정확하게 등록

  * 의약품 상세정보 제공 : 보험(보험/비보험 여부), 성분함량, 효능효과, 용법용량, DUR 등 해당 의약품에 대한 상세정보 제공

* **복용약 등록 및 알림**

  * 복용약 사진 설정 : 식품의약처, 카메라촬영/앨범, 네이버 이미지 검색 기반의 복용약 사진 설정

  * 복용약 그룹 설정 : 사용자의 의약품 용도에 따른 N개 이상의 복용약에 대한 그룹 설정

  * 복용약 그룹 알림 설정 : 사용자의 복용약 주기(매일, 특정요일, 일/주/월 간격)에 따른 세부 시간 설정

  * 복용약 그룹 알림 : 사용자가 지정한 시간에 등록된 복용약 그룹에 대한 알림

<br>

## 🔆 **적용 기술**

* ***프레임워크***

  ​	UIKit

* ***아키텍쳐***

  ​	MVVM

* ***오픈 소스***(Cocoapods)

  ​	Realm / RxSwift / Alamofire /	Kingfisher / UserNotifications

  ​ SnapKit / SearchTextField / Toast-Swift / NVActivityIndicatorView / SwipeableTabBarController / WHTabbar / Parchment / Tabman

* ***버전 관리***

  ​	Git(Git-Flow 적용) / Github

  <br>


## 🔆 **적용 기술 소개**

***MVVM***

* View 및 Business 로직을 분리하기 위한 MVVM 아키텍처를 도입

* Input-Output 패턴 기반의 User Interaction과 View Data 핸들링


***Realm***

* Repository Pattern 기반의 데이터 로직 추상화

* 아래와 같은 Database Schema 구성 (**1:N**)

  ![DatabaseSchema](https://github.com/Jin0331/Pill-IT/assets/42958809/d40541b6-5bde-4590-9b90-8f38b45556f3)

***Reactive Programming***

* 비동기 Event의 관리를 위한 Custom Observable과 RxSwift를 이용한 Reactive Programming 구현

* Generic 기반의 Observable 구현

```swift
final class Observable<T> {
    
    private var closure : ((T) -> Void)?
    
    var value : T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ text: T) {
        self.value = text
    }
    
    func bind(_ closure : @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
}

```

***Alamorfie***

* Router pattern 기반의 네트워크 추상화

* Error Handling을 위한 Result Type 적용


***SearchTextField*** 

* User Interaction 기반의 userStoppedTypingHandler, itemSelectionHandler 구현을 통한 TextField의 Autocomplete 적용
 
  <img src="https://github.com/Jin0331/Pill-IT/assets/42958809/35fc427f-2924-4fc3-8679-1aa39cdac51d" width="20%" height="20%"/>

***SwipeableTabBarController, WHTabbar, Parchment, Tabman***

* 다수의 UITabBarController 연관 Open Source를 활용한 사용자 친화적 UI 구성


<br>

## 🔆 트러블슈팅

### 1. App의 Life-Cycle과 Background Timer를 이용한 오늘/내일 알림 등록을 통한 Local Notification 제한 극복

* **문제 상황**

  > ​	"iOS 디바이스는 알림을 최신 64개 알림으로 제한"한다. 개발 과정에서 해당 사항을 고려하지 않고, 복용약 알림을 등록할 때 생성되는 모든 Date를 iOS 디바이스에 등록하게 되어 알림이 정상적으로 발생하지 않는 문제 발생
  >
  > ​	-> 복용약 알림등록에서 알림 주기를 등록시간 06:00시 기준으로 "매일(365일) - 07:00, 12:00, 19:00"로 설정하는 경우, 365 * 3 = 1095개의 알림이 생성됨.

* **해결 방법**

  1. ``Local Notification``을 관리하는 ``RefreshManager 생성 (Singleton Pattern)``

  2. ``sceneDidBecomeActive`` (앱이 Terminated 된 후 다시 실행되었을 때)

      PillAlarmDate Table로부터 ``D-1,D+0,D+1 Date``에 해당하는 알림 목록 Fetch하고 ``Local Notification``을 등록하는 함수(RefreshManager.shared.resetNotificationAction) 실행

        ​	-> 앱이 Active 될때마다 실행되므로, ``UserDefault를 활용하여 D+0에서 최초 1번 실행``한 경우에는 이후 부터 실행되지 않음

        ​	-> 앱이 sceneDidDisconnect 된 경우 알림이 제대로 동작하지 않으므로, 사용자가 다시 앱을 실행할 수 있도록 Local Notification으로 유도

  3. ``sceneDidEnterBackground`` (앱이 Background로 전환되었을 때)

      Background -> Foreground 상태로 전환시, 최신 Local Notification을 등록할 수 있도록 Timer 사용

<br>

### 2. Realm Table의 isDeleted Attribute 추가를 통한, Realm과 Diffable Datasource가 연결 되었을 때 삭제시 Snapshot 문제 극복

* **문제 상황**

  >  DiffableDataSource에서는 Diff을 위해 삭제된 객체를 들고있어야 하는데, Realm은 데이터가 삭제되는 순간 해당 데이터에 접근할 수 없으므로 "Terminating app due to uncaught exception 'RLMException', reason: 'Object has been deleted or invalidated.'" 에러가 발생한다.

  ![img](https://blog.kakaocdn.net/dn/yJLGU/btruZPt9FBL/F7mZcbyjuNzpOl4ZF5CYN0/img.png)

* **해결 방법**

  1. Realm Table에서 임의의 Attribute인 Bool 타입의 isDeleted 생성 후 해당 Record의 Delete가 발생할 때, Realm Table에서 실제로 삭제되는 것이 아니고 isDeleted에 ``true`` 부여
  2. 또한, Realm Table에서 실제 삭제가 되는 것이 아니므로, 앱이 ``sceneDidDisconnect`` 또는 ``sceneDidEnterBackground`` 상태로 변경될 때 Delete 되도록 함
