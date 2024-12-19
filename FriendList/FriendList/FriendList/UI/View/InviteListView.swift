import UIKit
import SnapKit
import RxSwift
import RxCocoa

class InviteListView: UIView {
    weak var delegate: InviteListViewDelegate?
    
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    private var tableViewHeightConstraint: Constraint? // 保存 tableView 高度约束
    private var isExpanded = false // 默認為折疊狀態

    var inviteFriendsRelay = BehaviorRelay<[FriendInfo]>(value: []) // 外部传入的数据源

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
        addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            tableViewHeightConstraint = make.height.equalTo(100).constraint // 預設高度
            make.bottom.equalToSuperview() // 使其適配父視圖
        }

        // 配置 TableView
        tableView.register(
            ShadowInviteListTableViewCell.self,
            forCellReuseIdentifier: ShadowInviteListTableViewCell.identifier
        )
        tableView.register(
            InviteListTableViewCell.self,
            forCellReuseIdentifier: InviteListTableViewCell.identifier
        )

        tableView.estimatedRowHeight = 100 // 設置估算高度
        tableView.rowHeight = UITableView.automaticDimension // 自適應高度
        tableView.isScrollEnabled = false // 禁用滾動
        tableView.separatorStyle = .none

        // 添加點擊手勢
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: false) // 取消選中動畫
                if !self!.isExpanded && indexPath.row == 0 {
                    self?.expandInviteList()
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindData() {
        // 動態綁定模式
        inviteFriendsRelay
            .observe(on: MainScheduler.instance)
            .map { [weak self] friends -> [FriendInfo] in
                guard let self = self else { return [] }
                return self.isExpanded ? friends : Array(friends.prefix(1)) // 展開時顯示全部，折疊時顯示第一筆
            }
            .bind(to: tableView.rx.items) { [weak self] tableView, index, friend in
                guard let self = self else { return UITableViewCell() }
                if index == 0 && !self.isExpanded {
                    // 折疊模式時使用 ShadowInviteListTableViewCell
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: ShadowInviteListTableViewCell.identifier,
                        for: IndexPath(row: 0, section: 0)
                    ) as! ShadowInviteListTableViewCell
                    cell.configure(with: friend)
                    return cell
                } else {
                    // 展開模式時使用 InviteListTableViewCell
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: InviteListTableViewCell.identifier,
                        for: IndexPath(row: index, section: 0)
                    ) as! InviteListTableViewCell
                    cell.configure(with: friend)
                    return cell
                }
            }
            .disposed(by: disposeBag)

        // 動態調整 TableView 高度
        inviteFriendsRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.updateTableViewHeight()
            })
            .disposed(by: disposeBag)
    }

    private func expandInviteList() {
        isExpanded = true
        // 重新觸發 inviteFriendsRelay 的數據流更新
        inviteFriendsRelay.accept(inviteFriendsRelay.value)
        updateTableViewHeight() // 更新高度
        print("inviteFriendsRelay.value.count: \(inviteFriendsRelay.value.count)")
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
