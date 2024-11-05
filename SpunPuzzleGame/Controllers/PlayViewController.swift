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
            self?.navigationController?.popViewController(animated: true)
        }
        
        playView.puzzlePieceTapped = { [weak self] piece in
            self?.handlePuzzlePieceTapped(piece)
        }
    }
    
    private func handlePuzzlePieceTapped(_ piece: String) {
        guard selectedAnswers.count < 4 else { return }
        
        selectedAnswers.append(piece)
        playView.updateAnswerZone(with: selectedAnswers)
        
        if selectedAnswers.count == correctAnswer.count {
            checkAnswer()
        }
    }
    
    private func checkAnswer() {
        if selectedAnswers == correctAnswer {
            // 정답 처리
            print("정답!")
        } else {
            // 오답 처리: X 아이콘 표시 후 제거
            playView.showXIconForError()
            selectedAnswers.removeAll()
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
