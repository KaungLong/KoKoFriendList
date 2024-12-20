import Foundation

struct User: Decodable {
    let name: String
    let kokoid: String
}

struct UserInfo {
    var name: String
    var avatar: String
    var kokoID: String
}

struct UserResponse: Decodable {
    let response: [User]
}
