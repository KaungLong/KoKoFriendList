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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func configure(with friend: FriendInfo) {
        avatarImageView.image = UIImage(named: "default_avatar")
        starImageView.image = friend.isTop == "1" ? UIImage(systemName: "star.fill") : nil
        starImageView.tintColor = .orange
        nameLabel.text = friend.name

        setupButtons(for: friend.status)
    }

    private func setupUI() {
        selectionStyle = .none

        setupContentStackView()
        setupAvatarImageView()
        setupStarImageView()
        setupButtonStackView()
        setupSeparatorView()
    }

    private func setupContentStackView() {
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.alignment = .center
        contentStackView.distribution = .fill
        contentView.addSubview(contentStackView)

        contentStackView.addArrangedSubview(starImageView)
        contentStackView.addArrangedSubview(avatarImageView)
        contentStackView.addArrangedSubview(buttonStackView)

        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }

    private func setupAvatarImageView() {
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
    }

    private func setupStarImageView() {
        starImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
    }

    private func setupButtonStackView() {
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fill
    }

    private func setupSeparatorView() {
        separatorView.backgroundColor = .lightGray
        contentView.addSubview(separatorView)

        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(contentStackView.snp.leading)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    private func setupButtons(for status: Int) {
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        transferButton.setTitle("轉帳", for: .normal)
        styleButton(transferButton, titleColor: .systemPink, borderColor: UIColor.systemPink.cgColor)

        if status == 2 {
            inviteButton.setTitle("邀請中", for: .normal)
            styleButton(inviteButton, titleColor: .lightGray, borderColor: UIColor.lightGray.cgColor)
            buttonStackView.addArrangedSubview(nameLabel)
            buttonStackView.addArrangedSubview(transferButton)
            buttonStackView.addArrangedSubview(inviteButton)
        } else {
            moreOptionsButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            moreOptionsButton.tintColor = .lightGray
            buttonStackView.addArrangedSubview(nameLabel)
            buttonStackView.addArrangedSubview(transferButton)
            buttonStackView.addArrangedSubview(moreOptionsButton)
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
            make.width.height.equalTo(30)
        }
    }

    private func styleButton(_ button: UIButton, titleColor: UIColor, borderColor: CGColor) {
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.borderColor = borderColor
        button.layer.cornerRadius = 5
    }
}
