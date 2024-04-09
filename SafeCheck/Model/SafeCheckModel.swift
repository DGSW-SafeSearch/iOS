import Foundation

let url = "http://10.80.162.84:8082"

struct Login: Codable {
    let userType: String?
    let userId: String
}

struct Information: Codable {
    let chemical_id: String?
    let english_name: String?
    let korean_name: String?
}
