import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = "설정 화면"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}
