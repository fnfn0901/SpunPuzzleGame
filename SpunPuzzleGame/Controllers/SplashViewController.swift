import UIKit

class SplashViewController: UIViewController {
    
    private let splashView = SplashView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashView()
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
    }
    
    @objc private func videoDidEnd() {
        let mainViewController = ViewController()
        navigationController?.pushViewController(mainViewController, animated: false)
    }
}
