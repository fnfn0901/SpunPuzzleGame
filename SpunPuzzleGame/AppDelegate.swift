import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // UIWindow 초기화
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // ViewController 초기화
        let rootViewController = ViewController()
        
        // UINavigationController에 감싸기
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        // rootViewController 설정
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        // 오디오 세션 설정
        setupAudioSession()
        
        return true
    }

    // 오디오 세션 설정 함수
    func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            
            // 오디오 세션 설정 간소화
            try audioSession.setCategory(.playback)
            try audioSession.setMode(.default)
            try audioSession.setActive(true)
            
            print("Audio session successfully set up")
            
        } catch let error as NSError {
            print("Failed to set up audio session: \(error), \(error.userInfo)")
        }
    }
}
