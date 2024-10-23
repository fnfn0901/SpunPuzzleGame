import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // UIWindow 초기화
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // SplashViewController를 첫 화면으로 설정
        let splashViewController = SplashViewController()
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
        
        // 오디오 세션 설정
        setupAudioSession()
        
        return true
    }

    // 오디오 세션 설정 함수
    func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .moviePlayback)
            try audioSession.setActive(true)
        } catch let error as NSError {
            NSLog("Failed to set up audio session: \(error), \(error.userInfo)")
        }
    }
}
