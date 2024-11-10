import UIKit
import SnapKit
import AVFoundation

class MainView: UIView {
    
    internal let startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FFFFFF")
        button.layer.cornerRadius = 10
        button.setTitle("게임 시작", for: .normal)
        button.setTitleColor(UIColor(hex: "#01B42F"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter24pt-Bold", size: 24)
        button.isHidden = true // 초기에는 숨김 상태
        return button
    }()
    
    internal let infoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FFFFFF")
        button.layer.cornerRadius = 10
        button.setTitle("게임 설명", for: .normal)
        button.setTitleColor(UIColor(hex: "#01B42F"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter24pt-Bold", size: 24)
        button.isHidden = true // 초기에는 숨김 상태
        return button
    }()
    
    internal let settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FFFFFF")
        button.layer.cornerRadius = 10
        button.setTitle("설정", for: .normal)
        button.setTitleColor(UIColor(hex: "#01B42F"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter24pt-Bold", size: 24)
        button.isHidden = true // 초기에는 숨김 상태
        return button
    }()
    
    internal let skipButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0, alpha: 0.5)
        button.layer.cornerRadius = 5
        button.setTitle("스킵", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let videoContainerView = UIView() // AVPlayerLayer를 담을 UIView
    
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
        
        videoContainerView.backgroundColor = .clear // 배경색 투명하게 설정
        videoContainerView.clipsToBounds = true // 경계를 넘지 않도록 제한
        
        videoContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(166) // 상단에서 166pt 떨어진 위치
            make.leading.trailing.equalToSuperview() // 가로로 화면에 꽉 차도록 설정
            make.height.equalTo(videoContainerView.snp.width).multipliedBy(9.0 / 16.0) // 세로는 16:9 비율 유지
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
    
    private func setupVideoPlayer() {
        guard let videoPath = Bundle.main.path(forResource: "숨은 동물 찾기송", ofType: "mp4") else {
            print("비디오 파일을 찾을 수 없습니다.")
            return
        }
        
        let videoURL = URL(fileURLWithPath: videoPath)
        player = AVPlayer(url: videoURL)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill // 비율을 유지하면서 여백을 제거하여 가득 채우기
        playerLayer?.frame = videoContainerView.bounds
        playerLayer?.backgroundColor = UIColor(hex: "#01B42F").cgColor
        videoContainerView.layer.addSublayer(playerLayer!) // playerLayer를 videoContainerView에 추가
        
        // 비디오 자동 재생
        player?.play()
        
        // 비디오가 끝났을 때 알림 설정
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoDidEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    
    @objc private func videoDidEnd() {
        showButtons()
    }
    
    func showButtons() {
        // 버튼들을 표시
        startButton.isHidden = false
        infoButton.isHidden = false
        settingsButton.isHidden = false
        skipButton.isHidden = true // 스킵 버튼 숨기기
    }
    
    func skipToEndOfVideo() {
        guard let player = player, let duration = player.currentItem?.duration else { return }
        let endTime = CMTimeGetSeconds(duration)
        player.seek(to: CMTime(seconds: endTime, preferredTimescale: 600)) { [weak self] _ in
            player.pause() // 영상 멈추기
            self?.showButtons() // 버튼 보이기
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // layoutSubviews에서 playerLayer의 frame을 업데이트
        playerLayer?.frame = videoContainerView.bounds
    }
    
    deinit {
        // NotificationCenter 해제
        NotificationCenter.default.removeObserver(self)
    }
}
