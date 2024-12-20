import UIKit
import SnapKit

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
    
    private func setupContainerView() {
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.layer.masksToBounds = false
        containerView.backgroundColor = .white
        contentView.addSubview(containerView)
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        setupShadowContainerView()
        setupContainerView()
        setupAvatarImageView()
        setupNameLabel()
        setupMessageLabel()
        setupAcceptButton()
        setupDeclineButton()
        setupLayout()
    }
    
    private func setupLayout() {
        shadowContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            make.height.equalTo(70)
        }
        
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
    
    private func setupShadowContainerView() {
        shadowContainerView.backgroundColor = .white
        shadowContainerView.layer.cornerRadius = 12
        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = 0.1
        shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowContainerView.layer.shadowRadius = 4
        contentView.addSubview(shadowContainerView)
    }
    
    private func setupAvatarImageView() {
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
    }
    
    private func setupNameLabel() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
    }
    
    private func setupMessageLabel() {
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .gray
    }
    
    private func setupAcceptButton() {
        acceptButton.setImage(UIImage(named: "btnFriendsAgree"), for: .normal)
        acceptButton.contentMode = .scaleAspectFit
        acceptButton.imageEdgeInsets = .zero
    }
    
    private func setupDeclineButton() {
        declineButton.setImage(UIImage(named: "btnFriendsDelet"), for: .normal)
        declineButton.contentMode = .scaleAspectFit
        declineButton.imageEdgeInsets = .zero
    }
    
    func configure(with friend: FriendInfo) {
        avatarImageView.image = UIImage(named: friend.avatar)
        nameLabel.text = friend.name
        messageLabel.text = "邀請你成為好友：）"
    }
}
