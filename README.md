![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://creativecommons.org/licenses/by/4.0/)  

# ☁️ 나에게 돌아오는 맞춤 날씨 서비스, Weathy  ☁️

<br>

![image](https://user-images.githubusercontent.com/42545818/104703718-073cd600-575b-11eb-881d-41af708a10a8.png)

<br>

<br>

## ☁️ 워크 플로우

[웨디 워크플로우로!](./Docs/weathy_workflow.png)



  ## 🛠 개발 환경 및 사용한 라이브러리 (Development Environment and Using Library)

- iOS 13.0+

- Xcode 12.3

  
  <br> <br>
### 라이브러리

| 라이브러리(Library) | 목적(Purpose) | 버전(Version) |
|:---|:----------|----|
| Alamofire | 서버 통신 | 5.2.2|
| Lottie-ios | 애니메이션 처리 |  |

  <br> <br>

## 📝 Coding Convention

  

 [👉웨디 코딩컨벤션으로!](./Docs/CodingConvention.md)

  

### 🗂 폴더링

  

```markdown

🗂 Resources

    - AppDelegate

    - SceneDelegate

    - Assets
    
    - APIServices 🗂

    - Storyboards 🗂

    - Xibs🗂

🗂 Sources

    - VCs 🗂

        - Main 🗂

        - Login 🗂

        - Calendar 🗂

        - ...

    - Cells 🗂

    - Classes 🗂

    - Extensions 🗂

    - Models 🗂

```

  

<br> <br>
## 💻 Github Branch  strategy

  

<img src="https://camo.githubusercontent.com/5af55d4c184cd61dabf0747bbf9ebc83b358eccb/68747470733a2f2f7761632d63646e2e61746c61737369616e2e636f6d2f64616d2f6a63723a62353235396363652d363234352d343966322d623839622d3938373166396565336661342f30332532302832292e7376673f63646e56657273696f6e3d393133" width="80%">

- main : 제품으로 출시될 수 있는 브랜치

- develop : 다음 출시 버전을 개발하는 브랜치

- feature : 기능을 개발하는 브랜치
```

- main

    └── develop

            ├── feat/1 (# Issue Number)

            ├── feat/2

            └── feat/3

```

<br> <br>

​	[참조](https://woowabros.github.io/experience/2017/10/30/baemin-mobile-git-branch-strategy.html)

<br> <br>

  ### 📜 커밋 메시지 명령어
```
  - init : 초기화 
  - add : 기능 추가 
  - update : 기능 보완 (업그레이드)
  - fix : 버그 수정 
  - refactor: 리팩토링 
  - style : 스타일 (코드 형식, 세미콜론 추가: 비즈니스 로직에 변경 없음) 
  - docs : 문서 (문서 추가(Add), 수정, 삭제) 
  - test : 테스트 (테스트 코드 추가, 수정, 삭제: 비즈니스 로직에 변경 없음) 
  - chore : 기타 변경사항 (빌드 스크립트 수정, 에셋 추가 등)
```

<br> <br>
### 🗂 칸반 보드

- Github Issue와 Project 이용

-  [👉 웨디 이슈보드로!](https://github.com/TeamWeathy/WeathyiOS/projects/1)

<br> <br>

## 👏 기능 소개 (Function Introduction)

  기능 명세서 

| 우선 순위 | 화면                                    | 기능                                                         | 세부설명                                             | 구현 여부 |
| :-------- | :-------------------------------------- | :----------------------------------------------------------- | :--------------------------------------------------- | :-------- |
| P1        | 사용자등록                              | [이름 등록 / 위치 권한 허용 ](https://www.notion.so/c1ba1b9899c64a2697f5c9bb8e21f47a) |                                                      |           |
| P1        | 메인 화면                               | [오늘 기본 날씨 정보](https://www.notion.so/47dac27b83264c54b4bde474c929fdbd) |                                                      |           |
| P1        | 메인 화면                               | [맞춤 날씨 정보 (과거 나의 날씨 정보 기반)](https://www.notion.so/dd1381ec26af4f20b95fc83692d78914) | 비슷한 날씨에 등록한 날의 데이터 구체적인 기준 미정  |           |
| P1        | 메인 화면                               | [나의 날씨 정보 등록하기 버튼](https://www.notion.so/e1399c48b80046d286e34359d5494901) | 메인에서 '+' 버트 누르면 정보 등록 화면으로 넘어 감. |           |
| P1        | 메인 화면                               | [다른 지역 검색 버튼](https://www.notion.so/ac8c688da77847aa8cce1b9201ff3925) |                                                      |           |
| P1        | 날씨 정보 등록 화면                     | [텍스트 등록](https://www.notion.so/e10c5d6b37974bf4821003d2ef909013) |                                                      |           |
| P1        | 날씨 정보 등록 화면                     | [옷 차림 태그 하기 기능](https://www.notion.so/fbfbc71b064c47ac9e9ae95eefd1a96c) | 아우터, 상의, 하의, 기타                             |           |
| P1        | 날씨 정보 등록 화면                     | [옷 차림 카테고리 별 등록 기능](https://www.notion.so/40e80b4108f5457e8cb2988b02bb44a4) |                                                      |           |
| P1        | 날씨 정보 등록 화면                     | [검색 키워드 추천(과거 옷 태그)](https://www.notion.so/cba66d62222a48e78061b223fa84e877) |                                                      |           |
| P1        | 메인 화면                               | [GPS 기능/ 현재 위치](https://www.notion.so/GPS-267667cfa032454a99c70be0b25ebd01) |                                                      |           |
| P2        | 메인 화면                               | [기본 날씨 정보 상세](https://www.notion.so/68c8ea52623d4fb89edea94f675bf880) | 수치 시각화(기본 날씨 정보)                          |           |
| P1        | 날씨 정보 등록 화면                     | [이모지 기능](https://www.notion.so/692f5fbfef564578b42e8667b06ec5c5) |                                                      |           |
| P1        | 주별 캘린더 화면캘린더 디폴트(미리보기) | [상태 이모지 표시 ](https://www.notion.so/4f6b62589ba744c8979b5f4d3c24e2d8) |                                                      |           |
| P1        | 주별 캘린더 화면캘린더 (선택보기)       | [해당 날짜 날씨 정보](https://www.notion.so/61992495e87744fdbb729041ea776651) |                                                      |           |
| P3        | 메인 화면                               | [설정 버튼](https://www.notion.so/0631b3f0a548433d94814221e2d8c1a5) |                                                      |           |
| P1        | 주별 캘린더 화면캘린더 (선택보기)       | [해당 날짜 옷차림 정보](https://www.notion.so/9ce0a1d3f7c34124bedc2ce89bd64b94) |                                                      |           |
| P1        | 주별 캘린더 화면캘린더 (선택보기)       | [해당 날짜 이모지](https://www.notion.so/36935e6019794a17a5fbf41ab7b0605f) |                                                      |           |
| P1        | 주별 캘린더 화면캘린더 (선택보기)       | [해당 날짜 텍스트](https://www.notion.so/3c0b9320f54046018da0a2ce1a6e5eb8) |                                                      |           |
| P1        | 다른 지역 검색 화면                     | [검색창](https://www.notion.so/0400266aa83e4c9aa206f7809cedcb62) | 다른 지역 검색                                       |           |
| P1        | 다른 지역 검색 화면                     | [다른 지역 기본 날씨 정보](https://www.notion.so/89b7dcc594ae4cbca67b7ccfacf0de8d) |                                                      |           |
| P3        | 설정 화면                               | [내 프로필](https://www.notion.so/ea1ae394d75e488592cbd35b3c9c4219) | 이름                                                 |           |
| P3        | 설정 화면                               | [옵션_ 푸시알림](https://www.notion.so/_-84f07b77979a4bf7ad1f9f2332ed705a) |                                                      |           |
| P3        | 다른 지역 검색 화면                     | [다른 지역 날씨 탭 추가](https://www.notion.so/c024f5bbd3a541f7861d653f7e034c29) | 스와이프로 다른 지역                                 |           |
| P3        | 위젯                                    | [날씨 정보 위젯](https://www.notion.so/eb8379e6a62c4e18b7f0b62293e3a71d) |                                                      |           |
| P1        | 날씨 정보 등록 화면                     | [위치 정보 재확인 ](https://www.notion.so/87df3ff600604f00959a79f386402906) | 변경 시 다른 지역 검색화면 이동                      |           |
| P3        | 날씨 정보 등록 화면                     | [사진 등록](https://www.notion.so/3f313c7ab77c4e22ae2fdfaf670c9ea4) |                                                      |           |
| P2        | 월별 캘린더 화면캘린더 디폴트(미리보기) | [최저 / 최고 기온](https://www.notion.so/5ff3c5e1124b43adb947f8698821e918) |                                                      |           |
| P2        | 월별 캘린더 화면캘린더 (선택보기)       | [제목 없음](https://www.notion.so/9e5d72edac3f40cb8f4b476a1c45995c) | 주별 캘린더 선택보기와 동일                          |           |
| P2        | 월별 캘린더 화면캘린더 디폴트(미리보기) | [상태 이모지 표시](https://www.notion.so/dc4765fb6aa7425587a9fadce697af2b) |                                                      |           |

<br>

 <br>

## 🌤 웨디 Developers


- 👩‍💻 예슬

  

웨슬

  

- 👩‍💻 다은

  

뒈은

  

- 🧑‍💻 황호

  

웽호

  

- 👩‍💻 인애

  

웨애


