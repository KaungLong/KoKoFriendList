import Foundation

class TestClient {
    static let shared = TestClient()
    
    enum TestMode: String, CaseIterable {
        case noFriends = "無好友"
        case onlyFriends = "只有好友"
        case friendsWithInvites = "好友含邀請列表"
        case noKokoID = "沒有設定KoKoID"
    }
    
    private init() {}
    
    var testMode: TestMode = .noFriends
}


