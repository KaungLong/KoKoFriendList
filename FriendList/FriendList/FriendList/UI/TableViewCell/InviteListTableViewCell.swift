import UIKit
import SnapKit

class InviteListTableViewCell: UITableViewCell {
    static let identifier = "InviteListTableViewCell"
    
    private let containerView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let messageLabel = UILabel()
    private let acceptButton = UIButton()
    private let declineButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none 
        setupUI()
        setupShadowAndRoundedCorners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
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
        
        contentView.addSubview(containerView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(acceptButton)
        containerView.addSubview(declineButton)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            make.height.equalTo(70)
        }
        
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
    
    private func setupShadowAndRoundedCorners() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.masksToBounds = false
    }
    
    func configure(with friend: FriendInfo) {
        avatarImageView.image = UIImage(named: friend.avatar)
        nameLabel.text = friend.name
        messageLabel.text = "邀請你成為好友：）"
    }
}
