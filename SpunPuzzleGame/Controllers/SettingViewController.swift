import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    private let settingView = SettingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupActions()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(settingView)
        
        settingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        settingView.backButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    }
    
    private func setupActions() {
        // UserDefaults에서 저장된 값을 가져오고, 없으면 기본값으로 true를 사용
        let soundSwitchState = UserDefaults.standard.object(forKey: "soundSwitchState") as? Bool ?? true
        let backgroundMusicSwitchState = UserDefaults.standard.object(forKey: "backgroundMusicSwitchState") as? Bool ?? true
        
        settingView.soundSwitch.isOn = soundSwitchState
        settingView.backgroundMusicSwitch.isOn = backgroundMusicSwitchState
        
        // 스위치 값이 변경될 때 UserDefaults에 저장
        settingView.soundSwitch.addTarget(self, action: #selector(soundSwitchChanged(_:)), for: .valueChanged)
        settingView.backgroundMusicSwitch.addTarget(self, action: #selector(backgroundMusicSwitchChanged(_:)), for: .valueChanged)
    }
    
    @objc private func soundSwitchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "soundSwitchState")
    }
    
    @objc private func backgroundMusicSwitchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "backgroundMusicSwitchState")
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
}
