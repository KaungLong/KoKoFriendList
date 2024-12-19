import UIKit
import SnapKit

class FriendTableViewCell: UITableViewCell {
    static let identifier = "FriendTableViewCell"
    
    private let avatarImageView = UIImageView()
    private let starImageView = UIImageView()
    private let transferButton = UIButton()
    private let inviteButton = UIButton()
    private let moreOptionsButton = UIButton()
    private let separatorView = UIView()
    private let contentStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let nameLabel = UILabel()
    
    func configure(with friend: FriendInfo) {
        setupUI()
        
        selectionStyle = .none
        
        avatarImageView.image = UIImage(named: "default_avatar")
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        
        nameLabel.text = friend.name
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        
        starImageView.image = friend.isTop == "1" ? UIImage(systemName: "star.fill") : nil
        starImageView.tintColor = .orange
        
        transferButton.setTitle("轉帳", for: .normal)
        transferButton.setTitleColor(.systemPink, for: .normal)
        transferButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        transferButton.layer.borderWidth = 1
        transferButton.layer.borderColor = UIColor.systemPink.cgColor
        transferButton.layer.cornerRadius = 5
        
        inviteButton.setTitle("邀請中", for: .normal)
        inviteButton.setTitleColor(.lightGray, for: .normal)
        inviteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        inviteButton.layer.borderWidth = 1
        inviteButton.layer.borderColor = UIColor.lightGray.cgColor
        inviteButton.layer.cornerRadius = 5
        
        moreOptionsButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreOptionsButton.tintColor = .lightGray
        
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttonStackView.spacing = 8
        buttonStackView.alignment = .center
        
        if friend.status == 2 {
            buttonStackView.addArrangedSubview(nameLabel)
            buttonStackView.addArrangedSubview(transferButton)
            buttonStackView.addArrangedSubview(inviteButton)
        } else {
            buttonStackView.addArrangedSubview(nameLabel)
            buttonStackView.addArrangedSubview(transferButton)
            buttonStackView.addArrangedSubview(moreOptionsButton)
        }
    }
    
    private func setupUI() {
        if contentView.subviews.contains(contentStackView) { return }
        
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.alignment = .center
        contentStackView.distribution = .fill
        
        contentView.addSubview(contentStackView)
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fill
        
        contentStackView.addArrangedSubview(starImageView)
        contentStackView.addArrangedSubview(avatarImageView)
        contentStackView.addArrangedSubview(buttonStackView)
        
        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        
        starImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        transferButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        inviteButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        moreOptionsButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        contentView.addSubview(separatorView)
        separatorView.backgroundColor = .lightGray
        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(buttonStackView.snp.leading)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.width.equalTo(buttonStackView)
            make.height.equalTo(1)
        }
        
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
