import UIKit
import SnapKit

class InfoView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "게임 설명"
        label.textColor = UIColor(hex: "#4CAF50")
        label.font = UIFont(name: "Inter24pt-Bold", size: 24)
        label.textAlignment = .center
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor(hex: "#4CAF50")
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#000000")
        label.font = UIFont(name: "Inter24pt-Regular", size: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24

        label.attributedText = NSMutableAttributedString(
            string: """
            쌀프렌즈 가나다 퍼즐과 함께하는 숲속 숨은 동물 찾기 게임에 오신 것을 환영합니다!
            
            이 게임은 영상 속 숲속에 숨은 동물들의 특징을 파악하고 해당 동물이 누구일지 찾고, 동물의 이름을 퍼즐 조각으로 맞추는 게임이에요.
            
            1. 영상 속 동물의 특징을 탐색해요.   
            2. 해당 동물의 이름을 퍼즐 조각으로 맞춰봐요!
            3. 모든 퍼즐 조각을 맞추면 게임이 끝나요.
            
            동물 친구들과 함께 재밌는 시간을 보내요!
            """,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(94)
            make.height.equalTo(29)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalToSuperview().offset(28)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(330)
        }
    }
}
