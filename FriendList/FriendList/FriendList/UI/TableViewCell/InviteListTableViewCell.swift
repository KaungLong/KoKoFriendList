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
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        selectionStyle = .none
        setupContainerView()
        setupAvatarImageView()
        setupNameLabel()
        setupMessageLabel()
        setupAcceptButton()
        setupDeclineButton()
        setupLayout()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.masksToBounds = false
        contentView.addSubview(containerView)
    }
    
    private func setupAvatarImageView() {
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        containerView.addSubview(avatarImageView)
    }
    
    private func setupNameLabel() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
        containerView.addSubview(nameLabel)
    }
    
    private func setupMessageLabel() {
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .gray
        containerView.addSubview(messageLabel)
    }
    
    private func setupAcceptButton() {
        acceptButton.setImage(UIImage(named: "btnFriendsAgree"), for: .normal)
        acceptButton.contentMode = .scaleAspectFit
        acceptButton.imageEdgeInsets = .zero
        containerView.addSubview(acceptButton)
    }
    
    private func setupDeclineButton() {
        declineButton.setImage(UIImage(named: "btnFriendsDelet"), for: .normal)
        declineButton.contentMode = .scaleAspectFit
        declineButton.imageEdgeInsets = .zero
        containerView.addSubview(declineButton)
    }
    
    private func setupLayout() {
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
    
    func configure(with friend: FriendInfo) {
        avatarImageView.image = UIImage(named: friend.avatar)
        nameLabel.text = friend.name
        messageLabel.text = "邀請你成為好友：）"
    }
}
