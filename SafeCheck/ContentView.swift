import SwiftUI
import Alamofire
import GoogleSignIn
import GoogleSignInSwift

struct ContentView: View {
    @ObservedObject private var vision = Vision()
    @State var google: GoogleModel?
    @State var isPresent: Bool = false
    @State var isPresented: Bool = false
    @State var image: UIImage?
    
    var body: some View {
        GoogleSignInButton {
            handleSignInButton()
            login()
        }
        .padding()
        .fullScreenCover(isPresented: $isPresent) {
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .onAppear {
                            vision.reText(image: image)
                        }
                }
                
                Text(vision.OCRString ?? "오류")
                
                HStack {
                    Button("사진") {
                        isPresented.toggle()
                    }
                }
            }
            .fullScreenCover(isPresented: $isPresented) {
                CameraView($image)
            }
            .onChange(of: image) { _ in
                if let image = image {
                    vision.reText(image: image)
                }
            }
        }
    }
    
    func login() {
        AF.request("http://10.80.163.32:8082/auth/google")
        { $0.timeoutInterval = 60 }
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let responseData = try JSONDecoder().decode(GoogleModel.self, from: data)
                        self.google = responseData
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func handleSignInButton() {
        var rootViewController: UIViewController {
            if let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let root = screen.windows.first?.rootViewController {
                return root
            } else {
                return .init()
            }
        }
        
        GIDSignIn.sharedInstance.signIn( withPresenting: rootViewController ) { signInResult, error in
            guard signInResult != nil else { return }
            let user = signInResult?.user
            _ = user?.profile?.email
            _ = user?.profile?.name
        }
    }
}
