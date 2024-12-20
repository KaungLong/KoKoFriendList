import Foundation
import RxRelay
import RxSwift
import UIKit

class FriendViewModel: BaseViewModel {
    let userInfoRelay = BehaviorRelay<UserInfo>(
        value: UserInfo(name: "未知", avatar: "default_avatar", kokoID: ""))
    let inviteListRelay = BehaviorRelay<[FriendInfo]>(value: [])
    let friendListRelay = BehaviorRelay<[FriendInfo]>(value: [])
    let inviteCountRelay = BehaviorRelay<Int>(value: 0)
    let unreadMessagesCountRelay = BehaviorRelay<Int>(value: 0)

    override init() {
        super.init()
        bindInviteCountToFriendList()
    }

    func initializeLoad() {
        switch TestClient.shared.testMode {
        case .noFriends:
            loadNoFriends()
        case .onlyFriends:
            loadFriendsOnly()
        case .friendsWithInvites:
            loadFriendsWithInvites()
        case .noKokoID:
            loadNoKokoID()
        case .errorAPI:
            loadErrorAPI()
        }
    }

    private func loadNoFriends() {
        fetchUserData()
        fetchFriendList(path: .emptyFriendList)
        unreadMessagesCountRelay.accept(0)
    }

    private func loadFriendsOnly() {
        fetchUserData()
        fetchCombinedFriendLists { [weak self] combinedFriends in
            guard let self = self else { return }
            self.processFriends(combinedFriends)
        }
        unreadMessagesCountRelay.accept(100)
    }

    private func fetchCombinedFriendLists(
        completion: @escaping ([Friend]) -> Void
    ) {
        Observable.zip(
            APIClient.shared.request(path: .friendList1),
            APIClient.shared.request(path: .friendList2)
        )
        .map { (response1: FriendsResponse, response2: FriendsResponse) in
            return response1.response + response2.response
        }
        .subscribe(
            onNext: { combinedFriends in
                completion(combinedFriends)
            },
            onError: { error in
                print("Failed to fetch combined friend lists: \(error)")
            }
        )
        .disposed(by: disposeBag)
    }

    private func processFriends(_ combinedFriends: [Friend]) {
        let friendInfos = mapToFriendInfo(from: combinedFriends)
        let uniqueFriendInfos = getUniqueFriendInfo(from: friendInfos)
        let prioritizedFriends = prioritizeStatusTwoFriends(in: uniqueFriendInfos)

        inviteListRelay.accept([])
        friendListRelay.accept(prioritizedFriends)
    }

    private func loadFriendsWithInvites() {
        fetchUserData()
        fetchFriendList(path: .friendWithInvites)
        unreadMessagesCountRelay.accept(100)
    }

    private func loadNoKokoID() {
        userInfoRelay.accept(
            UserInfo(name: "陳彥琮", avatar: "imgFriendsList", kokoID: ""))
        inviteListRelay.accept([])
        friendListRelay.accept([])
        unreadMessagesCountRelay.accept(0)
    }

    func fetchUserData() {
        APIClient.shared.request(path: .userData)
            .subscribe(
                onNext: { [weak self] (response: UserResponse) in
                    guard let user = response.response.first else { return }
                    self?.userInfoRelay.accept(
                        UserInfo(
                            name: user.name, avatar: "default_avatar",
                            kokoID: user.kokoid))
                },
                onError: { error in
                    self.handleError(error, context: "fetchUserData")
                }
            )
            .disposed(by: disposeBag)
    }

    func fetchFriendList(path: APIPath) {
        APIClient.shared.request(path: path)
            .subscribe(
                onNext: { [weak self] (response: FriendsResponse) in
                    guard let self = self else { return }

                    let (inviteFriends, normalFriends) = self.splitFriends(
                        from: response.response)
                    let inviteFriendInfoList = self.mapToFriendInfo(
                        from: inviteFriends)
                    let prioritizedFriends = self.prioritizeStatusTwoFriends(
                        in: self.mapToFriendInfo(from: normalFriends))

                    self.updateFriendLists(
                        invites: inviteFriendInfoList,
                        friends: prioritizedFriends)
                },
                onError: { [weak self] error in
                    self?.handleError(error, context: "fetchFriendList")
                }
            )
            .disposed(by: disposeBag)
    }

    private func splitFriends(from friends: [Friend]) -> ([Friend], [Friend]) {
        let inviteFriends = friends.filter { $0.status == 0 }
        let normalFriends = friends.filter { $0.status != 0 }
        return (inviteFriends, normalFriends)
    }

    private func updateFriendLists(invites: [FriendInfo], friends: [FriendInfo])
    {
        inviteListRelay.accept(invites)
        friendListRelay.accept(friends)
    }

    private func mapToFriendInfo(from friends: [Friend]) -> [FriendInfo] {
        let dateFormats = ["yyyy/MM/dd", "yyyyMMdd"]
        let dateFormatter = DateFormatter()

        func parseDate(from string: String) -> Date? {
            for format in dateFormats {
                dateFormatter.dateFormat = format
                if let date = dateFormatter.date(from: string) {
                    return date
                }
            }
            return nil
        }

        return friends.compactMap { friend in
            guard let updateDate = parseDate(from: friend.updateDate) else {
                print("Invalid date format: \(friend.updateDate)")
                return nil
            }

            return FriendInfo(
                name: friend.name,
                status: friend.status,
                isTop: friend.isTop,
                fid: friend.fid,
                updateDate: updateDate,
                avatar: "imgFriendsList"
            )
        }
    }

    private func loadErrorAPI() {
        fetchUserData()
        fetchFriendList(path: .errorAPI)
    }

    private func getUniqueFriendInfo(from friends: [FriendInfo]) -> [FriendInfo] {
        var friendDict: [String: FriendInfo] = [:]

        for friend in friends {
            if let existingFriend = friendDict[friend.fid] {
                if friend.updateDate > existingFriend.updateDate {
                    friendDict[friend.fid] = friend
                }
            } else {
                friendDict[friend.fid] = friend
            }
        }

        return Array(friendDict.values)
    }
    
    private func prioritizeStatusTwoFriends(in friends: [FriendInfo])
        -> [FriendInfo]
    {
        let prioritizedFriends = friends.filter { $0.status == 2 }
        let otherFriends = friends.filter { $0.status != 2 }
        return prioritizedFriends + otherFriends
    }

    private func bindInviteCountToFriendList() {
        friendListRelay
            .map { friends in
                friends.filter { $0.status == 2 }.count
            }
            .bind(to: inviteCountRelay)
            .disposed(by: disposeBag)
    }
}
