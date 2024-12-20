import RxCocoa
import RxSwift
import SnapKit
import UIKit

class FriendListView: UIView {
    private let containerView = UIView()
    private let searchBar = UISearchBar()
    private let addFriendButton = UIButton()
    private let tableView = UITableView()
    
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
        setupContainerView()
        setupSearchBar()
        setupAddFriendButton()
        setupTableView()
    }

    private func setupContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }
    }

    private func setupSearchBar() {
        searchBar.placeholder = "想轉一筆給誰呢？"
        searchBar.backgroundImage = UIImage()
        containerView.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-44)
        }
    }

    private func setupAddFriendButton() {
        addFriendButton.setImage(UIImage(named: "icBtnAddFriends"), for: .normal)
        addFriendButton.contentMode = .scaleAspectFit
        addFriendButton.addTarget(self, action: #selector(addFriendTapped), for: .touchUpInside)
        containerView.addSubview(addFriendButton)
        addFriendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }

    private func setupTableView() {
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendTableViewCell")
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
    }

    private func bindViewModel() {
        bindSearchBarToFilteredList()
        bindFilteredListToTableView()
        observeFilteredListForHeightUpdate()
    }

    private func bindSearchBarToFilteredList() {
        Observable.combineLatest(
            searchBar.rx.text.orEmpty.distinctUntilChanged(),
            friendListRelay
        )
        .map(filterFriends)
        .bind(to: filteredFriendListRelay)
        .disposed(by: disposeBag)
    }

    private func bindFilteredListToTableView() {
        filteredFriendListRelay
            .observe(on: MainScheduler.instance)
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: "FriendTableViewCell",
                    cellType: FriendTableViewCell.self)
            ) { (row, friend, cell) in
                cell.configure(with: friend)
            }
            .disposed(by: disposeBag)
    }

    private func observeFilteredListForHeightUpdate() {
        filteredFriendListRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.updateTableViewHeight()
            })
            .disposed(by: disposeBag)
    }

    private func filterFriends(searchText: String, friends: [FriendInfo]) -> [FriendInfo] {
        if searchText.isEmpty {
            return friends
        }
        return friends.filter { $0.name.contains(searchText) }
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
