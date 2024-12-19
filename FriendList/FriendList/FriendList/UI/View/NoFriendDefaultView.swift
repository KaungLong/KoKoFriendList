import UIKit
import SnapKit

class NoFriendDefaultView: UIView {
    
    private let illustrationImageView = UIImageView()
    private let welcomeLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let addButton = UIButton()
    private let bottomLabel = UILabel()
    
    var onAddFriendTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        illustrationImageView.image = UIImage(named: "friends_img")
        addSubview(illustrationImageView)
        illustrationImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(245)
            make.height.equalTo(172)
        }
        
        welcomeLabel.text = "就從加好友開始吧：)"
        welcomeLabel.font = .boldSystemFont(ofSize: 21)
        addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(illustrationImageView.snp.bottom).offset(41)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.text = "與好友們一起用 KOKO 聊起來！還能互相收付款，發紅包喔 :)"
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        configureAddButton()
        addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(192)
            make.height.equalTo(40)
        }
        
        bottomLabel.font = .systemFont(ofSize: 14)
        bottomLabel.textColor = .gray
        bottomLabel.textAlignment = .center
        let attributedString = NSMutableAttributedString(
            string: "幫助好友更快找到你？設定 KOKO ID",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        let kokoIDRange = (attributedString.string as NSString).range(of: "設定 KOKO ID")
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 236/255, green: 0, blue: 140/255, alpha: 1), range: kokoIDRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: kokoIDRange)
        bottomLabel.attributedText = attributedString
        bottomLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openKokoIDLink))
        bottomLabel.addGestureRecognizer(tapGesture)
        addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(addButton.snp.bottom).offset(37)
        }
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    private func configureAddButton() {
        addButton.backgroundColor = .clear
        addButton.layer.cornerRadius = 20
        addButton.clipsToBounds = true
        applyGradient(to: addButton)
        
        let titleLabel = UILabel()
        titleLabel.text = "加好友"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white

        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "icAddFriendWhite")
        iconImageView.contentMode = .scaleAspectFit

        addButton.addSubview(titleLabel)
        addButton.addSubview(iconImageView)

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(24)
        }
    }

    private func applyGradient(to button: UIButton) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 86/255, green: 179/255, blue: 11/255, alpha: 1).cgColor,
            UIColor(red: 166/255, green: 204/255, blue: 66/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 192, height: 40)
        gradientLayer.cornerRadius = 20
        button.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc private func addButtonTapped() {
        onAddFriendTapped?()
    }
    
    @objc private func openKokoIDLink() {
        if let url = URL(string: "https://www.google.com") {
            UIApplication.shared.open(url)
        }
    }
}
