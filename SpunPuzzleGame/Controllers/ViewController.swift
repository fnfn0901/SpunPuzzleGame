import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 버튼 액션 추가
        mainView.startButton.addTarget(self, action: #selector(navigateToPlay), for: .touchUpInside)
        mainView.infoButton.addTarget(self, action: #selector(showInfoModal), for: .touchUpInside)
        mainView.settingsButton.addTarget(self, action: #selector(showSettingsModal), for: .touchUpInside)
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
}
