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
            Text(UserDefaults.standard.string(forKey: "user_id") ?? "으야")
        }
    }
}
