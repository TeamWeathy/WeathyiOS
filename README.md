
# ☁️ 나에게 돌아오는 맞춤 날씨 서비스, Weathy  ☁️
<img style="border: 1px solid black !important; border-radius:20px; " src="https://user-images.githubusercontent.com/63707317/103549586-f7b3c680-4eea-11eb-9ef1-248da4b4bbb2.png" width="600px" />

<br> <br>
  ## 🛠 개발 환경 및 사용한 라이브러리 (Development Environment and Using Library)
  
<img src="https://camo.githubusercontent.com/aed50ad10015be965f5e23eb27a2c2094d335d3cf8b334014c3676ac5425a013/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f694f532d3030303030303f7374796c653d666f722d7468652d6261646765266c6f676f3d696f73266c6f676f436f6c6f723d7768697465"> <img src="https://camo.githubusercontent.com/42cf4ea24de2413dc2e79ddc2476f9e26a2fbebb841adfe323ceae6098368c98/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f53776966742d4641373334333f7374796c653d666f722d7468652d6261646765266c6f676f3d7377696674266c6f676f436f6c6f723d7768697465">
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://creativecommons.org/licenses/by/4.0/) ![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg) 


  

- iOS 13.0+

- Xcode 12.3

  
  <br> <br>
### 라이브러리

  | 라이브러리(Library) | 목적(Purpose) | 버전(Version) |

|:---|:----------|----|
| Alamofire | 서버 통신 | 5.2.2|
| Kingfisher  | 이미지 처리 | 5.0 |
| SnapKit  | Layout 설정 | 5.0.0 |

  <br> <br>

## 📝 Coding Convention

  

해당 가이드 참조 --> [👉이동하기](./Docs/CodingConvention.md)

  

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

- Main

    └── develop

            ├── feature/1 (# Issue Number)

            ├── feature/2

            └── feature/3

```

****각자 자신이 맡은 기능 구현에 성공시! feature Branch에  push 해서  pull request 하는 방식****

  
<br> <br>
- feature 브랜치 생성

  

```bash

git cheackout -b feat/<Issue number>

```

  

- 작업 완료 후 커밋

  

```bash

git add .

git commit -m "커밋 메세지"     // [@@@@] 해당 작업 내용

```

  

- 푸시 (현재 ****feat/이슈번호**** 브랜치)  -> ****pull**** ****request~****

  

```bash

git push -u origin feat/<Issue number> 브랜치

```


- 기존에 있던 브랜치 삭제 

  

```bash

git branch -d <branchname>                 // 커밋 완료한 브랜치 삭제 
git branch -D <branchname>                // 커밋 완료하지 않은 브랜치 삭제 
git push origin -- delete <branchname>     // git에 push 되어있는 Branch 삭제

```

  

- 신규 브랜치 생성

  

```bash

git checkout develop             // develop 브랜치로 이동 

git pull origin < develop >     // 합쳐진 develop pull 받기 
git checkout -b < feat/2 >         // feature 브랜치 만들면서 이동 
git push -u origin < feat/2 >     // 브랜치 생성+이동 후 바로 이 명령어하면 로컬 - 리모트 연결 되고 이후 origin 뭐시기 노필요

```

해당 가이드 ---> [참고](https://woowabros.github.io/experience/2017/10/30/baemin-mobile-git-branch-strategy.html)

<br> <br>
  ### 📜커밋 메시지 명령어
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
### 칸반 보드

  

- Github Issue와 Project 이용

-  [👉 이동하기](https://github.com/TeamWeathy/WeathyiOS/projects/1)

<br> <br>
## 👏 기능 소개 (Function Introduction)

  

| 이름 | 화면 | 기능설명 | 중요도 | 구현여부 |
|:--------|:--------|:--------:|:---------|:--------:|
| 예슬 | 캘린더 |  | 1 | ⭕️|

<br> <br>

| 이름 | 화면 | 기능설명 | 중요도 | 구현여부 |
|:--------|:--------|:--------:|:---------|:--------:|
| 다은 | 날씨 기록 |  | 1 | ⭕️|

<br> <br>

| 이름 | 화면 | 기능설명 | 중요도 | 구현여부 |
|:--------|:--------|:--------:|:---------|:--------:|
| 황호 | 설정 |  | 1 | ⭕️|

<br> <br>

| 이름 | 화면 | 기능설명 | 중요도 | 구현여부 |
|:--------|:--------|:--------:|:---------|:--------:|
| 인애 | 메인 |  | 1 | ⭕️|



<br> <br>
## 🌤 웨디 Developers
  

- 👩‍💻 예슬

  

웨슬

  

- 👩‍💻 다은

  

뒈은

  

- 🧑‍💻 황호

  

웽호

  

- 👩‍💻 인애

  

웨애


