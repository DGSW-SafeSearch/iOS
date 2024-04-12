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
        }
    }
}
