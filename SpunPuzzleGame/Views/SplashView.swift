import UIKit
import AVKit
import SnapKit

class SplashView: UIView {
    
    var player: AVPlayer?
    private var playerView: UIView = UIView()
    
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
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspect
            playerView.layer.addSublayer(playerLayer)
            self.addSubview(playerView)
            
            // SnapKit을 사용한 오토레이아웃 설정
            setupConstraintsForVideo(playerLayer: playerLayer)
            
            // 비디오 재생
            player?.play()
            
            // 비디오 재생이 끝나면 Notification 발송
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        } else {
            print("비디오 파일을 찾을 수 없습니다.")
        }
    }
    
    private func setupConstraintsForVideo(playerLayer: AVPlayerLayer) {
        playerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(166)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(playerView.snp.width).multipliedBy(9.0 / 16.0)
        }
        playerLayer.frame = playerView.bounds
    }
    
    @objc func videoDidEnd() {
        NotificationCenter.default.post(name: NSNotification.Name("SplashVideoDidEnd"), object: nil)
    }
    
    func stopVideoPlayback() {
        player?.pause()
        player = nil
    }
}
