import UIKit
import SnapKit

class InfoViewController: UIViewController {
    
    private let infoView = InfoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(infoView)
        
        infoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        infoView.backButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
}
