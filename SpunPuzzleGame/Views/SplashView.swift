import UIKit
import AVKit
import SnapKit

class SplashView: UIView {
    
    var player: AVPlayer?
    private var playerView: UIView = UIView() // AVPlayerLayer를 담을 뷰
    private var playerLayer: AVPlayerLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(hex: "#00B8FD")
        
        // 비디오 파일을 앱 번들에서 가져오기
        if let videoURL = Bundle.main.url(forResource: "쌀프렌즈", withExtension: "mov") {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspect // 비율 유지
            if let playerLayer = playerLayer {
                playerView.layer.addSublayer(playerLayer) // playerView에 playerLayer 추가
                self.addSubview(playerView) // playerView를 self(SplashView)에 추가
            }
            
            // SnapKit을 사용한 오토레이아웃 설정
            setupConstraintsForVideo()
            
            // AVPlayer의 상태를 확인하여 준비가 완료된 후에 재생
            player?.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
            
            // 비디오 재생 종료 이벤트 감지
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        } else {
            print("비디오 파일을 찾을 수 없습니다.")
        }
    }
    
    private func setupConstraintsForVideo() {
        // playerView의 오토레이아웃 설정
        playerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0) // 상단 여백 제거
            make.leading.trailing.equalToSuperview() // 화면 전체 너비에 맞춤
            make.bottom.equalToSuperview() // 화면 전체 높이에 맞춤
        }
        
        // playerView의 초기 레이아웃 설정
        playerView.layoutIfNeeded()
        playerLayer?.frame = playerView.bounds // AVPlayerLayer의 크기 설정
    }
    
    // AVPlayer의 상태를 확인하여 준비가 완료되면 비디오 재생
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if player?.status == .readyToPlay {
                player?.play() // 준비 완료된 후에 비디오 재생
            } else if player?.status == .failed {
                print("비디오 로딩 실패: \(String(describing: player?.error))")
            }
        }
    }

    @objc func videoDidEnd() {
        NotificationCenter.default.post(name: NSNotification.Name("SplashVideoDidEnd"), object: nil)
    }
    
    func stopVideoPlayback() {
        // 비디오 재생 중단 및 메모리 해제
        player?.pause()
        player = nil
    }
    
    deinit {
        // 옵저버 제거
        NotificationCenter.default.removeObserver(self)
    }
}
