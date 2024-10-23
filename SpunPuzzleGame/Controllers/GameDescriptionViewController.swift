import UIKit

class GameDescriptionViewController: UIViewController {
    
    let gameDescriptionView = GameDescriptionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view = gameDescriptionView
        
        // Chevron 버튼 액션 설정
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        gameDescriptionView.chevronView.isUserInteractionEnabled = true
        gameDescriptionView.chevronView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissView() {
        // 모달 닫기
        self.dismiss(animated: true, completion: nil)
    }
}
