import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // UIWindow 인스턴스를 만들고 초기 뷰 컨트롤러를 설정
        window = UIWindow(windowScene: windowScene)
        let viewController = ViewController() // 초기 뷰 컨트롤러 설정
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
