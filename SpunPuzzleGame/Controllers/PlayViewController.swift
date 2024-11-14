import UIKit
import AVFoundation

class PlayViewController: UIViewController {

    private let playView = PlayView()
    private var selectedAnswers: [String] = []
    private let correctAnswer = ["ㄱ", "ㅓ", "ㅁ", "ㅣ"]
    private var audioPlayer: AVAudioPlayer?

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
        playView.progressView.setProgress(currentProgress: 1, maxProgress: 14)
        playView.correctAnswer = correctAnswer
        playView.selectedAnswers = selectedAnswers
    }

    // MARK: - 액션 설정
    private func setupActions() {
        // 뒤로 가기 버튼
        playView.navigationBar.backButtonAction = { [weak self] in
            self?.showCustomAlert()
        }

        // 설정 버튼
        playView.navigationBar.settingsButtonAction = { [weak self] in
            self?.showSettingsModal()
        }

        // 화면 바깥 터치로 알림 닫기
        playView.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideCustomAlert)))

        // 사용자 정의 알림 버튼 동작 설정
        playView.customAlertView.cancelAction = { [weak self] in
            self?.hideCustomAlert()
        }

        playView.customAlertView.exitAction = { [weak self] in
            self?.exitGame()
        }

        // 퍼즐 조각 선택 동작 설정
        playView.puzzlePieceTapped = { [weak self] piece in
            self?.handlePuzzlePieceTapped(piece)
        }
    }

    // MARK: - 퍼즐 조각 선택 처리
    private func handlePuzzlePieceTapped(_ piece: String) {
        guard selectedAnswers.count < correctAnswer.count else { return }

        if piece == correctAnswer[selectedAnswers.count] {
            // 정답 조각 선택
            selectedAnswers.append(piece)
            playSound(named: "click.mp3") // 정답 효과음
            playView.updateAnswerZone(with: selectedAnswers)
        } else {
            playSound(named: "wrong.mp3") // 오답 효과음
        }

        if selectedAnswers.count == correctAnswer.count {
            // 정답 확인
            checkAnswer()
        }
    }

    // MARK: - 정답 확인
    private func checkAnswer() {
        if selectedAnswers == correctAnswer {
            // 정답 처리
            playSound(named: "pass.wav") // 정답 완료 효과음
            playView.videoContainerView.replaceVideo(with: "거미 정답")
            playView.updateViewForCorrectAnswer(with: correctAnswer)
        } else {
            // 오답 처리 (선택 초기화)
            selectedAnswers.removeAll()
            playView.updateAnswerZone(with: selectedAnswers)
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
        playView.dimmingView.isHidden = false
        playView.customAlertView.isHidden = false
        view.bringSubviewToFront(playView.dimmingView)
        view.bringSubviewToFront(playView.customAlertView)
    }

    @objc private func hideCustomAlert() {
        playView.dimmingView.isHidden = true
        playView.customAlertView.isHidden = true
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
