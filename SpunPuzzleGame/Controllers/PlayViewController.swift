import UIKit
import AVFoundation

struct Quiz {
    let questionVideo: String
    let puzzle: [String]
    let answer: [String]
    let answerVideo: String
}

class PlayViewController: UIViewController {

    private let playView = PlayView()
    private var selectedAnswers: [String] = []
    private var audioPlayer: AVAudioPlayer?

    private var quizzes: [Quiz] = [
        Quiz(questionVideo: "거미 문제", puzzle: ["ㄱ", "ㅂ", "ㅓ", "ㅠ", "ㅣ", "ㅋ", "ㅁ", "ㅐ"], answer: ["ㄱ", "ㅓ", "ㅁ", "ㅣ"], answerVideo: "거미 정답"),
        Quiz(questionVideo: "나비 문제", puzzle: ["ㅣ", "ㅉ", "ㅏ", "ㅐ", "ㄴ", "ㅉ", "ㅗ", "ㅂ"], answer: ["ㄴ", "ㅏ", "ㅂ", "ㅣ"], answerVideo: "나비 정답"),
        Quiz(questionVideo: "사자 문제", puzzle: ["ㅏ", "ㅈ", "ㅗ", "ㅑ", "ㅠ", "ㅍ", "ㅅ", "ㅏ"], answer: ["ㅅ", "ㅏ", "ㅈ", "ㅏ"], answerVideo: "사자 정답"),
        Quiz(questionVideo: "하마 문제", puzzle: ["ㅁ", "ㅈ", "ㅏ", "ㅔ", "ㅇ", "ㅏ", "ㅃ", "ㅎ"], answer: ["ㅎ", "ㅏ", "ㅁ", "ㅏ"], answerVideo: "하마 정답")
    ]

    private var currentQuizIndex = 0

    override func loadView() {
        view = playView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupActions()
        initializeGame()
    }

    // MARK: - 초기 설정
    private func initializeGame() {
        guard currentQuizIndex < quizzes.count else {
            print("모든 문제를 완료했습니다.")
            return
        }

        let currentQuiz = quizzes[currentQuizIndex]
        selectedAnswers.removeAll()
        playView.resetView() // 이전 문제 UI 초기화
        playView.progressView.setProgress(currentProgress: CGFloat(currentQuizIndex + 1), maxProgress: CGFloat(quizzes.count))
        playView.updateQuizData(puzzle: currentQuiz.puzzle, correctAnswer: currentQuiz.answer, video: currentQuiz.questionVideo)

        print("initializeGame called for quiz \(currentQuizIndex)")
    }

    // MARK: - 액션 설정
    private func setupActions() {
        playView.navigationBar.backButtonAction = { [weak self] in
            self?.showCustomAlert()
        }
        playView.navigationBar.settingsButtonAction = { [weak self] in
            self?.showSettingsModal()
        }
        playView.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideCustomAlert)))
        playView.customAlertView.cancelAction = { [weak self] in
            self?.hideCustomAlert()
        }
        playView.customAlertView.exitAction = { [weak self] in
            self?.exitGame()
        }
        playView.puzzlePieceTapped = { [weak self] piece in
            self?.handlePuzzlePieceTapped(piece)
        }
    }

    // MARK: - 퍼즐 조각 선택 처리
    private func handlePuzzlePieceTapped(_ piece: String) {
        print("Selected piece: \(piece)")
        print("Expected answer: \(playView.correctAnswer[selectedAnswers.count])")

        guard selectedAnswers.count < playView.correctAnswer.count else { return }

        if piece == playView.correctAnswer[selectedAnswers.count] {
            // 올바른 조각 선택
            selectedAnswers.append(piece)
            playSound(named: "click.mp3")
            playView.updateAnswerZone(with: selectedAnswers)
            print("Correct piece! Current answers: \(selectedAnswers)")
        } else {
            // 잘못된 조각 선택
            playSound(named: "wrong.mp3")
            print("Wrong piece!")
        }

        // 정답 완성 여부 확인
        if selectedAnswers.count == playView.correctAnswer.count {
            checkAnswer()
        }
    }

    // MARK: - 정답 확인
    private func checkAnswer() {
        if selectedAnswers == playView.correctAnswer {
            playSound(named: "pass.wav")
            playView.displayCorrectAnswer(with: quizzes[currentQuizIndex].answerVideo)

            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.goToNextQuiz()
            }
        } else {
            playView.resetAnswerZone()
        }
    }

    // MARK: - 다음 문제로 이동
    private func goToNextQuiz() {
        currentQuizIndex += 1
        if currentQuizIndex < quizzes.count {
            initializeGame()
        } else {
            print("모든 문제를 완료했습니다.")
            exitGame()
        }
    }

    // MARK: - 사운드 재생
    private func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: nil) else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("오디오 파일 재생 실패: \(error)")
        }
    }

    // MARK: - 사용자 정의 알림
    private func showCustomAlert() {
        playView.showCustomAlert()
    }

    @objc private func hideCustomAlert() {
        playView.hideCustomAlert()
    }

    // MARK: - 설정 화면 표시
    private func showSettingsModal() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .pageSheet
        present(settingsVC, animated: true, completion: nil)
    }

    // MARK: - 게임 종료
    private func exitGame() {
        playView.videoContainerView.stopVideo()
        navigationController?.popToRootViewController(animated: true)
    }
}
