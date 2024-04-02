import Alamofire
import GoogleSignIn
import GoogleSignInSwift

class Google: ObservableObject {
    @Published var googleLogin: Login?
    @Published var dmdi: String = ""
    
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
            self.dmdi = user.profile?.email ?? ""
            print(self.dmdi)
            self.login()
        }
    }
    
    func login() {
        
        let query : Parameters = [
            "emailAddress" : dmdi
        ]
        
        AF.request("http://10.80.163.106:8082/auth/google",
                   method: .post,
                   parameters: query,
                   encoding: JSONEncoding.default)
        
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
}
