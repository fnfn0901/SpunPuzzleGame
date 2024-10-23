import UIKit

class ViewController: UIViewController {

    // MainView를 생성
    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // 뷰를 설정하는 함수
    private func setupView() {
        view = mainView // MainView를 컨트롤러의 view로 설정
    }
}
