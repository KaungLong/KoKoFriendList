import UIKit
import SnapKit

class UserInfoView: UIView {
    
    private let avatarImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let kokoIDButton = UIButton()
    private let kokoIDBadgeView = UIView()
    
    var userName: String? {
        didSet { userNameLabel.text = userName }
    }
    
    var avatarImage: UIImage? {
        didSet { avatarImageView.image = avatarImage }
    }
    
    var kokoID: String? {
        didSet { updateKokoID() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        updateKokoID()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLayout()
        updateKokoID()
    }
    
    private func setupUI() {
        setupAvatarImageView()
        setupUserNameLabel()
        setupKokoIDButton()
        setupKokoIDBadgeView()
    }
    
    private func setupAvatarImageView() {
        avatarImageView.layer.cornerRadius = 8
        avatarImageView.clipsToBounds = true
        addSubview(avatarImageView)
    }
    
    private func setupUserNameLabel() {
        userNameLabel.font = .boldSystemFont(ofSize: 18)
        addSubview(userNameLabel)
    }
    
    private func setupKokoIDButton() {
        kokoIDButton.setTitle("設定 KOKO ID", for: .normal)
        kokoIDButton.setImage(UIImage(named: "icInfoBackDeepGray"), for: .normal)
        kokoIDButton.titleLabel?.font = .systemFont(ofSize: 14)
        kokoIDButton.setTitleColor(.darkGray, for: .normal)
        kokoIDButton.contentHorizontalAlignment = .leading
        kokoIDButton.semanticContentAttribute = .forceRightToLeft
        kokoIDButton.addTarget(self, action: #selector(kokoIDButtonTapped), for: .touchUpInside)
        addSubview(kokoIDButton)
    }
    
    private func setupKokoIDBadgeView() {
        kokoIDBadgeView.backgroundColor = .systemPink
        kokoIDBadgeView.layer.cornerRadius = 4
        kokoIDBadgeView.isHidden = true
        addSubview(kokoIDBadgeView)
    }
    
    private func setupLayout() {
        avatarImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(54)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(avatarImageView).offset(-10)
        }
        
        kokoIDButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.height.equalTo(20)
        }
        
        kokoIDBadgeView.snp.makeConstraints { make in
            make.centerY.equalTo(kokoIDButton)
            make.leading.equalTo(kokoIDButton.snp.trailing).offset(6)
            make.width.height.equalTo(8)
        }
    }
    
    private func updateKokoID() {
        if let id = kokoID, !id.isEmpty {
            kokoIDButton.setTitle("設定 KOKO ID: \(id)", for: .normal)
            kokoIDBadgeView.isHidden = true
        } else {
            kokoIDButton.setTitle("設定 KOKO ID", for: .normal)
            kokoIDBadgeView.isHidden = false
        }
    }
    
    @objc private func kokoIDButtonTapped() {
        print("設定 KOKO ID 觸發")
    }
}
