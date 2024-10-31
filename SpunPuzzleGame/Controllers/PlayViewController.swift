import UIKit
import SnapKit
import AVKit
import AVFoundation

class PlayViewController: UIViewController {
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()
    
    private let customAlertView = CustomAlertView()
    private let progressView = ProgressView()
    private let videoContainerView = VideoContainerView() // 16:9 영상 컨테이너
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setupNavigationBar()
        setupDimmingView()
        setupAlertView()
        setupProgressView()
        setupVideoContainer()
        
        // 초기 진행도 설정
        progressView.setProgress(currentProgress: 1, maxProgress: 14)
    }
    
    private func setupNavigationBar() {
        let navigationBar = CustomNavigationBar()
        view.addSubview(navigationBar)
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 43)
        ])
        
        navigationBar.backButtonAction = { [weak self] in
            self?.showCustomAlert()
        }
        
        navigationBar.settingsButtonAction = { [weak self] in
            self?.showSettingsModal()
        }
    }
    
    private func setupDimmingView() {
        view.addSubview(dimmingView)
        
        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideCustomAlert))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    private func setupAlertView() {
        view.addSubview(customAlertView)
        customAlertView.isHidden = true
        customAlertView.cancelAction = { [weak self] in
            self?.hideCustomAlert()
        }
        customAlertView.exitAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        customAlertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(273)
            $0.height.equalTo(224)
        }
    }
    
    private func setupProgressView() {
        view.addSubview(progressView)
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(53) // 네비게이션 바 아래 10
            $0.centerX.equalToSuperview()
            $0.width.equalTo(345)
            $0.height.equalTo(38)
        }
    }
    
    private func setupVideoContainer() {
        view.addSubview(videoContainerView)
        
        videoContainerView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(22) // 진행도 바 아래 22pt
            $0.leading.trailing.equalToSuperview().inset(16) // 화면 가득 채우기 (양 옆 여백 16)
            $0.height.equalTo(videoContainerView.snp.width).multipliedBy(9.0 / 16.0) // 16:9 비율
        }
    }
    
    private func showCustomAlert() {
        dimmingView.isHidden = false
        customAlertView.isHidden = false
        
        // 최상단에 위치하도록 설정
        view.bringSubviewToFront(dimmingView)
        view.bringSubviewToFront(customAlertView)
    }
    
    @objc private func hideCustomAlert() {
        dimmingView.isHidden = true
        customAlertView.isHidden = true
    }
    
    private func showSettingsModal() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .pageSheet
        present(settingsVC, animated: true, completion: nil)
    }
}
