import UIKit
import SnapKit

class CustomSegmentedControl: UIView {

    private var buttons: [UIButton] = []
    private var badgeLabels: [UILabel] = []
    private let indicatorView = UIView()
    private let stackView = UIStackView()
    private var selectedIndex: Int = 0

    var buttonTitles: [String] = [] {
        didSet {
            setupButtons()
        }
    }
    var badgeValues: [Int] = [] {
        didSet {
            updateBadgeValues()
        }
    }
    var onSegmentSelected: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupIndicatorView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        setupIndicatorView()
    }

    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 16
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        badgeLabels.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        badgeLabels.removeAll()

        for (index, title) in buttonTitles.enumerated() {
            // Create Button
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(.gray, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            stackView.addArrangedSubview(button)

            let badgeLabel = UILabel()
            badgeLabel.textColor = .white
            badgeLabel.font = UIFont.systemFont(ofSize: 10)
            badgeLabel.textAlignment = .center
            badgeLabel.backgroundColor = .systemPink
            badgeLabel.layer.cornerRadius = 10
            badgeLabel.layer.masksToBounds = true
            badgeLabel.isHidden = true
            
            addSubview(badgeLabel)
            badgeLabels.append(badgeLabel)

            badgeLabel.snp.makeConstraints { make in
                make.top.equalTo(button.snp.top).offset(-5)
                make.leading.equalTo(button.snp.trailing).offset(-10)
                make.height.equalTo(20)
                make.width.greaterThanOrEqualTo(20) 
            }
        }

        buttons.first?.isSelected = true
        buttons.first?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        layoutIndicatorView()
    }

    private func setupIndicatorView() {
        indicatorView.backgroundColor = .systemPink
        indicatorView.layer.cornerRadius = 2
        indicatorView.layer.masksToBounds = true
        addSubview(indicatorView)
    }

    private func layoutIndicatorView() {
        guard let firstButton = buttons.first else { return }
        indicatorView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(4)
            make.centerX.equalTo(firstButton.snp.centerX)
            make.width.equalTo(firstButton.titleLabel?.intrinsicContentSize.width ?? 0)
        }
    }

    private func updateBadgeValues() {
        for (index, badgeValue) in badgeValues.enumerated() {
            guard index < badgeLabels.count else { continue }
            let badgeLabel = badgeLabels[index]
            if badgeValue > 0 {
                badgeLabel.text = badgeValue > 99 ? "99+" : "\(badgeValue)"
                badgeLabel.isHidden = false
                badgeLabel.snp.remakeConstraints { make in
                    make.top.equalTo(buttons[index].snp.top).offset(-5)
                    make.leading.equalTo(buttons[index].snp.trailing).offset(-10)
                    make.height.equalTo(20) 
                    make.width.equalTo(max(20, badgeLabel.intrinsicContentSize.width + 10))
                }
            } else {
                badgeLabel.isHidden = true
            }
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        updateSelection(to: sender.tag)
        onSegmentSelected?(sender.tag)
    }

    private func updateSelection(to index: Int) {
        buttons[selectedIndex].isSelected = false
        buttons[selectedIndex].titleLabel?.font = UIFont.systemFont(ofSize: 13)

        buttons[index].isSelected = true
        buttons[index].titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)

        selectedIndex = index

        UIView.animate(withDuration: 0.3) {
            self.indicatorView.snp.remakeConstraints { make in
                make.bottom.equalToSuperview()
                make.height.equalTo(4)
                make.centerX.equalTo(self.buttons[index].snp.centerX)
                make.width.equalTo(self.buttons[index].titleLabel?.intrinsicContentSize.width ?? 0)
            }
            self.layoutIfNeeded()
        }
    }
}
