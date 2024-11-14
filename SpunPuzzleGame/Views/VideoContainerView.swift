import UIKit
import AVFoundation

class VideoContainerView: UIView {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupVideoPlayer(fileName: "거미 문제")
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(hex: "#D3D3D3") // 회색 배경
        layer.cornerRadius = 10
        clipsToBounds = true // Corner radius가 적용되도록 설정
    }
    
    private func setupVideoPlayer(fileName: String) {
        guard let videoPath = Bundle.main.path(forResource: fileName, ofType: "mp4") else {
            print("\(fileName) 비디오 파일을 찾을 수 없습니다.")
            return
        }
        
        let videoURL = URL(fileURLWithPath: videoPath)
        player = AVPlayer(url: videoURL)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill // 비디오가 꽉 차게 보이도록 설정
        playerLayer?.frame = bounds // 초기 프레임 설정
        
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }
        
        // 비디오가 끝났을 때 알림 설정
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoDidEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        
        // 자동 재생
        player?.play()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(replayVideo))
        addGestureRecognizer(tapGesture)
    }
    
    func stopVideo() {
        player?.pause() // 비디오 재생 중단
    }
    
    func replaceVideo(with fileName: String) {
        stopVideo() // 기존 비디오 중단
        playerLayer?.removeFromSuperlayer() // 기존 플레이어 레이어 제거
        setupVideoPlayer(fileName: fileName) // 새로운 비디오 설정
        
        print("Video replaced with: \(fileName)")
    }
    
    @objc private func videoDidEnd() {
        // 원하는 중간 지점 (50%)으로 이동하여 썸네일로 설정
        if let duration = player?.currentItem?.duration {
            let middleTime = CMTimeMultiplyByFloat64(duration, multiplier: 0.5) // 영상의 50% 지점
            player?.seek(to: middleTime, toleranceBefore: .zero, toleranceAfter: .zero)
            player?.pause()
        }
    }
    
    @objc private func replayVideo() {
        // 비디오를 처음부터 다시 재생
        player?.seek(to: .zero)
        player?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds // 레이아웃 변경 시 플레이어 레이어 프레임 업데이트
    }
    
    deinit {
        // NotificationCenter 해제
        NotificationCenter.default.removeObserver(self)
    }
}
