## **들여쓰기 및 띄어쓰기**

- 들여쓰기에는 탭(tab) 대신 2개의 space를 사용합니다.

- 콜론(`:`)을 쓸 때에는 콜론의 오른쪽에만 공백을 둡니다.

  ```swift
  let names: [String: String]?
  ```

- 연산자 오버로딩 함수 정의에서는 연산자와 괄호 사이에 한 칸 띄어씁니다.

  ```swift
  func ** (lhs: Int, rhs: Int)
  ```

## **최대 줄 길이**

- 한 줄은 최대 99자를 넘지 않아야 합니다.

  Xcode의 **Preferences → Text Editing → Display**의 'Page guide at column' 옵션을 활성화하고 99자로 설정하면 편리합니다.

## **빈 줄**

- 빈 줄에는 공백이 포함되지 않도록 합니다.

- 모든 파일은 빈 줄로 끝나도록 합니다.

- MARK 구문 위와 아래에는 공백이 필요합니다.

  ```swift
  class{
  	//MARK: - Custom Variables
  	
  	
  	
  	//MARK: - IBOutlets
  
  	@IBOutlet
  	@IBOutlet
  	
  	//MARK: - LifeCycle Methods
  
  	override func viewDidLoad(){
  	
  	}
  	
  	//MARK: - Custom Methods
  	
  	//MARK: - @objc Methods
  	
  	//MARK: - IBActions
  }
  //MARK: - UITableViewDelegate
  
  //MARK: - UITableViewDatasource
  ```

## **임포트**

모듈 임포트는 알파벳 순으로 정렬합니다. 내장 프레임워크를 먼저 임포트하고, 빈 줄로 구분하여 서드파티 프레임워크를 임포트합니다.

```swift
import UIKit

import SwiftyColor
import SwiftyImage
import Then
import URLNavigator
```

## 네이밍

### 클래스

- 클래스 이름에는 UpperCamelCase를 사용합니다.
- 클래스 이름에는 접두사Prefix를 붙이지 않습니다.

### 함수

- 함수 이름에는 lowerCamelCase를 사용합니다.

- Action 함수의 네이밍은 '주어 + 동사 + 목적어' 형태를 사용합니다. **지키면 좋다**

  - Tap(눌렀다 뗌)*은 `UIControlEvents`의 `.touchUpInside`에 대응하고, *Press(누름)*는 `.touchDown`에 대응합니다.
  - will~*은 특정 행위가 일어나기 직전이고, *did~*는 특정 행위가 일어난 직후입니다.
  - should~*는 일반적으로 `Bool`을 반환하는 함수에 사용됩니다.

  **좋은 예:**

  ```swift
  func backButtonDidTap() {
    // ...
  }
  ```

  **나쁜 예:**

  ```swift
  func back() {
    // ...
  }
  
  func pressBack() {
    // ...
  }
  ```

### 변수

- 변수 이름에는 lowerCamelCase를 사용합니다.

### 상수

- 상수 이름에는 lowerCamelCase를 사용합니다.

  **좋은 예:**

  ```swift
  let maximumNumberOfLines = 3
  ```

  **나쁜 예:**

  ```swift
  let kMaximumNumberOfLines = 3
  let MAX_LINES = 3
  ```

### 열거형

- enum의 각 case에는 lowerCamelCase를 사용합니다.

  **좋은 예:**

  ```swift
  enum Result {
    case .success
    case .failure
  }
  ```

  **나쁜 예:**

  ```swift
  enum Result {
    case .Success
    case .Failure
  }
  ```

### 약어

- 약어로 시작하는 경우 소문자로 표기하고, 그 외의 경우에는 항상 대문자로 표기합니다.

  **좋은 예:**

  ```swift
    let userID: Int?
    let html: String?
    let websiteURL: URL?
    let urlString: String?
  ```

  **나쁜 예:**

  ```swift
    let userId: Int?
    let HTML: String?
    let websiteUrl: NSURL?
    let URLString: String?
  ```

  - tableView - TV
  - tableViewCell - TVC
  - collectionView- CV
  - collectionView Cell - CVC
  - viewController - VC
  - navigationController - NVC

  ### **Delegate**

  - Delegate 메서드는 프로토콜명으로 네임스페이스를 구분합니다.

    **좋은 예:**

    ```swift
    protocol UserCellDelegate {
      func userCellDidSetProfileImage(_ cell: UserCell)
      func userCell(_ cell: UserCell, didTapFollowButtonWith user: User)
    }
    ```

    **나쁜 예:**

    ```swift
    protocol UserCellDelegate {
      func didSetProfileImage()
      func followPressed(user: User)
    
      // `UserCell`이라는 클래스가 존재할 경우 컴파일 에러 발생
      func UserCell(_ cell: UserCell, didTapFollowButtonWith user: User)
    }
    ```

  ## **타입**

  - `Array<T>`와 `Dictionary<T: U>` 보다는 `[T]`, `[T: U]`를 사용합니다.

    **좋은 예:**

    ```swift
    var messages: [String]?
    var names: [Int: String]?
    ```

  ## **주석**

  - `///`를 사용해서 문서화에 사용되는 주석을 남깁니다.

    ```swift
    /// 사용자 프로필을 그려주는 뷰
    class ProfileView: UIView {
    
      /// 사용자 닉네임을 그려주는 라벨
      var nameLabel: UILabel!
    }
    ```

  UpperCamalCase

  - 클래스
  - 구조체
  - 익스텐션
  - 프로토콜
  - 열거형

  lowerCamelCase

  - 함수
  - 메서드
  - 인스턴스

[참고](https://github.com/StyleShare/swift-style-guide)
