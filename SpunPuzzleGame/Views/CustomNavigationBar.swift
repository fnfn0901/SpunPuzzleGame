import UIKit
import SnapKit

class CustomNavigationBar: UIView {
    
    // 뒤로가기 버튼 동작을 정의하는 클로저
    var backButtonAction: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가나다 한글 놀이"
        label.textColor = .white
        label.font = UIFont(name: "Inter24pt-Bold", size: 24)
        return label
    }()
    
    private let settingsButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "gearshape"))
        imageView.tintColor = .white
        return imageView
    }()
    
    private let backIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.backward"))
        imageView.tintColor = .white
        imageView.isUserInteractionEnabled = true // 사용자 상호작용 가능하도록 설정
        imageView.contentMode = .scaleAspectFit // 비율을 유지하며 크기 조절
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "01B42F")
        setupLayout()
        
        // 뒤로가기 아이콘에 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backIconTapped))
        backIcon.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(backIcon)
        addSubview(titleLabel)
        addSubview(settingsButton)

        // Back Icon Constraints
        backIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.centerY.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            $0.height.equalTo(24)
            $0.width.equalTo(12)
        }
        
        // Title Label Constraints
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        // Settings Button Constraints
        settingsButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            $0.width.height.equalTo(24)
        }
    }
    
    // 뒤로가기 버튼이 탭되었을 때 실행되는 메서드
    @objc private func backIconTapped() {
        backButtonAction?()
    }
}
