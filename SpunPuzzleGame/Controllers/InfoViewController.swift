import UIKit

class InfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = "게임 설명 화면"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}
