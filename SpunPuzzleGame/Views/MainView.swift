import UIKit
import AVKit
import SnapKit

class MainView: UIView {
    
    var player: AVPlayer?
    private var playerView: UIView = UIView() // AVPlayerLayer를 담을 뷰
    private var buttonsContainer: UIView = UIView() // 버튼을 담을 컨테이너 뷰

    // 버튼 선언
    let firstButton = UIButton()
    let secondButton = UIButton()
    let thirdButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(hex: "#01B42F")
        
        // 터치 이벤트 활성화
        self.isUserInteractionEnabled = true
        buttonsContainer.isUserInteractionEnabled = true

        // 비디오 파일을 앱 번들에서 가져오기
        if let videoURL = Bundle.main.url(forResource: "숨은 동물 찾기송", withExtension: "mov") {
            player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspect
            playerView.layer.addSublayer(playerLayer)
            self.addSubview(playerView)
            setupConstraintsForVideo(playerLayer: playerLayer)
            player?.play()
        } else {
            print("비디오 파일을 찾을 수 없습니다.")
        }
        
        // 버튼 컨테이너 설정
        setupButtons()
    }
    
    private func setupConstraintsForVideo(playerLayer: AVPlayerLayer) {
        playerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(166)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(playerView.snp.width).multipliedBy(9.0 / 16.0)
        }
        
        playerView.layoutIfNeeded()
        playerLayer.frame = playerView.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let playerLayer = playerView.layer.sublayers?.first as? AVPlayerLayer {
            playerLayer.frame = playerView.bounds
        }
    }
    
    private func setupButtons() {
        // 버튼 컨테이너 추가
        addSubview(buttonsContainer)
        buttonsContainer.alpha = 0 // 버튼 컨테이너를 처음에 숨김 처리
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // 버튼 컨테이너의 오토레이아웃 설정
        buttonsContainer.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp.bottom).offset(123)
            make.leading.trailing.equalToSuperview()
        }
        
        // 첫 번째 버튼 추가
        setupButton(firstButton, title: "게임 시작")
        firstButton.snp.makeConstraints { make in
            make.top.equalTo(buttonsContainer.snp.top) // 컨테이너 상단에 위치
        }

        // 두 번째 버튼 추가 (첫 번째 버튼 아래로 30)
        setupButton(secondButton, title: "게임 설명")
        secondButton.snp.makeConstraints { make in
            make.top.equalTo(firstButton.snp.bottom).offset(30) // 첫 번째 버튼 아래로 30 간격
        }

        // 세 번째 버튼 추가 (두 번째 버튼 아래로 30)
        setupButton(thirdButton, title: "설정")
        thirdButton.snp.makeConstraints { make in
            make.top.equalTo(secondButton.snp.bottom).offset(30) // 두 번째 버튼 아래로 30 간격
        }
    }
    
    private func setupButton(_ button: UIButton, title: String) {
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(hex: "#01B42F"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter24pt-Bold", size: 24)
        buttonsContainer.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.centerX.equalToSuperview() // 가로 중앙에 배치
        }
        
        // 터치 이벤트 활성화
        button.isUserInteractionEnabled = true
    }
    
    func showButtonsWithAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonsContainer.alpha = 1 // 버튼을 애니메이션과 함께 표시
        })
    }
}
