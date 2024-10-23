import UIKit

class PlayView: UIView {
    // PlayView 관련 UI 요소 추가 및 설정
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white // 배경색 설정
        
        let label = UILabel()
        label.text = "게임 플레이 화면"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .black
        addSubview(label)
        
        // 오토레이아웃 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
