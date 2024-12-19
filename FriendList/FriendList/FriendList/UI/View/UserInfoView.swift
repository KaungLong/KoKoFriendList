import UIKit
import SnapKit

class UserInfoView: UIView {
    
    private let avatarImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let kokoIDButton = UIButton()
    private let kokoIDBadgeView = UIView() // 粉红色圆点
    
    var userName: String? {
        didSet { userNameLabel.text = userName }
    }
    
    var avatarImage: UIImage? {
        didSet { avatarImageView.image = avatarImage }
    }
    
    var kokoID: String? {
        didSet {
            if let id = kokoID, !id.isEmpty {
                kokoIDButton.setTitle("設定 KOKO ID: \(id)", for: .normal)
                kokoIDBadgeView.isHidden = true
            } else {
                kokoIDButton.setTitle("設定 KOKO ID", for: .normal)
                kokoIDBadgeView.isHidden = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateKokoID() // 确保初始化时更新状态
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        updateKokoID()
    }
    
    private func setupUI() {
        avatarImageView.layer.cornerRadius = 8
        avatarImageView.clipsToBounds = true
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(54)
        }
        
        userNameLabel.font = .boldSystemFont(ofSize: 18)
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(avatarImageView).offset(-10)
        }
        
        kokoIDButton.setTitle("設定 KOKO ID", for: .normal)
        kokoIDButton.setImage(UIImage(named: "icInfoBackDeepGray"), for: .normal)
        kokoIDButton.titleLabel?.font = .systemFont(ofSize: 14)
        kokoIDButton.setTitleColor(.darkGray, for: .normal)
        kokoIDButton.contentHorizontalAlignment = .leading
        kokoIDButton.semanticContentAttribute = .forceRightToLeft
        
        addSubview(kokoIDButton)
        kokoIDButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.height.equalTo(20)
        }
        
        kokoIDBadgeView.backgroundColor = .systemPink
        kokoIDBadgeView.layer.cornerRadius = 4
        kokoIDBadgeView.isHidden = true
        addSubview(kokoIDBadgeView)
        kokoIDBadgeView.snp.makeConstraints { make in
            make.centerY.equalTo(kokoIDButton)
            make.leading.equalTo(kokoIDButton.snp.trailing).offset(6)
            make.width.height.equalTo(8)
        }
        
        kokoIDButton.addTarget(self, action: #selector(kokoIDButtonTapped), for: .touchUpInside)
    }
    
    private func updateKokoID() {
        if let kokoID = kokoID, !kokoID.isEmpty {
            kokoIDButton.setTitle("設定 KOKO ID: \(kokoID)", for: .normal)
            kokoIDBadgeView.isHidden = true
        } else {
            kokoIDButton.setTitle("設定 KOKO ID", for: .normal)
            kokoIDBadgeView.isHidden = false
        }
    }
    
    @objc private func kokoIDButtonTapped() {
        print("設定 KOKO ID 按钮被点击")
        // 可以在这里添加其他逻辑，例如打开设置页面等
    }
}
