import UIKit
import SnapKit

class GameDescriptionView: UIView {
    
    let chevronView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        // Chevron setup
        let chevronImage = UIImage(systemName: "chevron.backward")
        chevronView.image = chevronImage
        addSubview(chevronView)
        
        chevronView.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(24)
            make.leading.equalToSuperview().offset(40)
            make.top.equalToSuperview().offset(83)
        }
        
        // Title Label setup
        titleLabel.text = "게임 설명"
        titleLabel.textColor = UIColor(hex: "#4CAF50")
        titleLabel.font = UIFont(name: "Inter24pt-Bold", size: 24)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(94)
            make.height.equalTo(29)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(80)
        }
        
        // Description Label setup
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24
        
        let attributedText = NSMutableAttributedString(string: """
        숲속 동물 찾기 게임에 오신 것을 환영합니다! 
        이 게임은 영상 속에서 동물의 이름을 듣고 
        퍼즐 조각을 맞추는 재미있는 게임이에요.

        1. 영상에서 동물의 이름을 들어요.
        2. 이름과 같은 동물 퍼즐 조각을 찾아서 맞춰요!
        3. 모든 퍼즐 조각을 맞추면 게임이 끝나요.

        동물 친구들과 함께 재미있는 시간을 보내요!
        """, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        descriptionLabel.attributedText = attributedText
        descriptionLabel.textColor = .black
        descriptionLabel.font = UIFont(name: "Inter24pt-Regular", size: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(330)
            make.height.equalTo(216)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(129)
        }
    }
}
