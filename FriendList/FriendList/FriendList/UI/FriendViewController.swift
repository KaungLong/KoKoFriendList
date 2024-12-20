import RxSwift
import SnapKit
import UIKit

class FriendViewController: BaseViewController<FriendViewModel> {
    private let atmButton = UIButton()
    private let dollarButton = UIButton()
    private let scanButton = UIButton()
    private let userInfoView = UserInfoView()
    private let spacerView = UIView()
    private let scrollView = UIScrollView()
    private let refreshControl = UIRefreshControl()
    private let contentView = UIView()
    private let separatorView = UIView()
    private let inviteListView = InviteListView()
    private let customSegmentControl = CustomSegmentedControl()
    private let noFriendDefaultView = NoFriendDefaultView()
    private let friendListView = FriendListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FriendViewModel()
        observeErrors(from: viewModel)
        
        view.backgroundColor = .white
        inviteListView.delegate = self
        setupUI()
        bindData()
        viewModel.initializeLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.layoutIfNeeded()
        scrollView.contentSize = contentView.frame.size
    }

    private func setupUI() {
        dollarButton.setImage(UIImage(named: "money_transfer"), for: .normal)
        view.addSubview(dollarButton)
        dollarButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(30)
        }

        atmButton.setImage(UIImage(named: "atm"), for: .normal)
        view.addSubview(atmButton)
        atmButton.snp.makeConstraints { make in
            make.top.equalTo(dollarButton)
            make.leading.equalTo(dollarButton.snp.trailing).offset(16)
            make.width.height.equalTo(30)
        }

        scanButton.setImage(UIImage(named: "scan_QRcode"), for: .normal)
        view.addSubview(scanButton)
        scanButton.snp.makeConstraints { make in
            make.top.equalTo(atmButton)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(30)
        }

        view.addSubview(userInfoView)
        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(atmButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(60)
        }

        spacerView.backgroundColor = .clear
        view.addSubview(spacerView)
        spacerView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(14)
        }

        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(
            self, action: #selector(handleRefresh), for: .valueChanged)

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(spacerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        contentView.addSubview(inviteListView)
        inviteListView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.greaterThanOrEqualTo(0)
        }

        contentView.addSubview(customSegmentControl)
        customSegmentControl.buttonTitles = ["好友", "聊天"]
        customSegmentControl.badgeValues = [2, 100]
        customSegmentControl.onSegmentSelected = { selectedIndex in
            print("Selected segment: \(selectedIndex)")
        }
        customSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(inviteListView.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }

        separatorView.backgroundColor = .lightGray
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(customSegmentControl.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        contentView.addSubview(noFriendDefaultView)
        noFriendDefaultView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }

        contentView.addSubview(friendListView)
        friendListView.snp.makeConstraints { make in
            make.top.equalTo(customSegmentControl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }

    private func bindData() {
        viewModel.userInfoRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] userInfo in
                guard let self = self else { return }
                self.userInfoView.userName = userInfo.name
                self.userInfoView.avatarImage = UIImage(named: userInfo.avatar)
                self.userInfoView.kokoID = userInfo.kokoID
            })
            .disposed(by: disposeBag)

        viewModel.inviteListRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] inviteFriends in
                print("InviteList updated: \(inviteFriends)")
                self?.inviteListView.inviteFriendsRelay.accept(inviteFriends)
                self?.inviteListView.isHidden = inviteFriends.isEmpty
                self?.spacerView.isHidden = inviteFriends.isEmpty
            })
            .disposed(by: disposeBag)

        viewModel.friendListRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] friends in
                print("FriendList updated: \(friends)")
                guard let self = self else { return }
                if friends.isEmpty {
                    self.noFriendDefaultView.isHidden = false
                    self.friendListView.isHidden = true
                } else {
                    self.noFriendDefaultView.isHidden = true
                    self.friendListView.isHidden = false
                    self.friendListView.friendListRelay.accept(friends)
                }
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(
            viewModel.inviteCountRelay,
            viewModel.unreadMessagesCountRelay
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] inviteCount, unreadMessagesCount in
            guard let self = self else { return }
            self.customSegmentControl.badgeValues = [
                inviteCount, unreadMessagesCount,
            ]
        })
        .disposed(by: disposeBag)
    }

    @objc private func handleRefresh() {
        viewModel.initializeLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

extension FriendViewController: InviteListViewDelegate {
    func inviteListViewDidUpdateHeight(_ inviteListView: InviteListView) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
