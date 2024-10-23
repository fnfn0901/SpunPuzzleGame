import UIKit

class ViewController: UIViewController {

    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // 비디오 재생 종료 알림을 통해 버튼 표시
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: mainView.player?.currentItem)
        
        // 각 버튼에 대한 액션 연결
        mainView.firstButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        mainView.secondButton.addTarget(self, action: #selector(showGameDescription), for: .touchUpInside)
        mainView.thirdButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
    }
    
    private func setupView() {
        view = mainView
    }
    
    // 비디오 재생을 위한 메서드
    func startVideoPlayback() {
        mainView.player?.play()
    }

    @objc func videoDidEnd() {
        mainView.showButtonsWithAnimation() // 비디오 종료 후 버튼 나타내기
    }

    @objc func startGame() {
        guard let navigationController = navigationController else {
            print("Navigation Controller가 없습니다.")
            return
        }
        let playVC = PlayViewController()
        navigationController.pushViewController(playVC, animated: true)
    }
    
    @objc func showGameDescription() {
        // `GameDescriptionViewController` 모달 표시
        let gameDescriptionVC = GameDescriptionViewController()
        gameDescriptionVC.modalPresentationStyle = .fullScreen // 전체 화면 모달
        self.present(gameDescriptionVC, animated: true, completion: nil)
    }
    
    @objc func showSettings() {
        let alert = UIAlertController(title: "설정", message: "여기 설정을 표시합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
