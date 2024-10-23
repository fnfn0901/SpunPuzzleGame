import UIKit
import AVKit
import SnapKit

class MainView: UIView {
    
    var player: AVPlayer?
    private var playerView: UIView = UIView() // AVPlayerLayer를 담을 뷰
    private var buttonsContainer: UIView = UIView() // 버튼을 담을 컨테이너 뷰

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
        
        // 버튼 생성
        let firstButton = createButton(title: "게임 시작")
        buttonsContainer.addSubview(firstButton)
        
        let secondButton = createButton(title: "게임 설명")
        buttonsContainer.addSubview(secondButton)
        
        let thirdButton = createButton(title: "설정")
        buttonsContainer.addSubview(thirdButton)
        
        // 첫 번째 버튼 오토레이아웃
        firstButton.snp.makeConstraints { make in
            make.top.equalTo(buttonsContainer.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        // 두 번째 버튼 오토레이아웃 (첫 번째 버튼에서 아래로 30만큼 떨어짐)
        secondButton.snp.makeConstraints { make in
            make.top.equalTo(firstButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        // 세 번째 버튼 오토레이아웃 (두 번째 버튼에서 아래로 30만큼 떨어짐)
        thirdButton.snp.makeConstraints { make in
            make.top.equalTo(secondButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
    }
    
    private func createButton(title: String) -> UIView {
        let buttonView = UIView()
        buttonView.layer.backgroundColor = UIColor.white.cgColor
        buttonView.layer.cornerRadius = 10
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        // 버튼 레이블 설정
        let buttonLabel = UILabel()
        buttonLabel.text = title
        buttonLabel.textColor = UIColor(hex: "#01B42F")
        buttonLabel.font = UIFont(name: "Inter24pt-Bold", size: 24)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonView.addSubview(buttonLabel)
        
        // 버튼 레이블 오토레이아웃 설정
        buttonLabel.snp.makeConstraints { make in
            make.centerX.equalTo(buttonView)
            make.centerY.equalTo(buttonView)
        }
        
        return buttonView
    }
    
    func showButtonsWithAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonsContainer.alpha = 1 // 버튼을 애니메이션과 함께 표시
        })
    }
}
