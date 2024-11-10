import UIKit
import AVKit

class SplashView: UIView {

    private var playerLayer: AVPlayerLayer?
    private let videoContainerView = UIView() // 비디오 컨테이너 뷰 추가
    let skipButton = UIButton() // 스킵 버튼 추가
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupVideo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(hex: "00B8FD")
        
        // 비디오 컨테이너 뷰 설정
        addSubview(videoContainerView)
        videoContainerView.backgroundColor = .clear
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 188),
            videoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            videoContainerView.heightAnchor.constraint(equalTo: videoContainerView.widthAnchor, multiplier: 9.0 / 16.0) // 16:9 비율 유지
        ])
        
        // 스킵 버튼 설정
        addSubview(skipButton)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.backgroundColor = UIColor(white: 0, alpha: 0.5)
        skipButton.layer.cornerRadius = 5
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            skipButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            skipButton.widthAnchor.constraint(equalToConstant: 80),
            skipButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupVideo() {
        guard let path = Bundle.main.path(forResource: "쌀프렌즈", ofType: "mp4") else { return }
        let url = URL(fileURLWithPath: path)
        
        let player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        guard let playerLayer = playerLayer else { return }
        
        videoContainerView.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspect
        player.play()
        
        // 비디오 끝 알림 설정
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // playerLayer의 크기를 videoContainerView에 맞춤
        playerLayer?.frame = videoContainerView.bounds
    }
    
    @objc private func videoDidEnd() {
        NotificationCenter.default.post(name: Notification.Name("SplashVideoDidEnd"), object: nil)
    }
}
