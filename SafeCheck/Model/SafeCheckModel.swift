import Foundation

let url = "http://10.80.162.186:8084"

struct user_entity: Codable {
    let user_type: String
}

struct logined: Codable {
    let user_entity: user_entity
    let user_id: String?
    let res: String
    
    func saveUserIdToUserDefaults() {
        if let user_id = user_id {
            UserDefaults.standard.set(user_id, forKey: "user_id")
        }
    }
}

struct informations: Codable {
    let chemical_substance: chemical_substance
    let chemical_id: String?

}

struct chemical_substance: Codable {
    let english_name: String?
    let korean_name: String?
}
