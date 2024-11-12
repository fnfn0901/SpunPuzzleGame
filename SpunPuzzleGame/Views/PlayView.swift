import UIKit
import SnapKit
import AVFoundation

class PlayView: UIView {
    
    // MARK: - 외부에서 설정 가능한 변수
    var puzzlePieceTapped: ((String) -> Void)?
    var correctAnswer: [String] = []
    var selectedAnswers: [String] = []
    
    // MARK: - UI 요소
    let dimmingView: UIView = createDimmingView()
    let customAlertView = CustomAlertView()
    let progressView = ProgressView()
    let videoContainerView = VideoContainerView()
    let navigationBar = CustomNavigationBar()
    let puzzleBundleView = UIView()
    let answerZoneView: UIView = createAnswerZoneView()
    
    private var answerImages: [UIImageView] = []
    private var audioPlayer: AVAudioPlayer?
    private var cookieView: UIView?

    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View 설정
    private func setupViews() {
        backgroundColor = .white
        setupNavigationBar()
        setupDimmingView()
        setupAlertView()
        setupProgressView()
        setupVideoContainer()
        setupPuzzleBundleView()
        setupAnswerZoneView()
    }
    
    private func setupNavigationBar() {
        addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 43)
        ])
    }
    
    private func setupDimmingView() {
        addSubview(dimmingView)
        dimmingView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupAlertView() {
        addSubview(customAlertView)
        customAlertView.isHidden = true
        customAlertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(273)
            $0.height.equalTo(224)
        }
    }
    
    private func setupProgressView() {
        addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(53)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(345)
            $0.height.equalTo(38)
        }
    }
    
    private func setupVideoContainer() {
        addSubview(videoContainerView)
        videoContainerView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(videoContainerView.snp.width).multipliedBy(9.0 / 16.0)
        }
    }
    
    private func setupPuzzleBundleView() {
        addSubview(puzzleBundleView)
        puzzleBundleView.snp.makeConstraints {
            $0.top.equalTo(videoContainerView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(345)
            $0.height.equalTo(175)
        }
        
        let imageNames = ["ㄱ", "ㅂ", "ㅓ", "ㅠ", "ㅣ", "ㅋ", "ㅁ", "ㅐ"]
        let gridStackView = createGridStackView(with: imageNames)
        puzzleBundleView.addSubview(gridStackView)
        gridStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    private func setupAnswerZoneView() {
        addSubview(answerZoneView)
        answerZoneView.snp.makeConstraints {
            $0.top.equalTo(puzzleBundleView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(228)
        }
    }

    // MARK: - 퍼즐 정답 업데이트
    func updateAnswerZone(with answers: [String]) {
        answerImages.forEach { $0.removeFromSuperview() }
        answerImages.removeAll()
        
        let imageSize: CGFloat = (345 - 30) / 4
        let spacing: CGFloat = 10

        // `answerZoneView`의 중심을 기준으로 이미지 위치를 계산
        for (index, answer) in answers.enumerated() {
            let imageView = UIImageView(image: UIImage(named: answer))
            imageView.contentMode = .scaleAspectFit
            answerZoneView.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(imageSize)
                // 가로 간격 유지하면서 중심에 정렬
                let offset = CGFloat(index - answers.count / 2) * (imageSize + spacing)
                make.centerX.equalToSuperview().offset(offset)
            }
            answerImages.append(imageView)
        }
    }

    // MARK: - 정답 맞춘 후 화면 변경
    func updateViewForCorrectAnswer(with answers: [String]) {
        // 정답존 숨기기
        puzzleBundleView.isHidden = true
        answerZoneView.isHidden = true

        // 정답 이미지뷰를 PlayView로 이동
        for (index, imageView) in answerImages.enumerated() {
            // PlayView에 이미지뷰 추가
            self.addSubview(imageView)
            
            // 중앙 정렬 위치 재설정
            imageView.snp.remakeConstraints { make in
                let offset = CGFloat(index - answers.count / 2) * (imageView.frame.width + 10)
                make.centerX.equalToSuperview().offset(offset)
                make.centerY.equalTo(answerZoneView.snp.centerY)
                make.width.height.equalTo(imageView.frame.size.width)
            }
        }

    }
    
    // MARK: - Helper Methods
    private static func createDimmingView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }
    
    private static func createAnswerZoneView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#E3E3E3")
        view.layer.cornerRadius = 114
        view.layer.masksToBounds = true
        return view
    }
    
    private func createGridStackView(with imageNames: [String]) -> UIStackView {
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.distribution = .fillEqually
        gridStackView.spacing = 8
        
        for row in 0..<2 {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 8
            
            for col in 0..<4 {
                let index = row * 4 + col
                let button = UIButton()
                button.tag = index
                if let image = UIImage(named: imageNames[index]) {
                    button.setImage(image, for: .normal)
                }
                button.addTarget(self, action: #selector(puzzlePieceTappedAction(_:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
            }
            gridStackView.addArrangedSubview(rowStackView)
        }
        return gridStackView
    }
    
    @objc private func puzzlePieceTappedAction(_ sender: UIButton) {
        let imageNames = ["ㄱ", "ㅂ", "ㅓ", "ㅠ", "ㅣ", "ㅋ", "ㅁ", "ㅐ"]
        let piece = imageNames[sender.tag]
        puzzlePieceTapped?(piece)
    }
}
