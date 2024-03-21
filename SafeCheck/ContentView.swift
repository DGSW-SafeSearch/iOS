import SwiftUI

struct ContentView: View {
    
    @State var isPresented: Bool = false
    @State var image: UIImage?
    
    var body: some View {
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
