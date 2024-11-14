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
    private var successLabel: UILabel?

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
    }

    private func setupAnswerZoneView() {
        addSubview(answerZoneView)
        answerZoneView.snp.makeConstraints {
            $0.top.equalTo(puzzleBundleView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(228)
        }
    }

    // MARK: - UI 업데이트
    func resetView() {
        resetAnswerZone()
        puzzleBundleView.isHidden = false
    }

    func resetAnswerZone() {
        answerImages.forEach { $0.removeFromSuperview() }
        answerImages.removeAll()
        successLabel?.removeFromSuperview()
        answerZoneView.backgroundColor = UIColor(hex: "#E3E3E3") // 기본 배경색 복원
    }

    func updateQuizData(puzzle: [String], correctAnswer: [String], video: String) {
        self.correctAnswer = correctAnswer
        updatePuzzle(with: puzzle)
        videoContainerView.replaceVideo(with: video)
    }

    func updatePuzzle(with puzzle: [String]) {
        puzzleBundleView.subviews.forEach { $0.removeFromSuperview() }
        let gridStackView = createGridStackView(with: puzzle)
        puzzleBundleView.addSubview(gridStackView)
        gridStackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
    }

    func updateAnswerZone(with answers: [String]) {
        // 기존 정답 이미지를 제거
        answerImages.forEach { $0.removeFromSuperview() }
        answerImages.removeAll()

        let imageSize: CGFloat = (345 - 30) / 4
        let spacing: CGFloat = -10
        let startX = (answerZoneView.bounds.width - (imageSize + spacing) * CGFloat(answers.count) + spacing) / 2

        // 새 정답 이미지를 추가
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

    func displayCorrectAnswer(with video: String) {
        puzzleBundleView.isHidden = true
        videoContainerView.replaceVideo(with: video)

        successLabel = UILabel()
        successLabel?.text = "정답입니다!"
        successLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        successLabel?.textColor = UIColor(hex: "#4CAF50")
        successLabel?.textAlignment = .center
        successLabel?.alpha = 0
        addSubview(successLabel!)

        successLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(answerZoneView.snp.bottom).offset(20)
        }

        UIView.animate(withDuration: 0.5) {
            self.successLabel?.alpha = 1.0
        }
    }

    func showCustomAlert() {
        dimmingView.isHidden = false
        customAlertView.isHidden = false
        bringSubviewToFront(dimmingView)
        bringSubviewToFront(customAlertView)
    }

    func hideCustomAlert() {
        dimmingView.isHidden = true
        customAlertView.isHidden = true
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
                guard index < imageNames.count else { break }

                let button = UIButton()
                button.setImage(UIImage(named: imageNames[index]), for: .normal)
                button.accessibilityLabel = imageNames[index] // 퍼즐 텍스트를 저장
                button.addTarget(self, action: #selector(puzzlePieceTappedAction(_:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
            }
            gridStackView.addArrangedSubview(rowStackView)
        }
        return gridStackView
    }
    
    // MARK: - 하단 콘텐츠 숨기기/표시
    func hideBottomContent() {
        puzzleBundleView.isHidden = true
        answerZoneView.isHidden = true
        progressView.isHidden = true
    }

    func showBottomContent() {
        puzzleBundleView.isHidden = false
        answerZoneView.isHidden = false
        progressView.isHidden = false
    }

    @objc private func puzzlePieceTappedAction(_ sender: UIButton) {
        guard let piece = sender.accessibilityLabel else { return }
        puzzlePieceTapped?(piece)
    }
}

// MARK: - Array Extension for Safe Indexing
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
