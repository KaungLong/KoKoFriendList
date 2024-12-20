import SnapKit
import UIKit

class CustomSegmentedControl: UIView {

    private var buttons: [UIButton] = []
    private var badgeLabels: [UILabel] = []
    private let indicatorView = UIView()
    private let stackView = UIStackView()
    private var selectedIndex: Int = 0

    var buttonTitles: [String] = [] {
        didSet { createButtons() }
    }

    var badgeValues: [Int] = [] {
        didSet { updateBadgeVisibility() }
    }

    var onSegmentSelected: ((Int) -> Void)?

    private let buttonFontSize: CGFloat = 13
    private let badgeFontSize: CGFloat = 10
    private let indicatorHeight: CGFloat = 4
    private let badgeRadius: CGFloat = 10
    private let badgeInset: CGFloat = 10

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
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 16
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func setupIndicatorView() {
        indicatorView.backgroundColor = .systemPink
        indicatorView.layer.cornerRadius = indicatorHeight / 2
        addSubview(indicatorView)
    }

    private func createButtons() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        badgeLabels.forEach { $0.removeFromSuperview() }
        badgeLabels.removeAll()

        buttonTitles.enumerated().forEach { index, title in
            let button = createButton(with: title, tag: index)
            buttons.append(button)
            stackView.addArrangedSubview(button)

            let badge = createBadge()
            badgeLabels.append(badge)
            addSubview(badge)
        }

        updateSelection(to: 0)
    }

    private func createButton(with title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
        button.contentEdgeInsets = UIEdgeInsets(
            top: 0, left: 16, bottom: 0, right: 16)
        button.tag = tag
        button.addTarget(
            self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }

    private func createBadge() -> UILabel {
        let badge = UILabel()
        badge.textColor = .white
        badge.font = UIFont.systemFont(ofSize: badgeFontSize)
        badge.textAlignment = .center
        badge.backgroundColor = .systemPink
        badge.layer.cornerRadius = badgeRadius
        badge.layer.masksToBounds = true
        badge.isHidden = true

        badge.snp.makeConstraints { make in
            make.height.equalTo(badgeRadius * 2) 
        }
        return badge
    }

    private func updateBadgeVisibility() {
        for (index, value) in badgeValues.enumerated() {
            guard index < badgeLabels.count else { continue }
            let badge = badgeLabels[index]
            badge.isHidden = value <= 0
            badge.text = value > 99 ? "99+" : "\(value)"
            updateBadgeConstraints(badge: badge, index: index)
        }
    }

    private func updateBadgeConstraints(badge: UILabel, index: Int) {
        badge.snp.remakeConstraints { make in
            make.top.equalTo(buttons[index].snp.top).offset(-5)
            make.leading.equalTo(buttons[index].snp.trailing).offset(-badgeInset)
            make.height.equalTo(badgeRadius * 2)
            make.width.greaterThanOrEqualTo(badgeRadius * 2)
            make.width.greaterThanOrEqualTo(badge.intrinsicContentSize.width + 8)
        }
    }

    private func updateSelection(to index: Int) {
        guard index < buttons.count else { return }

        buttons[selectedIndex].isSelected = false
        buttons[selectedIndex].titleLabel?.font = UIFont.systemFont(
            ofSize: buttonFontSize)

        buttons[index].isSelected = true
        buttons[index].titleLabel?.font = UIFont.boldSystemFont(
            ofSize: buttonFontSize)

        selectedIndex = index
        updateIndicatorPosition(for: buttons[index])
        onSegmentSelected?(index)
    }

    private func updateIndicatorPosition(for button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.snp.remakeConstraints { make in
                make.bottom.equalToSuperview()
                make.height.equalTo(self.indicatorHeight)
                make.centerX.equalTo(button.snp.centerX)
                make.width.equalTo(
                    button.titleLabel?.intrinsicContentSize.width ?? 0)
            }
            self.layoutIfNeeded()
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        updateSelection(to: sender.tag)
    }
}
