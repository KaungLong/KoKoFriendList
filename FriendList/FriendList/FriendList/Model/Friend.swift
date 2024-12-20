import Foundation

struct Friend: Decodable {
    let name: String
    let status: Int
    let isTop: String
    let fid: String
    let updateDate: String
}

struct FriendsResponse: Decodable {
    let response: [Friend]
}

struct FriendInfo: Decodable {
    let name: String
    let status: Int
    let isTop: String
    let fid: String
    let updateDate: Date
    let avatar: String 
}
