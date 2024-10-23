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
        self.backgroundColor = UIColor(hex: "#01B42F") // UIColor 코드 사용

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
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // 버튼 컨테이너의 오토레이아웃 설정
        buttonsContainer.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp.bottom).offset(123) // 비디오와 첫 버튼 간의 간격
            make.leading.trailing.equalToSuperview() // 버튼 컨테이너가 전체 너비를 차지하도록 설정
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
            make.top.equalTo(buttonsContainer.snp.top) // 첫 번째 버튼은 컨테이너의 상단에 배치
            make.centerX.equalToSuperview() // 가로 중앙에 배치
            make.width.equalTo(200) // 버튼 너비 설정
            make.height.equalTo(60) // 버튼 높이 설정
        }
        
        // 두 번째 버튼 오토레이아웃 (첫 번째 버튼에서 아래로 30만큼 떨어짐)
        secondButton.snp.makeConstraints { make in
            make.top.equalTo(firstButton.snp.bottom).offset(30) // 첫 번째 버튼의 아래에서 30만큼 떨어짐
            make.centerX.equalToSuperview() // 가로 중앙에 배치
            make.width.equalTo(200) // 버튼 너비 설정
            make.height.equalTo(60) // 버튼 높이 설정
        }
        
        // 세 번째 버튼 오토레이아웃 (두 번째 버튼에서 아래로 30만큼 떨어짐)
        thirdButton.snp.makeConstraints { make in
            make.top.equalTo(secondButton.snp.bottom).offset(30) // 두 번째 버튼의 아래에서 30만큼 떨어짐
            make.centerX.equalToSuperview() // 가로 중앙에 배치
            make.width.equalTo(200) // 버튼 너비 설정
            make.height.equalTo(60) // 버튼 높이 설정
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
            make.centerX.equalTo(buttonView) // 레이블을 버튼 중앙에 배치
            make.centerY.equalTo(buttonView) // 레이블을 버튼 중앙에 배치
        }
        
        return buttonView
    }
    
    func showButtonsWithAnimation() {
        buttonsContainer.alpha = 0 // 초기 상태를 숨김
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonsContainer.alpha = 1 // 애니메이션으로 나타나기
        })
    }
}
