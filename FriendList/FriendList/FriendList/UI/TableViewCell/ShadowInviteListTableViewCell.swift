import UIKit

class ShadowInviteListTableViewCell: UITableViewCell {
    static let identifier = "ShadowInviteListTableViewCell"
    
    private let containerView = UIView()
    private let shadowContainerView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let messageLabel = UILabel()
    private let acceptButton = UIButton()
    private let declineButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        shadowContainerView.backgroundColor = .white
        shadowContainerView.layer.cornerRadius = 12
        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = 0.1
        shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowContainerView.layer.shadowRadius = 4
        contentView.addSubview(shadowContainerView)
        
        shadowContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }
        
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8 
        containerView.layer.masksToBounds = false
        containerView.backgroundColor = .white
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(shadowContainerView.snp.bottom).offset(-10) 
        }
        
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
        
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .gray
        
        acceptButton.setImage(UIImage(named: "btnFriendsAgree"), for: .normal)
        acceptButton.contentMode = .scaleAspectFit
        acceptButton.imageEdgeInsets = .zero
        
        declineButton.setImage(UIImage(named: "btnFriendsDelet"), for: .normal)
        declineButton.contentMode = .scaleAspectFit
        declineButton.imageEdgeInsets = .zero
        
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(acceptButton)
        containerView.addSubview(declineButton)
        
        avatarImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(acceptButton.snp.leading).offset(-8)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nameLabel)
            make.trailing.lessThanOrEqualTo(acceptButton.snp.leading).offset(-8)
        }
        
        declineButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(30)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(declineButton.snp.leading).offset(-16)
            make.width.height.equalTo(30)
        }
    }
    
    func configure(with friend: FriendInfo) {
        avatarImageView.image = UIImage(named: friend.avatar)
        nameLabel.text = friend.name
        messageLabel.text = "邀請你成為好友：）"
    }
}
