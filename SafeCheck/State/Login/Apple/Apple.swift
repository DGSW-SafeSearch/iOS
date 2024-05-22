import Alamofire
import AuthenticationServices

class Apple: NSObject, ObservableObject {
    @Published var appleLogin: logined?
    @Published var UserIdentifier: String = ""
    @Published var isPresent: Bool = false
    
    func handleSignInButton() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    func login() {
        let query : Parameters = [
            "emailAddress" : UserIdentifier
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
                    responseData.saveUserId()
                    self.appleLogin = responseData
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

extension Apple: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            self.UserIdentifier = userIdentifier
            print(self.UserIdentifier)
            login()
        }
    }
}
