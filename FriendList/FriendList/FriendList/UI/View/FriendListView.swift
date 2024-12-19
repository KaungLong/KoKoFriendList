import RxCocoa
import RxSwift
import SnapKit
import UIKit

class FriendListView: UIView {

    private let containerView = UIView()
    private let searchBar = UISearchBar()
    private let addFriendButton = UIButton()
    let tableView = UITableView()
    private let disposeBag = DisposeBag()
    var friendListRelay = BehaviorRelay<[FriendInfo]>(value: [])
    private let filteredFriendListRelay = BehaviorRelay<[FriendInfo]>(value: [])
    private var tableViewHeightConstraint: Constraint?
    
    var onAddFriendTapped: (() -> Void)?

    init() {
        super.init(frame: .zero)
        setupUI()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        backgroundColor = .white

        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }

        containerView.addSubview(searchBar)
        searchBar.placeholder = "想轉一筆給誰呢？"
        searchBar.backgroundImage = UIImage()
        searchBar.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-44)
        }

        addFriendButton.setImage(
            UIImage(named: "icBtnAddFriends"), for: .normal)
        addFriendButton.contentMode = .scaleAspectFit
        containerView.addSubview(addFriendButton)
        addFriendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(44)
        }

        tableView.register(
            FriendTableViewCell.self,
            forCellReuseIdentifier: "FriendTableViewCell")
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            tableViewHeightConstraint = make.height.equalTo(100).constraint
            make.bottom.equalToSuperview()
        }

        addFriendButton.addTarget(
            self, action: #selector(addFriendTapped), for: .touchUpInside)
    }

    private func bindViewModel() {
        Observable.combineLatest(
            searchBar.rx.text.orEmpty.distinctUntilChanged(),
            friendListRelay
        )
        .map { (searchText, friends) -> [FriendInfo] in
            // 根據名字進行篩選
            if searchText.isEmpty {
                return friends
            }
            return friends.filter { $0.name.contains(searchText) }
        }
        .bind(to: filteredFriendListRelay)
        .disposed(by: disposeBag)

        filteredFriendListRelay
            .observe(on: MainScheduler.instance)
            .do(onNext: { friends in
                print("Filtered FriendListRelay received: \(friends.count) friends")
            })
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: "FriendTableViewCell",
                    cellType: FriendTableViewCell.self)
            ) { (row, friend, cell) in
                cell.configure(with: friend)
                print("Configuring cell with: \(friend.name)")
            }
            .disposed(by: disposeBag)

        filteredFriendListRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] friends in
                self?.updateTableViewHeight()
            })
            .disposed(by: disposeBag)
    }

    private func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        tableViewHeightConstraint?.update(offset: contentHeight)
    }

    @objc private func addFriendTapped() {
        onAddFriendTapped?()
    }
}
