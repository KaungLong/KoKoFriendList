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
            make.width.height.equalTo(120)
        }
        
        // 歡迎標籤
        welcomeLabel.text = "就從加好友開始吧：)"
        welcomeLabel.font = .boldSystemFont(ofSize: 18)
        addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(illustrationImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        // 描述標籤
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
        
        // 加好友按鈕
        addButton.setTitle("加好友", for: .normal)
        addButton.backgroundColor = .systemGreen
        addButton.layer.cornerRadius = 20
        addButton.setTitleColor(.white, for: .normal)
        addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        // 底部超連結標籤
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
            make.top.equalTo(addButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview() // 設置底部約束
        }
        
        // 按鈕點擊事件
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        onAddFriendTapped?() // 觸發外部提供的回調
    }
    
    @objc private func openKokoIDLink() {
        if let url = URL(string: "https://www.google.com") {
            UIApplication.shared.open(url)
        }
    }
}
