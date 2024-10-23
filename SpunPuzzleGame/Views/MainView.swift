import UIKit

class MainView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // 뷰 설정 함수
    private func setupView() {
        self.backgroundColor = UIColor(hex: "#01B42F")
    }
}
