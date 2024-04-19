import Foundation

let url = "http://10.80.163.40:8084"

// MARK: - 로그인
struct logined: Codable {
    let user_entity: user_entity
    let user_id: String?
    let res: String
    
    func saveUserId() {
            UserDefaults.standard.set(user_id, forKey: "user_id")
        }
}

struct user_entity: Codable {
    let user_type: String
}

// MARK: - ocr
struct informations: Codable {
    let chemical_substance: chemical_substance
    let res: String?
    let chemical_id: String?
}

struct chemical_substance: Codable {
    let english_name: String?
    let korean_name: String?
}
