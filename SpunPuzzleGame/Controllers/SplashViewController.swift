import UIKit

class SplashViewController: UIViewController {
    
    private let splashView = SplashView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashView()
        
        // 비디오가 끝났을 때 videoDidEnd 호출
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: Notification.Name("SplashVideoDidEnd"), object: nil)
    }
    
    private func setupSplashView() {
        splashView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashView)
        
        NSLayoutConstraint.activate([
            splashView.topAnchor.constraint(equalTo: view.topAnchor),
            splashView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splashView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splashView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 스킵 버튼의 액션 설정
        splashView.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    @objc private func videoDidEnd() {
        transitionToMainViewController()
    }
    
    @objc private func skipButtonTapped() {
        transitionToMainViewController()
    }
    
    private func transitionToMainViewController() {
        // ViewController를 새로운 네비게이션 스택의 루트로 설정
        let mainViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        // SceneDelegate의 window 루트 뷰 컨트롤러 업데이트
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navigationController
        }
    }
}
