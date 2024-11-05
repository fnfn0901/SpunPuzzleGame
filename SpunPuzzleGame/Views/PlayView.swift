import UIKit
import SnapKit

class PlayView: UIView {
    
    // 퍼즐 조각이 선택되었을 때 호출되는 클로저
    var puzzlePieceTapped: ((String) -> Void)?
    
    let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()
    
    let customAlertView = CustomAlertView()
    let progressView = ProgressView()
    let videoContainerView = VideoContainerView()
    let navigationBar = CustomNavigationBar()
    
    private let puzzleBundleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let answerZoneView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#E3E3E3") // 회색 배경 추가
        view.layer.cornerRadius = 114
        view.layer.masksToBounds = true
        view.clipsToBounds = false // 뷰의 경계를 벗어나도 잘리지 않도록 설정
        return view
    }()
    
    private var answerImages: [UIImageView] = []
    private let xIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "xmark.circle"))
        imageView.tintColor = .red
        imageView.isHidden = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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
                    button.setImage(image, for: .normal) // 이미지 설정
                } else {
                    print("이미지를 찾을 수 없습니다: \(imageNames[index])") // 디버그 로그
                }
                
                button.addTarget(self, action: #selector(puzzlePieceTappedAction(_:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
            }
            gridStackView.addArrangedSubview(rowStackView)
        }
        
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
            $0.width.height.equalTo(228) // 너비와 높이를 동일하게 설정하여 원형 유지
        }
        
        answerZoneView.layer.cornerRadius = 114 // 너비/높이의 절반으로 설정하여 원형 유지
        
        answerZoneView.addSubview(xIcon)
        xIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func updateAnswerZone(with answers: [String]) {
        answerImages.forEach { $0.removeFromSuperview() }
        answerImages.removeAll()
        
        let imageSize: CGFloat = (345 - 30) / 4 // puzzleBundleView의 사이즈와 동일한 크기로 설정
        let spacing: CGFloat = -10
        let startX = (answerZoneView.bounds.width - (imageSize + spacing) * CGFloat(answers.count) + spacing) / 2
        
        for (index, answer) in answers.enumerated() {
            let imageView = UIImageView(image: UIImage(named: answer))
            imageView.contentMode = .scaleAspectFit
            addSubview(imageView) // answerZoneView 대신 self에 추가하여 경계를 벗어날 수 있게 함
            
            let xPosition = startX + CGFloat(index) * (imageSize + spacing) + answerZoneView.frame.origin.x
            let yPosition = answerZoneView.frame.midY - (imageSize / 2)
            
            imageView.frame = CGRect(x: xPosition, y: yPosition, width: imageSize, height: imageSize)
            answerImages.append(imageView)
        }
    }
    
    func showXIconForError() {
        xIcon.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.xIcon.isHidden = true
            self?.updateAnswerZone(with: [])
        }
    }
    
    @objc private func puzzlePieceTappedAction(_ sender: UIButton) {
        let imageNames = ["ㄱ", "ㅂ", "ㅓ", "ㅠ", "ㅣ", "ㅋ", "ㅁ", "ㅐ"]
        let piece = imageNames[sender.tag]
        puzzlePieceTapped?(piece)
    }
}
