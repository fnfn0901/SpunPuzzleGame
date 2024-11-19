import UIKit
import SnapKit

class CustomNavigationBar: UIView {
    
    // 뒤로가기 버튼 동작을 정의하는 클로저
    var backButtonAction: (() -> Void)?
    // 설정 버튼 동작을 정의하는 클로저
    var settingsButtonAction: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가나다 퍼즐 게임"
        label.textColor = .white
        label.font = UIFont(name: "Inter24pt-Bold", size: 24)
        return label
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = .white
        button.contentMode = .scaleAspectFit // 비율을 유지하며 크기 조절
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .white
        button.contentMode = .scaleAspectFit // 비율을 유지하며 크기 조절
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "01B42F")
        setupLayout()
        
        // 뒤로가기 버튼에 액션 추가
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // 설정 버튼에 액션 추가
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(settingsButton)

        // Back Button Constraints (터치 영역을 더 크게 설정)
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16) // 여백 설정
            $0.centerY.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            $0.height.width.equalTo(44) // 터치 영역을 넓게 설정
        }
        
        // Title Label Constraints
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        // Settings Button Constraints (터치 영역을 더 크게 설정)
        settingsButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16) // 여백 설정
            $0.centerY.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            $0.height.width.equalTo(44) // 터치 영역을 넓게 설정
        }
    }
    
    // 뒤로가기 버튼이 탭되었을 때 실행되는 메서드
    @objc private func backButtonTapped() {
        backButtonAction?()
    }
    
    // 설정 버튼이 탭되었을 때 실행되는 메서드
    @objc private func settingsButtonTapped() {
        settingsButtonAction?()
    }
}
