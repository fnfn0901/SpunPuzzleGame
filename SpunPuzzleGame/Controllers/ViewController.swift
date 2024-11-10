import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back 버튼 숨기기
        navigationItem.hidesBackButton = true
        
        // 기존 코드
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 버튼 액션 추가
        mainView.startButton.addTarget(self, action: #selector(navigateToPlay), for: .touchUpInside)
        mainView.infoButton.addTarget(self, action: #selector(showInfoModal), for: .touchUpInside)
        mainView.settingsButton.addTarget(self, action: #selector(showSettingsModal), for: .touchUpInside)
        mainView.skipButton.addTarget(self, action: #selector(skipVideo), for: .touchUpInside)
    }
    
    @objc private func navigateToPlay() {
        let playVC = PlayViewController()
        navigationController?.pushViewController(playVC, animated: true)
    }
    
    @objc private func showInfoModal() {
        let infoVC = InfoViewController()
        infoVC.modalPresentationStyle = .pageSheet
        present(infoVC, animated: true, completion: nil)
    }
    
    @objc private func showSettingsModal() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .pageSheet
        present(settingsVC, animated: true, completion: nil)
    }
    
    @objc private func skipVideo() {
        mainView.skipToEndOfVideo() // 스킵 버튼 동작
    }
}
