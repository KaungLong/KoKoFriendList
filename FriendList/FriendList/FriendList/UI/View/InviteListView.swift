import UIKit
import SnapKit
import RxSwift
import RxCocoa

class InviteListView: UIView {
    weak var delegate: InviteListViewDelegate?
    
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    private var tableViewHeightConstraint: Constraint?
    private var isExpanded = false
    
    var inviteFriendsRelay = BehaviorRelay<[FriendInfo]>(value: [])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindData()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        bindData()
    }

    private func setupUI() {
        setupTableView()
    }

    private func setupTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            tableViewHeightConstraint = make.height.equalTo(100).constraint
            make.bottom.equalToSuperview()
        }

        tableView.register(ShadowInviteListTableViewCell.self,
                           forCellReuseIdentifier: ShadowInviteListTableViewCell.identifier)
        tableView.register(InviteListTableViewCell.self,
                           forCellReuseIdentifier: InviteListTableViewCell.identifier)

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none

        bindTableViewSelection()
    }

    private func bindTableViewSelection() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: false)
                if !self.isExpanded && indexPath.row == 0 {
                    self.expandInviteList()
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindData() {
        bindInviteFriendsRelayToTableView()
        observeInviteFriendsRelayForHeightUpdate()
    }

    private func bindInviteFriendsRelayToTableView() {
        inviteFriendsRelay
            .observe(on: MainScheduler.instance)
            .map { [weak self] friends -> [FriendInfo] in
                guard let self = self else { return [] }
                return self.isExpanded ? friends : Array(friends.prefix(1))
            }
            .bind(to: tableView.rx.items) { [weak self] tableView, index, friend in
                self?.configureCell(for: tableView, at: index, with: friend) ?? UITableViewCell()
            }
            .disposed(by: disposeBag)
    }

    private func observeInviteFriendsRelayForHeightUpdate() {
        inviteFriendsRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.updateTableViewHeight()
            })
            .disposed(by: disposeBag)
    }

    private func configureCell(for tableView: UITableView, at index: Int, with friend: FriendInfo) -> UITableViewCell {
        if index == 0 && !isExpanded {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ShadowInviteListTableViewCell.identifier,
                for: IndexPath(row: 0, section: 0)
            ) as! ShadowInviteListTableViewCell
            cell.configure(with: friend)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: InviteListTableViewCell.identifier,
                for: IndexPath(row: index, section: 0)
            ) as! InviteListTableViewCell
            cell.configure(with: friend)
            return cell
        }
    }

    private func expandInviteList() {
        isExpanded = true
        inviteFriendsRelay.accept(inviteFriendsRelay.value)
        updateTableViewHeight()
    }

    private func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        tableViewHeightConstraint?.update(offset: contentHeight)
        delegate?.inviteListViewDidUpdateHeight(self)
    }
}

protocol InviteListViewDelegate: AnyObject {
    func inviteListViewDidUpdateHeight(_ inviteListView: InviteListView)
}
