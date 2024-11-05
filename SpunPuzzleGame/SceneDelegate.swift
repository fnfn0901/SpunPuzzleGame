// SceneDelegate.swift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let playViewController = PlayViewController() // PlayViewController로 변경
        let navigationController = UINavigationController(rootViewController: playViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
