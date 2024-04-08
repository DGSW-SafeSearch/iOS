import Alamofire
import GoogleSignIn
import GoogleSignInSwift

class Google: ObservableObject {
    @Published var googleLogin: Login?
    @Published var logined: Islogined?
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
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController ) { signInResult, error in
            guard let signInResult = signInResult else { return }
            let user = signInResult.user
            self.mail = user.profile?.email ?? ""
            self.isLogined()
            if self.logined?.signup != nil {
                print("회원가입 X")
            } else {
                self.login()
            }
        }
    }
    
    func login() {
        let query : Parameters = [
            "emailAddress" : mail
        ]
        
        AF.request("\(url)/auth/signup/google/IOS",
                   method: .post,
                   parameters: query,
                   encoding: JSONEncoding.default)
        { $0.timeoutInterval = 60 }
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let responseData = try JSONDecoder().decode(Login.self, from: data)
                    self.googleLogin = responseData
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func isLogined() {
        AF.request("\(url)/auth?emailAddress=\(mail)")
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let responseData = try JSONDecoder().decode(Islogined.self, from: data)
                    self.logined = responseData
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
