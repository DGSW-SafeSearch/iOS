import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct ContentView: View {
    @ObservedObject private var vision = Vision()
    @ObservedObject private var google = Google()
    @State var isPresented: Bool = false
    @State var image: UIImage?
    
    var body: some View {
        VStack {
            GoogleSignInButton {
                google.handleSignInButton()
            }
            .padding()
            
            Button("A") {
                google.isPresent.toggle()
            }
            .fullScreenCover(isPresented: $google.isPresent) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .onAppear {
                            vision.reText(image: image)
                        }
                }
                
                Text(vision.casNumber ?? "__empty__")
                
                HStack {
                    Button("사진") {
                        isPresented.toggle()
                    }
                    .fullScreenCover(isPresented: $isPresented) {
                        CameraView($image)
                    }
                    .onChange(of: image) { _ in
                        if let image = image {
                            vision.reText(image: image)
                        }
                    }
                    Button("으야") {
                        vision.informationed()
                    }
                }
            }
        }
    }
}
