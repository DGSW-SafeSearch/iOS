import Alamofire
import GoogleSignIn
import GoogleSignInSwift

class Google: ObservableObject {
    @Published var googleLogin: logined?
    @Published var isPresent: Bool = false
    @Published var mail: String = ""
    
    func handleSignInButton() {
        var rootViewController: UIViewController {
            if let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let root = screen.windows.first?.rootViewController {
                return root
            } else {
                return .init()
            }
        }
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController ) { [self] signInResult, error in
            guard let signInResult = signInResult else { return }
            let user = signInResult.user
            self.mail = user.profile?.email ?? ""
            self.login()
        }
    }
    
    func login() {
        let query: Parameters = [
            "emailAddress": mail
        ]
        
        AF.request("\(url)/auth/google/ios",
                   method: .post,
                   parameters: query)
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    print(String(decoding: data, as: UTF8.self))
                    let responseData = try JSONDecoder().decode(logined.self, from: data)
                    responseData.saveUserId()
                    self.googleLogin = responseData
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
