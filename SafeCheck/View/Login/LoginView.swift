import SwiftUI
import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @ObservedObject private var google = Google()
    @ObservedObject private var apple = Apple()
    
    var body: some View {
        VStack {
            // MARK: - 메인
            Image("main")
                .padding(.top, 40)
            
            Text("로그인")
                .bold()
                .padding(.top,50)
                .font(.title2)
            
            // MARK: - 구글
            VStack(spacing: 25) {
                Button(action: {
                    google.handleSignInButton()
                }) {
                    HStack(spacing: 80) {
                        Image("google")
                            .padding(.leading, 30)
                        Text("Google 로그인")
                            .foregroundColor(.black)
                        Spacer()
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(Color.white)
                    .cornerRadius(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                    .fullScreenCover(isPresented: $google.isPresent) {
                        MainView()
                    }
                }
                
                // MARK: - 애플
                Button(action: {
                    
                }) {
                    HStack(spacing: 80) {
                        Image("apple")
                            .padding(.leading, 30)
                        Text("Apple 로그인")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 63)
                    .background(Color.black)
                    .cornerRadius(3)
                    .contrast(0.5)
                    .fullScreenCover(isPresented: $google.isPresent) {
                        MainView()
                    }
                }
            }
            .padding(.top,30)
            Spacer()
            
            // MARK: - footer
            Image("footer")
                .padding()
        }
        .padding(.horizontal,20)
    }
}
