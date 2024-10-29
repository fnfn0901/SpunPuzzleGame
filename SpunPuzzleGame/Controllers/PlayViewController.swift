import UIKit
import SnapKit

class PlayViewController: UIViewController {
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true // 기본적으로 숨김
        return view
    }()
    
    private let customAlertView = CustomAlertView() // 커스텀 경고 화면
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true // 기본 내비게이션 바 숨기기
        setupNavigationBar()
        setupDimmingView()
        setupAlertView()
    }
    
    private func setupNavigationBar() {
        let navigationBar = CustomNavigationBar()
        view.addSubview(navigationBar)
        
        // Auto Layout 설정
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 43)
        ])
        
        // 뒤로가기 버튼에 경고 화면 연결
        navigationBar.backButtonAction = { [weak self] in
            self?.showCustomAlert()
        }
    }
    
    private func setupDimmingView() {
        view.addSubview(dimmingView)
        
        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview() // 전체 화면을 덮도록 설정
        }
        
        // dimmingView에 탭 제스처 추가 (취소 동작)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideCustomAlert))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    private func setupAlertView() {
        view.addSubview(customAlertView)
        customAlertView.isHidden = true // 기본적으로 숨김
        customAlertView.cancelAction = { [weak self] in
            self?.hideCustomAlert() // 취소 버튼 누르면 경고 화면과 dimmingView 숨기기
        }
        customAlertView.exitAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true) // 종료 버튼 누르면 뒤로 가기
        }
        
        customAlertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(273)
            $0.height.equalTo(224)
        }
    }
    
    private func showCustomAlert() {
        dimmingView.isHidden = false // 어두운 배경 표시
        customAlertView.isHidden = false
    }
    
    @objc private func hideCustomAlert() {
        dimmingView.isHidden = true // 어두운 배경 숨기기
        customAlertView.isHidden = true
    }
}
