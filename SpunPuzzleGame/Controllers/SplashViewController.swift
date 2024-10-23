import UIKit
import AVFoundation

class SplashViewController: UIViewController {
    
    let splashView = SplashView() // SplashView 생성

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 뷰 설정
        view = splashView
        
        // 비디오 종료 후 MainViewController로 전환
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToMainView), name: NSNotification.Name("SplashVideoDidEnd"), object: nil)
    }
    
    @objc func navigateToMainView() {
        // 스플래시 화면에서 AVPlayer의 재생을 중단
        splashView.stopVideoPlayback()

        // MainView로 전환
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let mainViewController = ViewController()
            let navigationController = UINavigationController(rootViewController: mainViewController)
            
            // 애니메이션 없이 루트 뷰 컨트롤러를 MainViewController로 변경
            UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                window.rootViewController = navigationController
            }, completion: nil)
        }
    }
    
    deinit {
        // 옵저버 제거
        NotificationCenter.default.removeObserver(self)
    }
}
