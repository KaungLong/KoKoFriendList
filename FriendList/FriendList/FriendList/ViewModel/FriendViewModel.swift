import Foundation
import RxRelay
import UIKit
import RxSwift

class FriendViewModel {

    let userInfoRelay = BehaviorRelay<UserInfo>(value: UserInfo(name: "未知", avatar: "default_avatar", kokoID: ""))
    let inviteListRelay = BehaviorRelay<[FriendInfo]>(value: [])
    let friendListRelay = BehaviorRelay<[FriendInfo]>(value: [])
    let inviteCountRelay = BehaviorRelay<Int>(value: 0) // 邀請中好友數量
    let unreadMessagesCountRelay = BehaviorRelay<Int>(value: 0) // 未讀消息數量

    private let disposeBag = DisposeBag()
    
    init() {
          bindInviteCountToFriendList()
      }

    func getAvatarImage() -> UIImage? {
        return UIImage(named: userInfoRelay.value.avatar)
    }

    func getUserName() -> String {
        return userInfoRelay.value.name
    }

    func getKokoID() -> String {
        return userInfoRelay.value.kokoID
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
        }
    }
    
    // TestMode: 無好友
     private func loadNoFriends() {
         fetchUserData()
         fetchFriendList(path: .emptyFriendList)
         unreadMessagesCountRelay.accept(0)
     }

     // TestMode: 只有好友
    private func loadFriendsOnly() {
        fetchUserData()
        Observable.zip(
            APIClient.shared.request(path: .friendList1),
            APIClient.shared.request(path: .friendList2)
        )
        .map { [weak self] (response1: FriendsResponse, response2: FriendsResponse) -> [FriendInfo] in
            guard let self = self else { return [] }
            let combinedFriends = response1.response + response2.response
            
            let uniqueFriends = self.getUniqueFriends(from: combinedFriends)
            
            let friendInfos = uniqueFriends.map { friend in
                FriendInfo(
                    name: friend.name,
                    status: friend.status,
                    isTop: friend.isTop,
                    fid: friend.fid,
                    updateDate: friend.updateDate,
                    avatar: "imgFriendsList"
                )
            }
            
            return self.prioritizeStatusTwoFriends(in: friendInfos)
        }
        .subscribe(onNext: { [weak self] friendList in
            self?.inviteListRelay.accept([])
            self?.friendListRelay.accept(friendList)
        }, onError: { error in
            print("Failed to fetch friend lists: \(error)")
        })
        .disposed(by: disposeBag)

        unreadMessagesCountRelay.accept(100)
    }

     // TestMode: 好友含邀請列表
     private func loadFriendsWithInvites() {
         fetchUserData()
         fetchFriendList(path: .friendWithInvites)
         
         unreadMessagesCountRelay.accept(100)
     }

     // TestMode: 沒有設定 KoKo ID
     private func loadNoKokoID() {
         userInfoRelay.accept(UserInfo(name: "陳彥琮", avatar: "imgFriendsList", kokoID: ""))
         inviteListRelay.accept([])
         friendListRelay.accept([])
         unreadMessagesCountRelay.accept(0)
     }

    func fetchUserData() {
        APIClient.shared.request(path: .userData)
            .subscribe(onNext: { [weak self] (response: UserResponse) in
                guard let user = response.response.first else { return }
                self?.userInfoRelay.accept(UserInfo(name: user.name, avatar: "default_avatar", kokoID: user.kokoid))
            }, onError: { error in
                print("Failed to fetch user data: \(error)")
            })
            .disposed(by: disposeBag)
    }

    func fetchFriendList(path: APIPath) {
        APIClient.shared.request(path: path)
            .subscribe(onNext: { [weak self] (response: FriendsResponse) in
                let inviteFriends = response.response.filter { $0.status == 0 }
                let normalFriends = response.response.filter { $0.status != 0 }

                let inviteFriendInfoList = inviteFriends.map { friend in
                    FriendInfo(
                        name: friend.name,
                        status: friend.status,
                        isTop: friend.isTop,
                        fid: friend.fid,
                        updateDate: friend.updateDate,
                        avatar: "imgFriendsList"
                    )
                }

                var normalFriendInfoList = normalFriends.map { friend in
                    FriendInfo(
                        name: friend.name,
                        status: friend.status,
                        isTop: friend.isTop,
                        fid: friend.fid,
                        updateDate: friend.updateDate,
                        avatar: "imgFriendsList"
                    )
                }
                
                normalFriendInfoList = self?.prioritizeStatusTwoFriends(in: normalFriendInfoList) ?? normalFriendInfoList

                self?.inviteListRelay.accept(inviteFriendInfoList)
                self?.friendListRelay.accept(normalFriendInfoList)
            }, onError: { error in
                print("Failed to fetch friend list: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func getUniqueFriends(from friends: [Friend]) -> [Friend] {
        var friendDict: [String: Friend] = [:]
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
        
        for friend in friends {
            guard let currentDate = parseDate(from: friend.updateDate) else {
                print("Invalid date format: \(friend.updateDate)")
                continue
            }
            
            if let existingFriend = friendDict[friend.fid],
               let existingDate = parseDate(from: existingFriend.updateDate) {
                if currentDate > existingDate {
                    friendDict[friend.fid] = friend
                }
            } else {
                friendDict[friend.fid] = friend
            }
        }
        return Array(friendDict.values)
    }
    
    private func prioritizeStatusTwoFriends(in friends: [FriendInfo]) -> [FriendInfo] {
     
        let prioritizedFriends = friends.filter { $0.status == 2 }
        let otherFriends = friends.filter { $0.status != 2 }
        return prioritizedFriends + otherFriends
    }
    
    private func bindInviteCountToFriendList() {
        friendListRelay
            .map { friends in
                friends.filter { $0.status == 2 }.count
            }
            .bind(to: inviteCountRelay) // 將結果綁定到 inviteCountRelay
            .disposed(by: disposeBag)
    }
}

