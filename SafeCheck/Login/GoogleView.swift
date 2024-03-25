import SwiftUI
import Alamofire
import GoogleSignIn
import GoogleSignInSwift

struct GoogleView: View {
    @State var google: GoogleModel?
    
    var body: some View {
        Text("A")
    }
    
    func login() {
        AF.request("http://10.80.163.32:8082/auth/google")
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let responseData = try JSONDecoder().decode(google.self, from: data)
                        self.google = responseData
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}
