import UIKit
import SnapKit
import AVFoundation

// 헬퍼 메서드: Skip 버튼 생성
func createSkipButton() -> UIButton {
    let button = UIButton()
    button.setTitle("Skip", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = UIColor(white: 0, alpha: 0.5)
    button.layer.cornerRadius = 5
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}

class MainView: UIView {
    
    internal let startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FFFFFF")
        button.layer.cornerRadius = 10
        button.setTitle("게임 시작", for: .normal)
        button.setTitleColor(UIColor(hex: "#01B42F"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter24pt-Bold", size: 24)
        button.isHidden = true
        return button
    }()
    
    internal let infoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FFFFFF")
        button.layer.cornerRadius = 10
        button.setTitle("게임 설명", for: .normal)
        button.setTitleColor(UIColor(hex: "#01B42F"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter24pt-Bold", size: 24)
        button.isHidden = true
        return button
    }()
    
    internal let settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FFFFFF")
        button.layer.cornerRadius = 10
        button.setTitle("설정", for: .normal)
        button.setTitleColor(UIColor(hex: "#01B42F"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter24pt-Bold", size: 24)
        button.isHidden = true
        return button
    }()
    
    internal let skipButton: UIButton = createSkipButton()
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let videoContainerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#01B42F")
        setupView()
        setupVideoPlayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor(hex: "#01B42F")
        setupView()
        setupVideoPlayer()
    }
    
    private func setupView() {
        addSubview(videoContainerView)
        addSubview(startButton)
        addSubview(infoButton)
        addSubview(settingsButton)
        addSubview(skipButton)
        
        videoContainerView.backgroundColor = .clear
        videoContainerView.clipsToBounds = true
        
        videoContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(166)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(videoContainerView.snp.width).multipliedBy(9.0 / 16.0)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-102)
        }
        
        infoButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(settingsButton.snp.top).offset(-30)
        }
        
        startButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(infoButton.snp.top).offset(-30)
        }
        
        skipButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    private func setupVideoPlayer() {
        guard let videoPath = Bundle.main.path(forResource: "숨은 동물 찾기송", ofType: "mp4") else {
            print("비디오 파일을 찾을 수 없습니다.")
            return
        }
        
        let videoURL = URL(fileURLWithPath: videoPath)
        player = AVPlayer(url: videoURL)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = videoContainerView.bounds
        playerLayer?.backgroundColor = UIColor(hex: "#01B42F").cgColor
        videoContainerView.layer.addSublayer(playerLayer!)
        
        player?.play()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoDidEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    
    @objc private func videoDidEnd() {
        showButtons()
    }
    
    func showButtons() {
        startButton.isHidden = false
        infoButton.isHidden = false
        settingsButton.isHidden = false
        skipButton.isHidden = true
    }
    
    func skipToEndOfVideo() {
        guard let player = player, let duration = player.currentItem?.duration else { return }
        let endTime = CMTimeGetSeconds(duration)
        player.seek(to: CMTime(seconds: endTime, preferredTimescale: 600)) { [weak self] _ in
            player.pause()
            self?.showButtons()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
