import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct ContentView: View {
    @ObservedObject private var vision = Vision()
    @ObservedObject private var google = Google()
    @State var isPresent: Bool = false
    @State var isPresented: Bool = false
    @State var image: UIImage?
    
    var body: some View {
        GoogleSignInButton {
            google.handleSignInButton()
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
        }
    }
}
