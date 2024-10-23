import UIKit
import AVKit

class ViewController: UIViewController {

    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // 비디오 재생 종료 알림을 통해 버튼 표시
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: mainView.player?.currentItem)
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
        let playVC = PlayViewController()
        navigationController?.pushViewController(playVC, animated: true)
    }
    
    @objc func showGameDescription() {
        let alert = UIAlertController(title: "게임 설명", message: "여기 게임 설명을 표시합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func showSettings() {
        let alert = UIAlertController(title: "설정", message: "여기 설정을 표시합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
