import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct ContentView: View {
    @ObservedObject private var google = Google()
    
    var body: some View {
        VStack {
            GoogleSignInButton {
                google.handleSignInButton()
            }
            .padding()
            .fullScreenCover(isPresented: $google.isPresent) {
                MainView()
            }
            let user_id = UserDefaults.standard.string(forKey: "user_id")
            Text(user_id ?? "으야")
        }
    }
}
