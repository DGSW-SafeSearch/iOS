import SwiftUI

struct ContentView: View {
    
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
                }
                
                Button {
                    isPresented.toggle()
                } label: {
                    Text("버튼")
                }
            }
            .fullScreenCover(isPresented: $isPresented) {
                CameraView($image)
            }
        }
    }
}

