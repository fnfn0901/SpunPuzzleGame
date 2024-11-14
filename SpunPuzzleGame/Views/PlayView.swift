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
        let spacing: CGFloat = -10
        let startX = (answerZoneView.bounds.width - (imageSize + spacing) * CGFloat(answers.count) + spacing) / 2

        for (index, answer) in answers.enumerated() {
            let imageView = UIImageView(image: UIImage(named: answer))
            imageView.contentMode = .scaleAspectFit
            answerZoneView.addSubview(imageView)

            let xPosition = startX + CGFloat(index) * (imageSize + spacing)
            let yPosition = answerZoneView.bounds.midY - (imageSize / 2)
            imageView.frame = CGRect(x: xPosition, y: yPosition, width: imageSize, height: imageSize)
            answerImages.append(imageView)
        }
    }

    // MARK: - 정답 맞춘 후 화면 변경
    func updateViewForCorrectAnswer(with answers: [String]) {
        // 1. 퍼즐 영역 숨김
        puzzleBundleView.isHidden = true

        // 2. 정답 영역 위치를 videoContainerView 아래로 변경
        UIView.animate(withDuration: 0.5, animations: {
            self.answerZoneView.backgroundColor = .clear
            self.answerZoneView.snp.remakeConstraints {
                $0.centerX.equalToSuperview() // 화면 중앙
                $0.top.equalTo(self.videoContainerView.snp.bottom).offset(50) // videoContainerView의 아래 50pt
                $0.width.equalTo(228) // 크기는 유지
                $0.height.equalTo(228)
            }
            self.layoutIfNeeded()
        })

        // 3. 정답 조각 중앙 정렬 + 들썩이는 애니메이션
        let imageSize: CGFloat = 80
        let spacing: CGFloat = 10
        let totalWidth = CGFloat(answers.count) * imageSize + CGFloat(answers.count - 1) * spacing
        let startX = (answerZoneView.bounds.width - totalWidth) / 2

        for (index, imageView) in answerImages.enumerated() {
            let delay = Double(index) * 0.2 // 각 조각마다 딜레이 추가
            let initialTransform = CGAffineTransform(translationX: 0, y: 20).scaledBy(x: 0.8, y: 0.8) // 시작 크기와 위치 설정
            let finalTransform = CGAffineTransform.identity // 최종 위치

            imageView.transform = initialTransform // 초기 상태 설정
            imageView.alpha = 0 // 초기 투명도

            UIView.animate(withDuration: 0.6, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.5, options: [.curveEaseInOut], animations: {
                let xPosition = startX + CGFloat(index) * (imageSize + spacing)
                let yPosition = (228 - imageSize) / 2 // answerZoneView의 세로 중앙
                imageView.frame = CGRect(x: xPosition, y: yPosition, width: imageSize, height: imageSize)
                imageView.alpha = 1.0
                imageView.transform = finalTransform
            }, completion: nil)

            // 추가적인 회전 애니메이션
            UIView.animateKeyframes(withDuration: 0.6, delay: delay, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                    imageView.transform = imageView.transform.rotated(by: CGFloat.pi / 8)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    imageView.transform = imageView.transform.rotated(by: -CGFloat.pi / 8)
                }
            }, completion: nil)
        }

        // 4. 성공 메시지 표시
        let successLabel = UILabel()
        successLabel.text = "정답입니다!"
        successLabel.font = UIFont.boldSystemFont(ofSize: 24)
        successLabel.textColor = UIColor(hex: "#4CAF50")
        successLabel.textAlignment = .center
        successLabel.alpha = 0
        addSubview(successLabel)

        successLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(answerZoneView.snp.bottom).offset(20)
        }

        UIView.animate(withDuration: 0.5, delay: Double(answers.count) * 0.2, options: [.curveEaseInOut], animations: {
            successLabel.alpha = 1.0
        }, completion: nil)
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
        view.layer.masksToBounds = false
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
