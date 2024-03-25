import SwiftUI

struct ContentView: View {
    @ObservedObject private var vision = Vision()
    @State var isPresent: Bool = false
    @State var isPresented: Bool = false
    @State var image: UIImage?
    
    
    var body: some View {
        Button{
            isPresent.toggle()
        } label: {
            Text("로그인")
        }
        .fullScreenCover(isPresented: $isPresent) {
            VStack {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .onAppear {
                            vision.reText(image: image)
                        }
                }
                
                Text(vision.OCRString ?? "오류")
                
                HStack {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Text("사진")
                    }
                    
                }
            }
            .fullScreenCover(isPresented: $isPresented) {
                CameraView($image)
            }
        }
    }
}

