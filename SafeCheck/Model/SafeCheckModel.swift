import Foundation

let url = "http://10.80.163.99:8082"

struct user_entity: Codable {
    let user_type: String
}

struct Login: Codable {
    let user_entity: user_entity
    let user_id: String?
    let res: String

    func saveUserIdToUserDefaults() {
        if let user_id = user_id {
            UserDefaults.standard.set(user_id, forKey: "user_id")
        }
    }
}

struct Information: Codable {
    let chemical_id: String?
    let english_name: String?
    let korean_name: String?
}
