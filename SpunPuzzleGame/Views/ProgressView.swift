import UIKit
import SnapKit

class ProgressView: UIView {
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "진행도"
        label.textColor = UIColor(hex: "#00894D")
        label.font = UIFont(name: "Inter24pt-Regular", size: 16)
        return label
    }()
    
    private let progressNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#00894D")
        label.font = UIFont(name: "Inter24pt-Regular", size: 16)
        return label
    }()
    
    private let progressBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#D9D9D9")
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let progressBarFillView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#01B42F")
        view.layer.cornerRadius = 8
        return view
    }()
    
    private var maxProgress: CGFloat = 14 // 최대 진행도 값
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(progressLabel)
        addSubview(progressNumberLabel)
        addSubview(progressBarBackgroundView)
        progressBarBackgroundView.addSubview(progressBarFillView)
        
        // 진행도 텍스트 위치
        progressLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        // 진행 숫자 위치
        progressNumberLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(progressLabel.snp.centerY)
        }
        
        // 진행 바 배경 위치
        progressBarBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(progressLabel.snp.bottom).offset(4)
            $0.height.equalTo(15)
        }
    }
    
    func setProgress(currentProgress: CGFloat, maxProgress: CGFloat) {
        self.maxProgress = maxProgress
        let progressRatio = currentProgress / maxProgress
        let progressBarWidth = 345 * progressRatio
        
        // 진행 숫자 텍스트 업데이트
        progressNumberLabel.attributedText = NSMutableAttributedString(
            string: "\(Int(currentProgress)) / \(Int(maxProgress))",
            attributes: [NSAttributedString.Key.kern: 1.6]
        )
        
        // 진행 바 너비 업데이트
        progressBarFillView.snp.remakeConstraints {
            $0.leading.equalTo(progressBarBackgroundView.snp.leading)
            $0.centerY.equalTo(progressBarBackgroundView.snp.centerY)
            $0.height.equalTo(15)
            $0.width.equalTo(progressBarWidth)
        }
    }
}
