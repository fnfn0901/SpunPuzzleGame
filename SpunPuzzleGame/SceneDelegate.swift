import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Scene이 생성될 때 호출됩니다.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // UIWindow 인스턴스 생성
        window = UIWindow(windowScene: windowScene)
        
        // 초기 ViewController를 설정
        let rootViewController = ViewController() // ViewController를 원하는 화면으로 변경 가능
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        
        // UIWindow를 보이게 설정
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { /* 생략 */ }
    func sceneDidBecomeActive(_ scene: UIScene) { /* 생략 */ }
    func sceneWillResignActive(_ scene: UIScene) { /* 생략 */ }
    func sceneWillEnterForeground(_ scene: UIScene) { /* 생략 */ }
    func sceneDidEnterBackground(_ scene: UIScene) { /* 생략 */ }
}
