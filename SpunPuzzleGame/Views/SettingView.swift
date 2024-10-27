import UIKit
import SnapKit

class SettingView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
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
    
    let soundGroupView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let soundLabel: UILabel = {
        let label = UILabel()
        label.text = "사운드"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Inter24pt-Regular", size: 18)
        return label
    }()
    
    let speakerIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "speaker.wave.2")
        imageView.tintColor = UIColor.black
        return imageView
    }()
    
    let soundSwitch: UISwitch = {
        let soundSwitch = UISwitch()
        soundSwitch.isOn = true // 기본값을 On으로 설정
        return soundSwitch
    }()
    
    // 백그라운드 음악 그룹
    let backgroundMusicGroupView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let backgroundMusicLabel: UILabel = {
        let label = UILabel()
        label.text = "백그라운드 음악"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Inter24pt-Regular", size: 18)
        return label
    }()
    
    let musicIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.quarternote.3")
        imageView.tintColor = UIColor.black
        return imageView
    }()
    
    let backgroundMusicSwitch: UISwitch = {
        let musicSwitch = UISwitch()
        musicSwitch.isOn = true // 기본값을 On으로 설정
        return musicSwitch
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
        addSubview(soundGroupView)
        addSubview(backgroundMusicGroupView)
        
        // 사운드 그룹 구성 요소 추가
        soundGroupView.addSubview(soundLabel)
        soundGroupView.addSubview(speakerIconView)
        soundGroupView.addSubview(soundSwitch)
        
        // 백그라운드 음악 그룹 구성 요소 추가
        backgroundMusicGroupView.addSubview(backgroundMusicLabel)
        backgroundMusicGroupView.addSubview(musicIconView)
        backgroundMusicGroupView.addSubview(backgroundMusicSwitch)
        
        // 레이아웃 설정
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
        
        soundGroupView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.height.equalTo(31)
        }
        
        soundLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(22)
        }
        
        speakerIconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(soundLabel.snp.trailing).offset(4)
            make.width.height.equalTo(24)
        }
        
        soundSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(51)
            make.height.equalTo(31)
        }
        
        backgroundMusicGroupView.snp.makeConstraints { make in
            make.top.equalTo(soundGroupView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.height.equalTo(31)
        }
        
        backgroundMusicLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(121)
            make.height.equalTo(22)
        }
        
        musicIconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(backgroundMusicLabel.snp.trailing).offset(4)
            make.width.height.equalTo(24)
        }
        
        backgroundMusicSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(51)
            make.height.equalTo(31)
        }
    }
}
