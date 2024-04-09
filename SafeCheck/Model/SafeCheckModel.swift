import Foundation

let url = "http://10.80.162.84:8082"

struct Login: Codable {
    let userType: String?
    let userId: Int64
}

struct Islogined: Codable {
    let message: String?
    let userId: Int64?
}

struct Information: Codable {
    let chemical_id: Int64?
    let english_name: String?
    let korean_name: String?
}
