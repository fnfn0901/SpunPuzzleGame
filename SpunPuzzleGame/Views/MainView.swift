import UIKit
import AVKit
import SnapKit

class MainView: UIView {
    
    // AVPlayer와 AVPlayerLayer 선언
    var player: AVPlayer? // ViewController에서 접근 가능하도록 var로 설정
    private var playerView: UIView = UIView() // AVPlayerLayer를 담을 뷰
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // 뷰 설정 함수
    private func setupView() {
        self.backgroundColor = UIColor(hex: "#01B42F")
        
        // 비디오 파일을 앱 번들에서 가져오기 (상대 경로 사용)
        if let videoURL = Bundle.main.url(forResource: "숨은 동물 찾기송", withExtension: "mov") {
            player = AVPlayer(url: videoURL)
            
            // 플레이어 레이어 설정
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspect // 비율 유지
            playerView.layer.addSublayer(playerLayer)
            self.addSubview(playerView)
            
            // SnapKit을 사용한 오토레이아웃 설정
            setupConstraintsForVideo(playerLayer: playerLayer)
            
            // 비디오 재생
            player?.play()
        } else {
            print("비디오 파일을 찾을 수 없습니다.")
        }
    }
    
    // 비디오의 오토레이아웃 설정 (SnapKit 사용)
    private func setupConstraintsForVideo(playerLayer: AVPlayerLayer) {
        // 비디오 플레이어의 크기 및 위치 설정
        playerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(166) // 상단에서 166 여백
            make.leading.trailing.equalToSuperview() // 화면 너비에 맞춤
            make.height.equalTo(playerView.snp.width).multipliedBy(9.0 / 16.0) // 16:9 비율 유지
        }
        
        // 레이아웃이 업데이트될 때 AVPlayerLayer의 프레임도 맞추기
        playerView.layoutIfNeeded() // 초기 레이아웃 설정
        playerLayer.frame = playerView.bounds // AVPlayerLayer의 크기 설정
    }
    
    // 레이아웃 갱신시 호출 (SnapKit 사용)
    override func layoutSubviews() {
        super.layoutSubviews()
        if let playerLayer = playerView.layer.sublayers?.first as? AVPlayerLayer {
            playerLayer.frame = playerView.bounds
        }
    }
}
