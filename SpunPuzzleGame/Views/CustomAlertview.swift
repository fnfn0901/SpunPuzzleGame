import UIKit
import SnapKit

class CustomAlertView: UIView {
    
    // 종료 버튼과 취소 버튼의 동작을 정의하는 클로저
    var exitAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "정말 종료하시겠습니까?"
        label.textColor = UIColor(hex: "#333333")
        label.font = UIFont(name: "Inter24pt-Bold", size: 20)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "게임 진행 중인 내용을 잃게 됩니다."
        label.textColor = UIColor(hex: "#666666")
        label.font = UIFont(name: "Inter24pt-Regular", size: 16)
        return label
    }()
    
    private let warningIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
        imageView.tintColor = UIColor(hex: "#FF5722")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FF5722")
        button.setTitle("종료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter24pt-Bold", size: 18)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#4CAF50")
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter24pt-Bold", size: 18)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 20
        setupLayout()
        
        // 버튼 동작 연결
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(warningIcon)
        addSubview(exitButton)
        addSubview(cancelButton)
        
        // Title Label Constraints
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.centerX.equalToSuperview()
        }
        
        // Message Label Constraints
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        // Warning Icon Constraints
        warningIcon.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        // Exit Button Constraints
        exitButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.top.equalTo(warningIcon.snp.bottom).offset(20)
            $0.width.equalTo(120)
            $0.height.equalTo(50)
        }
        
        // Cancel Button Constraints
        cancelButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-14)
            $0.top.equalTo(warningIcon.snp.bottom).offset(20)
            $0.width.equalTo(120)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func exitButtonTapped() {
        exitAction?() // 종료 버튼이 탭되면 exitAction 실행
    }
    
    @objc private func cancelButtonTapped() {
        cancelAction?() // 취소 버튼이 탭되면 cancelAction 실행
    }
}
