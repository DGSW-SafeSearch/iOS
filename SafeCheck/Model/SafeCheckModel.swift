import Foundation

let url = "http://10.80.163.1:8082"

struct Login: Codable {
    let userType: String?
    let userId: Int64
}

struct Information: Codable {
    let dmdi: String
}

struct Islogined: Codable {
    let signup: String?
    let userId: Int64?
}
