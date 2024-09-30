import Foundation

let url = "http://safesearch.kr"

// MARK: - 로그인
struct logined: Codable {
    let user_entity: user_entity?
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
    let chemical_substance: [chemical_substance]?
    let res: String?
}

struct chemical_substance: Codable, Hashable {
    let chemical_id: Int?
    let cas_number: String?
    let un_number: String?
    let english_name: String?
    let korean_name: String?
}
