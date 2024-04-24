import Alamofire
import AuthenticationServices

class Apple: ObservableObject {
    @Published var appleLogin: logined?
    @Published var UserIdentifier: String = ""
    @Published var isPresent: Bool = false
    
    func handleSignInButton() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.performRequests()
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
//
//SignInWithAppleButton(
//    onRequest: { request in
//        request.requestedScopes = [.fullName, .email]
//    },
//    onCompletion: { result in
//        switch result {
//        case .success(let authResults):
//            switch authResults.credential{
//            case let appleIDCredential as ASAuthorizationAppleIDCredential:
//                let UserIdentifier = appleIDCredential.user
//                print(UserIdentifier)
//
//            default:
//                break
//            }
//        case .failure(let error):
//            print(error.localizedDescription)
//        }
//    }
//)
//.frame(width : UIScreen.main.bounds.width * 0.9, height:50)
//.cornerRadius(5)
