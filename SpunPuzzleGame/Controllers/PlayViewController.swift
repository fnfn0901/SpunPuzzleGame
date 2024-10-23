import UIKit

class PlayViewController: UIViewController {
    
    let playView = PlayView() // PlayView 생성
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view = playView
    }
}
