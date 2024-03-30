# 💊 **삐릿(Pill It) - 복용약 알림, 정보 관리**

[📱 앱 스토어](https://apps.apple.com/kr/app/%EC%82%90%EB%A6%BF-pill-it-%EB%B3%B5%EC%9A%A9%EC%95%BD-%EC%95%8C%EB%A6%BC-%EC%A0%95%EB%B3%B4-%EA%B4%80%EB%A6%AC/id6479727658)

![PillItImageMerge](https://github.com/Jin0331/Pill-IT/assets/42958809/afd41e86-1296-4133-aac3-736ea6e287a6)

> 출시 기간 : 2024.03.07 - 03.27 (약 3주)
>
> Release version : v1.0.2 (지속 업데이트 중 🚀)
>
> 기획/디자인/개발 1인 개발
>
> 프로젝트 환경 - iPhone 전용(iOS 15.0+), 라이트 모드 고정

---

## 🔆 **한줄소개**

***때맞춰 당신의 건강을 챙겨주는 빠릿빠릿한 약복용 비서 - 삐릿(Pill It)***

## 🔆 **핵심 기능**

* **의약품 정보 검색**

  * 식품의약안전처(의약품 제품 허가정보, 의약품 낱알식별 정보) API 연동 : 국내에서 신고 및 허가된 의약품(전문/일반)에 대한 정보 상세 검색

  * 의약품 상세 검색 기반의 복용약 등록 : 품목명, 업체명, 주성분, 분류명 등에 따른 자신의 복용약을 정확하게 등록

  * 의약품 상세정보 제공 : 보험(보험/비보험 여부), 성분함량, 효능효과, 용법용량, DUR 등 해당 의약품에 대한 상세정보 제공

* **복용약 등록 및 알림**

  * 복용약 사진 설정 : 식품의약처, 카메라촬영/앨범, 네이버 이미지 검색 기반의 복용약 사진 설정

  * 복용약 그룹 설정 : 사용자의 의약품 용도에 따른 N개 이상의 복용약에 대한 그룹 설정

  * 복용약 그룹 알림 설정 : 사용자의 복용약 주기(매일, 특정요일, 일/주/월 간격)에 따른 세부 시간 설정

  * 복용약 그룹 알림 : 사용자가 지정한 시간에 등록된 복용약 그룹에 대한 알림

## 🔆 **기술 스택**

* **프레임워크**

  ​	***UIKit***

* **디자인패턴**

  ​	***MVVM + MVC(MainTabbarController 한정)***

* **라이브러리**

  ​	***Realm*** - 복용약(Pill), 복용약 그룹(PillAlarm), 복용약 알림(PillAlarmDate) Table 구성 및 Repository Pattern 기반의 CRUD 구현

  ​	***Diffable DataSoruce*** - Hashable 기반의 각종 데이터의 변경 사항 추적 및 Snapshot을 활용한 UI 요소의 업데이트

  ​	***Alamofire*** - Router pattern 기반의 다수의 API 호출 및 Error Handling

  ​	***SearchTextField*** - User Input 기반의 userStoppedTypingHandler, itemSelectionHandler 구현을 통한 Text Auto Complete

  ​	***Kingfisher*** - Memory Leak 방지를 위한 Manul Cache clear 적용

  ​	***Toast-Swift+NVActivityIndicatorView*** - UX를 고려하여 사용자의 행동에 따른 상태 정보 제공

  ​	***SwipeableTabBarController+WHTabbar+Parchment+Tabman*** - 다수의 UITabBarController Library를 활용한 사용자 친화적 UI 구성

* 버전 관리

  ​	***Git(Git-Flow 적용), Github***

  

## 🔆  **Database Schema**
 ![DatabaseSchema](https://github.com/Jin0331/Pill-IT/assets/42958809/d40541b6-5bde-4590-9b90-8f38b45556f3)


