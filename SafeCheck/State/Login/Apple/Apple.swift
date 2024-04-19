import Alamofire
import AuthenticationServices

class Apple: ObservableObject {
    @Published var appleLogin: logined?
    @Published var UserIdentifier: String = ""
    @Published var isPresent: Bool = false
    
    func handleSignInButton() {
        let button = ASAuthorizationAppleIDButton()
        
    }
    
    func login() {
        let query : Parameters = [
            "UserIdentifier" : UserIdentifier
        ]
        
        AF.request("\(url)/auth/apple/ios",
                   method: .post,
                   parameters: query)
        
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    print(String(decoding: data, as: UTF8.self))
                    let responseData = try JSONDecoder().decode(logined.self, from: data)
                    self.appleLogin = responseData
                    self.appleLogin!.saveUserId()
                    if UserDefaults.standard.string(forKey: "user_id") != nil {
                        self.isPresent.toggle()
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
