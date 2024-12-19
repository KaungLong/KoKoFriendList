import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setValue(CustomTabBar(), forKey: "tabBar")

        setupTabBar()
        
        addSeparatorLine()
    }
    
    private func addSeparatorLine() {
        let separatorLine = UIView()
        separatorLine.backgroundColor = .lightGray
        tabBar.addSubview(separatorLine)

        separatorLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(7.5) 
        }

        tabBar.sendSubviewToBack(separatorLine)
    }
    
    private func setupTabBar() {
        let walletVC = UIViewController()
        walletVC.view.backgroundColor = .white
        walletVC.tabBarItem = createTabBarItem(imageName: "icTabbarProductsOff", tag: 0)

        let friendVC = FriendViewController()
        friendVC.view.backgroundColor = .white
        friendVC.tabBarItem = createTabBarItem(imageName: "icTabbarFriendsOn", tag: 1)

        let mainVC = UIViewController()
        mainVC.view.backgroundColor = .white
        mainVC.tabBarItem = createTabBarItem(imageName: "icTabbarHomeOff", tag: 2)

        let recordVC = UIViewController()
        recordVC.view.backgroundColor = .white
        recordVC.tabBarItem = createTabBarItem(imageName: "icTabbarManageOff", tag: 3)

        let settingVC = UIViewController()
        settingVC.view.backgroundColor = .white
        settingVC.tabBarItem = createTabBarItem(imageName: "icTabbarSettingOff", tag: 4)

        viewControllers = [walletVC, friendVC, mainVC, recordVC, settingVC]
    }

    private func createTabBarItem(imageName: String, tag: Int) -> UITabBarItem {
        let tabBarHeight = (tabBar as? CustomTabBar)?.customHeight ?? 80
        let isCenterItem = tag == 2
        let targetSize = isCenterItem
            ? CGSize(width: (tabBarHeight+30) * 0.85, height: (tabBarHeight+30) * 0.68)
            : CGSize(width: (tabBarHeight+30) * 0.28, height: (tabBarHeight+30) * 0.46)

        if let originalImage = UIImage(named: imageName) {
            let resizedImage = resizeImage(image: originalImage, targetSize: targetSize)
            return UITabBarItem(title: nil, image: resizedImage.withRenderingMode(.alwaysOriginal), tag: tag)
        }
        return UITabBarItem()
    }

    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

class CustomTabBar: UITabBar {
    var customHeight: CGFloat = 100

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjustedSize = super.sizeThatFits(size)
        adjustedSize.height = customHeight
        return adjustedSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let items = items else { return }

        let tabBarButtons = subviews.filter { $0 is UIControl }
        let buttonHeight = customHeight - 20
        let yOffset: CGFloat = 10

        for (index, tabBarButton) in tabBarButtons.enumerated() {
            guard index < items.count else { continue }

            var frame = tabBarButton.frame

            if items[index].tag == 2 {
                frame.origin.y = yOffset - 8 
            } else {
                frame.origin.y = yOffset + 2
            }

            frame.size.height = buttonHeight
            tabBarButton.frame = frame
        }
    }

}
