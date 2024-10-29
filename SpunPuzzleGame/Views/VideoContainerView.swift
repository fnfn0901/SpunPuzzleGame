import UIKit
import SnapKit

class VideoContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(hex: "#D3D3D3") // 회색 배경
        layer.cornerRadius = 10
    }
}
