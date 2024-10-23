import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MainView를 생성
    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        // 오디오 인터럽트 처리 설정
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    // 뷰를 설정하는 함수
    private func setupView() {
        view = mainView // MainView를 컨트롤러의 view로 설정
    }
    
    // MainView가 화면에 완전히 나타난 후에 비디오 재생을 시작하는 대신, 외부에서 명시적으로 호출
    func startVideoPlayback() {
        mainView.player?.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
        mainView.player?.play() // MainViewController가 표시된 후에 비디오 재생 시작
    }

    // AVPlayer 상태 확인
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if mainView.player?.status == .failed {
                print("AVPlayer failed with error: \(String(describing: mainView.player?.error))")
            } else if mainView.player?.status == .readyToPlay {
                print("AVPlayer is ready to play")
            }
        }
    }

    // 오디오 인터럽트 처리
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

        if type == .began {
            // 인터럽트가 시작됨
            print("Audio session interrupted")
        } else if type == .ended {
            // 인터럽트가 끝남
            try? AVAudioSession.sharedInstance().setActive(true)
            mainView.player?.play() // 재생 재개
        }
    }
}
