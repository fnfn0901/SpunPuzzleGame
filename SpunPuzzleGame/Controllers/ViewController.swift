import UIKit
import AVKit

class ViewController: UIViewController {

    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // 오디오 인터럽트 처리 설정
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    private func setupView() {
        view = mainView
        
        // 비디오 재생 종료 알림을 통해 버튼 표시
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: mainView.player?.currentItem)
    }
    
    @objc func videoDidEnd() {
        mainView.showButtonsWithAnimation() // 비디오 종료 후 버튼 나타내기
    }

    func startVideoPlayback() {
        mainView.player?.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
        mainView.player?.play()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if mainView.player?.status == .failed {
                print("AVPlayer failed with error: \(String(describing: mainView.player?.error))")
            }
        }
    }

    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

        if type == .began {
            print("Audio session interrupted")
        } else if type == .ended {
            try? AVAudioSession.sharedInstance().setActive(true)
            mainView.player?.play()
        }
    }
}
