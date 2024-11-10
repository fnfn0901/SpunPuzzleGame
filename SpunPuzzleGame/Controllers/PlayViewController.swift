import UIKit

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
        playView.progressView.setProgress(currentProgress: 1, maxProgress: 14)
        
        // 정답과 선택된 답을 PlayView에 전달
        playView.correctAnswer = correctAnswer
        playView.selectedAnswers = selectedAnswers
    }
    
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
    
    private func handlePuzzlePieceTapped(_ piece: String) {
        guard selectedAnswers.count < correctAnswer.count else { return }
        
        if piece == correctAnswer[selectedAnswers.count] {
            selectedAnswers.append(piece)
            playView.updateAnswerZone(with: selectedAnswers)
        }
        
        if selectedAnswers.count == correctAnswer.count {
            checkAnswer()
        }
    }
    
    private func checkAnswer() {
        if selectedAnswers == correctAnswer {
            print("정답!")
        } else {
            selectedAnswers.removeAll()
            playView.updateAnswerZone(with: selectedAnswers)
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
    
    private func exitGame() {
        playView.videoContainerView.stopVideo()
        navigationController?.popToRootViewController(animated: true)
    }
}
