import UIKit
import SnapKit

class PlayViewController: UIViewController {
    
    private let playView = PlayView()
    private var selectedAnswers: [String] = []
    private let correctAnswer = ["ㄱ", "ㅓ", "ㅁ", "ㅣ"]
    
    override func loadView() {
        view = playView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupActions()
        
        // 초기 진행도 설정
        playView.progressView.setProgress(currentProgress: 1, maxProgress: 14)
    }
    
    private func setupActions() {
        playView.navigationBar.backButtonAction = { [weak self] in
            self?.showCustomAlert()
        }
        
        playView.navigationBar.settingsButtonAction = { [weak self] in
            self?.showSettingsModal()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideCustomAlert))
        playView.dimmingView.addGestureRecognizer(tapGesture)
        
        playView.customAlertView.cancelAction = { [weak self] in
            self?.hideCustomAlert()
        }
        
        playView.customAlertView.exitAction = { [weak self] in
            guard let self = self else { return }
            
            // 비디오 멈추기
            self.playView.videoContainerView.stopVideo()
            
            // 네비게이션 스택 최상위 뷰 컨트롤러로 돌아가기 (ViewController)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        playView.puzzlePieceTapped = { [weak self] piece in
            self?.handlePuzzlePieceTapped(piece)
        }
    }
    
    private func handlePuzzlePieceTapped(_ piece: String) {
        guard selectedAnswers.count < correctAnswer.count else { return }
        
        // 현재 추가하려는 글자가 정답 순서에 맞는지 확인
        if piece == correctAnswer[selectedAnswers.count] {
            selectedAnswers.append(piece)
            playView.updateAnswerZone(with: selectedAnswers)
        } else {
            // 순서가 맞지 않는 경우: X 아이콘 표시
            playView.showXIconForError()
        }
        
        if selectedAnswers.count == correctAnswer.count {
            checkAnswer()
        }
    }
    
    private func checkAnswer() {
        if selectedAnswers == correctAnswer {
            // 정답 처리
            print("정답!")
        } else {
            // 정답 순서가 틀린 경우
            playView.showXIconForError()
            selectedAnswers.removeAll()
            playView.updateAnswerZone(with: selectedAnswers) // 기존 답을 초기화
        }
    }
    
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
    
    private func showSettingsModal() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .pageSheet
        present(settingsVC, animated: true, completion: nil)
    }
}
