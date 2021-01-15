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

| 담당자 | 우선 순위 | 화면                                    | 기능                                                         | 세부설명                                             | 구현 여부 |
|:--------:| :-------- | :-------------------------------------- | :----------------------------------------------------------- | :--------------------------------------------------- | :-------- |
|송황호| P1        | 사용자등록                              | [이름 등록 / 위치 권한 허용 ](https://www.notion.so/c1ba1b9899c64a2697f5c9bb8e21f47a) |                                                      |     🌦      |
|이인애| P1        | 메인 화면                               | [오늘 기본 날씨 정보](https://www.notion.so/47dac27b83264c54b4bde474c929fdbd) |                                                      |       🌦    |
|이인애| P1        | 메인 화면                               | [맞춤 날씨 정보 (과거 나의 날씨 정보 기반)](https://www.notion.so/dd1381ec26af4f20b95fc83692d78914) | 비슷한 날씨에 등록한 날의 데이터 구체적인 기준 미정  |      🌦     |
|송황호| P1        | 메인 화면                               | [나의 날씨 정보 등록하기 버튼](https://www.notion.so/e1399c48b80046d286e34359d5494901) | 메인에서 '+' 버트 누르면 정보 등록 화면으로 넘어 감. |     🌦      |
|이인애| P1        | 메인 화면                               | [다른 지역 검색 버튼](https://www.notion.so/ac8c688da77847aa8cce1b9201ff3925) |                                                      |      🌦     |
|이다은| P1        | 날씨 정보 등록 화면                     | [텍스트 등록](https://www.notion.so/e10c5d6b37974bf4821003d2ef909013) |                                                      |       🌦    |
|이다은| P1        | 날씨 정보 등록 화면                     | [옷 차림 태그 하기 기능](https://www.notion.so/fbfbc71b064c47ac9e9ae95eefd1a96c) | 아우터, 상의, 하의, 기타                             |     🌦      |
|이다은| P1        | 날씨 정보 등록 화면                     | [옷 차림 카테고리 별 등록 기능](https://www.notion.so/40e80b4108f5457e8cb2988b02bb44a4) |                                                      |      🌦     |
|이인애| P1        | 메인 화면                               | [GPS 기능/ 현재 위치](https://www.notion.so/GPS-267667cfa032454a99c70be0b25ebd01) |                                                      |           |
|이인애| P2        | 메인 화면                               | [기본 날씨 정보 상세](https://www.notion.so/68c8ea52623d4fb89edea94f675bf880) | 수치 시각화(기본 날씨 정보)                          |     🌦      |
|이다은| P1        | 날씨 정보 등록 화면                     | [이모지 기능](https://www.notion.so/692f5fbfef564578b42e8667b06ec5c5) |                                                      |     🌦      |
|이예슬| P1        | 주별 캘린더 화면캘린더 디폴트(미리보기) | [상태 이모지 표시 ](https://www.notion.so/4f6b62589ba744c8979b5f4d3c24e2d8) |                                                      |     🌦      |
|이예슬| P1        | 주별 캘린더 화면캘린더 (선택보기)       | [해당 날짜 날씨 정보](https://www.notion.so/61992495e87744fdbb729041ea776651) |                                                      |     🌦      |
|이인애| P3        | 메인 화면                               | [설정 버튼](https://www.notion.so/0631b3f0a548433d94814221e2d8c1a5) |                                                      |      🌦     |
|이예슬| P1        | 주별 캘린더 화면캘린더 (선택보기)       | [해당 날짜 옷차림 정보](https://www.notion.so/9ce0a1d3f7c34124bedc2ce89bd64b94) |                                                      |     🌦      |
|이예슬| P1        | 주별 캘린더 화면캘린더 (선택보기)       | [해당 날짜 이모지](https://www.notion.so/36935e6019794a17a5fbf41ab7b0605f) |                                                      |      🌦     |
|이예슬| P1        | 주별 캘린더 화면캘린더 (선택보기)       | [해당 날짜 텍스트](https://www.notion.so/3c0b9320f54046018da0a2ce1a6e5eb8) |                                                      |      🌦     |
|송황호| P1        | 다른 지역 검색 화면                     | [검색창](https://www.notion.so/0400266aa83e4c9aa206f7809cedcb62) | 다른 지역 검색                                       |     🌦      |
|송황호| P1        | 다른 지역 검색 화면                     | [다른 지역 기본 날씨 정보](https://www.notion.so/89b7dcc594ae4cbca67b7ccfacf0de8d) |                                                      |      🌦     |
|송황호| P3        | 다른 지역 검색 화면                     | [다른 지역 날씨 탭 추가](https://www.notion.so/c024f5bbd3a541f7861d653f7e034c29) | 스와이프로 다른 지역                                 |      🌦     |
|이다은| P1        | 날씨 정보 등록 화면                     | [위치 정보 재확인 ](https://www.notion.so/87df3ff600604f00959a79f386402906) | 변경 시 다른 지역 검색화면 이동                      |       🌦    |
|이예슬| P2        | 월별 캘린더 화면캘린더 디폴트(미리보기) | [최저 / 최고 기온](https://www.notion.so/5ff3c5e1124b43adb947f8698821e918) |                                                      |     🌦      |
|이예슬| P2        | 월별 캘린더 화면캘린더 (선택보기)       | [제목 없음](https://www.notion.so/9e5d72edac3f40cb8f4b476a1c45995c) | 주별 캘린더 선택보기와 동일                          |      🌦     |
|이예슬| P2        | 월별 캘린더 화면캘린더 디폴트(미리보기) | [상태 이모지 표시](https://www.notion.so/dc4765fb6aa7425587a9fadce697af2b) |                                                      |     🌦      |

<br>

<br>

## 🌿 핵심 기능 구현 
<details><summary>캘린더</summary>
<p>

```swift5
//CalendarVC        
NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "ChangeDate"),object: selectedDate)
//CalendarDetailVC
NotificationCenter.default.addObserver(self, selector: #selector(selectedDateDidChange(_:)), name: NSNotification.Name(rawValue: "ChangeDate"), object: nil)
```
캘린더가 월간뷰/주간뷰가 따로 있어서 뷰 간에 데이터를 전달하는데에 NotificationCenter를 이용해 데이터를 전달했다.
</p>
</details>

<details><summary>테이블 뷰 셀 삭제 커스텀</summary>
<p>

1. 기본 화면에 대해서 StoryBoard에 만들기
2. StoryBoard에 만든 cell과 swipe했을 때 임의로 나올 Button을 Stack으로 묶어주기!
```swift
// MARK: - UI 생성하기 (Stack, Button)
let buttonStack: UIStackView = {
	let stackView = UIStackView()
	stackView.axis = .horizontal
	stackView.distribution = .fill
	stackView.alignment = .fill
	stackView.spacing = 7
	stackView.translatesAutoresizingMaskIntoConstraints = **false**
	return stackView
}()
let backButton: UIButton = {
	let btn = UIButton(type: .system)
	btn.setTitle(“삭제“, for: .normal)
	btn.setTitleColor(.black, for: .normal)
	btn.backgroundColor = UIColor.gray
	btn.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha:0.1)
	btn.layer.cornerRadius = 35
	btn.dropShadow(color: .black, offSet: CGSize(width: 0, height: 0), opacity: 0.7, radius: 1)
	return btn
}()
// MARK: - Layout 잡기
private func configureLayout() {
		leadingConstraint = backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
		deletTrailingConstraint = trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
	NSLayoutConstraint.activate([
		leadingConstraint,
		backView.topAnchor.constraint(equalTo: contentView.topAnchor),
		backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		backView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
		buttonStack.leadingAnchor.constraint(equalTo: backView.trailingAnchor, constant: 15),
		buttonStack.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
		buttonStack.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -10),
		buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
		])
}
// MARK: - Init StackView 안에 backButton 과 cell 넣기!
private func initView() {
	backView.frame = self.bounds
	self.contentView.addSubview(backView)
	self.contentView.addSubview(buttonStack)
	buttonStack.addArrangedSubview(backButton)
	addGesture()
}
```
3. swipe action을 pan Gesture를 통해 만들기!
```swift
private func addGesture() {
	let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanAction(**_**:)))
	backView.addGestureRecognizer(panGesture)
}
// MARK: - Action
@objc
func didPanAction(_ sender: UIPanGestureRecognizer) {
	let changedX = sender.translation(in: backView).x
	print(“----> \(changedX)“)
	if changedX < 0 {
		buttonStack.frame.size.width = -(changedX) - 15
		leadingConstraint.constant = changedX
		UIView.animate(withDuration: 0.1) {
			self.layoutIfNeeded()
	}
}
switch sender.state {
	case .ended:
		if changedX > -170 && changedX < -(buttonStack.bounds.width) {
			buttonStack.frame.size.width = 108
			leadingConstraint.constant = -buttonStack.bounds.width  -  15
			UIView.animate(withDuration: 0.3) {
				self.layoutIfNeeded()
				self.buttonStack.frame.size.width = 108
			}
		}else if changedX < -170{
			leadingConstraint.constant = -(self.backView.frame.size.width)
			UIView.animate(withDuration: 0.2) {
				self.layoutIfNeeded()
			}
			///해당 cell을 지우기 위한 data 전송
			didSwipe()
			DispatchQueue.main.asyncAfter(deadline: .now() + 1){
				self.leadingConstraint.constant = 0
				self.layoutIfNeeded()
				}
		}else {
			leadingConstraint.constant = 0
			UIView.animate(withDuration: 0.3) {
				self.layoutIfNeeded()
			}
		}
	default:
		break
	}
}
```

</p>
</details>

## 🔫 Extension 
<details><summary>Date Extension</summary>
<p>

```swift5
extension Date {
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    public var month: Int {
         return Calendar.current.component(.month, from: self)
    }
    public var day: Int {
         return Calendar.current.component(.day, from: self)
    }
    public var weekday: Int{
        return Calendar.current.component(.weekday, from: self) - 1
    }
    public var monthType: Int{
        if month<10{
            return 0
        }
        else{
            return 1
        }
    }
    public var currentYearMonth: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }

```
Date 클래스를 extension으로 캘린더 날짜 계산에 필요한 프로퍼티들을 계산해서 만들었다.
</p>
</details>
<details><summary>Toast Extension</summary>
<p>

```swift5
extension UIViewController{
    func showToast(message: String) {
        let width_variable: CGFloat = 33
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: self.view.frame.size.height-165, width: view.frame.size.width-2*width_variable, height: 50))
        // 뷰가 위치할 위치를 지정해준다. 여기서는 아래로부터 100만큼 떨어져있고, 너비는 양쪽에 10만큼 여백을 가지며, 높이는 35로
        toastLabel.backgroundColor = UIColor(red: 202/255, green: 241/255, blue: 235/255, alpha: 0.6)
        toastLabel.textColor = UIColor.mainGrey
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.SDGothicRegular16
        toastLabel.lineSetting(kernValue: -0.8)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 29.5
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
```
다양한 뷰에서 활용되는 토스트를 띄우기 위해 현재 뷰 위에 서브뷰 형태로 추가되는 토스트 익스텐션을 추가하였다.
</p>
</details>

</br>

## 🌤 웨디 Developers


- 👩‍💻 예슬

  

웨슬

  

- 👩‍💻 다은

  

뒈은

  

- 🧑‍💻 황호

  

웽호

  

- 👩‍💻 인애

  

웨애
