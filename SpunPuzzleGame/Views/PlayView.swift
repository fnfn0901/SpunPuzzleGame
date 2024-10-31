import UIKit
import SnapKit
import AVKit
import AVFoundation

class PlayView: UIView {
    
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
    
    // 추가된 구성 요소
    private let puzzleBundleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray // 퍼즐 묶음 회색으로 초기화
        return view
    }()
    
    private let answerZoneView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#E3E3E3") // 정답존 E3E3E3 색상
        view.layer.cornerRadius = 114 // 원 모양
        view.layer.masksToBounds = true
        return view
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
    }
    
    private func setupAnswerZoneView() {
        addSubview(answerZoneView)
        answerZoneView.snp.makeConstraints {
            $0.top.equalTo(puzzleBundleView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(228) // 원형 영역
        }
    }
}
