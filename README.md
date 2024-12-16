# 가나다 퍼즐 게임

<div align="center">
  <img src="https://github.com/user-attachments/assets/9cca8637-d7d9-4ab6-bcb3-205af8b5f5c4" alt="AppIcon" width="200" />
</div>

가나다 퍼즐 게임은 [스푼랩](http://www.ssalfriends.com/)과의 협업 프로젝트로, 아이들이 한글 퍼즐을 통해 학습하면서 쌀의 매력을 느낄 수 있도록 제작된 iOS 전용 게임입니다.
해당 프로젝트는 스푼랩의 브랜드 정체성을 반영하여 식품을 단순히 섭취하는 데에서 멈추지 않고, 이를 지속 가능한 경험으로 확장하는데 포커싱 했습니다.
게임은 힌트 동영상을 시청하고, 퍼즐 조각을 조합하여 정답을 완성하는 방식으로 진행됩니다.
백엔드 없이 로컬 데이터를 활용해 MVP 형태로 개발되었습니다.

<div align="center">
  <img src="https://github.com/user-attachments/assets/3eab5dfd-bdd6-40bd-928d-62e8efdca881" alt="최종 화면" width="400" />
</div>

### **최종 화면**

<div align="center">
  <img src="https://github.com/user-attachments/assets/0f48eb3e-4258-481f-9a42-8fb824733e16" alt="시연 영상" />
</div>

### **프로젝트 구조**

```
SpunPuzzleGame
├── Views
│   ├── CustomAlertview.swift
│   ├── CustomNavigationBar.swift
│   ├── InfoView.swift
│   ├── MainView.swift
│   ├── PlayView.swift
│   ├── ProgressView.swift
│   ├── SettingView.swift
│   ├── SplashView.swift
│   └── VideoContainerView.swift
├── Controllers
│   ├── InfoViewController.swift
│   ├── PlayViewController.swift
│   ├── SettingsViewController.swift
│   ├── SplashViewController.swift
│   └── ViewController.swift
├── Extensions
│   ├── UIColor.swift
├── Resources
│   ├── Fonts
│   ├── Videos
│   └── Sounds
├── AppDelegate.swift
├── SceneDelegate.swift
├── Assets.xcassets
└── Info.plist
```

### **사용된 기술**

- **프론트엔드 기술**
    - **UIKit**: iOS 사용자 인터페이스 구현
    - **SnapKit**: 레이아웃 제약 조건 처리
    - **AVFoundation**: 동영상 및 사운드 재생
- **로컬 데이터 처리**
    - Swift 코드 내 배열로 하드코딩된 데이터를 사용하여 간단하게 구성.
    ```swift
    struct Quiz {
        let questionVideo: String  // 문제 동영상 이름
        let puzzle: [String]       // 퍼즐 조각
        let answer: [String]       // 정답 조각 순서
        let answerVideo: String    // 정답 동영상 이름
    }
    
    private var quizzes: [Quiz] = [
        Quiz(questionVideo: "거미 문제",
             puzzle: ["ㄱ", "ㅂ", "ㅓ", "ㅠ", "ㅣ", "ㅋ", "ㅁ", "ㅐ"],
             answer: ["ㄱ", "ㅓ", "ㅁ", "ㅣ"],
             answerVideo: "거미 정답"),
        Quiz(questionVideo: "나비 문제",
             puzzle: ["ㅣ", "ㅉ", "ㅏ", "ㅐ", "ㄴ", "ㅋ", "ㅗ", "ㅂ"],
             answer: ["ㄴ", "ㅏ", "ㅂ", "ㅣ"],
             answerVideo: "나비 정답"),
        Quiz(questionVideo: "사자 문제",
             puzzle: ["ㅋ", "ㅈ", "ㅗ", "ㅑ", "ㅠ", "ㅍ", "ㅅ", "ㅏ"],
             answer: ["ㅅ", "ㅏ", "ㅈ", "ㅏ"],
             answerVideo: "사자 정답"),
        Quiz(questionVideo: "하마 문제",
             puzzle: ["ㅁ", "ㅈ", "ㅏ", "ㅔ", "ㅇ", "ㄸ", "ㅃ", "ㅎ"],
             answer: ["ㅎ", "ㅏ", "ㅁ", "ㅏ"],
             answerVideo: "하마 정답")
    ]
    
    ```

### **주요 기능**

1. **퍼즐 조합 게임**
    - 동영상 힌트를 보고 퍼즐 조각을 조합해 정답 완성.
2. **힌트 동영상 재생**
    - AVFoundation을 사용하여 동영상 스트리밍 없이 로컬 파일 재생.
3. **진행도 관리**
    - ProgressView를 통해 사용자가 푼 문제 개수 및 전체 진행률 표시.
4. **사용자 피드백**
    - 정답 시 진동(Haptic Feedback) 및 성공 메시지 표시.
5. **설정 저장**
    - UserDefaults를 활용해 사운드 설정 저장.

### **📌 트러블슈팅**

1. **문제:** 동영상 재생 후 UI 레이아웃 깨짐
    
    **분석:** Auto Layout이 동영상 비율을 제대로 유지하지 못함.
    
    **해결:** SnapKit 제약 조건을 동영상 컨테이너 크기에 따라 유연하게 수정.
    
    **결과코드**:
    
    ```swift
    private func setupVideoPlayerConstraints() {
        videoContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(videoContainerView.snp.width).multipliedBy(9.0 / 16.0) // 16:9 비율 유지
        }
    }
    ```
    
2. **문제:** JSON 파일 파싱 과정 불필요한 복잡성
    
    **분석:** 데이터 로드를 백엔드 없이 구현해야 하는 상황에서 JSON 파일 사용은 비효율적.
    
    **해결:** 데이터를 Swift 코드에 하드코딩하여 간단하게 관리.
    
    **결과코드**:
    
    ```swift
    // 기존 JSON 데이터 로드 방식
    if let path = Bundle.main.path(forResource: "quizData", ofType: "json"),
       let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
        do {
            let decoder = JSONDecoder()
            quizzes = try decoder.decode([Quiz].self, from: data)
        } catch {
            print("JSON 데이터 로드 실패: \(error)")
        }
    }
    ```
    
    ```swift
    // 하드코딩된 데이터 배열로 대체
    private var quizzes: [Quiz] = [
        Quiz(questionVideo: "거미 문제",
             puzzle: ["ㄱ", "ㅂ", "ㅓ", "ㅠ", "ㅣ", "ㅋ", "ㅁ", "ㅐ"],
             answer: ["ㄱ", "ㅓ", "ㅁ", "ㅣ"],
             answerVideo: "거미 정답"),
        Quiz(questionVideo: "나비 문제",
             puzzle: ["ㅣ", "ㅉ", "ㅏ", "ㅐ", "ㄴ", "ㅋ", "ㅗ", "ㅂ"],
             answer: ["ㄴ", "ㅏ", "ㅂ", "ㅣ"],
             answerVideo: "나비 정답")
    ]
    ```
    
3. **문제:** 잘못된 퍼즐 조각 선택 시 피드백 부족
    
    **분석:** 사용자가 잘못된 퍼즐 조각을 선택했을 때 시각적/청각적 피드백이 부족하여 혼란 초래.
    
    **해결:** 잘못된 선택 시 음향 효과와 Haptic Feedback을 추가하여 명확한 피드백 제공.
    
    **결과코드**:
    
    ```swift
    private func handlePuzzlePieceTapped(_ piece: String) {
        if piece == playView.correctAnswer[selectedAnswers.count] {
            // 올바른 조각 선택
            selectedAnswers.append(piece)
            playSound(named: "click.wav")
            playView.updateAnswerZone(with: selectedAnswers)
        } else {
            // 잘못된 조각 선택
            playSound(named: "wrong.wav")
            triggerHapticFeedback()
        }
    }
    
    private func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred() // 진동 발생
    }
    ```

### **성과 및 교훈**

- **성과**
    - [쌀 키우기 테스트](https://github.com/fnfn0901/RiceGrowingTest) 프로젝트와 가나다 퍼즐 게임 프로젝트를 통해 **스푼랩 서포터즈 활동**에서 **우수 서포터즈 표창**을 수상.
    - Swift와 UIKit을 활용한 iOS 앱 개발의 전 과정을 경험하며, UI/UX와 데이터 처리를 깊이 이해.
    - TestFlight를 활용하여 앱 배포 및 테스트 프로세스를 숙달하고, 다양한 사용자 피드백을 수집해 앱 개선에 적극 반영.
- **교훈**
    - 간단한 프로젝트에서도 기획, 디자인, 데이터 관리의 중요성을 체감.
    - Swift 언어의 강점과 iOS 생태계에 대한 자신감 향상.
    - TestFlight를 활용한 베타 테스트의 효과를 경험하며, 사용자 중심의 개발 프로세스에 대한 이해를 높임.
