import UIKit
import SnapKit

class MainView: UIView {
    
    internal let startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FFFFFF")
        button.layer.cornerRadius = 10
        button.setTitle("게임 시작", for: .normal)
        button.setTitleColor(UIColor(hex: "#01B42F"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter24pt-Bold", size: 24)
        return button
    }()
    
    internal let infoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FFFFFF")
        button.layer.cornerRadius = 10
        button.setTitle("게임 설명", for: .normal)
        button.setTitleColor(UIColor(hex: "#01B42F"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter24pt-Bold", size: 24)
        return button
    }()
    
    internal let settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FFFFFF")
        button.layer.cornerRadius = 10
        button.setTitle("설정", for: .normal)
        button.setTitleColor(UIColor(hex: "#01B42F"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter24pt-Bold", size: 24)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#01B42F")
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor(hex: "#01B42F")
        setupView()
    }
    
    private func setupView() {
        addSubview(startButton)
        addSubview(infoButton)
        addSubview(settingsButton)
        
        settingsButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-102)
        }
        
        infoButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(settingsButton.snp.top).offset(-30)
        }
        
        startButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(infoButton.snp.top).offset(-30)
        }
    }
}
